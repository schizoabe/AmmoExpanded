@addMethod(PlayerPuppet)
public func DPAE_IsNarrativeAmmoWindowActive() -> Bool {
  let qs = GameInstance.GetQuestsSystem(this.GetGame());

  if this.IsReplacer() { return true; }

  if qs.GetFact(n"q001_active") >= 1
    && qs.GetFact(n"q001_aft_maxtac_scene") < 1
    && qs.GetFact(n"q001_aft_maxtac_scene_skip") < 1 {
    return true;
  }

  if qs.GetFact(n"q005_ride_to_notell") >= 1 && qs.GetFact(n"q005_done") < 1 { return true; }

  if qs.GetFact(n"q005_done") >= 1
    && qs.GetFact(n"q101_v_reached_pills") < 1
    && qs.GetFact(n"q101_08_takemura_hmm") < 1 {
    return true;
  }

  if qs.GetFact(n"q115_started") >= 1 && qs.GetFact(n"q115_done") < 1 { return true; }

  if qs.GetFact(n"sq004_saul_rescued") >= 1
    && qs.GetFact(n"sq004_no_chase") < 1
    && qs.GetFact(n"sq004_chase_done") < 1 {
    return true;
  }

  return false;
}

@addMethod(PlayerPuppet)
public func DPAE_IsJohnnyPossession() -> Bool {
  return Equals(this.GetRecord().GetID(), t"Character.johnny_replacer");
}

func DPAE_GetCaliberHEVariant(caliberTDBID: TweakDBID) -> TweakDBID {
  let heID = TDBID.Create(TDBID.ToStringDEBUG(caliberTDBID) + "_HE");
  if IsDefined(TweakDBInterface.GetItemRecord(heID)) {
    return heID;
  }
  return TDBID.None();
}
