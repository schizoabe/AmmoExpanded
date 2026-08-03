

@addField(PlayerPuppet) public let dpae_test_active: Bool;
@addField(PlayerPuppet) public let dpae_prev_mag_pct: Float;
@addField(PlayerPuppet) public let dpae_prev_dummy_qty: Int32;
@addField(PlayerPuppet) public let dpae_dummy_ammo: TweakDBID;
@addField(PlayerPuppet) public let dpae_pending_internal_dummy_qty: Int32;
@addField(PlayerPuppet) public let dpae_pending_disassembly_caliber: TweakDBID;
@addField(PlayerPuppet) public let dpae_pending_zero_weapon: ItemID;
@addField(PlayerPuppet) public let dpae_pending_zero_caliber: TweakDBID;
@addField(PlayerPuppet) public let dpae_caliber: TweakDBID;
@addField(PlayerPuppet) public let dpae_locked_variant: TweakDBID;
@addField(PlayerPuppet) public let dpae_is_tube_fed: Bool;
@addField(PlayerPuppet) public let dpae_is_masked_ammo: Bool;
@addField(PlayerPuppet) public let dpae_masked_first_shot_owed: Bool;
@addField(PlayerPuppet) public let dpae_pending_forced_drain_pending: Bool;
@addField(PlayerPuppet) public let dpae_pending_forced_drain_weapon: ItemID;
@addField(PlayerPuppet) public let dpae_pending_forced_drain_pad: Uint32;
@addField(PlayerPuppet) public let dpae_active_ammo: TweakDBID;
@addField(PlayerPuppet) public let dpae_known_weapons: array<ItemID>;
@addField(PlayerPuppet) public let dpae_known_weapon_ammo: array<TweakDBID>;
@addField(PlayerPuppet) public let dpae_known_weapon_chamber: array<Uint32>;
@addField(PlayerPuppet) public let dpae_current_weapon_right: ItemID;
@addField(PlayerPuppet) public let dpae_current_weapon_left: ItemID;
@addField(PlayerPuppet) public let dpae_pyro_qualities: array<Int32>;
@addField(PlayerPuppet) public let dpae_caustic_qualities: array<Int32>;
@addField(PlayerPuppet) public let dpae_arc_qualities: array<Int32>;
@addField(PlayerPuppet) public let dpae_pending_effect: array<TweakDBID>;
@addField(PlayerPuppet) public let dpae_pending_nl: Bool;
@addField(PlayerPuppet) public let dpae_remembered_calibers: array<TweakDBID>;
@addField(PlayerPuppet) public let dpae_remembered_ammo:     array<TweakDBID>;

@addField(PlayerPuppet) public let dpae_starter_granted_calibers: array<TweakDBID>;

@addField(PlayerPuppet) public let dpae_pending_internal_grant_qty: Int32;

@addMethod(PlayerPuppet)
public func DPAE_GiveAmmoInternal(itemTDBID: TweakDBID, qty: Int32) -> Void {
  this.dpae_pending_internal_grant_qty += qty;
  GameInstance.GetTransactionSystem(this.GetGame()).GiveItem(this, ItemID.FromTDBID(itemTDBID), qty);
}

@addMethod(PlayerPuppet)
public func DPAE_GetEquippedMagazineCapacity() -> Int32 {
  let ts = GameInstance.GetTransactionSystem(this.GetGame());
  let weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if !IsDefined(weaponObj) {
    weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
  }
  if IsDefined(weaponObj) {
    let cap = Cast<Int32>(WeaponObject.GetMagazineCapacity(weaponObj));
    if cap > 0 { return cap; }
  }
  return 20;
}

@addField(PlayerPuppet) public let dpae_input_listener: ref<DPAE_InputListener>;

@addField(PlayerPuppet) public let dpae_slug_proj:         ref<gameStatModifierData>;
@addField(PlayerPuppet) public let dpae_slug_spreadMaxX:   ref<gameStatModifierData>;
@addField(PlayerPuppet) public let dpae_slug_spreadMaxY:   ref<gameStatModifierData>;
@addField(PlayerPuppet) public let dpae_slug_spreadAdsX:   ref<gameStatModifierData>;
@addField(PlayerPuppet) public let dpae_slug_spreadAdsY:   ref<gameStatModifierData>;
@addField(PlayerPuppet) public let dpae_slug_spreadChange: ref<gameStatModifierData>;
@addField(PlayerPuppet) public let dpae_slug_entity:       EntityID;

@addField(PlayerPuppet) public let dpae_armorpen_mod:      ref<gameStatModifierData>;
@addField(PlayerPuppet) public let dpae_armorpen_entity:   EntityID;

@addField(PlayerPuppet) public let dpae_snakeshot_proj:    ref<gameStatModifierData>;
@addField(PlayerPuppet) public let dpae_snakeshot_entity:  EntityID;

@addField(NPCPuppet) public let dpae_npcslug_proj:         ref<gameStatModifierData>;
@addField(NPCPuppet) public let dpae_npcslug_spreadMaxX:   ref<gameStatModifierData>;
@addField(NPCPuppet) public let dpae_npcslug_spreadMaxY:   ref<gameStatModifierData>;
@addField(NPCPuppet) public let dpae_npcslug_spreadAdsX:   ref<gameStatModifierData>;
@addField(NPCPuppet) public let dpae_npcslug_spreadAdsY:   ref<gameStatModifierData>;
@addField(NPCPuppet) public let dpae_npcslug_spreadChange: ref<gameStatModifierData>;
@addField(NPCPuppet) public let dpae_npcslug_entity:       EntityID;
@addField(NPCPuppet) public let dpae_npcsnake_proj:        ref<gameStatModifierData>;
@addField(NPCPuppet) public let dpae_npcsnake_entity:      EntityID;

@addField(NPCPuppet) public let dpae_npcarmorpen_mod:      ref<gameStatModifierData>;
@addField(NPCPuppet) public let dpae_npcarmorpen_entity:   EntityID;



@addMethod(PlayerPuppet)
private func DPAE_FindKnownWeaponIndex(itemID: ItemID) -> Int32 {
  let i = 0;
  while i < ArraySize(this.dpae_known_weapons) {
    if this.dpae_known_weapons[i] == itemID { return i; }
    i += 1;
  }
  return -1;
}

@addMethod(PlayerPuppet)
public func DPAE_RecordWeaponState(itemID: ItemID, ammoID: TweakDBID, chamberCount: Uint32) -> Void {
  if !ItemID.IsValid(itemID) { return; }
  let idx = this.DPAE_FindKnownWeaponIndex(itemID);
  if idx >= 0 {
    this.dpae_known_weapon_ammo[idx]    = ammoID;
    this.dpae_known_weapon_chamber[idx] = chamberCount;
  } else {
    ArrayPush(this.dpae_known_weapons, itemID);
    ArrayPush(this.dpae_known_weapon_ammo, ammoID);
    ArrayPush(this.dpae_known_weapon_chamber, chamberCount);
  }
}


@addMethod(PlayerPuppet)
public func DPAE_IsActive() -> Bool { return this.dpae_test_active; }

@addMethod(PlayerPuppet)
public func DPAE_IsTubeFed() -> Bool { return this.dpae_is_tube_fed; }


@addMethod(PlayerPuppet)
public func DPAE_RememberAmmo(caliberID: TweakDBID, ammoID: TweakDBID) -> Void {
  let i = 0;
  while i < ArraySize(this.dpae_remembered_calibers) {
    if Equals(this.dpae_remembered_calibers[i], caliberID) {
      this.dpae_remembered_ammo[i] = ammoID;
      return;
    }
    i += 1;
  }
  ArrayPush(this.dpae_remembered_calibers, caliberID);
  ArrayPush(this.dpae_remembered_ammo, ammoID);
}

@addMethod(PlayerPuppet)
public func DPAE_GetRememberedAmmo(caliberID: TweakDBID) -> TweakDBID {
  let i = 0;
  while i < ArraySize(this.dpae_remembered_calibers) {
    if Equals(this.dpae_remembered_calibers[i], caliberID) {
      return this.dpae_remembered_ammo[i];
    }
    i += 1;
  }
  return TDBID.None();
}


@addMethod(PlayerPuppet)
public func DPAE_HasCaliberStarterBeenGranted(caliberID: TweakDBID) -> Bool {
  let i = 0;
  while i < ArraySize(this.dpae_starter_granted_calibers) {
    if Equals(this.dpae_starter_granted_calibers[i], caliberID) { return true; }
    i += 1;
  }
  return false;
}

@addMethod(PlayerPuppet)
public func DPAE_GrantCaliberStarter(caliberID: TweakDBID, grantID: TweakDBID) -> Void {
  this.DPAE_GiveAmmoInternal(grantID, this.DPAE_GetEquippedMagazineCapacity());
  ArrayPush(this.dpae_starter_granted_calibers, caliberID);
}

