
@addMethod(PlayerPuppet)
public func DPAE_RefreshAmmoHUD() -> Void {
  let gi = this.GetGame();
  let container = GameInstance.GetScriptableSystemsContainer(gi);
  if !IsDefined(container) { return; }
  let sys = container.Get(n"DPAE_IntegratedAmmoHUDSystem") as DPAE_IntegratedAmmoHUDSystem;
  if !IsDefined(sys) { return; }

  if this.DPAE_IsWeaponStowed() {
    sys.HideDisplay();
    return;
  }

  let shownWeapon: ItemID;
  let activeWeapon = GameObject.GetActiveWeapon(this);
  if IsDefined(activeWeapon) {
    shownWeapon = activeWeapon.GetItemID();
  }

  if this.DPAE_IsHMGEquipped() {
    if sys.IsShowing(1, TDBID.None(), TDBID.None(), shownWeapon) { return; }
    sys.UpdateDisplay(this.DPAE_HUDItemName(t"Ammo.Cal50APHETIL"), GetLocalizedTextByKey(n"AmmoExpanded-HUD-BeltFed"), 1.0, 0.75, 0.35, shownWeapon);
    sys.RememberShown(1, TDBID.None(), TDBID.None(), shownWeapon);
    return;
  }

  if !TDBID.IsValid(this.dpae_caliber) || !TDBID.IsValid(this.dpae_active_ammo) {
    sys.HideDisplay();
    return;
  }

  if sys.IsShowing(2, this.dpae_active_ammo, this.dpae_caliber, shownWeapon) { return; }

  let activeStr = TDBID.ToStringDEBUG(this.dpae_active_ammo);
  let variantLabel: String = "";
  let r: Float = 0.85;
  let g: Float = 0.85;
  let b: Float = 0.85;

  if StrEndsWith(activeStr, "_AP") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-AP");       r = 0.45; g = 0.75; b = 1.00;
  } else if StrEndsWith(activeStr, "_HP") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-HP");       r = 1.00; g = 0.45; b = 0.45;
  } else if StrEndsWith(activeStr, "_EMP") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-EMP");      r = 0.80; g = 0.45; b = 1.00;
  } else if StrEndsWith(activeStr, "_INC") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-INC");      r = 1.00; g = 0.55; b = 0.15;
  } else if StrEndsWith(activeStr, "_CHEM") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-CHEM");     r = 0.55; g = 0.90; b = 0.35;
  } else if StrEndsWith(activeStr, "_NL") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-NL");       r = 0.45; g = 1.00; b = 0.45;
  } else if StrEndsWith(activeStr, "_HE") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-HE");       r = 1.00; g = 0.80; b = 0.20;
  } else if StrEndsWith(activeStr, "_Snakeshot") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-Snakeshot"); r = 0.55; g = 0.85; b = 0.25;
  } else if StrEndsWith(activeStr, "_Slug") {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-Slug");     r = 0.95; g = 0.85; b = 0.50;
  } else if this.dpae_is_tube_fed {
    variantLabel = GetLocalizedTextByKey(n"AmmoExpanded-HUD-Buckshot");
  } else {
    let ts = GameInstance.GetTransactionSystem(this.GetGame());
    let weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
    if !IsDefined(weaponObj) {
      weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
    }
    let evolution = IsDefined(weaponObj) ? RPGManager.GetWeaponEvolution(weaponObj.GetItemID()) : gamedataWeaponEvolution.Power;
    variantLabel = Equals(evolution, gamedataWeaponEvolution.Power) ? GetLocalizedTextByKey(n"AmmoExpanded-HUD-FMJ") : GetLocalizedTextByKey(n"AmmoExpanded-HUD-Standard");
  }

  let caliberName = this.DPAE_HUDItemName(this.dpae_caliber);
  if StrEndsWith(caliberName, ")") && StrContains(caliberName, " (") {
    caliberName = StrBeforeLast(caliberName, " (");
  }

  sys.UpdateDisplay(caliberName, variantLabel, r, g, b, shownWeapon);
  sys.RememberShown(2, this.dpae_active_ammo, this.dpae_caliber, shownWeapon);
}

@addMethod(PlayerPuppet)
private func DPAE_HUDItemName(id: TweakDBID) -> String {
  let rec = TweakDBInterface.GetItemRecord(id);
  if !IsDefined(rec) { return ""; }
  return GetLocalizedTextByKey(rec.DisplayName());
}
