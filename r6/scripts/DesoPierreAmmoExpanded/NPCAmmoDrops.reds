
func DPAE_DropChance() -> Float { return 1.00; }

func DPAE_QtyMinPct() -> Float { return 0.40; }
func DPAE_QtyMaxPct() -> Float { return 1.00; }

@addField(NPCPuppet)
public let dpae_hasAmmoData: Bool;

@addField(NPCPuppet)
public let dpae_ammoTDBID: TweakDBID;

@addField(NPCPuppet)
public let dpae_weaponItemType: gamedataItemType;

@addField(NPCPuppet)
public let dpae_npc_ammo: TweakDBID;


func DPAE_GetSpecialVariants(caliberTDBID: TweakDBID) -> array<TweakDBID> {
  let validSpecial: array<TweakDBID>;
  if !TDBID.IsValid(caliberTDBID) { return validSpecial; }
  let baseStr = TDBID.ToStringDEBUG(caliberTDBID);

  let suffixes: array<String>;
  ArrayPush(suffixes, "_HP");
  ArrayPush(suffixes, "_AP");
  ArrayPush(suffixes, "_NL");
  ArrayPush(suffixes, "_EMP");
  ArrayPush(suffixes, "_INC");
  ArrayPush(suffixes, "_CHEM");
  ArrayPush(suffixes, "_Slug");
  ArrayPush(suffixes, "_Snakeshot");
  ArrayPush(suffixes, "_HE");
  ArrayPush(suffixes, "HE");

  let i = 0;
  while i < ArraySize(suffixes) {
    let candidate = TDBID.Create(baseStr + suffixes[i]);
    if IsDefined(TweakDBInterface.GetItemRecord(candidate)) {
      ArrayPush(validSpecial, candidate);
    }
    i += 1;
  }
  return validSpecial;
}

func DPAE_RollNPCAmmoVariant(caliberTDBID: TweakDBID) -> TweakDBID {
  if !TDBID.IsValid(caliberTDBID) { return TDBID.None(); }
  let validSpecial  = DPAE_GetSpecialVariants(caliberTDBID);
  let specialCount = ArraySize(validSpecial);
  if specialCount <= 0 { return caliberTDBID; }

  let roll = RandF();
  if roll < 0.55 { return caliberTDBID; }

  let specialRoll = (roll - 0.55) / 0.45;
  let idx = Cast<Int32>(specialRoll * Cast<Float>(specialCount));
  if idx >= specialCount { idx = specialCount - 1; }
  return validSpecial[idx];
}

func DPAE_GetLargestAmmoVariant(owner: ref<GameObject>, caliberTDBID: TweakDBID) -> TweakDBID {
  if !TDBID.IsValid(caliberTDBID) { return TDBID.None(); }
  let ts = GameInstance.GetTransactionSystem(owner.GetGame());

  let bestID  = TDBID.None();
  let bestQty = 0;

  let plainQty = ts.GetItemQuantity(owner, ItemID.FromTDBID(caliberTDBID));
  if plainQty > bestQty { bestQty = plainQty; bestID = caliberTDBID; }

  let specials = DPAE_GetSpecialVariants(caliberTDBID);
  let i = 0;
  while i < ArraySize(specials) {
    let qty = ts.GetItemQuantity(owner, ItemID.FromTDBID(specials[i]));
    if qty > bestQty { bestQty = qty; bestID = specials[i]; }
    i += 1;
  }
  return bestID;
}

func DPAE_GetNextAutoSwapVariant(owner: ref<GameObject>, caliberTDBID: TweakDBID) -> TweakDBID {
  if !TDBID.IsValid(caliberTDBID) { return TDBID.None(); }
  let ts = GameInstance.GetTransactionSystem(owner.GetGame());

  let bestID  = TDBID.None();
  let bestQty = 0;

  let specials = DPAE_GetSpecialVariants(caliberTDBID);
  let i = 0;
  while i < ArraySize(specials) {
    let qty = ts.GetItemQuantity(owner, ItemID.FromTDBID(specials[i]));
    if qty > bestQty { bestQty = qty; bestID = specials[i]; }
    i += 1;
  }
  if TDBID.IsValid(bestID) { return bestID; }

  let plainQty = ts.GetItemQuantity(owner, ItemID.FromTDBID(caliberTDBID));
  if plainQty > 0 { return caliberTDBID; }

  return TDBID.None();
}

@wrapMethod(NPCPuppet)
protected cb func OnItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
  let result = wrappedMethod(evt);
  let slotID = evt.GetSlotID();
  if !Equals(slotID, t"AttachmentSlots.WeaponRight") && !Equals(slotID, t"AttachmentSlots.WeaponLeft") {
    return result;
  }

  let ts        = GameInstance.GetTransactionSystem(this.GetGame());
  let weaponObj = ts.GetItemInSlot(this, slotID) as WeaponObject;
  if !IsDefined(weaponObj) || weaponObj.IsMelee() { return result; }

  let weaponItemID = weaponObj.GetItemID();
  if !ItemID.IsValid(weaponItemID) { return result; }

  let caliberTDBID = DPAE_GetCaliberFromEntity(this, weaponItemID);
  if !TDBID.IsValid(caliberTDBID) {
    this.dpae_npc_ammo = TDBID.None();
    return result;
  }

  let lockedVariant = DPAE_GetLockedVariant(this, weaponItemID, caliberTDBID);
  this.dpae_npc_ammo = TDBID.IsValid(lockedVariant) ? lockedVariant : DPAE_RollNPCAmmoVariant(caliberTDBID);

  let npcAmmoStrHE = TDBID.ToStringDEBUG(this.dpae_npc_ammo);
  if StrEndsWith(npcAmmoStrHE, "HE") {
    weaponObj.OverrideRangedAttackPackage(TweakDBInterface.GetRangedAttackPackageRecord(DPAE_GetExplosivePackageForRound(npcAmmoStrHE)));
  }

  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.INC_Burn");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.EMP_Shock");
  StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.CHEM_Poison");
  let npcAmmoStr = TDBID.ToStringDEBUG(this.dpae_npc_ammo);
  if StrEndsWith(npcAmmoStr, "_INC") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.INC_Burn", this.GetEntityID());
  } else if StrEndsWith(npcAmmoStr, "_EMP") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.EMP_Shock", this.GetEntityID());
  } else if StrEndsWith(npcAmmoStr, "_CHEM") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.CHEM_Poison", this.GetEntityID());
  }

  this.DPAE_RemoveSlugModifiersNPC();
  this.DPAE_RemoveSnakeshotModifiersNPC();
  if StrEndsWith(npcAmmoStr, "_Slug") {
    this.DPAE_ApplySlugModifiersNPC(weaponObj);
  } else if StrEndsWith(npcAmmoStr, "_Snakeshot") {
    this.DPAE_ApplySnakeshotModifiersNPC(weaponObj);
  }

  this.DPAE_UpdateArmorPierceNPC(npcAmmoStr, weaponObj);

  return result;
}

@addMethod(NPCPuppet)
public func DPAE_CacheAmmoDropData() -> Void {
  let weapon = ScriptedPuppet.GetActiveWeapon(this);
  if !IsDefined(weapon) { weapon = ScriptedPuppet.GetWeaponRight(this); }
  if !IsDefined(weapon) { weapon = ScriptedPuppet.GetWeaponLeft(this); }
  if !IsDefined(weapon) || weapon.IsMelee() { return; }

  let ts = GameInstance.GetTransactionSystem(this.GetGame());
  if ts.HasTag(this, n"HMG", weapon.GetItemID()) { return; }

  let weaponRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(weapon.GetItemID())) as WeaponItem_Record;
  if !IsDefined(weaponRecord) { return; }

  let ammoRecord = weaponRecord.Ammo();
  if !IsDefined(ammoRecord) { return; }

  let ammoTDBID = ammoRecord.GetID();
  if !TDBID.IsValid(ammoTDBID) { return; }

  this.dpae_ammoTDBID = ammoTDBID;

  if TDBID.IsValid(this.dpae_npc_ammo) {
    this.dpae_ammoTDBID = this.dpae_npc_ammo;
  } else {
    let dpaeCaliberTDBID = DPAE_GetCaliberFromEntity(this, weapon.GetItemID());
    if TDBID.IsValid(dpaeCaliberTDBID) {
      this.dpae_ammoTDBID = dpaeCaliberTDBID;
    }
  }

  this.dpae_weaponItemType = weaponRecord.ItemType().Type();
  this.dpae_hasAmmoData = true;
}

@wrapMethod(NPCPuppet)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
  let result = wrappedMethod(evt);
  this.DPAE_CacheAmmoDropData();
  return result;
}

@wrapMethod(NPCPuppet)
protected func OnIncapacitated() -> Void {
  wrappedMethod();
  this.DPAE_CacheAmmoDropData();
}

@wrapMethod(ScriptedPuppet)
protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
  let result = wrappedMethod(evt);
  let npc = this as NPCPuppet;
  if IsDefined(npc) && evt.isNewApplication {
    let seID = evt.staticData.GetID();
    if Equals(seID, t"BaseStatusEffect.Unconscious") || Equals(seID, t"BaseStatusEffect.Defeated") || Equals(seID, t"BaseStatusEffect.DefeatedWithRecover") {
      npc.DPAE_CacheAmmoDropData();
    }
  }
  return result;
}

@wrapMethod(ScriptedPuppet)
private final func EvaluateLootQuality() -> Bool {
  let npc = this as NPCPuppet;
  if IsDefined(npc) && npc.dpae_hasAmmoData {
    npc.dpae_hasAmmoData = false;

    let dropRoll = RandF();
    if dropRoll <= DPAE_DropChance() {
      let baseQty = DPAE_AmmoBaseQty(npc.dpae_weaponItemType);
      let pct = DPAE_QtyMinPct() + RandF() * (DPAE_QtyMaxPct() - DPAE_QtyMinPct());
      let qty = Max(1, RoundMath(Cast<Float>(baseQty) * pct));

      GameInstance.GetTransactionSystem(this.GetGame())
        .GiveItem(this, ItemID.FromTDBID(npc.dpae_ammoTDBID), qty);
    }
  }

  return wrappedMethod();
}

func DPAE_AmmoBaseQty(itemType: gamedataItemType) -> Int32 {
  switch itemType {
    case gamedataItemType.Wea_Handgun:         return 24;
    case gamedataItemType.Wea_Revolver:        return 12;
    case gamedataItemType.Wea_SubmachineGun:   return 30;
    case gamedataItemType.Wea_Shotgun:         return 8;
    case gamedataItemType.Wea_ShotgunDual:     return 8;
    case gamedataItemType.Wea_SniperRifle:     return 6;
    case gamedataItemType.Wea_PrecisionRifle:  return 6;
    case gamedataItemType.Wea_Rifle:           return 20;
    case gamedataItemType.Wea_AssaultRifle:    return 20;
    case gamedataItemType.Wea_LightMachineGun: return 40;
    case gamedataItemType.Wea_HeavyMachineGun: return 40;
    default:                                   return 15;
  }
}


@addMethod(PlayerPuppet)
public func DPAE_DropCurrentWeapon() -> Void {
  let weapon = ScriptedPuppet.GetActiveWeapon(this);
  if !IsDefined(weapon) { weapon = ScriptedPuppet.GetWeaponRight(this); }
  if !IsDefined(weapon) { weapon = ScriptedPuppet.GetWeaponLeft(this); }
  if !IsDefined(weapon) {
    return;
  }
  let weaponRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(weapon.GetItemID())) as WeaponItem_Record;
  if IsDefined(weaponRecord) {
    let itemType = weaponRecord.ItemType().Type();
    if Equals(itemType, gamedataItemType.Cyb_StrongArms) || Equals(itemType, gamedataItemType.Cyb_NanoWires)
      || Equals(itemType, gamedataItemType.Cyb_MantisBlades) || Equals(itemType, gamedataItemType.Cyb_Launcher) {
      return;
    }
  }
  ItemActionsHelper.DropItem(this, weapon.GetItemID());
}
