class Narcissist extends Agent {
  Narcissist(int id, float x, float y, float size) {
    super(id, x, y, size);
    this.type = AgentType.NARCISSIST;
    this.col = color(255, 0, 0);
    this.opposite = AgentType.COOPERATIVE;
    this.motiveVector = new PVector(10, -10, -10);
  }


  Treaty generateTreaty(Agent a) { // selectively generate treaty based on agent
    TreatyInfo t = globalTreatyCache[2];
    return new Treaty(this, a, t);
  }

  boolean willOfferTreaty(Agent a) { // check if treaty will be offered based on trust/behaviour etc
    return random(1) < 0.05 && a.getID() > 0;
  }

  TreatyResponse reviewTreaty(Treaty treaty) {
    TreatyResponse response = new TreatyResponse(treaty, true);
    if (random(1) < 1) {
      response = new TreatyResponse(treaty, false);
    }
    return response;
  }
}
