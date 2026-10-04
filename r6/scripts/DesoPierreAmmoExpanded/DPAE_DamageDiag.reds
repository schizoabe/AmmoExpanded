
@wrapMethod(ScriptedPuppet)
protected cb func OnDamageReceived(evt: ref<gameDamageReceivedEvent>) -> Bool {
  if DesoPierreAmmoExpandedSettings.DebugAmmoLogging() && IsDefined(evt.hitEvent) && IsDefined(evt.hitEvent.attackData) {
    let player = GetPlayer(this.GetGame());
    let instigator = evt.hitEvent.attackData.GetInstigator();
    if IsDefined(player) && IsDefined(instigator) && Equals(player.GetEntityID(), instigator.GetEntityID()) {
      let attackData = evt.hitEvent.attackData;
      let weapon = attackData.GetWeapon();
      let totalHealth = evt.hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
      let line = "[DPAE_DMGDIAG] target=" + ToString(this.GetEntityID())
        + " attackType=" + ToString(attackData.GetAttackType())
        + " explosion=" + ToString(AttackData.IsExplosion(attackData.GetAttackType()))
        + " dot=" + ToString(AttackData.IsDoT(attackData))
        + " totalHealthDmg=" + ToString(totalHealth)
        + " dominatingType=" + ToString(evt.hitEvent.attackComputed.GetDominatingDamageType())
        + " ammo=" + DPAE_GetInstigatorAmmoString(instigator);
      if IsDefined(weapon) {
        let statsSystem = GameInstance.GetStatsSystem(this.GetGame());
        let weaponStatsID = Cast<StatsObjectID>(weapon.GetEntityID());
        line += " weaponTDBID=" + TDBID.ToStringDEBUG(ItemID.GetTDBID(weapon.GetItemID()))
          + " DPS=" + ToString(statsSystem.GetStatValue(weaponStatsID, gamedataStatType.DPS))
          + " EffectiveDamagePerHit=" + ToString(statsSystem.GetStatValue(weaponStatsID, gamedataStatType.EffectiveDamagePerHit))
          + " PhysicalDamage=" + ToString(statsSystem.GetStatValue(weaponStatsID, gamedataStatType.PhysicalDamage))
          + " ThermalDamage=" + ToString(statsSystem.GetStatValue(weaponStatsID, gamedataStatType.ThermalDamage));
      } else {
        line += " weapon=none";
      }
      DPAE_LogDebug(line);
    }
  }
  return wrappedMethod(evt);
}
