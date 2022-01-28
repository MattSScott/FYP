class Altruist extends Agent {
  Altruist(int id, float x, float y, float size) {
    super(id, x, y, size);
    this.col = color(0, 255, 0);
  }


  //void offerTreaty(Agent a) {
  //  TreatyProposal newTreaty = new TreatyProposal(this, a, "NiceTreaty");
  //  if (random(1) < 0.5 && this.canOfferTreaty(newTreaty)) {
  //    TreatyResponse newTreatyResponse = a.reviewTreaty(newTreaty);
  //    if (newTreatyResponse.response) {
  //      this.activeTreaties.add(newTreaty);
  //      a.activeTreaties.add(newTreaty);
  //    }
  //  }
  //}
  
    TreatyProposal generateTreaty(Agent a) { // selectively generate treaty based on agent
    return new TreatyProposal(this, a, "NiceTreaty");
  }

  boolean willOfferTreaty(Agent a) { // check if treaty will be offered based on trust/behaviour etc
    return random(1) < 0.1 && a.id > 0;
    //return true;
  }

  TreatyResponse reviewTreaty(TreatyProposal treaty) {
    TreatyResponse response = new TreatyResponse(treaty, true);
    if (random(1) < 0) {
      response = new TreatyResponse(treaty, false);
    }
    return response;
  }
  
  ActionMessage decideAction(ArrayList<Agent> nearbyAgents) {
    return this.stockpileUtility();
  }
  
  
   ArrayList<Agent> filterAgentsForFlocking(ArrayList<Agent> allAgents) { // override to flock conditionally
    return allAgents;
  }

  
  
}
