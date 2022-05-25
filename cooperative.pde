class Cooperative extends Agent {
  Cooperative(int id, float x, float y, float size) {
    super(id, x, y, size);
    this.type = AgentType.COOPERATIVE;
    this.col = color(255, 51, 204);
    this.opposite = AgentType.NARCISSIST;
  }


  Treaty generateTreaty(Agent a) { // selectively generate treaty based on agent
    TreatyInfo t = globalTreatyCache[2];
    return new Treaty(this, a, t);
  }

  boolean willOfferTreaty(Agent a) { // check if treaty will be offered based on trust/behaviour etc
    return random(1) < 0.1 && a.getID() > 0;
    //return true;
  }

  TreatyResponse reviewTreaty(Treaty treaty) {
    TreatyResponse response = new TreatyResponse(treaty, true);
    if (random(1) < 0) {
      response = new TreatyResponse(treaty, false);
    }
    return response;
  }

  ActionMessage decideAction(ArrayList<Agent> nearbyAgents) {
    return this.stockpileUtility();
  }
}
