class Narcissist extends Agent {
  Narcissist(int id, float x, float y, float size) {
    super(id, x, y, size);
    this.col = color(255, 0, 0);
  }

  void offerTreaty(Agent a) {
    TreatyProposal newTreaty = new TreatyProposal(this, a, "NastyTreaty");
    if (random(1) < 0.5 && this.canOfferTreaty(newTreaty)) {
      TreatyResponse newTreatyResponse = a.reviewTreaty(newTreaty);
      if (newTreatyResponse.response) {
        this.activeTreaties.add(newTreaty);
        a.activeTreaties.add(newTreaty);
      }
    }
  }

  TreatyResponse reviewTreaty(TreatyProposal treaty) {
    TreatyResponse response = new TreatyResponse(treaty, true);
    if (random(1) < 1) {
      response = new TreatyResponse(treaty, false);
    }
    return response;
  }

  ActionMessage decideAction(ArrayList<Agent> nearbyAgents){
    float rand = random(1);

    if ( rand < 0.33) {
      return this.stockpileDefence();
    }
    if ( rand < 0.85 || nearbyAgents.size() == 0) {
      return this.stockpileOffence();
    }
    Agent weakestAgent = nearbyAgents.get(0);
    for(int i=1; i<nearbyAgents.size(); i++){
      Agent currentAgent = nearbyAgents.get(i);
      if(currentAgent.defence < weakestAgent.defence){
        weakestAgent = currentAgent;
      }
    }
    return this.declareAttack(weakestAgent);
  }
}
