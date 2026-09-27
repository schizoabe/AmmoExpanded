
@wrapMethod(ReloadEvents)
protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  if !stateContext.GetBoolParameter(n"FinishedReload", true) {
    let logicalDuration = stateContext.GetPermanentFloatParameter(n"ReloadLogicalDuration");
    if logicalDuration.valid && this.GetInStateTime() > logicalDuration.value {
      let player = scriptInterface.executionOwner as PlayerPuppet;
      let weapon = this.GetWeaponObject(scriptInterface);
      if IsDefined(player) && IsDefined(weapon) {
        player.DPAE_TacticalReloadDrain(weapon.GetItemID(), WeaponObject.GetMagazineAmmoCount(weapon));
      }
    }
  }
  wrappedMethod(timeDelta, stateContext, scriptInterface);
}
