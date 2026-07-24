

@addMethod(PlayerPuppet)
public func DPAE_ResolveAmmoSelection(caliberTDBID: TweakDBID) -> Void {
  let ts = GameInstance.GetTransactionSystem(this.GetGame());

  if TDBID.IsValid(this.dpae_locked_variant) {
    this.DPAE_SelectAmmo(this.dpae_locked_variant);
    return;
  }

  let rememberedID = this.DPAE_GetRememberedAmmo(caliberTDBID);
  if TDBID.IsValid(rememberedID) && ts.GetItemQuantity(this, ItemID.FromTDBID(rememberedID)) > 0 {
    this.DPAE_SelectAmmo(rememberedID);
  } else {
    let largestID = DPAE_GetLargestAmmoVariant(this, caliberTDBID);
    if TDBID.IsValid(largestID) {
      this.DPAE_SelectAmmo(largestID);
    } else {
      this.dpae_active_ammo = TDBID.None();
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

public class DPAE_ResumeSelectEvent extends Event {
  public let caliberTDBID: TweakDBID;
  public let expectedWeapon: wref<WeaponObject>;
}

@addMethod(PlayerPuppet)
protected cb func DPAE_OnResumeSelect(evt: ref<DPAE_ResumeSelectEvent>) -> Bool {
  let ts    = GameInstance.GetTransactionSystem(this.GetGame());
  let right = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  let left  = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
  if !IsDefined(evt.expectedWeapon) || (evt.expectedWeapon != right && evt.expectedWeapon != left) {
    return true;
  }
  this.DPAE_ResolveAmmoSelection(evt.caliberTDBID);
  return true;
}

@addMethod(PlayerPuppet)
private func DPAE_HandleWeaponSlotEvent(slotID: TweakDBID) -> Void {
  let ts      = GameInstance.GetTransactionSystem(this.GetGame());

  let isRightSlot = Equals(slotID, t"AttachmentSlots.WeaponRight");
  let weaponObjPeek = ts.GetItemInSlot(this, slotID) as WeaponObject;
  let peekItemID: ItemID;
  if IsDefined(weaponObjPeek) { peekItemID = weaponObjPeek.GetItemID(); }

  let previousItemID = isRightSlot ? this.dpae_current_weapon_right : this.dpae_current_weapon_left;
  if ItemID.IsValid(peekItemID) && peekItemID == previousItemID {
    return;
  }
  if isRightSlot {
    this.dpae_current_weapon_right = peekItemID;
  } else {
    this.dpae_current_weapon_left = peekItemID;
  }

  let dummyID = this.DPAE_GetDummyItemID();

  let leftover = ts.GetItemQuantity(this, dummyID);
  if leftover > 0 { ts.RemoveItem(this, dummyID, leftover); }
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

  let caliberTDBID = DPAE_GetCaliberFromEntity(this, weaponItemID);
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

  let newDummyID = this.DPAE_GetDummyItemID();
  let staleTokens = ts.GetItemQuantity(this, newDummyID);
  if staleTokens > 0 { ts.RemoveItem(this, newDummyID, staleTokens); }

  if !TDBID.IsValid(this.dpae_locked_variant) {
    let knownIdx = this.DPAE_FindKnownWeaponIndex(weaponItemID);
    if knownIdx >= 0 {
      let rememberedAmmoID  = this.dpae_known_weapon_ammo[knownIdx];
      let rememberedChamber = this.dpae_known_weapon_chamber[knownIdx];
      if TDBID.IsValid(rememberedAmmoID) && ts.GetItemQuantity(this, ItemID.FromTDBID(rememberedAmmoID)) > 0 {
        this.DPAE_SelectAmmo(rememberedAmmoID);

        let restoreEvt = new SetAmmoCountEvent();
        restoreEvt.ammoTypeID = WeaponObject.GetAmmoType(weaponObj);
        restoreEvt.count      = rememberedChamber;
        GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(weaponObj, restoreEvt, 0.05, false);
        return;
      }
    }
  }

  let currentPct = WeaponObject.GetMagazinePercentage(weaponObj);
  if currentPct > 0.001 {
    let zeroEvt = new SetAmmoCountEvent();
    zeroEvt.ammoTypeID = WeaponObject.GetAmmoType(weaponObj);
    zeroEvt.count = Cast<Uint32>(0);
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(weaponObj, zeroEvt, 0.05, false);

    let resumeEvt = new DPAE_ResumeSelectEvent();
    resumeEvt.caliberTDBID   = caliberTDBID;
    resumeEvt.expectedWeapon = weaponObj;
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, resumeEvt, 0.15, false);
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

  this.DPAE_HandleWeaponSlotEvent(slotID);
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result = wrappedMethod();
  this.DPAE_HandleWeaponSlotEvent(t"AttachmentSlots.WeaponRight");
  this.DPAE_HandleWeaponSlotEvent(t"AttachmentSlots.WeaponLeft");
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


