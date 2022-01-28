class TreatyProposal {
  Agent treatyFrom;
  Agent treatyTo;
  String treatyType; //Treaty after MVP
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

class ActionMessage {
  Agent sender;
  float quantity;
  actionType type;
  ActionMessage(Agent sender, actionType type, float quantity) {
    this.sender = sender;
    this.quantity = quantity;
    this.type = type;
  }
}

class AttackMessage extends ActionMessage {
  Agent target;
  AttackMessage(Agent sender, actionType type, float quantity, Agent target) {
    super(sender, type, quantity);
    this.target = target;
  }
}


class AttackInfo {
  float resourcesContributed;
  Agent attacker;
  Agent target;
  AttackInfo(Agent attacker, Agent target, float contrib) {
    this.target = target;
    this.attacker = attacker;
    this.resourcesContributed = contrib;
  }

  float damageDealt() {
    float damage =  max(0, this.resourcesContributed - target.defence);
    println("agent " + this.attacker.getID() + " attacked agent " + this.target.getID() + " dealing " + damage + " damage ");
    return damage;
  }
}


class FlockingData {
  float cohesionFactor;
  float alignmentFactor;
  float separationFactor;
  float separationDistance;
  FlockingData(float c, float a, float sf, float sd) {
    this.cohesionFactor = c;
    this.alignmentFactor = a;
    this.separationFactor = sf;
    this.separationDistance = sd;
  }
}
