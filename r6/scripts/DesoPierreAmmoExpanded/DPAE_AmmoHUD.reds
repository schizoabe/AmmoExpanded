
public class DPAE_AmmoHUD {
  private let m_canvas:       ref<inkCanvas>;
  private let m_bg:           ref<inkImage>;
  private let m_variantLabel: ref<inkText>;

  public static func Create(parent: ref<inkCompoundWidget>) -> ref<DPAE_AmmoHUD> {
    let hud = new DPAE_AmmoHUD();
    hud.Build(parent);
    return hud;
  }

  private func Build(parent: ref<inkCompoundWidget>) -> Void {
    let w: Float = 140.0;
    let h: Float = 30.0;

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
    variantLabel.SetMargin(new inkMargin(12.0, 5.0, 12.0, 0.0));
    variantLabel.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
    variantLabel.SetText("");
    variantLabel.Reparent(canvas);
    this.m_variantLabel = variantLabel;
  }

  public func Show(variantLabel: String, r: Float, g: Float, b: Float) -> Void {
    if !IsDefined(this.m_canvas) { return; }
    this.m_variantLabel.SetText(variantLabel);
    this.m_variantLabel.SetTintColor(new HDRColor(r, g, b, 1.0));
    this.m_canvas.SetVisible(true);
  }

  public func Hide() -> Void {
    if !IsDefined(this.m_canvas) { return; }
    this.m_canvas.SetVisible(false);
  }
}

public class DPAE_AmmoHUDSystem extends ScriptableSystem {
  private let m_hud: ref<DPAE_AmmoHUD>;

  private let m_pendingCycle: Bool;

  public func RegisterHUD(hud: ref<DPAE_AmmoHUD>) -> Void {
    this.m_hud = hud;
  }

  public func UpdateDisplay(variantLabel: String, r: Float, g: Float, b: Float) -> Void {
    if IsDefined(this.m_hud) {
      this.m_hud.Show(variantLabel, r, g, b);
    }
  }

  public func HideDisplay() -> Void {
    if IsDefined(this.m_hud) {
      this.m_hud.Hide();
    }
  }

  public func RequestCycleAmmo() -> Void {
    this.m_pendingCycle = true;
  }

  public func ConsumeCycleAmmoRequest() -> Bool {
    let v = this.m_pendingCycle;
    this.m_pendingCycle = false;
    return v;
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
  canvas.SetSize(new Vector2(140.0, 30.0));
  canvas.Reparent(hudRoot);

  sys.RegisterHUD(DPAE_AmmoHUD.Create(canvas));

  return result;
}
