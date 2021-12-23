class TreatyProposal {
  Agent treatyFrom;
  Agent treatyTo;
  String treatyType;
  TreatyProposal(Agent treatyFrom, Agent treatyTo, String treatyType) {
    this.treatyFrom = treatyFrom;
    this.treatyTo = treatyTo;
    this.treatyType = treatyType;
  }
  void Print() {
    println(this.treatyFrom.getID(), this.treatyTo.getID(), this.treatyType);
  }
}

class TreatyResponse {
  TreatyProposal treaty;
  boolean response;
  TreatyResponse(TreatyProposal treaty, boolean response) {
    this.treaty = treaty;
    this.response = response;
  }
}

class Treaty {
  String treatyName;
  String description;
  VariableFieldName[] reqVars;
  float[] matReqVars;

  Treaty(String tn, String d, VariableFieldName[] rv, float[] mrv) {
    this.treatyName = tn;
    this.description = d;
    this.reqVars = rv;
    this.matReqVars = mrv;
  }

  String what() {
    return this.description;
  }
}

class AttackInfo {
  float resourcesContributed;
  int attacker;
  int target;
  AttackInfo(int attacker, int target, float contrib) {
    this.target = target;
    this.attacker = attacker;
    this.resourcesContributed = contrib;
  }
  boolean attackSuccessful() {
    return agents[attacker].offence >= this.resourcesContributed && this.resourcesContributed >= agents[target].defence;
  }
  float damageDealt() {
    if (this.attackSuccessful()) {
      float damage =  this.resourcesContributed - agents[target].defence;
      println("agent " + this.attacker + " attacked agent " + this.target + " dealing " + damage + " damage ");
      return damage;
    }
    return 0;
  }
}
