
func DPAE_DmgProbeIsPlayerShot(hitEvent: ref<gameHitEvent>) -> Bool {
  if !IsDefined(hitEvent) || !IsDefined(hitEvent.attackData) { return false; }
  let instigator = hitEvent.attackData.GetInstigator();
  return IsDefined(instigator) && instigator.IsPlayer();
}

func DPAE_DmgProbeLine(stage: String, hitEvent: ref<gameHitEvent>) -> String {
  let attackData = hitEvent.attackData;
  let weapon = attackData.GetWeapon();
  let line = "[DPAE_DMGPROBE] stage=" + stage
    + " target=" + ToString(hitEvent.target.GetEntityID())
    + " attackType=" + ToString(attackData.GetAttackType())
    + " total=" + ToString(hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health))
    + " dealNoDamage=" + ToString(attackData.HasFlag(hitFlag.DealNoDamage));
  if IsDefined(weapon) {
    line += " weapon=" + TDBID.ToStringDEBUG(ItemID.GetTDBID(weapon.GetItemID()));
  } else {
    line += " weapon=none";
  }
  let def = attackData.GetAttackDefinition();
  let rec: ref<Attack_Record>;
  if IsDefined(def) { rec = def.GetRecord(); }
  if IsDefined(rec) {
    line += " attackRecord=" + TDBID.ToStringDEBUG(rec.GetID());
  } else {
    line += " attackRecord=none";
  }
  return line;
}

@wrapMethod(DamageSystem)
private final func ProcessPipeline(hitEvent: ref<gameHitEvent>, cache: ref<CacheData>) -> Void {
  if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() && DPAE_DmgProbeIsPlayerShot(hitEvent) {
    DPAE_LogDebug(DPAE_DmgProbeLine("A_pipelineEnter", hitEvent));
  }
  wrappedMethod(hitEvent, cache);
}

@wrapMethod(DamageSystem)
private final func CheckForQuickExit(hitEvent: ref<gameHitEvent>, cache: ref<CacheData>) -> Bool {
  let result = wrappedMethod(hitEvent, cache);
  if result && DesoPierreAmmoExpandedSettings.DebugAmmoLogging() && DPAE_DmgProbeIsPlayerShot(hitEvent) {
    DPAE_LogDebug(DPAE_DmgProbeLine("B_quickExitDropped", hitEvent));
  }
  return result;
}

@wrapMethod(DamageSystem)
private final func ProcessDamageReduction(hitEvent: ref<gameHitEvent>) -> Void {
  let probe = DesoPierreAmmoExpandedSettings.DebugAmmoLogging() && DPAE_DmgProbeIsPlayerShot(hitEvent);
  if probe { DPAE_LogDebug(DPAE_DmgProbeLine("C1_beforeDamageReduction", hitEvent)); }
  wrappedMethod(hitEvent);
  if probe { DPAE_LogDebug(DPAE_DmgProbeLine("C2_afterDamageReduction", hitEvent)); }
}

@wrapMethod(DamageSystem)
public final func ProcessArmor(hitEvent: ref<gameHitEvent>) -> Void {
  let probe = DesoPierreAmmoExpandedSettings.DebugAmmoLogging() && DPAE_DmgProbeIsPlayerShot(hitEvent);
  if probe { DPAE_LogDebug(DPAE_DmgProbeLine("D1_beforeArmor", hitEvent)); }
  wrappedMethod(hitEvent);
  if probe { DPAE_LogDebug(DPAE_DmgProbeLine("D2_afterArmor", hitEvent)); }
}

@wrapMethod(DamageSystem)
private final func ModifyHitData(hitEvent: ref<gameHitEvent>) -> Void {
  wrappedMethod(hitEvent);
  if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() && DPAE_DmgProbeIsPlayerShot(hitEvent) {
    DPAE_LogDebug(DPAE_DmgProbeLine("E_afterModifyHitData", hitEvent));
  }
}

@wrapMethod(DamageSystem)
private final func DealDamages(hitEvent: ref<gameHitEvent>) -> Void {
  if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() && DPAE_DmgProbeIsPlayerShot(hitEvent) {
    DPAE_LogDebug(DPAE_DmgProbeLine("F_beforeDealDamages", hitEvent));
  }
  wrappedMethod(hitEvent);
}
