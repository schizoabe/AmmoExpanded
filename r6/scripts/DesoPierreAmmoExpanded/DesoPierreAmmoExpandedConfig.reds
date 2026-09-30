
import RedscriptConfigFramework.*
@if(ModuleExists("RedFunctions"))
import RedFunctions.*

public func DPAE_ModId() -> String = "AmmoExpanded"

public class DPAE_Config extends ScriptableSystem {
  public let accurateDamageColors: Bool = false;
  public let trueDamageConversion: Bool = true;
  public let forceReloadOnAmmoSwitch: Bool = false;
  public let ammoStarterSafetyNet: Bool = true;

  public let downgradeSpecialAmmoLoot: Bool = false;
  public let debugAmmoLogging: Bool = false;

  public let cycleAmmoKey: EInputKey = EInputKey.IK_F7;
  public let dropWeaponKey: EInputKey = EInputKey.IK_F10;

  private let m_provider: ref<DPAE_ConfigProvider>;

  public static func Get() -> ref<DPAE_Config> {
    return GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"DPAE_Config") as DPAE_Config;
  }

  private func OnAttach() -> Void {
    this.m_provider = new DPAE_ConfigProvider();
    this.m_provider.Init(this);

    DVRCF_Store.RestoreInto(this.GetGameInstance(), DPAE_ModId(), this.m_provider, this.m_provider.BuildSchema());
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Session/Ready", this, n"OnSessionReady")
      .SetLifetime(CallbackLifetime.Forever);
  }

  private func OnDetach() -> Void {
    GameInstance.GetCallbackSystem().UnregisterCallback(n"Session/Ready", this);
  }

  protected cb func OnSessionReady(event: ref<GameSessionEvent>) -> Void {
    if !IsDefined(this.m_provider) { return; }
    DVRCF.Register(this.GetGameInstance(), DPAE_ModId(), "DPAE.Mod.Name", "DPAE.Mod.Desc", this.m_provider);
    RedLogger.LogInfo(DPAE_ModId(), "loaded: accurateDamageColors=" + ToString(this.accurateDamageColors)
      + " trueDamageConversion=" + ToString(this.trueDamageConversion)
      + " forceReloadOnAmmoSwitch=" + ToString(this.forceReloadOnAmmoSwitch)
      + " ammoStarterSafetyNet=" + ToString(this.ammoStarterSafetyNet)
      + " downgradeSpecialAmmoLoot=" + ToString(this.downgradeSpecialAmmoLoot)
      + " debugAmmoLogging=" + ToString(this.debugAmmoLogging)
      + " redFunctions=" + DPAE_RedFunctionsVersion());

    if Equals(TDBID.ToStringDEBUG(t"Ammo.Cal9x19"), "") {
      DPAE_LogWarn("TDBID.ToStringDEBUG returns empty: install RedFunctions 0.10.0+ (or CET), ammo variants will not work");
    }
  }
}

public class DPAE_ConfigProvider extends DVRCF_Provider {
  private let m_cfg: wref<DPAE_Config>;

  public func Init(cfg: ref<DPAE_Config>) -> Void {
    this.m_cfg = cfg;
  }

  public func BuildSchema() -> ref<DVRCF_Schema> {
    let b: ref<DVRCF_SchemaBuilder> = DVRCF_SchemaBuilder.New("DPAE.Mod.Name");
    b.Tab("DPAE.tab.Main");
    b.Section("DPAE.sec.Keys");
    b.Keybind("DPAE_CycleAmmo", "DPAE.CycleAmmo.Name");
    b.Tip("DPAE.CycleAmmo.Desc");
    b.Keybind("DPAE_DropCurrentWeapon", "DPAE.DropWeapon.Name");
    b.Tip("DPAE.DropWeapon.Desc");
    b.Section("DPAE.sec.Gameplay");
    b.Toggle("accurateDamageColors", "DPAE.AccurateDamageColors.Name");
    b.Tip("DPAE.AccurateDamageColors.Desc");
    b.Toggle("trueDamageConversion", "DPAE.TrueDamageConversion.Name");
    b.Tip("DPAE.TrueDamageConversion.Desc");
    b.Toggle("forceReloadOnAmmoSwitch", "DPAE.ForceReload.Name");
    b.Tip("DPAE.ForceReload.Desc");
    b.Toggle("ammoStarterSafetyNet", "DPAE.SafetyNet.Name");
    b.Tip("DPAE.SafetyNet.Desc");
    b.Toggle("downgradeSpecialAmmoLoot", "DPAE.DowngradeSpecialAmmo.Name");
    b.Tip("DPAE.DowngradeSpecialAmmo.Desc");
    b.Section("DPAE.sec.Debug");
    b.Toggle("debugAmmoLogging", "DPAE.DebugLog.Name");
    b.Tip("DPAE.DebugLog.Desc");
    return b.Build();
  }

  public func GetBool(key: String) -> Bool {
    let c = this.m_cfg;
    if !IsDefined(c) { return false; }
    if Equals(key, "accurateDamageColors") { return c.accurateDamageColors; }
    if Equals(key, "trueDamageConversion") { return c.trueDamageConversion; }
    if Equals(key, "forceReloadOnAmmoSwitch") { return c.forceReloadOnAmmoSwitch; }
    if Equals(key, "ammoStarterSafetyNet") { return c.ammoStarterSafetyNet; }
    if Equals(key, "downgradeSpecialAmmoLoot") { return c.downgradeSpecialAmmoLoot; }
    if Equals(key, "debugAmmoLogging") { return c.debugAmmoLogging; }
    return false;
  }

  public func SetBool(key: String, value: Bool) -> Void {
    let c = this.m_cfg;
    if !IsDefined(c) { return; }
    if Equals(key, "accurateDamageColors") {
      if Equals(c.accurateDamageColors, value) { return; }
      c.accurateDamageColors = value;
      return;
    }
    if Equals(key, "trueDamageConversion") {
      if Equals(c.trueDamageConversion, value) { return; }
      c.trueDamageConversion = value;
      return;
    }
    if Equals(key, "forceReloadOnAmmoSwitch") {
      if Equals(c.forceReloadOnAmmoSwitch, value) { return; }
      c.forceReloadOnAmmoSwitch = value;
      return;
    }
    if Equals(key, "ammoStarterSafetyNet") {
      if Equals(c.ammoStarterSafetyNet, value) { return; }
      c.ammoStarterSafetyNet = value;
      return;
    }
    if Equals(key, "downgradeSpecialAmmoLoot") {
      if Equals(c.downgradeSpecialAmmoLoot, value) { return; }
      c.downgradeSpecialAmmoLoot = value;
      return;
    }
    if Equals(key, "debugAmmoLogging") {
      if Equals(c.debugAmmoLogging, value) { return; }
      c.debugAmmoLogging = value;
      return;
    }
  }

  public func GetInt(key: String) -> Int32 {
    let c = this.m_cfg;
    if !IsDefined(c) { return 0; }
    if Equals(key, "DPAE_CycleAmmo") { return EnumInt(c.cycleAmmoKey); }
    if Equals(key, "DPAE_DropCurrentWeapon") { return EnumInt(c.dropWeaponKey); }
    return 0;
  }

  public func SetInt(key: String, value: Int32) -> Void {
    let c = this.m_cfg;
    if !IsDefined(c) { return; }
    if Equals(key, "DPAE_CycleAmmo") {
      if EnumInt(c.cycleAmmoKey) == value { return; }
      c.cycleAmmoKey = IntEnum<EInputKey>(value);
      return;
    }
    if Equals(key, "DPAE_DropCurrentWeapon") {
      if EnumInt(c.dropWeaponKey) == value { return; }
      c.dropWeaponKey = IntEnum<EInputKey>(value);
      return;
    }
  }
}

public class DesoPierreAmmoExpandedSettings {

  public static func AccurateDamageColors() -> Bool {
    let s = DPAE_Config.Get();
    if IsDefined(s) { return s.accurateDamageColors; }
    return false;
  }

  public static func TrueDamageConversion() -> Bool {
    let s = DPAE_Config.Get();
    if IsDefined(s) { return s.trueDamageConversion; }
    return true;
  }

  public static func ForceReloadOnAmmoSwitch() -> Bool {
    let s = DPAE_Config.Get();
    if IsDefined(s) { return s.forceReloadOnAmmoSwitch; }
    return false;
  }

  public static func AmmoStarterSafetyNet() -> Bool {
    let s = DPAE_Config.Get();
    if IsDefined(s) { return s.ammoStarterSafetyNet; }
    return true;
  }

  public static func DowngradeSpecialAmmoLoot() -> Bool {
    let s = DPAE_Config.Get();
    if IsDefined(s) { return s.downgradeSpecialAmmoLoot; }
    return false;
  }

  public static func DebugAmmoLogging() -> Bool {
    let s = DPAE_Config.Get();
    if IsDefined(s) { return s.debugAmmoLogging; }
    return false;
  }
}

@if(ModuleExists("RedFunctions"))
public func DPAE_RedFunctionsVersion() -> String = RedFunc.Version()

@if(!ModuleExists("RedFunctions"))
public func DPAE_RedFunctionsVersion() -> String = "none"

public func DPAE_LogDebug(line: String) -> Void {
  RedLogger.LogDebug(DPAE_ModId(), line);
}

public func DPAE_LogWarn(line: String) -> Void {
  RedLogger.LogWarn(DPAE_ModId(), line);
}
