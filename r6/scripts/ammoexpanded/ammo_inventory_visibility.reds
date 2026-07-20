module AmmoExpanded

@wrapMethod(UIInventoryItemsManager)
public final static func GetBlacklistedTags() -> array<CName> {
    let tags: array<CName> = wrappedMethod();
    let i: Int32 = ArraySize(tags) - 1;
    while i >= 0 {
        if Equals(tags[i], n"Ammo") {
            ArrayErase(tags, i);
        }
        i -= 1;
    }
    return tags;
}
