class Agent {
  PVector pos;
  float size;
  color col;
  int id;
  ArrayList<TreatyProposal> treaties;

  Agent(int id, float x, float y, float size) {
    this.id = id;
    this.pos = new PVector(x, y);
    this.size = size;
    this.col = color(0, 0, 0);
    this.treaties = new ArrayList<TreatyProposal>();
  }


  int getID() {
    return this.id;
  }

  void agentConstrain() {
    if (this.pos.x > width) {
      this.pos.x = width;
    }
    if (this.pos.x < 0) {
      this.pos.x = 0;
    }
    if (this.pos.y > height) {
      this.pos.y = height;
    }
    if (this.pos.y < 0) {
      this.pos.y = 0;
    }
  }

  void moveRandom() {
    PVector mov = new PVector( random(-10.0, 10.0), random(-10.0, 10.0) );
    this.pos.add(mov);
    this.agentConstrain();
  }


  void drawAgent() {
    fill(this.col);
    ellipse(this.pos.x, this.pos.y, this.size, this.size);
  }

  ArrayList<TreatyProposal> makeTreaties() {
    ArrayList<TreatyProposal> proposals = new ArrayList<TreatyProposal>(agents.length-1);


    for (int i=0; i<agents.length; i++) {
      if (agents[i] != this) {
        int agentID = agents[i].getID();
        float twentyPercent = random(1);
        if (twentyPercent < 0.2) {
          TreatyProposal newTreaty = new TreatyProposal(agentID, this.getID(), "BaseTreaty");
          if (this.canAddTreaty(newTreaty)) {
            proposals.add(newTreaty);
          }
        }
      }
    }

    return proposals;
  }

  boolean isDuplicateTreaty(TreatyProposal t1, TreatyProposal t2) {
    return t1.treatyTo == t2.treatyTo && t1.treatyFrom == t2.treatyFrom && t1.treatyType == t2.treatyType;
  }

  boolean canAddTreaty(TreatyProposal t) {
    for (TreatyProposal t1 : agents[t.treatyTo].treaties) { //check what I'm proposing against the existing treaties that the other agent has
      if (this.isDuplicateTreaty(t1, t)) {
        return false;
      }
    }
    return true;
  }

  void reviewTreaties() {
  };
}
