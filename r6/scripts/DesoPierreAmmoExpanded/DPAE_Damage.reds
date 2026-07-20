
func DPAE_ComputeConversionPercent(instigator: wref<GameObject>, weapon: ref<WeaponObject>, elementalType: gamedataDamageType) -> Float {
  let pct = 0.3;
  let player = instigator as PlayerPuppet;
  if IsDefined(player) {
    if IsDefined(weapon) {
      let ts = GameInstance.GetTransactionSystem(player.GetGame());
      let weaponItemID = weapon.GetItemID();
      if ItemID.IsValid(weaponItemID) {
        let isIconicElemental = (Equals(elementalType, gamedataDamageType.Electric) && ts.HasTag(player, n"DPAE_IconicElemental_Electric", weaponItemID))
          || (Equals(elementalType, gamedataDamageType.Chemical) && ts.HasTag(player, n"DPAE_IconicElemental_Chemical", weaponItemID))
          || (Equals(elementalType, gamedataDamageType.Thermal) && ts.HasTag(player, n"DPAE_IconicElemental_Thermal", weaponItemID));
        if isIconicElemental {
          let iconicTier = DPAE_GetWeaponQualityTier(weapon);
          if iconicTier >= 0 {
            pct += 0.10 + 0.05 * Cast<Float>(iconicTier);
          };
        };
      };
    };
    let qualities: array<Int32>;
    if Equals(elementalType, gamedataDamageType.Electric) {
      qualities = player.dpae_arc_qualities;
    } else if Equals(elementalType, gamedataDamageType.Chemical) {
      qualities = player.dpae_caustic_qualities;
    } else if Equals(elementalType, gamedataDamageType.Thermal) {
      qualities = player.dpae_pyro_qualities;
    };
    let i = 0;
    while i < ArraySize(qualities) {
      pct += 0.05 + 0.05 * Cast<Float>(qualities[i]);
      i += 1;
    };
  };
  return MinF(pct, 1.0);
}

func DPAE_ApplyConversion(hitEvent: ref<gameHitEvent>, elementalType: gamedataDamageType, pct: Float) -> Void {
  let physicalValue = hitEvent.attackComputed.GetAttackValue(gamedataDamageType.Physical);
  let impliedBase = physicalValue / 0.7;
  let elementalAmount = impliedBase * pct;
  let newPhysical = MaxF(0.0, physicalValue - elementalAmount);
  hitEvent.attackComputed.SetAttackValue(elementalAmount, elementalType);
  hitEvent.attackComputed.SetAttackValue(newPhysical, gamedataDamageType.Physical);
}

func DPAE_GetInstigatorAmmoString(instigator: wref<GameObject>) -> String {
  let player = instigator as PlayerPuppet;
  if IsDefined(player) {
    return TDBID.ToStringDEBUG(player.dpae_active_ammo);
  }
  let npc = instigator as NPCPuppet;
  if IsDefined(npc) {
    return TDBID.ToStringDEBUG(npc.dpae_npc_ammo);
  }
  return "";
}

@wrapMethod(DamageSystem)
public final func ProcessArmor(hitEvent: ref<gameHitEvent>) -> Void {
  let toggle = DesoPierreAmmoExpandedSettings.TrueDamageConversion();
  if toggle && IsDefined(hitEvent.attackData) && !AttackData.IsDoT(hitEvent.attackData) {
    let instigator = hitEvent.attackData.GetInstigator();
    if IsDefined(instigator) {
      let ammoStr = DPAE_GetInstigatorAmmoString(instigator);
      let weapon = hitEvent.attackData.GetWeapon();
      if StrEndsWith(ammoStr, "_INC") {
        DPAE_ApplyConversion(hitEvent, gamedataDamageType.Thermal, DPAE_ComputeConversionPercent(instigator, weapon, gamedataDamageType.Thermal));
      } else {
        if StrEndsWith(ammoStr, "_EMP") {
          DPAE_ApplyConversion(hitEvent, gamedataDamageType.Electric, DPAE_ComputeConversionPercent(instigator, weapon, gamedataDamageType.Electric));
        } else {
          if StrEndsWith(ammoStr, "_CHEM") {
            DPAE_ApplyConversion(hitEvent, gamedataDamageType.Chemical, DPAE_ComputeConversionPercent(instigator, weapon, gamedataDamageType.Chemical));
          } else {
            let player = instigator as PlayerPuppet;
            if StrEndsWith(ammoStr, "_HE") && IsDefined(player) && IsDefined(weapon) && ItemID.IsValid(weapon.GetItemID())
              && GameInstance.GetTransactionSystem(player.GetGame()).HasTag(player, n"DPAE_ThermalOnHE", weapon.GetItemID()) {
              DPAE_ApplyConversion(hitEvent, gamedataDamageType.Thermal, DPAE_ComputeConversionPercent(instigator, weapon, gamedataDamageType.Thermal));
            };
          };
        };
      };
    };
  };

  if IsDefined(hitEvent.attackData) && !AttackData.IsDoT(hitEvent.attackData) {
    let hpInstigator = hitEvent.attackData.GetInstigator();
    if IsDefined(hpInstigator) {
      let hpAmmoStr = DPAE_GetInstigatorAmmoString(hpInstigator);
      let hpBonus = DPAE_GetHPUnarmoredBonus(hpAmmoStr);
      if hpBonus > 0.0 {
        let target = hitEvent.target as GameObject;
        if IsDefined(target) {
          let targetSS = GameInstance.GetStatsSystem(target.GetGame());
          let targetArmor = targetSS.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.Armor);
          let targetNPC = target as NPCPuppet;
          let ceIntegrity = IsDefined(targetNPC) ? targetNPC.DPAE_GetCEArmorIntegrity() : -1.0;
          let isUnarmored = ceIntegrity >= 0.0 ? (ceIntegrity <= 0.0) : (targetArmor <= 0.0);
          if isUnarmored {
            let physVal = hitEvent.attackComputed.GetAttackValue(gamedataDamageType.Physical);
            hitEvent.attackComputed.SetAttackValue(physVal * (1.0 + hpBonus), gamedataDamageType.Physical);
            StatusEffectHelper.ApplyStatusEffect(target, t"BaseStatusEffect.Bleeding", hpInstigator.GetEntityID());
          };
        };
      };
    };
  };

  let flechetteMod: ref<gameStatModifierData>;
  let flechetteSS: ref<StatsSystem>;
  let flechetteObjID: StatsObjectID;
  if IsDefined(hitEvent.attackData) && !AttackData.IsDoT(hitEvent.attackData) {
    let fInstigator = hitEvent.attackData.GetInstigator();
    if IsDefined(fInstigator) {
      let fAmmoStr = DPAE_GetInstigatorAmmoString(fInstigator);
      let chargeBonus = DPAE_GetFlechetteChargeBonus(fAmmoStr);
      if chargeBonus > 0.0 {
        let fWeapon = hitEvent.attackData.GetWeapon();
        if IsDefined(fWeapon) && WeaponObject.GetWeaponChargeNormalized(fWeapon) >= 0.9 {
          flechetteSS = GameInstance.GetStatsSystem(fWeapon.GetGame());
          flechetteObjID = Cast<StatsObjectID>(fWeapon.GetEntityID());
          flechetteMod = RPGManager.CreateStatModifier(gamedataStatType.CanWeaponIgnoreArmor, gameStatModifierType.Additive, chargeBonus);
          flechetteSS.AddModifier(flechetteObjID, flechetteMod);
        };
      };
    };
  };

  wrappedMethod(hitEvent);

  if IsDefined(flechetteMod) {
    flechetteSS.RemoveModifier(flechetteObjID, flechetteMod);
  };
}

@wrapMethod(DamageSystem)
public final func ConvertHitDataToDamageInfo(hitEvent: ref<gameHitEvent>) -> [DamageInfo] {
  let result = wrappedMethod(hitEvent);
  if DesoPierreAmmoExpandedSettings.AccurateDamageColors() && ArraySize(result) > 0 && !AttackData.IsDoT(hitEvent.attackData) {
    result[0].damageType = hitEvent.attackComputed.GetDominatingDamageType();
  }
  return result;
}
