import Codeware.Localization.*

public class DPAE_LocalizationProvider extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    switch language {
      default: return new DPAE_LocEnglish();
    };
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}
