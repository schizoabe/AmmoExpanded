
public func DPAE_GetEffectForRound(roundID: TweakDBID, instigator: wref<GameObject>, weapon: ref<WeaponObject>) -> array<TweakDBID> {
  let result: array<TweakDBID>;
  let activeStr = TDBID.ToStringDEBUG(roundID);
  let dotID: TweakDBID;
  let gimmickID: TweakDBID;
  let rateBonusTag: CName;
  let qualities: array<Int32>;
  let player = instigator as PlayerPuppet;
  if StrEndsWith(activeStr, "_EMP") {
    dotID = t"DPAE_StatusEffect.EMP_ShockMalfunction_DoT";
    gimmickID = t"DPAE_StatusEffect.EMP_CyberwareMalfunction";
    rateBonusTag = n"DPAE_IconicElementalRateBonus_Electric";
    if IsDefined(player) { qualities = player.dpae_arc_qualities; };
  } else if StrEndsWith(activeStr, "_INC") {
    dotID = t"DPAE_StatusEffect.INC_Burn_DoT";
    gimmickID = t"DPAE_StatusEffect.INC_Thermal_Debuff";
    rateBonusTag = n"DPAE_IconicElementalRateBonus_Thermal";
    if IsDefined(player) { qualities = player.dpae_pyro_qualities; };
  } else if StrEndsWith(activeStr, "_CHEM") {
    dotID = t"DPAE_StatusEffect.CHEM_Poison_DoT";
    gimmickID = t"DPAE_StatusEffect.CHEM_Poison_Debuff";
    rateBonusTag = n"DPAE_IconicElementalRateBonus_Chemical";
    if IsDefined(player) { qualities = player.dpae_caustic_qualities; };
  } else {
    return result;
  };
  let dotChance = DPAE_ComputeElementalDoTChance(instigator, weapon, activeStr, rateBonusTag, qualities);
  let gimmickChance = DPAE_ComputeElementalGimmickChance(instigator, weapon, rateBonusTag, qualities);
  let dotRoll = RandF();
  let gimmickRoll = RandF();
  let dotHit = dotRoll <= dotChance;
  let gimmickHit = gimmickRoll <= gimmickChance;
  if dotHit {
    ArrayPush(result, dotID);
  };
  if gimmickHit {
    ArrayPush(result, gimmickID);
  };
  return result;
}

func DPAE_GetCartridgeDoTChance(activeStr: String) -> Float {
  if StrFindFirst(activeStr, "Cal23x152Sov_") > -1 { return 1.0; }

  if StrFindFirst(activeStr, "Cal500Malour_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal10GaugeBuck_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal10GaugeFlech_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal12Gauge_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal4Gauge_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal50BMG_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal14x70TSlugHE_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal15x55Rocket_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal18x70Rocket_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal20x102Vulcan_") > -1 { return 0.70; }
  if StrFindFirst(activeStr, "Cal22x126AC_") > -1 { return 0.70; }

  if StrFindFirst(activeStr, "Cal45Super_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal454Casull_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal45WinMag_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal50AE_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal7p62x39Sov_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal6p5Arasaka_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal12p3x41UdaR_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal14x40TSlug_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal50BeowulfOni_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal12x45Rocket_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal12p7x70Rocket_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal243Win_") > -1 { return 0.50; }
  if StrFindFirst(activeStr, "Cal15x80TSpike_") > -1 { return 0.50; }

  if StrFindFirst(activeStr, "Cal5p45CT_") > -1 { return 0.35; }
  if StrFindFirst(activeStr, "Cal5p56CT_") > -1 { return 0.35; }
  if StrFindFirst(activeStr, "Cal5p56x45NUSA_") > -1 { return 0.35; }
  if StrFindFirst(activeStr, "Cal9x30TF_") > -1 { return 0.35; }
  if StrFindFirst(activeStr, "Cal8x30TShot_") > -1 { return 0.35; }
  if StrFindFirst(activeStr, "Cal9p5x35Minirocket_") > -1 { return 0.35; }
  if StrFindFirst(activeStr, "Cal8x30RailF_") > -1 { return 0.35; }
  if StrFindFirst(activeStr, "Cal10x40Rocket_") > -1 { return 0.35; }
  if StrFindFirst(activeStr, "Cal3x10FlechCluster_") > -1 { return 0.35; }

  return 0.20;
}

func DPAE_GetWeaponQualityTier(weapon: ref<WeaponObject>) -> Int32 {
  if !IsDefined(weapon) { return -1; }
  let ss = GameInstance.GetStatsSystem(weapon.GetGame());
  let objID = Cast<StatsObjectID>(weapon.GetEntityID());
  return Cast<Int32>(ss.GetStatValue(objID, gamedataStatType.Quality));
}

func DPAE_ComputeElementalDoTChance(instigator: wref<GameObject>, weapon: ref<WeaponObject>, activeStr: String, rateBonusTag: CName, qualities: array<Int32>) -> Float {
  let chance = DPAE_GetCartridgeDoTChance(activeStr);
  let player = instigator as PlayerPuppet;
  if IsDefined(player) {
    let i = 0;
    while i < ArraySize(qualities) {
      chance += 0.10 + 0.10 * Cast<Float>(qualities[i]);
      i += 1;
    };
    if IsDefined(weapon) {
      let ts = GameInstance.GetTransactionSystem(player.GetGame());
      let weaponItemID = weapon.GetItemID();
      if ItemID.IsValid(weaponItemID) && ts.HasTag(player, n"DPAE_IconicRateBonus_Sparky", weaponItemID) {
        chance += 0.10;
      };
      if ItemID.IsValid(weaponItemID) && ts.HasTag(player, rateBonusTag, weaponItemID) {
        let iconicTier = DPAE_GetWeaponQualityTier(weapon);
        if iconicTier >= 0 {
          chance += 0.15 + 0.10 * Cast<Float>(iconicTier);
        };
      };
    };
  } else {
    chance += 0.30;
  };
  return MinF(chance, 1.0);
}

func DPAE_ComputeElementalGimmickChance(instigator: wref<GameObject>, weapon: ref<WeaponObject>, rateBonusTag: CName, qualities: array<Int32>) -> Float {
  let player = instigator as PlayerPuppet;
  if !IsDefined(player) {
    return MinF(0.10 + 0.15, 0.60);
  };
  let isIconicTuned = false;
  let iconicTier = -1;
  let weaponHasValidID = false;
  if IsDefined(weapon) {
    let ts = GameInstance.GetTransactionSystem(player.GetGame());
    let weaponItemID = weapon.GetItemID();
    weaponHasValidID = ItemID.IsValid(weaponItemID);
    if weaponHasValidID && ts.HasTag(player, rateBonusTag, weaponItemID) {
      isIconicTuned = true;
      iconicTier = DPAE_GetWeaponQualityTier(weapon);
    };
  };
  if ArraySize(qualities) == 0 && !isIconicTuned {
    return 0.0;
  };
  let chance = 0.10;
  let i = 0;
  while i < ArraySize(qualities) {
    chance += 0.05 + 0.05 * Cast<Float>(qualities[i]);
    i += 1;
  };
  if isIconicTuned && iconicTier >= 0 {
    chance += 0.10 + 0.05 * Cast<Float>(iconicTier);
  };
  return MinF(chance, 0.60);
}

func DPAE_ApplyRoundEffects(target: ref<GameObject>, effectIDs: array<TweakDBID>, instigatorEntityID: EntityID) -> Void {
  let i = 0;
  while i < ArraySize(effectIDs) {
    StatusEffectHelper.ApplyStatusEffect(target, effectIDs[i], instigatorEntityID);
    i += 1;
  };
}

func DPAE_GetArmorPenValue(activeStr: String) -> Float {
  if StrFindFirst(activeStr, "Cal454Casull_AP") > -1 { return 0.25; }
  if StrEndsWith(activeStr, "Cal454Casull") { return 0.05; }
  if StrFindFirst(activeStr, "Cal45Super_AP") > -1 { return 0.20; }
  if StrEndsWith(activeStr, "Cal45Super") { return 0.0; }
  if StrFindFirst(activeStr, "Cal45WinMag_AP") > -1 { return 0.20; }
  if StrEndsWith(activeStr, "Cal45WinMag") { return 0.0; }
  if StrFindFirst(activeStr, "Cal10mmAuto_AP") > -1 { return 0.20; }
  if StrEndsWith(activeStr, "Cal10mmAuto") { return 0.0; }
  if StrFindFirst(activeStr, "Cal50AE_AP") > -1 { return 0.25; }
  if StrEndsWith(activeStr, "Cal50AE") { return 0.05; }
  if StrFindFirst(activeStr, "Cal12p3x41UdaR_AP") > -1 { return 0.25; }
  if StrEndsWith(activeStr, "Cal12p3x41UdaR") { return 0.05; }
  if StrFindFirst(activeStr, "Cal500Malour_AP") > -1 { return 0.40; }
  if StrEndsWith(activeStr, "Cal500Malour") { return 0.10; }
  if StrFindFirst(activeStr, "Cal50BMG_AP") > -1 { return 0.50; }
  if StrEndsWith(activeStr, "Cal50BMG") { return 0.20; }
  if StrEndsWith(activeStr, "Cal22x126AC") { return 0.60; }
  if StrEndsWith(activeStr, "Cal23x152Sov") { return 0.80; }
  if StrEndsWith(activeStr, "Cal20x102Vulcan") { return 0.60; }
  if StrFindFirst(activeStr, "Cal5p45CT_AP") > -1 { return 0.35; }
  if StrEndsWith(activeStr, "Cal5p45CT") { return 0.10; }
  if StrFindFirst(activeStr, "Cal5p56CT_AP") > -1 { return 0.35; }
  if StrEndsWith(activeStr, "Cal5p56CT") { return 0.10; }
  if StrFindFirst(activeStr, "Cal6p5Arasaka_AP") > -1 { return 0.40; }
  if StrEndsWith(activeStr, "Cal6p5Arasaka") { return 0.10; }
  if StrFindFirst(activeStr, "Cal50BeowulfOni_AP") > -1 { return 0.25; }
  if StrEndsWith(activeStr, "Cal50BeowulfOni") { return 0.05; }
  if StrFindFirst(activeStr, "Cal7p62x39Sov_AP") > -1 { return 0.30; }
  if StrEndsWith(activeStr, "Cal7p62x39Sov") { return 0.05; }
  if StrFindFirst(activeStr, "Cal5p56x45NUSA_AP") > -1 { return 0.35; }
  if StrEndsWith(activeStr, "Cal5p56x45NUSA") { return 0.10; }
  if StrFindFirst(activeStr, "Cal243Win_AP") > -1 { return 0.40; }
  if StrEndsWith(activeStr, "Cal243Win") { return 0.10; }
  if StrFindFirst(activeStr, "Cal9x19_AP") > -1 { return 0.20; }
  if StrEndsWith(activeStr, "Cal9x19") { return 0.0; }
  if StrFindFirst(activeStr, "Cal10GaugeBuck_Slug") > -1 { return 0.20; }
  if StrEndsWith(activeStr, "Cal10GaugeBuck") { return 0.0; }
  if StrFindFirst(activeStr, "Cal12Gauge_Slug") > -1 { return 0.20; }
  if StrEndsWith(activeStr, "Cal12Gauge") { return 0.0; }
  if StrFindFirst(activeStr, "Cal4Gauge_Slug") > -1 { return 0.25; }
  if StrEndsWith(activeStr, "Cal4Gauge") { return 0.05; }
  if StrEndsWith(activeStr, "Cal10x40Rocket") { return 0.0; }
  if StrEndsWith(activeStr, "Cal12x45Rocket") { return 0.0; }
  if StrEndsWith(activeStr, "Cal12p7x70Rocket") { return 0.0; }
  if StrEndsWith(activeStr, "Cal15x55Rocket") { return 0.0; }
  if StrEndsWith(activeStr, "Cal18x70Rocket") { return 0.0; }
  if StrEndsWith(activeStr, "Cal6p5x25Minirocket") { return 0.0; }
  if StrEndsWith(activeStr, "Cal9p5x35Minirocket") { return 0.0; }
  if StrEndsWith(activeStr, "Cal3x10FlechCluster") { return 0.10; }
  if StrEndsWith(activeStr, "Cal10GaugeFlech") { return 0.15; }
  if StrEndsWith(activeStr, "Cal10x20TF") { return 0.10; }
  if StrEndsWith(activeStr, "Cal5p7x28TF") { return 0.10; }
  if StrEndsWith(activeStr, "Cal14x40TSlug") { return 0.25; }
  if StrEndsWith(activeStr, "Cal14x70TSlugHE") { return 0.25; }
  if StrEndsWith(activeStr, "Cal15x80TSpike") { return 0.30; }
  if StrEndsWith(activeStr, "Cal4p7x10TF") { return 0.20; }
  if StrEndsWith(activeStr, "Cal8x30RailF") { return 0.05; }
  if StrEndsWith(activeStr, "Cal8x30TShot") { return 0.05; }
  if StrEndsWith(activeStr, "Cal9x30TF") { return 0.05; }

  return 0.0;
}

func DPAE_GetFlechetteChargeBonus(activeStr: String) -> Float {
  if StrEndsWith(activeStr, "Cal10GaugeFlech") { return 0.50; }  // uncharged 0.15 / charged 0.65
  if StrEndsWith(activeStr, "Cal10x20TF") { return 0.50; }       // uncharged 0.10 / charged 0.60
  if StrEndsWith(activeStr, "Cal5p7x28TF") { return 0.50; }      // uncharged 0.10 / charged 0.60
  if StrEndsWith(activeStr, "Cal14x40TSlug") { return 0.60; }    // uncharged 0.25 / charged 0.85
  if StrEndsWith(activeStr, "Cal14x70TSlugHE") { return 0.60; }  // uncharged 0.25 / charged 0.85 (Comrade's Hammer, never had _AP)
  if StrEndsWith(activeStr, "Cal15x80TSpike") { return 0.70; }   // uncharged 0.30 / charged 1.00
  if StrEndsWith(activeStr, "Cal4p7x10TF") { return 0.55; }      // uncharged 0.20 / charged 0.75
  if StrEndsWith(activeStr, "Cal8x30RailF") { return 0.50; }     // uncharged 0.05 / charged 0.55
  if StrEndsWith(activeStr, "Cal8x30TShot") { return 0.50; }     // uncharged 0.05 / charged 0.55
  if StrEndsWith(activeStr, "Cal9x30TF") { return 0.50; }        // uncharged 0.05 / charged 0.55
  return 0.0;
}



public func DPAE_GetExplosivePackageForRound(activeStr: String) -> TweakDBID {
  if StrEndsWith(activeStr, "Cal45Super_HE")      { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal500Malour_HE")    { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal22x126AC_HE")     { return t"DPAE_HE.ExplodingBulletLightPackage"; }
  if StrEndsWith(activeStr, "Cal4Gauge_HE")       { return t"DPAE_HE.ExplodingBulletLightPackage"; }
  if StrEndsWith(activeStr, "Cal14x70TSlugHE")    { return t"DPAE_HE.ExplodingBulletMediumPackage"; }
  if StrEndsWith(activeStr, "Cal20x102Vulcan_HE") { return t"DPAE_HE.ExplodingBulletLightPackage"; }
  if StrEndsWith(activeStr, "Cal23x152Sov_HE")    { return t"DPAE_HE.RocketProjectilePackage"; }
  if StrEndsWith(activeStr, "Cal10x40Rocket_HE")   { return t"DPAE_HE.SmartBulletLowExplosivePackage"; }
  if StrEndsWith(activeStr, "Cal12x45Rocket_HE")   { return t"DPAE_HE.HerculesBulletPackage"; }
  if StrEndsWith(activeStr, "Cal12p7x70Rocket_HE") { return t"DPAE_HE.SmartBulletMedExplosivePackage"; }
  if StrEndsWith(activeStr, "Cal15x55Rocket_HE")   { return t"DPAE_HE.SmartBulletTwoStageExplosivePackage"; }
  if StrEndsWith(activeStr, "Cal18x70Rocket_HE")  { return t"DPAE_HE.ZhuoBulletHighExplosivePackage"; }
  if StrEndsWith(activeStr, "Cal6p5x25Minirocket_HE") { return t"DPAE_HE.SmartBulletHighExplosivePackage"; }
  if StrEndsWith(activeStr, "Cal9p5x35Minirocket_HE") { return t"DPAE_HE.SmartBulletHighExplosivePackage"; }
  if StrEndsWith(activeStr, "Cal5p56CT_HE")       { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal12p3x41UdaR_HE")  { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal7p62x39Sov_HE")   { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal14x40TSlug_HE")   { return t"DPAE_HE.ExplodingBulletLightPackage"; }
  if StrEndsWith(activeStr, "Cal50AE_HE")         { return t"DPAE_HE.ExplodingBulletLightPackage"; }
  if StrEndsWith(activeStr, "Cal10GaugeBuck_HE")  { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal9x19_HE")          { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal10mmAuto_HE")      { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal12Gauge_HE")       { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal243Win_HE")        { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal454Casull_HE")     { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal45WinMag_HE")      { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal50BeowulfOni_HE")  { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal50BMG_HE")         { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal5p45CT_HE")        { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal5p56x45NUSA_HE")   { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  if StrEndsWith(activeStr, "Cal6p5Arasaka_HE")    { return t"DPAE_HE.PhysicalExplosiveBulletPackage"; }
  return t"DPAE_HE.ExplodingBulletLightPackage";
}

public func DPAE_IsFirecrackerGatedHE(activeStr: String) -> Bool {
  if StrEndsWith(activeStr, "Cal9x19_HE") { return true; }
  if StrEndsWith(activeStr, "Cal10mmAuto_HE") { return true; }
  if StrEndsWith(activeStr, "Cal12Gauge_HE") { return true; }
  if StrEndsWith(activeStr, "Cal243Win_HE") { return true; }
  if StrEndsWith(activeStr, "Cal454Casull_HE") { return true; }
  if StrEndsWith(activeStr, "Cal45WinMag_HE") { return true; }
  if StrEndsWith(activeStr, "Cal50BeowulfOni_HE") { return true; }
  if StrEndsWith(activeStr, "Cal50BMG_HE") { return true; }
  if StrEndsWith(activeStr, "Cal5p45CT_HE") { return true; }
  if StrEndsWith(activeStr, "Cal5p56x45NUSA_HE") { return true; }
  if StrEndsWith(activeStr, "Cal6p5Arasaka_HE") { return true; }
  return false;
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateExplosiveOverride(activeStr: String, weapon: ref<WeaponObject>) -> Void {
  if !IsDefined(weapon) { return; }
  let isHE = StrEndsWith(activeStr, "HE");
  if isHE && DPAE_IsFirecrackerGatedHE(activeStr) {
    let firecrackerQualities = this.DPAE_GetAttachedModQualities(weapon, "Items.ChimeraPowerMod");
    if ArraySize(firecrackerQualities) <= 0 {
      isHE = false;
    }
  }
  if isHE {
    weapon.OverrideRangedAttackPackage(TweakDBInterface.GetRangedAttackPackageRecord(DPAE_GetExplosivePackageForRound(activeStr)));
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.HE_Active", this.GetEntityID());
  } else {
    weapon.DefaultRangedAttackPackage();
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.HE_Active");
  }
}



@wrapMethod(HitReactionComponent)
public func EvaluateHit(newHitEvent: ref<gameHitEvent>) -> Void {
  let player     = newHitEvent.attackData.GetInstigator() as PlayerPuppet;
  let npc        = newHitEvent.attackData.GetInstigator() as NPCPuppet;
  let npcHasAmmo = IsDefined(npc) && TDBID.IsValid(npc.dpae_npc_ammo);

  if IsDefined(player) && player.dpae_pending_nl {
    newHitEvent.attackData.AddFlag(hitFlag.Nonlethal, n"DPAE_NL");
    player.dpae_pending_nl = false;
  }
  if npcHasAmmo && DPAE_RoundIsNL(npc.dpae_npc_ammo) {
    newHitEvent.attackData.AddFlag(hitFlag.Nonlethal, n"DPAE_NL");
  }

  wrappedMethod(newHitEvent);

  if IsDefined(player) {
    let target = newHitEvent.target as GameObject;
    if ArraySize(player.dpae_pending_effect) > 0 && IsDefined(target) {
      DPAE_ApplyRoundEffects(target, player.dpae_pending_effect, player.GetEntityID());
      let dpaeNoEffects: array<TweakDBID>;
      player.dpae_pending_effect = dpaeNoEffects;
    }
    return;
  }

  if npcHasAmmo {
    let target = newHitEvent.target as GameObject;
    if IsDefined(target) {
      let npcWeapon = newHitEvent.attackData.GetWeapon() as WeaponObject;
      let effects = DPAE_GetEffectForRound(npc.dpae_npc_ammo, npc, npcWeapon);
      if ArraySize(effects) > 0 {
        DPAE_ApplyRoundEffects(target, effects, npc.GetEntityID());
      }
    }
  }
}


@addField(sampleBullet) public let dpae_effect:     array<TweakDBID>;
@addField(sampleBullet) public let dpae_instigator: EntityID;

@wrapMethod(sampleBullet)
protected cb func OnProjectileInitialize(eventData: ref<gameprojectileSetUpEvent>) -> Bool {
  let result = wrappedMethod(eventData);
  let player = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  if !IsDefined(player) || !player.dpae_test_active { return result; }
  let weapon = eventData.weapon as WeaponObject;
  if IsDefined(weapon) {
    let ts          = GameInstance.GetTransactionSystem(this.GetGame());
    let rightWeapon = ts.GetItemInSlot(player, t"AttachmentSlots.WeaponRight") as WeaponObject;
    let leftWeapon  = ts.GetItemInSlot(player, t"AttachmentSlots.WeaponLeft")  as WeaponObject;
    if weapon != rightWeapon && weapon != leftWeapon { return result; }
  }
  this.dpae_effect     = DPAE_GetEffectForRound(player.dpae_active_ammo, player, weapon);
  this.dpae_instigator = player.GetEntityID();
  return result;
}

@wrapMethod(sampleBullet)
protected cb func OnCollision(eventData: ref<gameprojectileHitEvent>) -> Bool {
  let result = wrappedMethod(eventData);
  if ArraySize(this.dpae_effect) > 0 {
    let i = 0;
    while i < ArraySize(eventData.hitInstances) {
      let target = eventData.hitInstances[i].hitObject as GameObject;
      if IsDefined(target) {
        DPAE_ApplyRoundEffects(target, this.dpae_effect, this.dpae_instigator);
      }
      i += 1;
    }
    let dpaeNoEffects: array<TweakDBID>;
    this.dpae_effect = dpaeNoEffects;
  }
  return result;
}

