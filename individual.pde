class Individual extends Agent {
  Individual(int id, float x, float y, float size) {
    super(id, x, y, size);
    this.type = AgentType.INDIVIDUAL;
    this.col = color(0, 0, 255);
    this.opposite = AgentType.MARTYR;
    this.motiveVector = new PVector(-10, -10, 10);
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

  //ActionMessage decideAction(ArrayList<Agent> nearbyAgents) {
  //  return this.stockpileUtility();
  //}
}
