class ActionMessage {
  Agent sender;
  float quantity;
  ActionType type;
  ActionMessage(Agent sender, ActionType type, float quantity) {
    this.sender = sender;
    this.quantity = quantity;
    this.type = type;
  }
}

class AttackMessage extends ActionMessage {
  Agent target;
  AttackMessage(Agent sender, ActionType type, float quantity, Agent target) {
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
    //println("agent " + this.attacker.getID() + " attacked agent " + this.target.getID() + " dealing " + damage + " damage ");
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

class AgentProfile {
  float aggression;
  float treatyScore;
  float hedonism;
  AgentProfile() {
    this.aggression = 0;
    this.treatyScore = 0;
    this.hedonism = 0;
  }

  AgentType profileToMotive() {

    AgentType[] allMotives = new AgentType[]{
      AgentType.EQUITABLE, AgentType.NARCISSIST,
      AgentType.MARTYR, AgentType.COOPERATIVE,
      AgentType.COMPETITIVE, AgentType.AGGRESSIVE,
      AgentType.INDIVIDUAL, AgentType.ALTRUIST
    };

    int quadrant;
    float x = this.treatyScore;
    float y = this.aggression;
    float z = this.hedonism;

    if (x >= 0 && y >= 0) {
      quadrant = 0;
    } else if (x < 0 && y >= 0) {
      quadrant = 1;
    } else if (x < 0 && y < 0) {
      quadrant = 2;
    } else {
      quadrant = 3;
    }

    if (z >= 0) {
      quadrant += 4;
    }

    return allMotives[quadrant];
  }

  void Print() {
    println(this.treatyScore, this.aggression, this.hedonism, "=", this.profileToMotive());
  }
}


class JSONData {
  String[] input;
  String[] output;
  JSONData(String[] input, String[] output) {
    this.input = input;
    this.output = output;
  }

  String valToJSON(String in) {
    String token = "\"";
    return token + in + token;
  }

  String formJSON() {
    try {
      if (this.input.length != this.output.length) {
        throw new Exception("fields and values must be the same size");
      }
      String fullString = "{ ";
      for (int i=0; i<this.input.length; i++) {
        String in = this.input[i];
        String out = this.output[i];
        if (i < this.input.length - 1) {
          fullString += (this.valToJSON(in) + ": " + this.valToJSON(out) + ", ");
        } else {
          fullString += (this.valToJSON(in) + ": " + this.valToJSON(out) + "}");
        }
      }
      return fullString;
    }
    catch(Exception e) {
      println(e);
      return "";
    }
  }
}
