class Altruist extends Agent {
  Altruist(int id, float x, float y, float size) {
    super(id, x, y, size);
    this.col = color(0, 255, 0);
  }

  ArrayList<TreatyProposal> makeTreaties() {
    ArrayList<TreatyProposal> proposals = new ArrayList<TreatyProposal>(agents.length-1);

    for (int i=0; i<agents.length; i++) {
      int agentID = agents[i].getID();
      if (agents[i] != this) {
        TreatyProposal newTreaty = new TreatyProposal(agentID, this.getID(), "NiceTreaty");
        if (this.canAddTreaty(newTreaty)) {
          proposals.add(newTreaty);
        }
      }
    }

    return proposals;
  }
}
