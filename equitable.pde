class Equitable extends Agent {
  Equitable(int id, float x, float y, float size) {
    super(id, x, y, size);
    this.type = AgentType.EQUITABLE;
    this.col = color(230, 230, 250);
    this.opposite = AgentType.COMPETITIVE;
    this.motiveVector = new PVector(10, 10, -10);
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
}
