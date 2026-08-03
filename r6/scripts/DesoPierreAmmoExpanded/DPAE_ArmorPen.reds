@if(ModuleExists("GangBattlePower"))
import GangBattlePower.*


@if(ModuleExists("GangBattlePower"))
@addMethod(NPCPuppet)
public final func DPAE_GetCEArmorIntegrity() -> Float {
  return GBPStateOf(this).GBP_armorIntegrity;
}

@if(!ModuleExists("GangBattlePower"))
@addMethod(NPCPuppet)
public final func DPAE_GetCEArmorIntegrity() -> Float {
  return -1.0;
}

func DPAE_GetHPUnarmoredBonus(activeStr: String) -> Float {
  if StrFindFirst(activeStr, "Cal454Casull_HP") > -1 { return 0.40; }
  if StrFindFirst(activeStr, "Cal45Super_HP") > -1 { return 0.30; }
  if StrFindFirst(activeStr, "Cal45WinMag_HP") > -1 { return 0.30; }
  if StrFindFirst(activeStr, "Cal10mmAuto_HP") > -1 { return 0.25; }
  if StrFindFirst(activeStr, "Cal50AE_HP") > -1 { return 0.40; }
  if StrFindFirst(activeStr, "Cal12p3x41UdaR_HP") > -1 { return 0.40; }
  if StrFindFirst(activeStr, "Cal454Casull_Snakeshot") > -1 { return 0.40; }
  if StrFindFirst(activeStr, "Cal45Super_Snakeshot") > -1 { return 0.30; }
  if StrFindFirst(activeStr, "Cal45WinMag_Snakeshot") > -1 { return 0.30; }
  if StrFindFirst(activeStr, "Cal12p3x41UdaR_Snakeshot") > -1 { return 0.40; }
  if StrFindFirst(activeStr, "Cal5p45CT_HP") > -1 { return 0.60; }
  if StrFindFirst(activeStr, "Cal5p56CT_HP") > -1 { return 0.60; }
  if StrFindFirst(activeStr, "Cal6p5Arasaka_HP") > -1 { return 0.60; }
  if StrFindFirst(activeStr, "Cal308Win_HP") > -1 { return 0.60; }
  if StrFindFirst(activeStr, "Cal50BeowulfOni_HP") > -1 { return 0.40; }
  if StrFindFirst(activeStr, "Cal7p62x39Sov_HP") > -1 { return 0.60; }
  if StrFindFirst(activeStr, "Cal5p56x45NUSA_HP") > -1 { return 0.60; }
  if StrFindFirst(activeStr, "Cal243Win_HP") > -1 { return 0.65; }
  if StrFindFirst(activeStr, "Cal9x19_HP") > -1 { return 0.25; }
  if StrEndsWith(activeStr, "Cal10GaugeBuck") { return 0.55; }
  if StrEndsWith(activeStr, "Cal12Gauge") { return 0.50; }
  if StrEndsWith(activeStr, "Cal4Gauge") { return 0.65; }
  return 0.0;
}

@addMethod(PlayerPuppet)
public func DPAE_RemoveArmorPenModifier() -> Void {
  if !IsDefined(this.dpae_armorpen_mod) { return; }
  let ss = GameInstance.GetStatsSystem(this.GetGame());
  ss.RemoveModifier(Cast<StatsObjectID>(this.dpae_armorpen_entity), this.dpae_armorpen_mod);
  this.dpae_armorpen_mod = null;
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateArmorPierce(activeStr: String, weapon: ref<WeaponObject>) -> Void {
  this.DPAE_RemoveArmorPenModifier();
  if !IsDefined(weapon) { return; }
  let penValue = DPAE_GetArmorPenValue(activeStr);
  if penValue <= 0.0 { return; }
  let ss = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(weapon.GetEntityID());
  this.dpae_armorpen_entity = weapon.GetEntityID();
  this.dpae_armorpen_mod = RPGManager.CreateStatModifier(gamedataStatType.CanWeaponIgnoreArmor, gameStatModifierType.Additive, penValue);
  ss.AddModifier(objID, this.dpae_armorpen_mod);
}

@addMethod(NPCPuppet)
public func DPAE_RemoveArmorPenModifierNPC() -> Void {
  if !IsDefined(this.dpae_npcarmorpen_mod) { return; }
  let ss = GameInstance.GetStatsSystem(this.GetGame());
  ss.RemoveModifier(Cast<StatsObjectID>(this.dpae_npcarmorpen_entity), this.dpae_npcarmorpen_mod);
  this.dpae_npcarmorpen_mod = null;
}

@addMethod(NPCPuppet)
public func DPAE_UpdateArmorPierceNPC(activeStr: String, weapon: ref<WeaponObject>) -> Void {
  this.DPAE_RemoveArmorPenModifierNPC();
  if !IsDefined(weapon) { return; }
  let penValue = DPAE_GetArmorPenValue(activeStr);
  if penValue <= 0.0 { return; }
  let ss = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(weapon.GetEntityID());
  this.dpae_npcarmorpen_entity = weapon.GetEntityID();
  this.dpae_npcarmorpen_mod = RPGManager.CreateStatModifier(gamedataStatType.CanWeaponIgnoreArmor, gameStatModifierType.Additive, penValue);
  ss.AddModifier(objID, this.dpae_npcarmorpen_mod);
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateIncendiaryBurn(activeStr: String, pyroQualities: array<Int32>) -> Void {
  let isInc = StrEndsWith(activeStr, "_INC");
  if isInc {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.INC_Burn", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.INC_Burn");
  }
  this.DPAE_UpdatePyroBonusTier("INC_Burn_PyroBonus", pyroQualities, isInc);
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateHollowPointBleed(activeStr: String, pyroQualities: array<Int32>) -> Void {
  if StrEndsWith(activeStr, "_HP") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.HP_Bleed", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.HP_Bleed");
  }
  this.DPAE_UpdatePyroBonusTier("HP_Bleed_PyroBonus", pyroQualities, StrEndsWith(activeStr, "_HP"));
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateEmpShock(activeStr: String, pyroQualities: array<Int32>) -> Void {
  if StrEndsWith(activeStr, "_EMP") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.EMP_Shock", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.EMP_Shock");
  }
  this.DPAE_UpdatePyroBonusTier("EMP_Shock_PyroBonus", pyroQualities, StrEndsWith(activeStr, "_EMP"));
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateChemPoison(activeStr: String, pyroQualities: array<Int32>) -> Void {
  if StrEndsWith(activeStr, "_CHEM") {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.CHEM_Poison", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.CHEM_Poison");
  }
  this.DPAE_UpdatePyroBonusTier("CHEM_Poison_PyroBonus", pyroQualities, StrEndsWith(activeStr, "_CHEM"));
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateIconicElementalBonus(activeStr: String, weapon: ref<WeaponObject>) -> Void {
  let isElectric = false;
  let isChemical = false;
  let isThermal = false;
  let isChemicalRateBonus = false;
  let isThermalRateBonus = false;
  if IsDefined(weapon) {
    let ts = GameInstance.GetTransactionSystem(this.GetGame());
    let weaponItemID = weapon.GetItemID();
    if ItemID.IsValid(weaponItemID) {
      isElectric = ts.HasTag(this, n"DPAE_IconicElemental_Electric", weaponItemID) && StrEndsWith(activeStr, "_EMP");
      isChemical = ts.HasTag(this, n"DPAE_IconicElemental_Chemical", weaponItemID) && StrEndsWith(activeStr, "_CHEM");
      isThermal  = ts.HasTag(this, n"DPAE_IconicElemental_Thermal",  weaponItemID) && StrEndsWith(activeStr, "_INC");
      isChemicalRateBonus = ts.HasTag(this, n"DPAE_IconicElementalRateBonus_Chemical", weaponItemID) && StrEndsWith(activeStr, "_CHEM");
      isThermalRateBonus  = ts.HasTag(this, n"DPAE_IconicElementalRateBonus_Thermal",  weaponItemID) && StrEndsWith(activeStr, "_INC");
      if !isThermal && StrEndsWith(activeStr, "_HE") && ts.HasTag(this, n"DPAE_ThermalOnHE", weaponItemID) {
        isThermal = true;
        isThermalRateBonus = ts.HasTag(this, n"DPAE_IconicElementalRateBonus_Thermal", weaponItemID);
      }
    }
  }
  if isElectric {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.IconicElectric_Bonus", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicElectric_Bonus");
  }
  if isChemical {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.IconicChemical_Bonus", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicChemical_Bonus");
  }
  if isThermal {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.IconicThermal_Bonus", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicThermal_Bonus");
  }
  if isChemicalRateBonus {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.IconicChemical_RateBonus", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicChemical_RateBonus");
  }
  if isThermalRateBonus {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.IconicThermal_RateBonus", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.IconicThermal_RateBonus");
  }
}

@addMethod(PlayerPuppet)
public func DPAE_UpdateIconicRateBonus(activeStr: String, weapon: ref<WeaponObject>) -> Void {
  let isSparky      = false;
  let isBorzaya     = false;
  let isBloodyMaria = false;
  if IsDefined(weapon) {
    let ts = GameInstance.GetTransactionSystem(this.GetGame());
    let weaponItemID = weapon.GetItemID();
    if ItemID.IsValid(weaponItemID) {
      isSparky      = ts.HasTag(this, n"DPAE_IconicRateBonus_Sparky",      weaponItemID) && StrEndsWith(activeStr, "_EMP");
      isBorzaya     = ts.HasTag(this, n"DPAE_IconicRateBonus_Borzaya",     weaponItemID) && StrEndsWith(activeStr, "_INC");
      isBloodyMaria = ts.HasTag(this, n"DPAE_IconicRateBonus_BloodyMaria", weaponItemID) && StrEndsWith(activeStr, "Cal12Gauge");
    }
  }
  if isSparky {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.Sparky_RateBonus", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.Sparky_RateBonus");
  }
  if isBorzaya {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.Borzaya_RateBonus", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.Borzaya_RateBonus");
  }
  if isBloodyMaria {
    StatusEffectHelper.ApplyStatusEffect(this, t"DPAE_StatusEffect.BloodyMaria_RateBonus", this.GetEntityID());
  } else {
    StatusEffectHelper.RemoveStatusEffect(this, t"DPAE_StatusEffect.BloodyMaria_RateBonus");
  }
}

@addMethod(PlayerPuppet)
public func DPAE_UpdatePyroBonusTier(bonusName: String, pyroQualities: array<Int32>, ammoMatches: Bool) -> Void {
  let tier = 0;
  while tier <= 4 {
    let tierID = TDBID.Create("DPAE_StatusEffect." + bonusName + "_T" + ToString(tier));
    StatusEffectHelper.RemoveStatusEffect(this, tierID);
    if ammoMatches {
      let count = 0;
      let i = 0;
      while i < ArraySize(pyroQualities) {
        if pyroQualities[i] == tier { count += 1; }
        i += 1;
      }
      let c = 0;
      while c < count {
        StatusEffectHelper.ApplyStatusEffect(this, tierID, this.GetEntityID());
        c += 1;
      }
    }
    tier += 1;
  }
}

@addMethod(PlayerPuppet)
public func DPAE_ClearAllPyroBonuses() -> Void {
  let bonusNames: array<String>;
  ArrayPush(bonusNames, "INC_Burn_PyroBonus");
  ArrayPush(bonusNames, "HP_Bleed_PyroBonus");
  ArrayPush(bonusNames, "EMP_Shock_PyroBonus");
  ArrayPush(bonusNames, "CHEM_Poison_PyroBonus");
  let b = 0;
  while b < ArraySize(bonusNames) {
    let tier = 0;
    while tier <= 4 {
      StatusEffectHelper.RemoveStatusEffect(this, TDBID.Create("DPAE_StatusEffect." + bonusNames[b] + "_T" + ToString(tier)));
      tier += 1;
    }
    b += 1;
  }
}

@addMethod(PlayerPuppet)
public func DPAE_GetAttachedModQualities(weapon: ref<WeaponObject>, prefix: String) -> array<Int32> {
  let qualities: array<Int32>;
  if !IsDefined(weapon) { return qualities; }
  let ts = GameInstance.GetTransactionSystem(this.GetGame());
  let weaponItemID = weapon.GetItemID();
  let usedSlots: array<TweakDBID>;
  ts.GetUsedSlotsOnItem(this, weaponItemID, usedSlots);
  let itemData = ts.GetItemData(this, weaponItemID);
  let partData: InnerItemData;
  let i = 0;
  while i < ArraySize(usedSlots) {
    itemData.GetItemPart(partData, usedSlots[i]);
    let partID = InnerItemData.GetItemID(partData);
    if ItemID.IsValid(partID) {
      let partTDBID = ItemID.GetTDBID(partID);
      if StrBeginsWith(TDBID.ToStringDEBUG(partTDBID), prefix) {
        let itemRecord = TweakDBInterface.GetItemRecord(partTDBID);
        let qualityRecord = itemRecord.Quality();
        ArrayPush(qualities, IsDefined(qualityRecord) ? qualityRecord.Value() : 0);
      }
    }
    i += 1;
  }
  return qualities;
}

public func DPAE_RoundIsNL(roundID: TweakDBID) -> Bool {
  return StrEndsWith(TDBID.ToStringDEBUG(roundID), "_NL");
}



@addMethod(PlayerPuppet)
public func DPAE_ApplySlugModifiers(weapon: ref<WeaponObject>) -> Void {
  if !IsDefined(weapon) { return; }
  let ss    = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(weapon.GetEntityID());
  this.dpae_slug_entity      = weapon.GetEntityID();

  let projBefore = ss.GetStatValue(objID, gamedataStatType.ProjectilesPerShotBase);
  this.dpae_slug_proj        = RPGManager.CreateStatModifier(gamedataStatType.ProjectilesPerShotBase, gameStatModifierType.Additive,    1.0 - projBefore);
  this.dpae_slug_spreadMaxX  = RPGManager.CreateStatModifier(gamedataStatType.SpreadMaxX,             gameStatModifierType.Multiplier, 0.0);
  this.dpae_slug_spreadMaxY  = RPGManager.CreateStatModifier(gamedataStatType.SpreadMaxY,             gameStatModifierType.Multiplier, 0.0);
  this.dpae_slug_spreadAdsX  = RPGManager.CreateStatModifier(gamedataStatType.SpreadAdsMaxX,          gameStatModifierType.Multiplier, 0.0);
  this.dpae_slug_spreadAdsY  = RPGManager.CreateStatModifier(gamedataStatType.SpreadAdsMaxY,          gameStatModifierType.Multiplier, 0.0);
  this.dpae_slug_spreadChange = RPGManager.CreateStatModifier(gamedataStatType.SpreadChangePerShot,   gameStatModifierType.Multiplier, 0.0);
  ss.AddModifier(objID, this.dpae_slug_proj);
  ss.AddModifier(objID, this.dpae_slug_spreadMaxX);
  ss.AddModifier(objID, this.dpae_slug_spreadMaxY);
  ss.AddModifier(objID, this.dpae_slug_spreadAdsX);
  ss.AddModifier(objID, this.dpae_slug_spreadAdsY);
  ss.AddModifier(objID, this.dpae_slug_spreadChange);
}

@addMethod(PlayerPuppet)
public func DPAE_RemoveSlugModifiers() -> Void {
  if !IsDefined(this.dpae_slug_proj) { return; }
  let ss    = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(this.dpae_slug_entity);
  ss.RemoveModifier(objID, this.dpae_slug_proj);
  ss.RemoveModifier(objID, this.dpae_slug_spreadMaxX);
  ss.RemoveModifier(objID, this.dpae_slug_spreadMaxY);
  ss.RemoveModifier(objID, this.dpae_slug_spreadAdsX);
  ss.RemoveModifier(objID, this.dpae_slug_spreadAdsY);
  ss.RemoveModifier(objID, this.dpae_slug_spreadChange);
  this.dpae_slug_proj        = null;
  this.dpae_slug_spreadMaxX  = null;
  this.dpae_slug_spreadMaxY  = null;
  this.dpae_slug_spreadAdsX  = null;
  this.dpae_slug_spreadAdsY  = null;
  this.dpae_slug_spreadChange = null;
}

@addMethod(PlayerPuppet)
public func DPAE_ApplySnakeshotModifiers(weapon: ref<WeaponObject>) -> Void {
  if !IsDefined(weapon) { return; }
  let ss    = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(weapon.GetEntityID());
  this.dpae_snakeshot_entity = weapon.GetEntityID();

  let projBefore = ss.GetStatValue(objID, gamedataStatType.ProjectilesPerShotBase);
  this.dpae_snakeshot_proj = RPGManager.CreateStatModifier(gamedataStatType.ProjectilesPerShotBase, gameStatModifierType.Additive, 5.0 - projBefore);
  ss.AddModifier(objID, this.dpae_snakeshot_proj);
}

@addMethod(PlayerPuppet)
public func DPAE_RemoveSnakeshotModifiers() -> Void {
  if !IsDefined(this.dpae_snakeshot_proj) { return; }
  let ss    = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(this.dpae_snakeshot_entity);
  ss.RemoveModifier(objID, this.dpae_snakeshot_proj);
  this.dpae_snakeshot_proj = null;
}

@addMethod(NPCPuppet)
public func DPAE_ApplySlugModifiersNPC(weapon: ref<WeaponObject>) -> Void {
  if !IsDefined(weapon) { return; }
  let ss    = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(weapon.GetEntityID());
  this.dpae_npcslug_entity = weapon.GetEntityID();

  let projBefore = ss.GetStatValue(objID, gamedataStatType.ProjectilesPerShotBase);
  this.dpae_npcslug_proj        = RPGManager.CreateStatModifier(gamedataStatType.ProjectilesPerShotBase, gameStatModifierType.Additive,    1.0 - projBefore);
  this.dpae_npcslug_spreadMaxX  = RPGManager.CreateStatModifier(gamedataStatType.SpreadMaxX,             gameStatModifierType.Multiplier, 0.0);
  this.dpae_npcslug_spreadMaxY  = RPGManager.CreateStatModifier(gamedataStatType.SpreadMaxY,             gameStatModifierType.Multiplier, 0.0);
  this.dpae_npcslug_spreadAdsX  = RPGManager.CreateStatModifier(gamedataStatType.SpreadAdsMaxX,          gameStatModifierType.Multiplier, 0.0);
  this.dpae_npcslug_spreadAdsY  = RPGManager.CreateStatModifier(gamedataStatType.SpreadAdsMaxY,          gameStatModifierType.Multiplier, 0.0);
  this.dpae_npcslug_spreadChange = RPGManager.CreateStatModifier(gamedataStatType.SpreadChangePerShot,   gameStatModifierType.Multiplier, 0.0);
  ss.AddModifier(objID, this.dpae_npcslug_proj);
  ss.AddModifier(objID, this.dpae_npcslug_spreadMaxX);
  ss.AddModifier(objID, this.dpae_npcslug_spreadMaxY);
  ss.AddModifier(objID, this.dpae_npcslug_spreadAdsX);
  ss.AddModifier(objID, this.dpae_npcslug_spreadAdsY);
  ss.AddModifier(objID, this.dpae_npcslug_spreadChange);
}

@addMethod(NPCPuppet)
public func DPAE_RemoveSlugModifiersNPC() -> Void {
  if !IsDefined(this.dpae_npcslug_proj) { return; }
  let ss    = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(this.dpae_npcslug_entity);
  ss.RemoveModifier(objID, this.dpae_npcslug_proj);
  ss.RemoveModifier(objID, this.dpae_npcslug_spreadMaxX);
  ss.RemoveModifier(objID, this.dpae_npcslug_spreadMaxY);
  ss.RemoveModifier(objID, this.dpae_npcslug_spreadAdsX);
  ss.RemoveModifier(objID, this.dpae_npcslug_spreadAdsY);
  ss.RemoveModifier(objID, this.dpae_npcslug_spreadChange);
  this.dpae_npcslug_proj        = null;
  this.dpae_npcslug_spreadMaxX  = null;
  this.dpae_npcslug_spreadMaxY  = null;
  this.dpae_npcslug_spreadAdsX  = null;
  this.dpae_npcslug_spreadAdsY  = null;
  this.dpae_npcslug_spreadChange = null;
}

@addMethod(NPCPuppet)
public func DPAE_ApplySnakeshotModifiersNPC(weapon: ref<WeaponObject>) -> Void {
  if !IsDefined(weapon) { return; }
  let ss    = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(weapon.GetEntityID());
  this.dpae_npcsnake_entity = weapon.GetEntityID();

  let projBefore = ss.GetStatValue(objID, gamedataStatType.ProjectilesPerShotBase);
  this.dpae_npcsnake_proj = RPGManager.CreateStatModifier(gamedataStatType.ProjectilesPerShotBase, gameStatModifierType.Additive, 5.0 - projBefore);
  ss.AddModifier(objID, this.dpae_npcsnake_proj);
}

@addMethod(NPCPuppet)
public func DPAE_RemoveSnakeshotModifiersNPC() -> Void {
  if !IsDefined(this.dpae_npcsnake_proj) { return; }
  let ss    = GameInstance.GetStatsSystem(this.GetGame());
  let objID = Cast<StatsObjectID>(this.dpae_npcsnake_entity);
  ss.RemoveModifier(objID, this.dpae_npcsnake_proj);
  this.dpae_npcsnake_proj = null;
}


