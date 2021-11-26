class Narcissist extends Agent {
  Narcissist(int id, float x, float y, float size, boolean alive) {
    super(id, x, y, size, alive);
    this.col = color(255, 0, 0);
  }

  ArrayList<TreatyProposal> makeTreaties() {
    ArrayList<TreatyProposal> proposals = new ArrayList<TreatyProposal>(agents.length-1);

    for (int i=0; i<agents.length; i++) {
      int agentID = agents[i].getID();
      if (agents[i] != this) {
        TreatyProposal newTreaty = new TreatyProposal(agentID, this.getID(), "MeanTreaty");
        if (this.canAddTreaty(newTreaty)) {
          proposals.add(newTreaty);
        }
      }
    }

    return proposals;
  }
}
