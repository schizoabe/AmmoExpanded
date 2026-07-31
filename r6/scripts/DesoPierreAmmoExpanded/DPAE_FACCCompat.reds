@if(ModuleExists("FACCarryCapacity"))
import FACCarryCapacity.*

@if(ModuleExists("FACCarryCapacity"))
public func DPAE_IsFACCDummyToken(activeStr: String) -> Bool {
  return Equals(activeStr, "Ammo.HandgunAmmo") || Equals(activeStr, "Ammo.RifleAmmo")
    || Equals(activeStr, "Ammo.ShotgunAmmo") || Equals(activeStr, "Ammo.SniperRifleAmmo");
}

@if(ModuleExists("FACCarryCapacity"))
public func DPAE_GetFACCCaliberWeight(activeStr: String) -> Float {
  if StrBeginsWith(activeStr, "Ammo.Cal10GaugeBuck") { return 0.095; }
  if StrBeginsWith(activeStr, "Ammo.Cal10GaugeFlech") { return 0.095; }
  if StrBeginsWith(activeStr, "Ammo.Cal454Casull") { return 0.055; }
  if StrBeginsWith(activeStr, "Ammo.Cal10x20TF") { return 0.038; }
  if StrBeginsWith(activeStr, "Ammo.Cal5p7x28TF") { return 0.02; }
  if StrBeginsWith(activeStr, "Ammo.Cal10x40Rocket") { return 0.1; }
  if StrBeginsWith(activeStr, "Ammo.Cal45Super") { return 0.065; }
  if StrBeginsWith(activeStr, "Ammo.Cal45WinMag") { return 0.07; }
  if StrBeginsWith(activeStr, "Ammo.Cal10mmAuto") { return 0.033; }
  if StrBeginsWith(activeStr, "Ammo.Cal50AE") { return 0.064; }
  if StrBeginsWith(activeStr, "Ammo.Cal12Gauge") { return 0.075; }
  if StrBeginsWith(activeStr, "Ammo.Cal12p3x41UdaR") { return 0.072; }
  if StrBeginsWith(activeStr, "Ammo.Cal500Malour") { return 0.08; }
  if StrBeginsWith(activeStr, "Ammo.Cal50BMG") { return 0.25; }
  if StrBeginsWith(activeStr, "Ammo.Cal12p7x70Rocket") { return 0.19; }
  if StrBeginsWith(activeStr, "Ammo.Cal22x126AC") { return 0.75; }
  if StrBeginsWith(activeStr, "Ammo.Cal12x45Rocket") { return 0.13; }
  if StrBeginsWith(activeStr, "Ammo.Cal23x152Sov") { return 0.82; }
  if StrBeginsWith(activeStr, "Ammo.Cal14x40TSlug") { return 0.18; }
  if StrBeginsWith(activeStr, "Ammo.Cal14x70TSlugHE") { return 0.38; }
  if StrBeginsWith(activeStr, "Ammo.Cal15x55Rocket") { return 0.22; }
  if StrBeginsWith(activeStr, "Ammo.Cal15x80TSpike") { return 0.35; }
  if StrBeginsWith(activeStr, "Ammo.Cal18x70Rocket") { return 0.28; }
  if StrBeginsWith(activeStr, "Ammo.Cal20x102Vulcan") { return 0.55; }
  if StrBeginsWith(activeStr, "Ammo.Cal4Gauge") { return 0.16; }
  if StrBeginsWith(activeStr, "Ammo.Cal4p7x10TF") { return 0.012; }
  if StrBeginsWith(activeStr, "Ammo.Cal5p45CT") { return 0.018; }
  if StrBeginsWith(activeStr, "Ammo.Cal5p56CT") { return 0.02; }
  if StrBeginsWith(activeStr, "Ammo.Cal6p5Arasaka") { return 0.038; }
  if StrBeginsWith(activeStr, "Ammo.Cal50BeowulfOni") { return 0.09; }
  if StrBeginsWith(activeStr, "Ammo.Cal7p62x39Sov") { return 0.045; }
  if StrBeginsWith(activeStr, "Ammo.Cal6p5x25Minirocket") { return 0.04; }
  if StrBeginsWith(activeStr, "Ammo.Cal5p56x45NUSA") { return 0.026; }
  if StrBeginsWith(activeStr, "Ammo.Cal243Win") { return 0.048; }
  if StrBeginsWith(activeStr, "Ammo.Cal8x30RailF") { return 0.035; }
  if StrBeginsWith(activeStr, "Ammo.Cal8x30TShot") { return 0.045; }
  if StrBeginsWith(activeStr, "Ammo.Cal9p5x35Minirocket") { return 0.085; }
  if StrBeginsWith(activeStr, "Ammo.Cal9x19") { return 0.029; }
  if StrBeginsWith(activeStr, "Ammo.Cal9x30TF") { return 0.038; }
  if StrBeginsWith(activeStr, "Ammo.Cal3x10FlechCluster") { return 0.03; }
  return 0.0;
}


@if(ModuleExists("FACCarryCapacity"))
@wrapMethod(UIInventoryItem)
public final func GetWeight() -> Float {
  let cfg: ref<FACCarryCapacityConfig> = FACCarryCapacityConfig.Get();
  if cfg.modON && cfg.ammoWeightEnabled && Equals(this.GetItemType(), gamedataItemType.Con_Ammo) {
    let data: ref<gameItemData> = this.GetItemData();
    if IsDefined(data) {
      let tdbidStr = TDBID.ToStringDEBUG(ItemID.GetTDBID(data.GetID()));
      if DPAE_IsFACCDummyToken(tdbidStr) {
        return 0.0;
      }
      let perRound = DPAE_GetFACCCaliberWeight(tdbidStr);
      if perRound > 0.0 {
        let qty = data.GetQuantity();
        if qty < 1 { qty = 1; }
        return perRound * Cast<Float>(qty);
      }
    }
  }
  return wrappedMethod();
}
