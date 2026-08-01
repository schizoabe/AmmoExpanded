@if(ModuleExists("ModSettingsModule"))
import ModSettingsModule.*

@if(ModuleExists("ModSettingsModule"))
public class DPAE_InputKeybinds {

  @runtimeProperty("ModSettings.mod", "AmmoExpanded")
  @runtimeProperty("ModSettings.displayName", "AmmoExpanded-Input-CycleAmmo")
  @runtimeProperty("ModSettings.description", "AmmoExpanded-Input-CycleAmmo-Desc")
  @runtimeProperty("ModSettings.category", "AmmoExpanded-Input-Category")
  @runtimeProperty("ModSettings.category.order", "0")
  public let DPAE_CycleAmmo: EInputKey = EInputKey.IK_F7;

  @runtimeProperty("ModSettings.mod", "AmmoExpanded")
  @runtimeProperty("ModSettings.displayName", "AmmoExpanded-Input-DropCurrentWeapon")
  @runtimeProperty("ModSettings.description", "AmmoExpanded-Input-DropCurrentWeapon-Desc")
  @runtimeProperty("ModSettings.category", "AmmoExpanded-Input-Category")
  @runtimeProperty("ModSettings.category.order", "0")
  public let DPAE_DropCurrentWeapon: EInputKey = EInputKey.IK_F10;
}

public class DPAE_InputListener {
  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if !Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
      return false;
    }
    let actionName = ListenerAction.GetName(action);
    let gi = GetGameInstance();

    if Equals(actionName, n"DPAE_DropCurrentWeapon") {
      let player: wref<PlayerPuppet> = GetPlayer(gi);
      if IsDefined(player) {
        player.DPAE_DropCurrentWeapon();
      }
      return true;
    }

    if Equals(actionName, n"DPAE_CycleAmmo") {
      let sys: ref<DPAE_AmmoHUDSystem> = GameInstance.GetScriptableSystemsContainer(gi)
        .Get(n"DPAE_AmmoHUDSystem") as DPAE_AmmoHUDSystem;
      if !IsDefined(sys) { return false; }
      sys.RequestCycleAmmo();
      return true;
    }

    return false;
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result: Bool = wrappedMethod();
  this.dpae_input_listener = new DPAE_InputListener();
  this.RegisterInputListener(this.dpae_input_listener);
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  let result: Bool = wrappedMethod();
  if IsDefined(this.dpae_input_listener) {
    this.UnregisterInputListener(this.dpae_input_listener);
    this.dpae_input_listener = null;
  }
  return result;
}
