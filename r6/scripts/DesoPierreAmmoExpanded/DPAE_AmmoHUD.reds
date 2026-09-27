
public class DPAE_AmmoHUD {
  private let m_canvas:       ref<inkCanvas>;
  private let m_bg:           ref<inkImage>;
  private let m_variantLabel: ref<inkText>;
  private let m_detailLabel:  ref<inkText>;

  public static func Create(parent: ref<inkCompoundWidget>) -> ref<DPAE_AmmoHUD> {
    let hud = new DPAE_AmmoHUD();
    hud.Build(parent);
    return hud;
  }

  private func Build(parent: ref<inkCompoundWidget>) -> Void {
    let w: Float = 300.0;
    let h: Float = 48.0;

    let canvas = new inkCanvas();
    canvas.SetName(n"DPAEAmmoHUDInner");
    canvas.SetAnchor(inkEAnchor.TopLeft);
    canvas.SetAnchorPoint(new Vector2(0.0, 0.0));
    canvas.SetSize(new Vector2(w, h));
    canvas.SetVisible(false);
    canvas.Reparent(parent);
    this.m_canvas = canvas;

    let bg = new inkImage();
    bg.SetAnchor(inkEAnchor.TopLeft);
    bg.SetSize(new Vector2(w, h));
    bg.SetBrushMirrorType(inkBrushMirrorType.NoMirror);
    bg.SetBrushTileType(inkBrushTileType.NoTile);
    bg.SetAtlasResource(r"base\\gameplay\\gui\\common\\tooltip\\tooltips_new.inkatlas");
    bg.SetTexturePart(n"generic_background");
    bg.SetTintColor(new HDRColor(0.02, 0.02, 0.02, 1.0));
    bg.SetOpacity(0.15);
    bg.Reparent(canvas);
    this.m_bg = bg;

    let variantLabel = new inkText();
    variantLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    variantLabel.SetFontSize(20);
    variantLabel.SetLetterCase(textLetterCase.UpperCase);
    variantLabel.SetAnchor(inkEAnchor.TopLeft);
    variantLabel.SetMargin(new inkMargin(12.0, 6.0, 12.0, 0.0));
    variantLabel.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
    variantLabel.SetText("");
    variantLabel.Reparent(canvas);
    this.m_variantLabel = variantLabel;

    let detailLabel = new inkText();
    detailLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    detailLabel.SetFontSize(13);
    detailLabel.SetAnchor(inkEAnchor.TopLeft);
    detailLabel.SetMargin(new inkMargin(12.0, 28.0, 12.0, 0.0));
    detailLabel.SetTintColor(new HDRColor(0.75, 0.75, 0.75, 0.85));
    detailLabel.SetText("");
    detailLabel.Reparent(canvas);
    this.m_detailLabel = detailLabel;
  }

  public func Show(caliberLabel: String, variantLabel: String, r: Float, g: Float, b: Float) -> Void {
    if !IsDefined(this.m_canvas) { return; }
    this.m_variantLabel.SetText(caliberLabel);
    this.m_variantLabel.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
    this.m_detailLabel.SetText(variantLabel);
    this.m_detailLabel.SetTintColor(new HDRColor(r, g, b, 1.0));
    this.m_canvas.SetVisible(true);
  }

  public func Hide() -> Void {
    if !IsDefined(this.m_canvas) { return; }
    this.m_canvas.SetVisible(false);
  }
}

public class DPAE_AmmoHUDTick extends DelayCallback {
  public let m_system: wref<DPAE_AmmoHUDSystem>;

  public func Call() -> Void {
    let sys = this.m_system;
    if IsDefined(sys) {
      sys.Tick();
    }
  }
}

public class DPAE_AmmoHUDSystem extends ScriptableSystem {
  private let m_hud: ref<DPAE_AmmoHUD>;

  private let m_tickID: DelayID;
  private let m_tickArmed: Bool;

  private let m_wasWeaponStowed: Bool = true;

  private let m_shownState:   Int32;
  private let m_shownAmmo:    TweakDBID;
  private let m_shownCaliber: TweakDBID;
  private let m_shownWeapon:  ItemID;

  public func RegisterHUD(hud: ref<DPAE_AmmoHUD>) -> Void {
    this.m_hud = hud;
    this.m_shownState = 0;
  }

  public func IsShowing(state: Int32, ammo: TweakDBID, caliber: TweakDBID, weapon: ItemID) -> Bool {
    return this.m_shownState == state && this.m_shownAmmo == ammo && this.m_shownCaliber == caliber && this.m_shownWeapon == weapon;
  }

  public func RememberShown(state: Int32, ammo: TweakDBID, caliber: TweakDBID, weapon: ItemID) -> Void {
    this.m_shownState   = state;
    this.m_shownAmmo    = ammo;
    this.m_shownCaliber = caliber;
    this.m_shownWeapon  = weapon;
  }

  public func UpdateDisplay(caliberLabel: String, variantLabel: String, r: Float, g: Float, b: Float) -> Void {
    if IsDefined(this.m_hud) {
      this.m_hud.Show(caliberLabel, variantLabel, r, g, b);
    }
  }

  public func HideDisplay() -> Void {
    if this.m_shownState == 0 { return; }
    this.m_shownState = 0;
    if IsDefined(this.m_hud) {
      this.m_hud.Hide();
    }
  }

  public func StartTicking() -> Void {
    if this.m_tickArmed { return; }
    this.m_tickArmed = true;
    this.ScheduleTick();
  }

  private func ScheduleTick() -> Void {
    let cb = new DPAE_AmmoHUDTick();
    cb.m_system = this;
    this.m_tickID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayCallback(cb, 0.1, false);
  }

  public func Tick() -> Void {
    let p: ref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    if IsDefined(p) {

      if p.DPAE_IsWeaponStowed() {
        this.m_wasWeaponStowed = true;
      } else {
        if this.m_wasWeaponStowed {
          p.DPAE_RefreshOnDraw();
        }
        this.m_wasWeaponStowed = false;
      }
      p.DPAE_RefreshAmmoHUD();
    }
    this.ScheduleTick();
  }

  private func OnDetach() -> Void {
    if this.m_tickArmed {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_tickID);
      this.m_tickArmed = false;
    }
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result: Bool = wrappedMethod();
  let gi: GameInstance = this.GetGame();

  let sys: ref<DPAE_AmmoHUDSystem> = GameInstance.GetScriptableSystemsContainer(gi)
    .Get(n"DPAE_AmmoHUDSystem") as DPAE_AmmoHUDSystem;
  if !IsDefined(sys) { return result; }

  let inkSystem = GameInstance.GetInkSystem();
  if !IsDefined(inkSystem) { return result; }
  let hudLayer = inkSystem.GetLayer(n"inkHUDLayer");
  if !IsDefined(hudLayer) { return result; }
  let hudRoot = hudLayer.GetVirtualWindow();
  if !IsDefined(hudRoot) { return result; }

  hudRoot.RemoveChildByName(n"DPAEAmmoHUDCanvas");

  let canvas = new inkCanvas();
  canvas.SetName(n"DPAEAmmoHUDCanvas");
  canvas.SetAnchor(inkEAnchor.BottomRight);
  canvas.SetAnchorPoint(new Vector2(1.0, 1.0));

  canvas.SetMargin(new inkMargin(0.0, 0.0, 40.0, 220.0));
  canvas.SetSize(new Vector2(300.0, 48.0));
  canvas.Reparent(hudRoot);

  sys.RegisterHUD(DPAE_AmmoHUD.Create(canvas));
  sys.StartTicking();

  return result;
}
