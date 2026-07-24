

@wrapMethod(WeaponObject)
protected cb func OnAmmoStateChangeEvent(evt: ref<AmmoStateChangeEvent>) -> Bool {
  if IsDefined(evt.weaponOwner) && evt.weaponOwner.IsPlayer() {
    let player = evt.weaponOwner as PlayerPuppet;
    if IsDefined(player) {
      if player.dpae_test_active {
        let ts             = GameInstance.GetTransactionSystem(player.GetGame());
        let thisItemID     = this.GetItemID();
        let thisCaliberID  = ItemID.IsValid(thisItemID) ? DPAE_GetCaliberFromEntity(player, thisItemID) : TDBID.None();
        if !Equals(thisCaliberID, player.dpae_caliber) {
          return wrappedMethod(evt);
        }
        let currentPct  = WeaponObject.GetMagazinePercentage(this);
        let statsSystem = GameInstance.GetStatsSystem(player.GetGame());
        let magCapacity = statsSystem.GetStatValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.MagazineCapacity);
        let currentDummyQty = ts.GetItemQuantity(player, player.DPAE_GetDummyItemID());

        let percentDropped = currentPct < player.dpae_prev_mag_pct - 0.001;
        let percentUnchanged = currentPct <= player.dpae_prev_mag_pct + 0.001 && currentPct >= player.dpae_prev_mag_pct - 0.001;
        let dummyDroppedWithNoPercentChange = !percentDropped && percentUnchanged && currentDummyQty < player.dpae_prev_dummy_qty;

        let isForcedDrain = player.dpae_pending_forced_drain_pending && thisItemID == player.dpae_pending_forced_drain_weapon;
        if isForcedDrain {
          player.dpae_pending_forced_drain_pending = false;
          player.dpae_pending_forced_drain_pad = Cast<Uint32>(0);
        }
        if (percentDropped || dummyDroppedWithNoPercentChange) && !isForcedDrain {
          if TDBID.IsValid(player.dpae_active_ammo) {
            let activeID = ItemID.FromTDBID(player.dpae_active_ammo);

            let roundsConsumed = 1;
            if dummyDroppedWithNoPercentChange {
              roundsConsumed = player.dpae_prev_dummy_qty - currentDummyQty;
              if roundsConsumed < 1 { roundsConsumed = 1; }
            } else if magCapacity > 0.0 {
              roundsConsumed = Cast<Int32>((player.dpae_prev_mag_pct - currentPct) * magCapacity + 0.5);
              if roundsConsumed < 1 { roundsConsumed = 1; }
            }

            if player.dpae_is_masked_ammo && player.dpae_masked_first_shot_owed {
              roundsConsumed += 1;
              player.dpae_masked_first_shot_owed = false;
            }

            ts.RemoveItem(player, activeID, roundsConsumed);

            player.dpae_pending_effect = DPAE_GetEffectForRound(player.dpae_active_ammo, player, this);
            player.dpae_pending_nl     = DPAE_RoundIsNL(player.dpae_active_ammo);

            let left = ts.GetItemQuantity(player, activeID);

            let dummyLeft = ts.GetItemQuantity(player, player.DPAE_GetDummyItemID());
            if (currentPct < 0.001 && dummyLeft <= 0) || left <= 0 {
              if left > 0 { ts.RemoveItem(player, activeID, left); }
              player.dpae_active_ammo = TDBID.None();
              player.dpae_test_active = false;

              let swapID = DPAE_GetNextAutoSwapVariant(player, player.dpae_caliber);
              if TDBID.IsValid(swapID) {
                player.DPAE_SelectAmmo(swapID);
              } else {
                player.DPAE_RecordWeaponState(this.GetItemID(), TDBID.None(), Cast<Uint32>(0));

                let residual = ts.GetItemQuantity(player, player.DPAE_GetDummyItemID());
                if residual > 0 { ts.RemoveItem(player, player.DPAE_GetDummyItemID(), residual); }
              }
            } else if player.dpae_is_masked_ammo && Cast<Int32>(magCapacity + 0.5) == 1 && dummyLeft <= 1 {
              ts.GiveItem(player, player.DPAE_GetDummyItemID(), 5 - dummyLeft);
            }
          }
        }
        if TDBID.IsValid(player.dpae_active_ammo) && magCapacity > 0.0 {
          let chamberCount = Cast<Uint32>(currentPct * magCapacity + 0.5);
          player.DPAE_RecordWeaponState(this.GetItemID(), player.dpae_active_ammo, chamberCount);
        }
        player.dpae_prev_mag_pct = currentPct;
        player.dpae_prev_dummy_qty = ts.GetItemQuantity(player, player.DPAE_GetDummyItemID());
      }
    }
  }
  return wrappedMethod(evt);
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemChangedEvent(evt: ref<ItemChangedEvent>) -> Bool {
  let result = wrappedMethod(evt);
  if this.dpae_test_active && evt.difference > 0 && ItemID.IsValid(evt.itemID) && TDBID.IsValid(this.dpae_active_ammo)
    && Equals(ItemID.GetTDBID(evt.itemID), this.dpae_active_ammo) {
    GameInstance.GetTransactionSystem(this.GetGame()).GiveItem(this, this.DPAE_GetDummyItemID(), evt.difference);
  }
  return result;
}



@addMethod(PlayerPuppet)
public func DPAE_SelectAmmo(activeTDBID: TweakDBID) -> Void {
  let ts      = GameInstance.GetTransactionSystem(this.GetGame());
  let dummyID = this.DPAE_GetDummyItemID();

  let requestedTDBID = activeTDBID;
  if TDBID.IsValid(this.dpae_locked_variant) {
    requestedTDBID = this.dpae_locked_variant;
  }

  let weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if !IsDefined(weaponObj) {
    weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
  }

  let caliberStr = TDBID.ToStringDEBUG(this.dpae_caliber);
  let exclusiveSuffixes = DPAE_GetExclusiveVariantSuffixes(caliberStr);
  let requestedStr = TDBID.ToStringDEBUG(requestedTDBID);
  let exclusiveIdx = 0;
  while exclusiveIdx < ArraySize(exclusiveSuffixes) {
    let suffix = exclusiveSuffixes[exclusiveIdx];
    if StrEndsWith(requestedStr, suffix) {
      let hasPermission = false;
      if IsDefined(weaponObj) {
        let weaponItemIDCheck = weaponObj.GetItemID();
        if ItemID.IsValid(weaponItemIDCheck) {
          hasPermission = ts.HasTag(this, DPAE_SuffixToExclusiveTag(suffix), weaponItemIDCheck);
        }
      }
      if !hasPermission {
        requestedTDBID = this.dpae_caliber;
      }
      break;
    }
    exclusiveIdx += 1;
  }

  let activeItemID = ItemID.FromTDBID(requestedTDBID);
  let qty          = ts.GetItemQuantity(this, activeItemID);
  if qty <= 0 {
    return;
  }

  let isVariantSwitch = TDBID.IsValid(this.dpae_active_ammo) && !Equals(this.dpae_active_ammo, requestedTDBID);
  let settingOn = DesoPierreAmmoExpandedSettings.ForceReloadOnAmmoSwitch();

  if this.dpae_pending_forced_drain_pending && IsDefined(weaponObj) && weaponObj.GetItemID() == this.dpae_pending_forced_drain_weapon {
    this.dpae_pending_forced_drain_pending = false;
    this.dpae_pending_forced_drain_pad = Cast<Uint32>(0);
  }

  if isVariantSwitch && settingOn && IsDefined(weaponObj) {
    let switchWeaponItemID = weaponObj.GetItemID();
    let canReload = !(ItemID.IsValid(switchWeaponItemID) && ts.HasTag(this, n"DiscardOnEmpty", switchWeaponItemID));
    let chamberedRounds = WeaponObject.GetMagazineAmmoCount(weaponObj);
    if canReload && chamberedRounds > Cast<Uint32>(0) {
      if TDBID.IsValid(this.dpae_active_ammo) {
        let oldVariantID = ItemID.FromTDBID(this.dpae_active_ammo);
        let oldVariantQty = ts.GetItemQuantity(this, oldVariantID);
        let chargeAmount = Cast<Int32>(chamberedRounds);
        if chargeAmount > oldVariantQty { chargeAmount = oldVariantQty; }
        if chargeAmount > 0 { ts.RemoveItem(this, oldVariantID, chargeAmount); }
      }
      this.dpae_pending_forced_drain_pending = true;
      this.dpae_pending_forced_drain_weapon = switchWeaponItemID;
      this.dpae_pending_forced_drain_pad = chamberedRounds;
      let consumeEvt = new WeaponConsumeMagazineAmmoEvent();
      consumeEvt.amount = Cast<Uint16>(chamberedRounds);
      weaponObj.QueueEvent(consumeEvt);
    }
  }

  this.dpae_test_active = false;
  this.dpae_active_ammo = TDBID.None();
  this.DPAE_RemoveSlugModifiers();
  this.DPAE_RemoveArmorPenModifier();
  this.DPAE_RemoveSnakeshotModifiers();

  let magCap  = IsDefined(weaponObj) ? Cast<Int32>(WeaponObject.GetMagazineCapacity(weaponObj)) : 0;
  let giveQty = qty;
  if this.dpae_is_masked_ammo && magCap == 1 && qty <= magCap {
    giveQty = magCap + 4;
  }
  if this.dpae_pending_forced_drain_pad > Cast<Uint32>(0) {
    giveQty += Cast<Int32>(this.dpae_pending_forced_drain_pad);
  }
  this.dpae_masked_first_shot_owed = this.dpae_is_masked_ammo;

  let leftover = ts.GetItemQuantity(this, dummyID);
  if leftover > 0 { ts.RemoveItem(this, dummyID, leftover); }
  ts.GiveItem(this, dummyID, giveQty);

  this.dpae_prev_mag_pct   = IsDefined(weaponObj) ? WeaponObject.GetMagazinePercentage(weaponObj) : 0.0;
  this.dpae_prev_dummy_qty = giveQty;
  this.dpae_active_ammo  = requestedTDBID;
  let activeStr = TDBID.ToStringDEBUG(requestedTDBID);
  if StrEndsWith(activeStr, "_Slug") {
    this.DPAE_ApplySlugModifiers(weaponObj);
  }
  if StrEndsWith(activeStr, "_Snakeshot") {
    this.DPAE_ApplySnakeshotModifiers(weaponObj);
  }
  let pyroQualities = this.DPAE_GetAttachedModQualities(weaponObj, "Items.PowerMod1_");
  let causticQualities = this.DPAE_GetAttachedModQualities(weaponObj, "Items.CausticMod1_");
  let arcQualities = this.DPAE_GetAttachedModQualities(weaponObj, "Items.ArcMod1_");
  this.dpae_pyro_qualities = pyroQualities;
  this.dpae_caustic_qualities = causticQualities;
  this.dpae_arc_qualities = arcQualities;
  this.DPAE_UpdateArmorPierce(activeStr, weaponObj);
  this.DPAE_UpdateIncendiaryBurn(activeStr, pyroQualities);
  this.DPAE_UpdateEmpShock(activeStr, arcQualities);
  this.DPAE_UpdateChemPoison(activeStr, causticQualities);
  this.DPAE_UpdateIconicElementalBonus(activeStr, weaponObj);
  this.DPAE_UpdateIconicRateBonus(activeStr, weaponObj);
  this.DPAE_UpdateExplosiveOverride(activeStr, weaponObj);
  this.DPAE_UpdateIconicSignatureAmmo(activeStr);
  this.dpae_test_active = true;
  this.DPAE_RememberAmmo(this.dpae_caliber, requestedTDBID);

  if IsDefined(weaponObj) {
    let chamberCount = Cast<Uint32>(this.dpae_prev_mag_pct * Cast<Float>(WeaponObject.GetMagazineCapacity(weaponObj)) + 0.5);
    this.DPAE_RecordWeaponState(weaponObj.GetItemID(), requestedTDBID, chamberCount);
  }
}

@addMethod(PlayerPuppet)
public func DPAE_ClearAmmo() -> Void {
  let ts      = GameInstance.GetTransactionSystem(this.GetGame());
  let dummyID = this.DPAE_GetDummyItemID();

  let leftover = ts.GetItemQuantity(this, dummyID);
  if leftover > 0 { ts.RemoveItem(this, dummyID, leftover); }

  let weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if !IsDefined(weaponObj) {
    weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
  }

  this.dpae_active_ammo = TDBID.None();
  this.DPAE_RemoveSlugModifiers();
  this.DPAE_RemoveArmorPenModifier();
  this.DPAE_RemoveSnakeshotModifiers();
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.AP_Pierce");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.INC_Burn");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.HP_Bleed");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.EMP_Shock");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.CHEM_Poison");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicElectric_Bonus");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicChemical_Bonus");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicThermal_Bonus");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicChemical_RateBonus");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicThermal_RateBonus");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.Sparky_RateBonus");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.Borzaya_RateBonus");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.BloodyMaria_RateBonus");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.DividedSignature_Active");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.YinglongSignature_Active");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.HerculesSignature_Active");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.SparkySignature_Active");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.DezerterSignature_Active");
  this.DPAE_ClearAllPyroBonuses();
  if IsDefined(weaponObj) { weaponObj.DefaultRangedAttackPackage(); }
  this.dpae_test_active = false;
  this.DPAE_RememberAmmo(this.dpae_caliber, TDBID.None());
}

@addMethod(PlayerPuppet)
public func DPAE_GetActiveAmmoCount() -> Int32 {
  if !TDBID.IsValid(this.dpae_active_ammo) { return 0; }
  return GameInstance.GetTransactionSystem(this.GetGame())
    .GetItemQuantity(this, ItemID.FromTDBID(this.dpae_active_ammo));
}

@addMethod(PlayerPuppet)
public func DPAE_GetActiveAmmoID() -> String {
  if !TDBID.IsValid(this.dpae_active_ammo) { return ""; }
  return TDBID.ToStringDEBUG(this.dpae_active_ammo);
}

@addMethod(PlayerPuppet)
public func DPAE_GetLockedVariantID() -> String {
  if !TDBID.IsValid(this.dpae_locked_variant) { return ""; }
  return TDBID.ToStringDEBUG(this.dpae_locked_variant);
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateIconicSignatureAmmo(activeStr: String) -> Void {
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.DividedSignature_Active");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.YinglongSignature_Active");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.HerculesSignature_Active");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.SparkySignature_Active");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.DezerterSignature_Active");
  if StrEndsWith(activeStr, "_Divided_CHEM") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.DividedSignature_Active", this.GetEntityID());
  } else if StrEndsWith(activeStr, "_Yinglong_EMP") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.YinglongSignature_Active", this.GetEntityID());
  } else if StrEndsWith(activeStr, "_Hercules_CHEM") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.HerculesSignature_Active", this.GetEntityID());
  } else if StrEndsWith(activeStr, "_Sparky_EMP") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.SparkySignature_Active", this.GetEntityID());
  } else if StrEndsWith(activeStr, "_Dezerter_HE") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.DezerterSignature_Active", this.GetEntityID());
  }
}


func DPAE_SuffixToExclusiveTag(suffix: String) -> CName {
  if Equals(suffix, "_EMP") {
    return n"DPAE_VariantExclusive_EMP";
  }
  if Equals(suffix, "_CHEM") {
    return n"DPAE_VariantExclusive_CHEM";
  }
  if Equals(suffix, "_Divided_CHEM") {
    return n"DPAE_VariantExclusive_Divided";
  }
  if Equals(suffix, "_Yinglong_EMP") {
    return n"DPAE_VariantExclusive_Yinglong";
  }
  if Equals(suffix, "_Hercules_CHEM") {
    return n"DPAE_VariantExclusive_Hercules";
  }
  if Equals(suffix, "_Sparky_EMP") {
    return n"DPAE_VariantExclusive_Sparky";
  }
  if Equals(suffix, "_Dezerter_HE") {
    return n"DPAE_VariantExclusive_Dezerter";
  }
  return n"DPAE_VariantExclusive_HE";
}

func DPAE_GetExclusiveVariantSuffixes(caliberStr: String) -> array<String> {
  let suffixes: array<String>;
  if Equals(caliberStr, "Ammo.Cal23x152Sov") {
    ArrayPush(suffixes, "_HE");         // Borzaya / O'Five (pre-existing, unrelated)
    ArrayPush(suffixes, "_Sparky_EMP"); // Sparky's own signature round
  } else if Equals(caliberStr, "Ammo.Cal45Super") {
    ArrayPush(suffixes, "_HE");   // Seraph
  } else if Equals(caliberStr, "Ammo.Cal12p3x41UdaR") {
    ArrayPush(suffixes, "_HE");   // Doom Doom
  } else if Equals(caliberStr, "Ammo.Cal5p56CT") {
    ArrayPush(suffixes, "_HE");   // Psalm 11:6
  } else if Equals(caliberStr, "Ammo.Cal4Gauge") {
    ArrayPush(suffixes, "_EMP");  // Mox
  } else if Equals(caliberStr, "Ammo.Cal10x40Rocket") {
    ArrayPush(suffixes, "_Divided_CHEM");  // Divided We Stand's own signature round
  } else if Equals(caliberStr, "Ammo.Cal9p5x35Minirocket") {
    ArrayPush(suffixes, "_Yinglong_EMP");  // Yinglong's own signature round
  } else if Equals(caliberStr, "Ammo.Cal12x45Rocket") {
    ArrayPush(suffixes, "_Hercules_CHEM"); // Hercules's own signature round
  } else if Equals(caliberStr, "Ammo.Cal10GaugeBuck") {
    ArrayPush(suffixes, "_Dezerter_HE");   // Dezerter's own signature round
  }
  return suffixes;
}

@addMethod(PlayerPuppet)
public func DPAE_GetRestrictedVariantSuffixes() -> String {
  let caliberStr = TDBID.ToStringDEBUG(this.dpae_caliber);
  let exclusiveSuffixes = DPAE_GetExclusiveVariantSuffixes(caliberStr);
  if ArraySize(exclusiveSuffixes) == 0 {
    return "";
  }
  let ts = GameInstance.GetTransactionSystem(this.GetGame());
  let weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if !IsDefined(weaponObj) {
    weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
  }
  let hasWeapon = false;
  let weaponItemID: ItemID;
  if IsDefined(weaponObj) {
    weaponItemID = weaponObj.GetItemID();
    hasWeapon = ItemID.IsValid(weaponItemID);
  }
  let result = "";
  let i = 0;
  while i < ArraySize(exclusiveSuffixes) {
    let suffix = exclusiveSuffixes[i];
    let hasPermission = hasWeapon && ts.HasTag(this, DPAE_SuffixToExclusiveTag(suffix), weaponItemID);
    if !hasPermission {
      if !Equals(result, "") {
        result += ",";
      }
      result += suffix;
    }
    i += 1;
  }
  return result;
}

