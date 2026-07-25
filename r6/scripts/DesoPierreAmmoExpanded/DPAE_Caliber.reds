

func DPAE_GetCaliberFromEntity(entity: ref<GameObject>, itemID: ItemID) -> TweakDBID {
  let ts = GameInstance.GetTransactionSystem(entity.GetGame());
  if ts.HasTag(entity, n"DPAE_Cal10mmAuto",      itemID) { return t"Ammo.Cal10mmAuto"; }
  if ts.HasTag(entity, n"DPAE_Cal45WinMag",      itemID) { return t"Ammo.Cal45WinMag"; }
  if ts.HasTag(entity, n"DPAE_Cal45Super",       itemID) { return t"Ammo.Cal45Super"; }
  if ts.HasTag(entity, n"DPAE_Cal50BeowulfOni",  itemID) { return t"Ammo.Cal50BeowulfOni"; }
  if ts.HasTag(entity, n"DPAE_Cal14x70TSlugHE",  itemID) { return t"Ammo.Cal14x70TSlugHE"; }
  if ts.HasTag(entity, n"DPAE_Cal9x19",          itemID) { return t"Ammo.Cal9x19"; }
  if ts.HasTag(entity, n"DPAE_Cal243Win",        itemID) { return t"Ammo.Cal243Win"; }
  if ts.HasTag(entity, n"DPAE_Cal454Casull",     itemID) { return t"Ammo.Cal454Casull"; }
  if ts.HasTag(entity, n"DPAE_Cal50AE",          itemID) { return t"Ammo.Cal50AE"; }
  if ts.HasTag(entity, n"DPAE_Cal50BMG",         itemID) { return t"Ammo.Cal50BMG"; }
  if ts.HasTag(entity, n"DPAE_Cal500Malour",     itemID) { return t"Ammo.Cal500Malour"; }
  if ts.HasTag(entity, n"DPAE_Cal10GaugeBuck",   itemID) { return t"Ammo.Cal10GaugeBuck"; }
  if ts.HasTag(entity, n"DPAE_Cal10GaugeFlech",  itemID) { return t"Ammo.Cal10GaugeFlech"; }
  if ts.HasTag(entity, n"DPAE_Cal10x40Rocket",   itemID) { return t"Ammo.Cal10x40Rocket"; }
  if ts.HasTag(entity, n"DPAE_Cal10x20TF",       itemID) { return t"Ammo.Cal10x20TF"; }
  if ts.HasTag(entity, n"DPAE_Cal12Gauge",       itemID) { return t"Ammo.Cal12Gauge"; }
  if ts.HasTag(entity, n"DPAE_Cal12p3x41UdaR",   itemID) { return t"Ammo.Cal12p3x41UdaR"; }
  if ts.HasTag(entity, n"DPAE_Cal12p7x70Rocket", itemID) { return t"Ammo.Cal12p7x70Rocket"; }
  if ts.HasTag(entity, n"DPAE_Cal12x45Rocket",   itemID) { return t"Ammo.Cal12x45Rocket"; }
  if ts.HasTag(entity, n"DPAE_Cal14x40TSlug",    itemID) { return t"Ammo.Cal14x40TSlug"; }
  if ts.HasTag(entity, n"DPAE_Cal15x55Rocket",   itemID) { return t"Ammo.Cal15x55Rocket"; }
  if ts.HasTag(entity, n"DPAE_Cal15x80TSpike",   itemID) { return t"Ammo.Cal15x80TSpike"; }
  if ts.HasTag(entity, n"DPAE_Cal18x70Rocket",   itemID) { return t"Ammo.Cal18x70Rocket"; }
  if ts.HasTag(entity, n"DPAE_Cal20x102Vulcan",  itemID) { return t"Ammo.Cal20x102Vulcan"; }
  if ts.HasTag(entity, n"DPAE_Cal22x126AC",      itemID) { return t"Ammo.Cal22x126AC"; }
  if ts.HasTag(entity, n"DPAE_Cal23x152Sov",     itemID) { return t"Ammo.Cal23x152Sov"; }
  if ts.HasTag(entity, n"DPAE_Cal3x10FlechCluster", itemID) { return t"Ammo.Cal3x10FlechCluster"; }
  if ts.HasTag(entity, n"DPAE_Cal4Gauge",        itemID) { return t"Ammo.Cal4Gauge"; }
  if ts.HasTag(entity, n"DPAE_Cal4p7x10TF",      itemID) { return t"Ammo.Cal4p7x10TF"; }
  if ts.HasTag(entity, n"DPAE_Cal5p45CT",        itemID) { return t"Ammo.Cal5p45CT"; }
  if ts.HasTag(entity, n"DPAE_Cal5p56x45NUSA",   itemID) { return t"Ammo.Cal5p56x45NUSA"; }
  if ts.HasTag(entity, n"DPAE_Cal5p56CT",        itemID) { return t"Ammo.Cal5p56CT"; }
  if ts.HasTag(entity, n"DPAE_Cal5p7x28TF",      itemID) { return t"Ammo.Cal5p7x28TF"; }
  if ts.HasTag(entity, n"DPAE_Cal6p5x25Minirocket", itemID) { return t"Ammo.Cal6p5x25Minirocket"; }
  if ts.HasTag(entity, n"DPAE_Cal6p5Arasaka",    itemID) { return t"Ammo.Cal6p5Arasaka"; }
  if ts.HasTag(entity, n"DPAE_Cal7p62x39Sov",    itemID) { return t"Ammo.Cal7p62x39Sov"; }
  if ts.HasTag(entity, n"DPAE_Cal8x30RailF",     itemID) { return t"Ammo.Cal8x30RailF"; }
  if ts.HasTag(entity, n"DPAE_Cal8x30TShot",     itemID) { return t"Ammo.Cal8x30TShot"; }
  if ts.HasTag(entity, n"DPAE_Cal9p5x35Minirocket", itemID) { return t"Ammo.Cal9p5x35Minirocket"; }
  if ts.HasTag(entity, n"DPAE_Cal9x30TF",        itemID) { return t"Ammo.Cal9x30TF"; }
  return TDBID.None();
}

public func DPAE_GetLockedVariant(entity: ref<GameObject>, itemID: ItemID, caliberTDBID: TweakDBID) -> TweakDBID {
  if !TDBID.IsValid(caliberTDBID) { return TDBID.None(); }
  let ts = GameInstance.GetTransactionSystem(entity.GetGame());
  let baseStr = TDBID.ToStringDEBUG(caliberTDBID);
  if ts.HasTag(entity, n"DPAE_LockVariant_Plain", itemID) { return caliberTDBID; }
  if ts.HasTag(entity, n"DPAE_LockVariant_HE",    itemID) { return TDBID.Create(baseStr + "_HE"); }
  if ts.HasTag(entity, n"DPAE_LockVariant_AP",    itemID) { return TDBID.Create(baseStr + "_AP"); }
  if ts.HasTag(entity, n"DPAE_LockVariant_Slug",  itemID) { return TDBID.Create(baseStr + "_Slug"); }
  return TDBID.None();
}

public func DPAE_GetNPCForcedVariant(entity: ref<GameObject>, itemID: ItemID, caliberTDBID: TweakDBID) -> TweakDBID {
  if !TDBID.IsValid(caliberTDBID) { return TDBID.None(); }
  let ts = GameInstance.GetTransactionSystem(entity.GetGame());
  let baseStr = TDBID.ToStringDEBUG(caliberTDBID);
  if ts.HasTag(entity, n"DPAE_NPCForcedAmmo_INC", itemID) { return TDBID.Create(baseStr + "_INC"); }
  return TDBID.None();
}


@addMethod(PlayerPuppet)
public func DPAE_GetCaliberString() -> String {
  if !TDBID.IsValid(this.dpae_caliber) { return ""; }
  if Equals(this.dpae_caliber, t"Ammo.Cal9x19")            { return "Cal9x19"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal243Win")          { return "Cal243Win"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal45Super")         { return "Cal45Super"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal45WinMag")        { return "Cal45WinMag"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal454Casull")       { return "Cal454Casull"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal50AE")            { return "Cal50AE"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal50BeowulfOni")    { return "Cal50BeowulfOni"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal50BMG")           { return "Cal50BMG"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal500Malour")       { return "Cal500Malour"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal10GaugeBuck")     { return "Cal10GaugeBuck"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal10GaugeFlech")    { return "Cal10GaugeFlech"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal10x40Rocket")     { return "Cal10x40Rocket"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal10mmAuto")        { return "Cal10mmAuto"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal10x20TF")         { return "Cal10x20TF"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal12Gauge")         { return "Cal12Gauge"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal12p3x41UdaR")     { return "Cal12p3x41UdaR"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal12p7x70Rocket")   { return "Cal12p7x70Rocket"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal12x45Rocket")     { return "Cal12x45Rocket"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal14x40TSlug")      { return "Cal14x40TSlug"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal14x70TSlugHE")    { return "Cal14x70TSlugHE"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal15x55Rocket")     { return "Cal15x55Rocket"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal15x80TSpike")     { return "Cal15x80TSpike"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal18x70Rocket")     { return "Cal18x70Rocket"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal20x102Vulcan")    { return "Cal20x102Vulcan"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal22x126AC")        { return "Cal22x126AC"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal23x152Sov")       { return "Cal23x152Sov"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal3x10FlechCluster"){ return "Cal3x10FlechCluster"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal4Gauge")          { return "Cal4Gauge"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal4p7x10TF")        { return "Cal4p7x10TF"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal5p45CT")          { return "Cal5p45CT"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal5p56x45NUSA")     { return "Cal5p56x45NUSA"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal5p56CT")          { return "Cal5p56CT"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal5p7x28TF")        { return "Cal5p7x28TF"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal6p5x25Minirocket"){ return "Cal6p5x25Minirocket"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal6p5Arasaka")      { return "Cal6p5Arasaka"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal7p62x39Sov")      { return "Cal7p62x39Sov"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal8x30RailF")       { return "Cal8x30RailF"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal8x30TShot")       { return "Cal8x30TShot"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal9p5x35Minirocket"){ return "Cal9p5x35Minirocket"; }
  if Equals(this.dpae_caliber, t"Ammo.Cal9x30TF")          { return "Cal9x30TF"; }
  return "";
}

@addMethod(PlayerPuppet)
public func DPAE_IsHMGEquipped() -> Bool {
  let ts = GameInstance.GetTransactionSystem(this.GetGame());
  let weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if !IsDefined(weaponObj) {
    weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
  }
  if !IsDefined(weaponObj) { return false; }
  let itemID = weaponObj.GetItemID();
  if !ItemID.IsValid(itemID) { return false; }
  return ts.HasTag(this, n"HMG", itemID);
}


@addMethod(PlayerPuppet)
public func DPAE_GetDummyItemID() -> ItemID {
  if TDBID.IsValid(this.dpae_dummy_ammo) {
    return ItemID.FromTDBID(this.dpae_dummy_ammo);
  }
  return ItemID.FromTDBID(t"Ammo.HandgunAmmo");
}

