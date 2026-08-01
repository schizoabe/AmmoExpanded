@if(ModuleExists("ModSettingsModule"))
import ModSettingsModule.*

@if(ModuleExists("ModSettingsModule"))
public class DPAE_ToggleSettings extends ScriptableSystem {

  @runtimeProperty("ModSettings.mod", "AmmoExpanded")
  @runtimeProperty("ModSettings.displayName", "AmmoExpanded-Settings-AccurateDamageColors")
  @runtimeProperty("ModSettings.description", "AmmoExpanded-Settings-AccurateDamageColors-Desc")
  @runtimeProperty("ModSettings.category", "AmmoExpanded-Settings-Category")
  @runtimeProperty("ModSettings.category.order", "1")
  let accurateDamageColors: Bool = false;

  @runtimeProperty("ModSettings.mod", "AmmoExpanded")
  @runtimeProperty("ModSettings.displayName", "AmmoExpanded-Settings-TrueDamageConversion")
  @runtimeProperty("ModSettings.description", "AmmoExpanded-Settings-TrueDamageConversion-Desc")
  @runtimeProperty("ModSettings.category", "AmmoExpanded-Settings-Category")
  @runtimeProperty("ModSettings.category.order", "1")
  let trueDamageConversion: Bool = true;

  @runtimeProperty("ModSettings.mod", "AmmoExpanded")
  @runtimeProperty("ModSettings.displayName", "AmmoExpanded-Settings-ForceReloadOnAmmoSwitch")
  @runtimeProperty("ModSettings.description", "AmmoExpanded-Settings-ForceReloadOnAmmoSwitch-Desc")
  @runtimeProperty("ModSettings.category", "AmmoExpanded-Settings-Category")
  @runtimeProperty("ModSettings.category.order", "1")
  let forceReloadOnAmmoSwitch: Bool = false;

  public static func Get() -> ref<DPAE_ToggleSettings> {
    return GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"DPAE_ToggleSettings") as DPAE_ToggleSettings;
  }

  private func OnAttach() -> Void {
    ModSettings.RegisterListenerToClass(this);
  }

  private func OnDetach() -> Void {
    ModSettings.UnregisterListenerToClass(this);
  }
}

@if(ModuleExists("ModSettingsModule"))
public class DesoPierreAmmoExpandedSettings {

  public static func AccurateDamageColors() -> Bool {
    let s = DPAE_ToggleSettings.Get();
    if IsDefined(s) { return s.accurateDamageColors; }
    return false;
  }

  public static func TrueDamageConversion() -> Bool {
    let s = DPAE_ToggleSettings.Get();
    if IsDefined(s) { return s.trueDamageConversion; }
    return true;
  }

  public static func ForceReloadOnAmmoSwitch() -> Bool {
    let s = DPAE_ToggleSettings.Get();
    if IsDefined(s) { return s.forceReloadOnAmmoSwitch; }
    return false;
  }
}

@if(!ModuleExists("ModSettingsModule"))
public class DesoPierreAmmoExpandedSettings {
  public static func AccurateDamageColors() -> Bool { return false; }
  public static func TrueDamageConversion() -> Bool { return true; }
  public static func ForceReloadOnAmmoSwitch() -> Bool { return false; }
}
