@if(ModuleExists("FACCarryCapacity"))

@wrapMethod(CraftingSystem)
public final const func GetDisassemblyResultItems(target: wref<GameObject>, itemID: ItemID, amount: Int32, restoredAttachments: script_ref<array<ItemAttachments>>, opt calledFromUI: Bool) -> array<IngredientData> {
  if ItemID.IsValid(itemID) && IsDefined(target) {
    let player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if IsDefined(player) {
      let caliber = DPAE_GetCaliberFromEntity(target, itemID);
      if TDBID.IsValid(caliber) {
        player.dpae_pending_disassembly_caliber = caliber;
      }
    }
  }
  return wrappedMethod(target, itemID, amount, restoredAttachments, calledFromUI);
}
