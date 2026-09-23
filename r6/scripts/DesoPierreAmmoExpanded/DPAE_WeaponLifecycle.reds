
@addMethod(PlayerPuppet)
public func DPAE_ResolveAmmoSelection(caliberTDBID: TweakDBID) -> Void {
  let ts = GameInstance.GetTransactionSystem(this.GetGame());

  if TDBID.IsValid(this.dpae_locked_variant) {
    if DesoPierreAmmoExpandedSettings.AmmoStarterSafetyNet()
      && ts.GetItemQuantity(this, ItemID.FromTDBID(this.dpae_locked_variant)) <= 0 {
      if !this.DPAE_HasCaliberStarterBeenGranted(caliberTDBID) {
        this.DPAE_GrantCaliberStarter(caliberTDBID, this.dpae_locked_variant);
      } else if this.DPAE_IsNarrativeAmmoWindowActive() {

        this.DPAE_GiveAmmoInternal(this.dpae_locked_variant, this.DPAE_GetEquippedMagazineCapacity());
      }
    }
    this.DPAE_SelectAmmo(this.dpae_locked_variant);
    return;
  }

  if DesoPierreAmmoExpandedSettings.AmmoStarterSafetyNet() && this.DPAE_IsJohnnyPossession() {
    let johnnySignatureID = DPAE_GetCaliberHEVariant(caliberTDBID);
    if TDBID.IsValid(johnnySignatureID) {
      if ts.GetItemQuantity(this, ItemID.FromTDBID(johnnySignatureID)) <= 0 {
        this.DPAE_GiveAmmoInternal(johnnySignatureID, this.DPAE_GetEquippedMagazineCapacity());
      }
      this.DPAE_SelectAmmo(johnnySignatureID);
      return;
    }
  }

  let rememberedID = this.DPAE_GetRememberedAmmo(caliberTDBID);
  if TDBID.IsValid(rememberedID) && ts.GetItemQuantity(this, ItemID.FromTDBID(rememberedID)) > 0 {
    this.DPAE_SelectAmmo(rememberedID);
  } else {

    let largestID = DPAE_GetLargestAmmoVariant(this, caliberTDBID);
    if TDBID.IsValid(largestID) {
      this.DPAE_SelectAmmo(largestID);
    } else if DesoPierreAmmoExpandedSettings.AmmoStarterSafetyNet() && !this.DPAE_HasCaliberStarterBeenGranted(caliberTDBID) {

      this.DPAE_GrantCaliberStarter(caliberTDBID, caliberTDBID);
      this.DPAE_SelectAmmo(caliberTDBID);
    } else if DesoPierreAmmoExpandedSettings.AmmoStarterSafetyNet() && this.DPAE_IsNarrativeAmmoWindowActive() {

      this.DPAE_GiveAmmoInternal(caliberTDBID, this.DPAE_GetEquippedMagazineCapacity());
      this.DPAE_SelectAmmo(caliberTDBID);
    } else {
      this.dpae_active_ammo = TDBID.None();
      let clearedResolveWeapon: ItemID;
      this.dpae_active_ammo_weapon = clearedResolveWeapon;
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
      let weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
      if !IsDefined(weaponObj) {
        weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
      }
      if IsDefined(weaponObj) { weaponObj.DefaultRangedAttackPackage(); }
    }
  }
}

@addMethod(PlayerPuppet)
private func DPAE_HandleWeaponSlotEvent(slotID: TweakDBID, isSessionLoad: Bool) -> Void {
  let ts      = GameInstance.GetTransactionSystem(this.GetGame());

  let isRightSlot = Equals(slotID, t"AttachmentSlots.WeaponRight");
  let weaponObjPeek = ts.GetItemInSlot(this, slotID) as WeaponObject;
  let peekItemID: ItemID;
  if IsDefined(weaponObjPeek) { peekItemID = weaponObjPeek.GetItemID(); }

  let previousItemID = isRightSlot ? this.dpae_current_weapon_right : this.dpae_current_weapon_left;
  if ItemID.IsValid(peekItemID) && peekItemID == previousItemID {
    return;
  }

  let caliberTDBID = ItemID.IsValid(peekItemID) ? DPAE_GetCaliberFromEntity(this, peekItemID) : TDBID.None();

  if !TDBID.IsValid(caliberTDBID) && TDBID.IsValid(this.dpae_caliber) {
    let otherSlotID = isRightSlot ? t"AttachmentSlots.WeaponLeft" : t"AttachmentSlots.WeaponRight";
    let otherWeapon = ts.GetItemInSlot(this, otherSlotID) as WeaponObject;
    if IsDefined(otherWeapon) {
      let otherItemID = otherWeapon.GetItemID();
      if ItemID.IsValid(otherItemID) && Equals(DPAE_GetCaliberFromEntity(this, otherItemID), this.dpae_caliber) {
        return;
      }
    }
  }

  if isRightSlot {
    this.dpae_current_weapon_right = peekItemID;
  } else {
    this.dpae_current_weapon_left = peekItemID;
  }

  let clearedZeroWeapon: ItemID;
  this.dpae_pending_zero_weapon  = clearedZeroWeapon;
  this.dpae_pending_zero_caliber = TDBID.None();
  let clearedRestoreWeapon: ItemID;
  this.dpae_pending_restore_weapon = clearedRestoreWeapon;

  let dummyID = this.DPAE_GetDummyItemID();

  if !isSessionLoad {
    let leftover = ts.GetItemQuantity(this, dummyID);
    if leftover > 0 { ts.RemoveItem(this, dummyID, leftover); }
  }
  this.dpae_test_active       = false;
  let dpaeNoEffects: array<TweakDBID>;
  this.dpae_pending_effect    = dpaeNoEffects;
  this.dpae_pending_nl        = false;
  this.DPAE_RemoveSlugModifiers();
  this.DPAE_RemoveArmorPenModifier();
  this.DPAE_RemoveSnakeshotModifiers();

  let weaponObj = weaponObjPeek;
  if !IsDefined(weaponObj) { return; }

  let weaponItemID = peekItemID;
  if !ItemID.IsValid(weaponItemID) { return; }

  if !TDBID.IsValid(caliberTDBID) {

    this.dpae_caliber        = TDBID.None();
    this.dpae_dummy_ammo     = TDBID.None();
    this.dpae_is_tube_fed    = false;
    this.dpae_is_masked_ammo = false;
    this.dpae_locked_variant = TDBID.None();
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
    weaponObj.DefaultRangedAttackPackage();
    return;
  }

  this.dpae_caliber        = caliberTDBID;
  this.dpae_dummy_ammo     = ItemID.GetTDBID(WeaponObject.GetAmmoType(weaponObj));
  this.dpae_is_tube_fed    = ts.HasTag(this, n"DPAE_TubeFed", weaponItemID);
  this.dpae_is_masked_ammo = ts.HasTag(this, n"DPAE_MaskedAmmo", weaponItemID);
  this.dpae_locked_variant = DPAE_GetLockedVariant(this, weaponItemID, caliberTDBID);

  if !isSessionLoad {
    let newDummyID = this.DPAE_GetDummyItemID();
    let staleTokens = ts.GetItemQuantity(this, newDummyID);
    if staleTokens > 0 { ts.RemoveItem(this, newDummyID, staleTokens); }
  }

  if !TDBID.IsValid(this.dpae_locked_variant) {
    let knownIdx = this.DPAE_FindKnownWeaponIndex(weaponItemID);
    if knownIdx >= 0 {
      let rememberedAmmoID  = this.dpae_known_weapon_ammo[knownIdx];
      let rememberedChamber = this.dpae_known_weapon_chamber[knownIdx];

      let rememberedBelongsToCaliber = TDBID.IsValid(rememberedAmmoID)
        && StrBeginsWith(TDBID.ToStringDEBUG(rememberedAmmoID), TDBID.ToStringDEBUG(caliberTDBID));
      if rememberedBelongsToCaliber && ts.GetItemQuantity(this, ItemID.FromTDBID(rememberedAmmoID)) > 0 {
        if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() {
          LogChannel(n"DEBUG", "[DPAE_SWAPLOG] known-weapon restore ENTRY ammo=" + TDBID.ToStringDEBUG(rememberedAmmoID)
            + " rememberedChamber=" + ToString(rememberedChamber)
            + " realQtyBefore=" + ToString(ts.GetItemQuantity(this, ItemID.FromTDBID(rememberedAmmoID)))
            + " dummyQtyBefore=" + ToString(ts.GetItemQuantity(this, this.DPAE_GetDummyItemID())));
        }

        this.DPAE_SelectAmmo(rememberedAmmoID);

        if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() {
          LogChannel(n"DEBUG", "[DPAE_SWAPLOG] known-weapon restore POST-SELECT"
            + " realQtyAfter=" + ToString(ts.GetItemQuantity(this, ItemID.FromTDBID(rememberedAmmoID)))
            + " dummyQtyAfter=" + ToString(ts.GetItemQuantity(this, this.DPAE_GetDummyItemID()))
            + " chamberPctNow=" + ToString(WeaponObject.GetMagazinePercentage(weaponObj)));
        }

        this.dpae_pending_restore_weapon = weaponItemID;

        let restoreEvt = new SetAmmoCountEvent();
        restoreEvt.ammoTypeID = WeaponObject.GetAmmoType(weaponObj);
        restoreEvt.count      = rememberedChamber;
        GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(weaponObj, restoreEvt, 0.05, false);
        return;
      }
    }
  }

  if isSessionLoad {
    if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() {
      LogChannel(n"DEBUG", "[DPAE_LOADFIX] HandleWeaponSlotEvent SESSION-LOAD branch slot=" + (isRightSlot ? "Right" : "Left")
        + " caliber=" + TDBID.ToStringDEBUG(caliberTDBID)
        + " weaponMagPct=" + ToString(WeaponObject.GetMagazinePercentage(weaponObj))
        + " lockedVariant=" + TDBID.ToStringDEBUG(this.dpae_locked_variant));
    }

    let savedVariant = this.DPAE_GetSavedVariant(isRightSlot, caliberTDBID);
    if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() {
      LogChannel(n"DEBUG", "[DPAE_LOADFIX] savedVariant=" + TDBID.ToStringDEBUG(savedVariant)
        + " ownedQty=" + (TDBID.IsValid(savedVariant) ? ToString(ts.GetItemQuantity(this, ItemID.FromTDBID(savedVariant))) : "n/a"));
    }
    if TDBID.IsValid(savedVariant) && ts.GetItemQuantity(this, ItemID.FromTDBID(savedVariant)) > 0 {
      this.DPAE_RememberAmmo(caliberTDBID, savedVariant);
    }

    this.dpae_resync_only = true;
    this.DPAE_ResolveAmmoSelection(caliberTDBID);
    this.dpae_resync_only = false;
    if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() {
      LogChannel(n"DEBUG", "[DPAE_LOADFIX] POST-resolve activeAmmo=" + TDBID.ToStringDEBUG(this.dpae_active_ammo)
        + " dummyQtyNow=" + ToString(ts.GetItemQuantity(this, dummyID))
        + " magPctNow=" + ToString(WeaponObject.GetMagazinePercentage(weaponObj)));
    }
    return;
  }

  let currentPct = WeaponObject.GetMagazinePercentage(weaponObj);
  if currentPct > 0.001 {
    let zeroEvt = new SetAmmoCountEvent();
    zeroEvt.ammoTypeID = WeaponObject.GetAmmoType(weaponObj);
    zeroEvt.count = Cast<Uint32>(0);
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(weaponObj, zeroEvt, 0.05, false);

    this.dpae_pending_zero_weapon  = weaponItemID;
    this.dpae_pending_zero_caliber = caliberTDBID;
  } else {
    this.DPAE_ResolveAmmoSelection(caliberTDBID);
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
  let result = wrappedMethod(evt);
  let slotID = evt.GetSlotID();

  if !Equals(slotID, t"AttachmentSlots.WeaponRight") && !Equals(slotID, t"AttachmentSlots.WeaponLeft") {
    return result;
  }

  let isRightSlot = Equals(slotID, t"AttachmentSlots.WeaponRight");
  let isLoadRequip = isRightSlot ? this.dpae_pending_load_requip_right : this.dpae_pending_load_requip_left;
  let elapsedSinceAttach = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame())) - this.dpae_load_attach_time;
  if isLoadRequip && elapsedSinceAttach > 5.0 {
    isLoadRequip = false;
  }
  if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() {
    LogChannel(n"DEBUG", "[DPAE_LOADFIX] OnItemAddedToSlot slot=" + (isRightSlot ? "Right" : "Left")
      + " flagWasSet=" + ToString(isRightSlot ? this.dpae_pending_load_requip_right : this.dpae_pending_load_requip_left)
      + " elapsed=" + ToString(elapsedSinceAttach)
      + " -> isLoadRequip=" + ToString(isLoadRequip));
  }
  if isRightSlot {
    this.dpae_pending_load_requip_right = false;
  } else {
    this.dpae_pending_load_requip_left = false;
  }

  this.DPAE_HandleWeaponSlotEvent(slotID, isLoadRequip);
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result = wrappedMethod();

  this.dpae_load_attach_time = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame()));
  this.dpae_pending_load_requip_right = true;
  this.dpae_pending_load_requip_left  = true;
  if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() {
    LogChannel(n"DEBUG", "[DPAE_LOADFIX] OnGameAttached stamp=" + ToString(this.dpae_load_attach_time)
      + " armed both pending flags");
  }
  this.DPAE_HandleWeaponSlotEvent(t"AttachmentSlots.WeaponRight", true);
  this.DPAE_HandleWeaponSlotEvent(t"AttachmentSlots.WeaponLeft", true);
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemRemovedFromSlot(evt: ref<ItemRemovedFromSlot>) -> Bool {
  let result = wrappedMethod(evt);
  let slotID = evt.GetSlotID();
  if !Equals(slotID, t"AttachmentSlots.WeaponRight") && !Equals(slotID, t"AttachmentSlots.WeaponLeft") {
    return result;
  }

  let clearedID: ItemID;
  if Equals(slotID, t"AttachmentSlots.WeaponRight") {
    this.dpae_current_weapon_right = clearedID;
  } else {
    this.dpae_current_weapon_left = clearedID;
  }

  let itemID = evt.GetItemID();

  if ItemID.IsValid(this.dpae_pending_zero_weapon) && this.dpae_pending_zero_weapon == itemID {
    let clearedZeroWeapon: ItemID;
    this.dpae_pending_zero_weapon  = clearedZeroWeapon;
    this.dpae_pending_zero_caliber = TDBID.None();
  }
  if ItemID.IsValid(this.dpae_pending_restore_weapon) && this.dpae_pending_restore_weapon == itemID {
    let clearedRestoreWeapon: ItemID;
    this.dpae_pending_restore_weapon = clearedRestoreWeapon;
  }

  if !ItemID.IsValid(itemID) { return result; }

  let weaponRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)) as WeaponItem_Record;
  if !IsDefined(weaponRecord) { return result; }

  let ammoRecord = weaponRecord.Ammo();
  if !IsDefined(ammoRecord) { return result; }

  let nativeAmmoTDBID = ammoRecord.GetID();
  if !TDBID.IsValid(nativeAmmoTDBID) { return result; }

  let ts = GameInstance.GetTransactionSystem(this.GetGame());

  if ts.HasTag(this, n"HMG", itemID) { return result; }

  let rightWeapon = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if IsDefined(rightWeapon) && rightWeapon.GetItemID() != itemID && Equals(ItemID.GetTDBID(WeaponObject.GetAmmoType(rightWeapon)), nativeAmmoTDBID) {
    return result;
  }
  let leftWeapon = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
  if IsDefined(leftWeapon) && leftWeapon.GetItemID() != itemID && Equals(ItemID.GetTDBID(WeaponObject.GetAmmoType(leftWeapon)), nativeAmmoTDBID) {
    return result;
  }

  let nativeID = ItemID.FromTDBID(nativeAmmoTDBID);
  let leftover = ts.GetItemQuantity(this, nativeID);
  if leftover > 0 { ts.RemoveItem(this, nativeID, leftover); }

  return result;
}

