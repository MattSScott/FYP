enum TreatyVariable {
  AGE,
    OFFENCE,
    DEFENCE,
    UTILITY,
    NEIGHBOURHOOD,
    OFFENCE_INVESTMENT,
    DEFENCE_INVESTMENT,
    UTILITY_INVESTMENT,
    ATTACK_INVESTMENT,
    ATTACK_LAUNCHED,
    ATTACK_AGAINST
};

enum TreatyOpCode {
  EQ,
    NEQ,
    LT,
    GT,
    LEQ,
    GEQ
}

class Treaty {
  Agent treatyFrom;
  Agent treatyTo;
  TreatyInfo treatyInfo; //Treaty after MVP
  Treaty(Agent treatyFrom, Agent treatyTo, TreatyInfo t) {
    this.treatyFrom = treatyFrom;
    this.treatyTo = treatyTo;
    this.treatyInfo = t;
  }
  void Print() {
    println(this.treatyFrom.getID(), this.treatyTo.getID(), this.treatyInfo.treatyName);
  }
}

class TreatyResponse {
  Treaty proposal;
  boolean response;
  TreatyResponse(Treaty proposal, boolean response) {
    this.proposal = proposal;
    this.response = response;
  }
}

class TreatyInfo {
  String treatyName; // name of treaty
  String description; // description of how treaty works
  TreatyVariable[] reqVars; // necessary agent parameters to define treaty condition
  float[] matReqVars; // matrix of multipliers for agent parameters
  TreatyOpCode[] auxiliary; // op code set
  ActionType[] treatyCategory; // action(s) that treaty affects

  TreatyInfo(String tn, String d, TreatyVariable[] rv, float[] mrv, TreatyOpCode[] aux, ActionType[] tc) {
    this.treatyName = tn;
    this.description = d;
    this.reqVars = rv;
    this.matReqVars = mrv;
    this.auxiliary = aux;
    this.treatyCategory = tc;
  }

  String what() {
    return this.description;
  }
}

//class TreatyVarCategoryPair {
//  TreatyVariable tv;
//  ActionType[] category;
//  TreatyVarCategoryPair(TreatyVariable tv, ActionType[] category){
//    this.tv = tv;
//    this.category = category;
//  }
//}


//dependency map:

//actiontype : treatyVar


//set of treaties that can be proposed
final TreatyInfo[] globalTreatyCache = new TreatyInfo[]{

  new TreatyInfo("niceTreaty",
  "a nice treaty",
  new TreatyVariable[]{TreatyVariable.AGE},
  new float[]{1, -1, 1, -3},
  new TreatyOpCode[]{TreatyOpCode.GT, TreatyOpCode.LT},
  new ActionType[]{ActionType.boostUtility}
  ),


  new TreatyInfo("ageBig0UtilLess600",
  "a test treaty",
  new TreatyVariable[]{TreatyVariable.AGE, TreatyVariable.UTILITY},
  new float[]{1, 0, 0, 0, 1, -600},
  new TreatyOpCode[]{TreatyOpCode.GT, TreatyOpCode.LT},
  new ActionType[]{ActionType.boostOffence}
  ),



  new TreatyInfo("noAttacknoOffence",
  "a cool treaty",
  new TreatyVariable[]{TreatyVariable.OFFENCE_INVESTMENT, TreatyVariable.ATTACK_LAUNCHED},
  new float[]{1, 0, -20, 0, 1, -1},
  new TreatyOpCode[]{TreatyOpCode.LT, TreatyOpCode.EQ},
  new ActionType[]{ActionType.boostOffence, ActionType.launchAttack}
  ),


};
