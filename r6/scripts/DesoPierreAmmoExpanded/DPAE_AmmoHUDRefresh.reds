
@addMethod(PlayerPuppet)
public func DPAE_RefreshAmmoHUD() -> Void {
  let gi = this.GetGame();
  let container = GameInstance.GetScriptableSystemsContainer(gi);
  if !IsDefined(container) { return; }
  let sys = container.Get(n"DPAE_AmmoHUDSystem") as DPAE_AmmoHUDSystem;
  if !IsDefined(sys) { return; }

  if this.DPAE_IsWeaponStowed() {
    sys.HideDisplay();
    return;
  }

  if this.DPAE_IsHMGEquipped() {
    sys.UpdateDisplay("APHET-IL", 1.0, 0.75, 0.35);
    return;
  }

  if !TDBID.IsValid(this.dpae_caliber) || !TDBID.IsValid(this.dpae_active_ammo) {
    sys.HideDisplay();
    return;
  }

  let activeStr = TDBID.ToStringDEBUG(this.dpae_active_ammo);
  let mainLabel: String = "";
  let r: Float = 0.85;
  let g: Float = 0.85;
  let b: Float = 0.85;
  if StrEndsWith(activeStr, "_AP") {
    mainLabel = "AP";       r = 0.45; g = 0.75; b = 1.00;
  } else if StrEndsWith(activeStr, "_HP") {
    mainLabel = "HP";       r = 1.00; g = 0.45; b = 0.45;
  } else if StrEndsWith(activeStr, "_EMP") {
    mainLabel = "EMP";      r = 0.80; g = 0.45; b = 1.00;
  } else if StrEndsWith(activeStr, "_INC") {
    mainLabel = "INC";      r = 1.00; g = 0.55; b = 0.15;
  } else if StrEndsWith(activeStr, "_CHEM") {
    mainLabel = "CHEM";     r = 0.55; g = 0.90; b = 0.35;
  } else if StrEndsWith(activeStr, "_NL") {
    mainLabel = "NL";       r = 0.45; g = 1.00; b = 0.45;
  } else if StrEndsWith(activeStr, "_HE") {
    mainLabel = "HE";       r = 1.00; g = 0.80; b = 0.20;
  } else if StrEndsWith(activeStr, "_Snakeshot") {
    mainLabel = "Snake";    r = 0.55; g = 0.85; b = 0.25;
  } else if StrEndsWith(activeStr, "_Slug") {
    mainLabel = "Slug";     r = 0.95; g = 0.85; b = 0.50;
  } else if this.dpae_is_tube_fed {
    mainLabel = "Buckshot";
  } else {
    let ts = GameInstance.GetTransactionSystem(this.GetGame());
    let weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
    if !IsDefined(weaponObj) {
      weaponObj = ts.GetItemInSlot(this, t"AttachmentSlots.WeaponLeft") as WeaponObject;
    }
    let evolution = IsDefined(weaponObj) ? RPGManager.GetWeaponEvolution(weaponObj.GetItemID()) : gamedataWeaponEvolution.Power;
    mainLabel = Equals(evolution, gamedataWeaponEvolution.Power) ? "FMJ" : "Standard";
  }

  sys.UpdateDisplay(mainLabel, r, g, b);
}
