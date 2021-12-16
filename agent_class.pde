class Agent {
  PVector pos; // where am I on the screen
  private float size;
  protected color col; // goody or baddie
  private int id; // what's my name
  private float HP; //current HP
  boolean alive; // am I alive or dead
  int neighbourhood; // the other agents I'm close enough to interact with
  float minDistanceToNeighbourhood; // closest I am to other lads
  ArrayList<TreatyProposal> treaties; // what propositions have been made to me so far
  private float speed;
  private PVector glideVector; //destination used for smooth agent movement
  private PVector target;

  Agent(int id, float x, float y, float size) {
    this.id = id;
    this.pos = new PVector(x, y);
    this.size = size;
    this.col = color(0, 0, 0);
    this.alive = true;
    this.neighbourhood = -1;
    this.treaties = new ArrayList<TreatyProposal>();
    this.HP = 100;
    this.speed = random(1, 6);
    //this.speed = 15;
    this.target = new PVector( random(width), random(height) );
    this.glideVector = this.calculateGlideVector(target.copy());
  }


  int getID() {
    return this.id;
  }

  void setHP(float newHP) {
    this.HP = newHP;
  }

  float getHP() {
    return this.HP;
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
    PVector mov = new PVector( random(-50.0, 50.0), random(-50.0, 50.0) );
    this.pos.add(mov);
    this.agentConstrain();
  }

  void moveCalculated() {
    if (dist(this.pos.x, this.pos.y, this.target.x, this.target.y) <= 5 ) {
      this.target = new PVector( random(width), random(height) );
      this.glideVector = this.calculateGlideVector(target.copy());
    }
    this.pos.add(glideVector);
    //println(this.pos, this.target);
    this.agentConstrain();
  }

  PVector calculateGlideVector(PVector newPos) {
    PVector newDir = newPos.sub(this.pos);
    newDir.mult(speed/150.0);
    return newDir;
  }

  void drawAgent() {
    if (this.HP > 0) {
      fill(this.col);
    } else {
      fill(0);
    }
    ellipse(this.pos.x, this.pos.y, this.size, this.size);
    fill(0);
    text(this.id, this.pos.x, this.pos.y);
  }

  ArrayList<TreatyProposal> makeTreaties() {
    ArrayList<TreatyProposal> proposals = new ArrayList<TreatyProposal>(agents.length-1);

    for (int i=0; i<agents.length; i++) {
      if (agents[i] != this) {
        int agentID = agents[i].getID();
        if (random(1) < 0.2) {
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
    if ((this.neighbourhood != agents[t.treatyTo].neighbourhood)) {
      return false;
    }

    for (TreatyProposal t1 : agents[t.treatyTo].treaties) { //check what I'm proposing against the existing treaties that the other agent has
      if (this.isDuplicateTreaty(t1, t)) {
        return false;
      }
    }
    return true;
  }

  void reviewTreaties() {
    ArrayList<TreatyProposal> answeredTreaties = new ArrayList<TreatyProposal>();
    for (TreatyProposal t : this.treaties) {
      if (random(1) < 0.5) {
        answeredTreaties.add(t);
      }
    }
    this.treaties = answeredTreaties;
  }
}
