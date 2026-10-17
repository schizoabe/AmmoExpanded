
@wrapMethod(CraftingSystem)
public final const func GetMaxCraftingAmount(itemData: wref<gameItemData>) -> Int32 {
  let native = wrappedMethod(itemData);
  if native > 0 {
    return native;
  }
  let tdbid = ItemID.GetTDBID(itemData.GetID());
  if !StrBeginsWith(TDBID.ToStringDEBUG(tdbid), "Ammo.Cal") {
    return native;
  }
  return DPAE_ComputeMaxCraftableFromRecipe(this.GetGameInstance(), tdbid);
}

@wrapMethod(CraftingSystem)
public final const func CanItemBeCrafted(itemData: wref<gameItemData>) -> Bool {
  if wrappedMethod(itemData) {
    return true;
  }
  let tdbid = ItemID.GetTDBID(itemData.GetID());
  if !StrBeginsWith(TDBID.ToStringDEBUG(tdbid), "Ammo.Cal") {
    return false;
  }
  return DPAE_ComputeMaxCraftableFromRecipe(this.GetGameInstance(), tdbid) > 0;
}

public func DPAE_ComputeMaxCraftableFromRecipe(gi: GameInstance, tdbid: TweakDBID) -> Int32 {
  let debug = DesoPierreAmmoExpandedSettings.DebugAmmoLogging();
  let tdbidStr = TDBID.ToStringDEBUG(tdbid);
  let record: wref<Item_Record> = TweakDBInterface.GetItemRecord(tdbid);
  if !IsDefined(record) {
    if debug { DPAE_LogDebug("MaxCraftable[" + tdbidStr + "]: record UNDEFINED -> 0"); }
    return 0;
  }
  let craftingData = record.CraftingData();
  if !IsDefined(craftingData) {
    if debug { DPAE_LogDebug("MaxCraftable[" + tdbidStr + "]: CraftingData UNDEFINED -> 0"); }
    return 0;
  }
  let recipeElements: array<wref<RecipeElement_Record>>;
  craftingData.CraftingRecipe(recipeElements);
  if ArraySize(recipeElements) == 0 {
    if debug { DPAE_LogDebug("MaxCraftable[" + tdbidStr + "]: recipeElements EMPTY -> 0"); }
    return 0;
  }
  let player = GameInstance.GetPlayerSystem(gi).GetLocalPlayerMainGameObject() as PlayerPuppet;
  if !IsDefined(player) {
    if debug { DPAE_LogDebug("MaxCraftable[" + tdbidStr + "]: player UNDEFINED -> 0"); }
    return 0;
  }
  let ts = GameInstance.GetTransactionSystem(gi);
  let maxCraftable = 999999;
  for element in recipeElements {
    let ingredient = element.Ingredient();
    let requiredAmount = element.Amount();
    if !IsDefined(ingredient) || requiredAmount <= 0 {
      if debug { DPAE_LogDebug("MaxCraftable[" + tdbidStr + "]: ingredient UNDEFINED or requiredAmount<=0 (" + ToString(requiredAmount) + ") -> 0"); }
      return 0;
    }
    let owned = ts.GetItemQuantity(player, ItemID.FromTDBID(ingredient.GetID()));
    let affordable = owned / requiredAmount;
    if debug {
      DPAE_LogDebug("MaxCraftable[" + tdbidStr + "]: ingredient=" + TDBID.ToStringDEBUG(ingredient.GetID())
        + " owned=" + ToString(owned) + " required=" + ToString(requiredAmount) + " affordable=" + ToString(affordable));
    }
    if affordable < maxCraftable {
      maxCraftable = affordable;
    }
  }
  if debug { DPAE_LogDebug("MaxCraftable[" + tdbidStr + "]: result=" + ToString(maxCraftable)); }
  return maxCraftable;
}
