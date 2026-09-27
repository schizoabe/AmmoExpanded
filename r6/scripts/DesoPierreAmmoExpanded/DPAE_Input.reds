
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
      let player: wref<PlayerPuppet> = GetPlayer(gi);
      if !IsDefined(player) { return false; }
      player.DPAE_CycleAmmo();
      player.DPAE_RefreshAmmoHUD();
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
