
func DPAE_GetCaliberFromRecordTags(tags: array<CName>) -> TweakDBID {
  if ArrayContains(tags, n"DPAE_Cal10mmAuto")      { return t"Ammo.Cal10mmAuto"; }
  if ArrayContains(tags, n"DPAE_Cal45WinMag")      { return t"Ammo.Cal45WinMag"; }
  if ArrayContains(tags, n"DPAE_Cal45Super")       { return t"Ammo.Cal45Super"; }
  if ArrayContains(tags, n"DPAE_Cal50BeowulfOni")  { return t"Ammo.Cal50BeowulfOni"; }
  if ArrayContains(tags, n"DPAE_Cal14x70TSlugHE")  { return t"Ammo.Cal14x70TSlugHE"; }
  if ArrayContains(tags, n"DPAE_Cal9x19")          { return t"Ammo.Cal9x19"; }
  if ArrayContains(tags, n"DPAE_Cal243Win")        { return t"Ammo.Cal243Win"; }
  if ArrayContains(tags, n"DPAE_Cal308Win")        { return t"Ammo.Cal308Win"; }
  if ArrayContains(tags, n"DPAE_Cal454Casull")     { return t"Ammo.Cal454Casull"; }
  if ArrayContains(tags, n"DPAE_Cal50AE")          { return t"Ammo.Cal50AE"; }
  if ArrayContains(tags, n"DPAE_Cal50BMG")         { return t"Ammo.Cal50BMG"; }
  if ArrayContains(tags, n"DPAE_Cal500Malour")     { return t"Ammo.Cal500Malour"; }
  if ArrayContains(tags, n"DPAE_Cal10GaugeBuck")   { return t"Ammo.Cal10GaugeBuck"; }
  if ArrayContains(tags, n"DPAE_Cal10GaugeFlech")  { return t"Ammo.Cal10GaugeFlech"; }
  if ArrayContains(tags, n"DPAE_Cal10x40Rocket")   { return t"Ammo.Cal10x40Rocket"; }
  if ArrayContains(tags, n"DPAE_Cal10x20TF")       { return t"Ammo.Cal10x20TF"; }
  if ArrayContains(tags, n"DPAE_Cal12Gauge")       { return t"Ammo.Cal12Gauge"; }
  if ArrayContains(tags, n"DPAE_Cal12p3x41UdaR")   { return t"Ammo.Cal12p3x41UdaR"; }
  if ArrayContains(tags, n"DPAE_Cal12p7x70Rocket") { return t"Ammo.Cal12p7x70Rocket"; }
  if ArrayContains(tags, n"DPAE_Cal12x45Rocket")   { return t"Ammo.Cal12x45Rocket"; }
  if ArrayContains(tags, n"DPAE_Cal14x40TSlug")    { return t"Ammo.Cal14x40TSlug"; }
  if ArrayContains(tags, n"DPAE_Cal15x55Rocket")   { return t"Ammo.Cal15x55Rocket"; }
  if ArrayContains(tags, n"DPAE_Cal15x80TSpike")   { return t"Ammo.Cal15x80TSpike"; }
  if ArrayContains(tags, n"DPAE_Cal18x70Rocket")   { return t"Ammo.Cal18x70Rocket"; }
  if ArrayContains(tags, n"DPAE_Cal20x102Vulcan")  { return t"Ammo.Cal20x102Vulcan"; }
  if ArrayContains(tags, n"DPAE_Cal22x126AC")      { return t"Ammo.Cal22x126AC"; }
  if ArrayContains(tags, n"DPAE_Cal23x152Sov")     { return t"Ammo.Cal23x152Sov"; }
  if ArrayContains(tags, n"DPAE_Cal3x10FlechCluster") { return t"Ammo.Cal3x10FlechCluster"; }
  if ArrayContains(tags, n"DPAE_Cal4Gauge")        { return t"Ammo.Cal4Gauge"; }
  if ArrayContains(tags, n"DPAE_Cal4p7x10TF")      { return t"Ammo.Cal4p7x10TF"; }
  if ArrayContains(tags, n"DPAE_Cal5p45CT")        { return t"Ammo.Cal5p45CT"; }
  if ArrayContains(tags, n"DPAE_Cal5p56x45NUSA")   { return t"Ammo.Cal5p56x45NUSA"; }
  if ArrayContains(tags, n"DPAE_Cal5p56CT")        { return t"Ammo.Cal5p56CT"; }
  if ArrayContains(tags, n"DPAE_Cal5p7x28TF")      { return t"Ammo.Cal5p7x28TF"; }
  if ArrayContains(tags, n"DPAE_Cal6p5x25Minirocket") { return t"Ammo.Cal6p5x25Minirocket"; }
  if ArrayContains(tags, n"DPAE_Cal6p5Arasaka")    { return t"Ammo.Cal6p5Arasaka"; }
  if ArrayContains(tags, n"DPAE_Cal7p62x39Sov")    { return t"Ammo.Cal7p62x39Sov"; }
  if ArrayContains(tags, n"DPAE_Cal8x30RailF")     { return t"Ammo.Cal8x30RailF"; }
  if ArrayContains(tags, n"DPAE_Cal8x30TShot")     { return t"Ammo.Cal8x30TShot"; }
  if ArrayContains(tags, n"DPAE_Cal9p5x35Minirocket") { return t"Ammo.Cal9p5x35Minirocket"; }
  if ArrayContains(tags, n"DPAE_Cal9x30TF")        { return t"Ammo.Cal9x30TF"; }
  return TDBID.None();
}

func DPAE_GetAmmoTooltipLine(itemData: wref<gameItemData>) -> String {
  if !IsDefined(itemData) { return ""; }
  let itemID = itemData.GetID();
  if !ItemID.IsValid(itemID) { return ""; }
  let itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID));
  if !IsDefined(itemRecord) { return ""; }
  let weaponRecord = itemRecord as WeaponItem_Record;
  if !IsDefined(weaponRecord) { return ""; }

  let tags = itemRecord.Tags();
  let caliberTDBID = DPAE_GetCaliberFromRecordTags(tags);
  if !TDBID.IsValid(caliberTDBID) { return ""; }

  let displayTDBID = caliberTDBID;
  if ArrayContains(tags, n"DPAE_LockVariant_HE") {
    displayTDBID = TDBID.Create(TDBID.ToStringDEBUG(caliberTDBID) + "_HE");
  } else if ArrayContains(tags, n"DPAE_LockVariant_AP") {
    displayTDBID = TDBID.Create(TDBID.ToStringDEBUG(caliberTDBID) + "_AP");
  } else if ArrayContains(tags, n"DPAE_LockVariant_Slug") {
    displayTDBID = TDBID.Create(TDBID.ToStringDEBUG(caliberTDBID) + "_Slug");
  }

  let ammoRecord = TweakDBInterface.GetItemRecord(displayTDBID);
  if !IsDefined(ammoRecord) { ammoRecord = TweakDBInterface.GetItemRecord(caliberTDBID); }
  if !IsDefined(ammoRecord) { return ""; }

  let name = GetLocalizedTextByKey(ammoRecord.DisplayName());
  if StrLen(name) == 0 { return ""; }
  return GetLocalizedTextByKey(n"AmmoExpanded-Tooltip-AmmoLabel") + " " + name;
}

@wrapMethod(NewItemTooltipDetailsStatsModule)
public func NEW_Update(data: wref<UIInventoryItem>) -> Void {
  wrappedMethod(data);
  if !IsDefined(data) { return; }
  this.DPAECreateAmmoStatement(data.GetRealItemData());
}

@wrapMethod(NewItemTooltipDetailsStatsModule)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
  wrappedMethod(data);
  if !IsDefined(data) { return; }
  this.DPAECreateAmmoStatement(data.itemData);
}

@addMethod(NewItemTooltipDetailsStatsModule)
public func DPAECreateAmmoStatement(itemData: wref<gameItemData>) -> Void {
  let text = DPAE_GetAmmoTooltipLine(itemData);
  if StrLen(text) == 0 { return; }
  let widget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_statsContainer), n"itemDetailsStat");
  let controller = widget.GetController() as ItemTooltipStatController;
  if !IsDefined(controller) { return; }
  controller.DPAESetAmmoDetail(text);
}

@addMethod(ItemTooltipStatController)
public final func DPAESetAmmoDetail(text: String) -> Void {
  let color: HDRColor;
  color.Red = 0.75; color.Green = 0.80; color.Blue = 0.85; color.Alpha = 1.0;
  inkTextRef.SetText(this.m_statName, text);
  inkWidgetRef.SetTintColor(this.m_statName, color);
  inkTextRef.SetText(this.m_statValue, "");
}
