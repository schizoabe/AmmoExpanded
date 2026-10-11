module DPAE_RadialWheelAmmo

public class DPAE_RadialAmmoWidgetManager {
    private let m_panel: ref<inkHorizontalPanel>;
    private let m_icon: ref<inkImage>;
    private let m_variantLabel: ref<inkText>;
    private let m_detailLabel: ref<inkText>;
    private let m_player: wref<PlayerPuppet>;
    private let m_weaponSlot: ref<WeaponRadialSlot>;

    public static func Create(parentContainer: ref<inkCompoundWidget>, player: ref<PlayerPuppet>, slot: ref<WeaponRadialSlot>) -> ref<DPAE_RadialAmmoWidgetManager> {
        let widget = new DPAE_RadialAmmoWidgetManager();
        widget.Build(parentContainer, player, slot);
        return widget;
    }

    private func Build(parent: ref<inkCompoundWidget>, player: ref<PlayerPuppet>, slot: ref<WeaponRadialSlot>) -> Void {
        this.m_player = player;
        this.m_weaponSlot = slot;

        let panel = new inkHorizontalPanel();
        panel.SetName(n"DPAERadialAmmoPanel");
        panel.SetFitToContent(true);

        panel.SetAnchor(inkEAnchor.TopLeft);
        panel.SetAnchorPoint(new Vector2(0.0, 1.0));
        panel.SetMargin(new inkMargin(25.0, -5.0, 0.0, 0.0));

        panel.Reparent(parent);
        this.m_panel = panel;

        let icon = new inkImage();
        icon.SetName(n"DPAEVariantIcon");
        icon.SetSize(new Vector2(32.0, 32.0));
        icon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
        icon.SetTexturePart(n"ammo_rifle");
        icon.SetMargin(new inkMargin(0.0, 0.0, 8.0, 0.0));
        icon.Reparent(panel);
        this.m_icon = icon;

        let variantLabel = new inkText();
        variantLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        variantLabel.SetFontSize(32);
        variantLabel.SetStyle(r"base\\gameplay\\gui\\fullscreen\\fullscreen_main_colors.inkstyle");
        variantLabel.SetLetterCase(textLetterCase.UpperCase);
        variantLabel.SetMargin(new inkMargin(0.0, 0.0, 12.0, 0.0));
        variantLabel.BindProperty(n"tintColor", n"MainColors.White");
        variantLabel.SetText("");
        variantLabel.Reparent(panel);
        this.m_variantLabel = variantLabel;

        let detailLabel = new inkText();
        detailLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        detailLabel.SetFontSize(32);
        detailLabel.SetText("");
        detailLabel.Reparent(panel);
        this.m_detailLabel = detailLabel;

        this.m_panel.SetVisible(false);
    }

    public func GetWeaponSlot() -> ref<WeaponRadialSlot> {
        return this.m_weaponSlot;
    }

    public func Refresh(weaponID: ItemID, isActiveSlot: Bool) -> Void {
        if !IsDefined(this.m_player) || !ItemID.IsValid(weaponID) {
            this.m_panel.SetVisible(false);
            return;
        }

        let caliberTDBID = DPAE_GetCaliberFromEntity(this.m_player, weaponID);
        if !TDBID.IsValid(caliberTDBID) {
            this.m_panel.SetVisible(false);
            return;
        }

        let rememberedAmmoID = this.m_player.DPAE_GetRememberedAmmo(caliberTDBID);
        let activeAmmoStr = TDBID.ToStringDEBUG(rememberedAmmoID);

        let variantLabelStr: String = "Standard";
        let r: Float = 0.85; let g: Float = 0.85; let b: Float = 0.85;

        if StrEndsWith(activeAmmoStr, "_AP") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-AP");       r = 0.45; g = 0.75; b = 1.00;
        } else if StrEndsWith(activeAmmoStr, "_HP") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-HP");       r = 1.00; g = 0.45; b = 0.45;
        } else if StrEndsWith(activeAmmoStr, "_EMP") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-EMP");      r = 0.80; g = 0.45; b = 1.00;
        } else if StrEndsWith(activeAmmoStr, "_INC") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-INC");      r = 1.00; g = 0.55; b = 0.15;
        } else if StrEndsWith(activeAmmoStr, "_CHEM") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-CHEM");     r = 0.55; g = 0.90; b = 0.35;
        } else if StrEndsWith(activeAmmoStr, "_NL") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-NL");       r = 0.45; g = 1.00; b = 0.45;
        } else if StrEndsWith(activeAmmoStr, "_HE") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-HE");       r = 1.00; g = 0.80; b = 0.20;
        } else if StrEndsWith(activeAmmoStr, "_Snakeshot") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-Snakeshot"); r = 0.55; g = 0.85; b = 0.25;
        } else if StrEndsWith(activeAmmoStr, "_Slug") {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-Slug");     r = 0.95; g = 0.85; b = 0.50;
        } else {
            variantLabelStr = GetLocalizedTextByKey(n"AmmoExpanded-HUD-Standard");
        }

        let caliberName = this.m_player.DPAE_HUDItemName(caliberTDBID);
        if StrEndsWith(caliberName, ")") && StrContains(caliberName, " (") {
            caliberName = StrBeforeLast(caliberName, " (");
        }

        let sys = GameInstance.GetScriptableSystemsContainer(this.m_player.GetGame()).Get(n"DPAE_IntegratedAmmoHUDSystem") as DPAE_IntegratedAmmoHUDSystem;
        let iconName = n"ammo_rifle";
        if IsDefined(sys) {
            iconName = sys.GetAmmoIconForWeapon(weaponID);
        }

        this.m_icon.SetTexturePart(iconName);
        this.m_icon.SetTintColor(new HDRColor(r, g, b, 1.0));

        this.m_variantLabel.SetText(caliberName);

        this.m_detailLabel.SetText(variantLabelStr);
        this.m_detailLabel.SetTintColor(new HDRColor(r, g, b, 1.0));

        this.m_panel.SetVisible(isActiveSlot);
    }
}

@addMethod(PlayerPuppet)
public func DPAE_RadialCycleAmmo(caliberTDBID: TweakDBID) -> Void {
    let caliberFull = TDBID.ToStringDEBUG(caliberTDBID);
    let caliberKey = StrAfterLast(caliberFull, ".");

    let variants = DPAE_GetCycleVariants(caliberKey);
    let total = ArraySize(variants);
    if total == 0 { return; }

    let restricted: array<String>;
    let restrictedCsv = this.DPAE_GetRestrictedVariantSuffixes();
    if !Equals(restrictedCsv, "") {
        restricted = StrSplit(restrictedCsv, ",");
    }

    let allowed: array<String>;
    let i = 0;
    while i < total {
        let isRestricted = false;
        let r = 0;
        while r < ArraySize(restricted) {
            if StrEndsWith(variants[i], restricted[r]) {
                isRestricted = true;
            }
            r += 1;
        }
        if !isRestricted {
            ArrayPush(allowed, variants[i]);
        }
        i += 1;
    }

    let count = ArraySize(allowed);
    if count == 0 { return; }

    let activeID = this.DPAE_GetRememberedAmmo(caliberTDBID);
    let activeIDStr = TDBID.ToStringDEBUG(activeID);
    let startIdx = -1;
    i = 0;
    while i < count {
        if startIdx < 0 && Equals(allowed[i], activeIDStr) {
            startIdx = i;
        }
        i += 1;
    }

    if startIdx < 0 {
        startIdx = 0;
    }

    let ts = GameInstance.GetTransactionSystem(this.GetGame());
    let offset = 1;
    while offset <= count {
        let idx = (startIdx + offset) % count;
        let variantID = TDBID.Create(allowed[idx]);

        if ts.GetItemQuantity(this, ItemID.FromTDBID(variantID)) > 0 {
            this.DPAE_RememberAmmo(caliberTDBID, variantID);

            if Equals(this.dpae_caliber, caliberTDBID) && !this.DPAE_IsWeaponStowed() {
                this.DPAE_SelectAmmo(variantID);
            }

            if !Equals(allowed[idx], activeIDStr) {
                GameObject.PlaySoundEvent(this, n"ui_loot_ammo");
            }
            return;
        }
        offset += 1;
    }
}

@addField(RadialWheelController)
private let dpae_slotAmmoWidgets: array<ref<DPAE_RadialAmmoWidgetManager>>;

@addField(RadialWheelController)
private let dpae_cycleAmmoInputHintDataUp: InputHintData;

@wrapMethod(RadialWheelController)
protected cb func OnInitialize() -> Bool {
    let result = wrappedMethod();
    ArrayClear(this.dpae_slotAmmoWidgets);

    let playerControlledObject = this.GetPlayerControlledObject();
    if IsDefined(playerControlledObject) {
        playerControlledObject.RegisterInputListener(this, n"DPAE_CycleAmmoUp");
    }
    return result;
}

@wrapMethod(RadialWheelController)
protected cb func OnUninitialize() -> Bool {
    let playerControlledObject = this.GetPlayerControlledObject();
    if IsDefined(playerControlledObject) {
        playerControlledObject.UnregisterInputListener(this, n"DPAE_CycleAmmoUp");
    }
    return wrappedMethod();
}

@wrapMethod(RadialWheelController)
private final func SetupWidgetForSlot(widget: ref<inkWidget>, slot: ref<RadialSlot>) -> Void {
    wrappedMethod(widget, slot);

    let weaponSlot = slot as WeaponRadialSlot;
    if IsDefined(weaponSlot) {
        let idx = weaponSlot.GetIndex();

        if idx >= 0 && idx <= 2 {
            let rootCompound = widget as inkCompoundWidget;
            if IsDefined(rootCompound) {
                let targetContainer: ref<inkCompoundWidget>;
                let containerWidget = rootCompound.GetWidget(n"container");

                if IsDefined(containerWidget) {
                    targetContainer = containerWidget as inkCompoundWidget;
                } else {
                    targetContainer = rootCompound;
                }

                let ammoManager = DPAE_RadialAmmoWidgetManager.Create(targetContainer, this.GetPlayerControlledObject() as PlayerPuppet, weaponSlot);
                ArrayPush(this.dpae_slotAmmoWidgets, ammoManager);
            }
        }
    }
}

@wrapMethod(RadialWheelController)
private final func CacheInputHintData() -> Void {
    wrappedMethod();
    let source: CName = n"DPAE_RadialWheel";

    this.dpae_cycleAmmoInputHintDataUp.action = n"DPAE_CycleAmmoUp";
    this.dpae_cycleAmmoInputHintDataUp.source = source;
    this.dpae_cycleAmmoInputHintDataUp.queuePriority = 1;
    this.dpae_cycleAmmoInputHintDataUp.sortingPriority = 1;
    this.dpae_cycleAmmoInputHintDataUp.localizedLabel = "Cycle Ammo";
}

@wrapMethod(RadialWheelController)
private final func UpdateInputHints() -> Void {
    wrappedMethod();

    let isWeaponSlot = false;
    if IsDefined(this.activeSlot) {
        let idx = this.activeSlot.GetIndex();
        if idx >= 0 && idx <= 2 {
            isWeaponSlot = true;
        }
    }
    this.AddInputHint(this.dpae_cycleAmmoInputHintDataUp, isWeaponSlot);
}

@addMethod(RadialWheelController)
private final func DPAE_RefreshAllAmmoWidgets() -> Void {
    let i = 0;
    while i < ArraySize(this.dpae_slotAmmoWidgets) {
        let manager = this.dpae_slotAmmoWidgets[i];
        if IsDefined(manager) {
            let slot = manager.GetWeaponSlot();
            let controller = slot.GetController() as InventoryItemDisplayController;
            if IsDefined(controller) {
                let itemData = controller.GetItemData();
                let weaponID = InventoryItemData.GetID(itemData);
                let isActive = (slot == this.activeSlot);
                manager.Refresh(weaponID, isActive);
            }
        }
        i += 1;
    }
}

@wrapMethod(RadialWheelController)
private final func SetActiveSlot(newActiveSlot: ref<WeaponRadialSlot>) -> Bool {
    let result = wrappedMethod(newActiveSlot);
    if result {
        this.DPAE_RefreshAllAmmoWidgets();
    }
    return result;
}

@wrapMethod(RadialWheelController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let aName: CName = ListenerAction.GetName(action);
    let aType: gameinputActionType = ListenerAction.GetType(action);
    let player = this.GetPlayerControlledObject() as PlayerPuppet;

    if this.isActive && IsDefined(this.activeSlot) && Equals(aType, gameinputActionType.BUTTON_PRESSED) {
        if Equals(aName, n"DPAE_CycleAmmoUp") {
            let idx = this.activeSlot.GetIndex();

            if idx >= 0 && idx <= 2 && IsDefined(player) {
                let controller = this.activeSlot.GetController() as InventoryItemDisplayController;
                if IsDefined(controller) {
                    let weaponID = InventoryItemData.GetID(controller.GetItemData());
                    if ItemID.IsValid(weaponID) {
                        let caliberTDBID = DPAE_GetCaliberFromEntity(player, weaponID);
                        if TDBID.IsValid(caliberTDBID) {

                            player.DPAE_RadialCycleAmmo(caliberTDBID);

                            this.DPAE_RefreshAllAmmoWidgets();
                        }
                    }
                }
            }
            return true;
        }
    }

    return wrappedMethod(action, consumer);
}
