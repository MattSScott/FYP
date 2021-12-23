class Agent {
  PVector pos; // where am I on the screen
  private float size;
  protected color col; // goody or baddie
  private int id; // what's my name
  private float HP; //current HP
  boolean alive; // am I alive or dead
  int neighbourhood; // the other agents I'm close enough to interact with
  float minDistanceToNeighbourhood; // closest I am to other lads
  ArrayList<TreatyProposal> activeTreaties; // what propositions have been made to me so far
  private float speed;
  private PVector glideVector; //destination used for smooth agent movement
  private PVector target;
  float pointsToInvest;
  float offence;
  float defence;
  float utility;

  Agent(int id, float x, float y, float size) {
    this.id = id;
    this.pos = new PVector(x, y);
    this.size = size;
    this.col = color(0, 0, 0);
    this.alive = true;
    this.neighbourhood = -1;
    this.activeTreaties = new ArrayList<TreatyProposal>();
    this.HP = 100;
    this.speed = random(1, 6);
    //this.speed = 0;
    this.target = new PVector( random(width), random(height) );
    this.glideVector = this.calculateGlideVector(target.copy());
    this.offence = 5;
    this.defence = 5;
    this.utility = 0;
    this.pointsToInvest = 10;
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
      this.glideVector = this.calculateGlideVector(this.target.copy());
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
    fill(255);
    text(this.id, this.pos.x, this.pos.y);
  }


  void offerTreaty(Agent a) {
    TreatyProposal newTreaty = new TreatyProposal(this, a, "BaseTreaty");
    if (random(1) < 0.001 && this.canOfferTreaty(newTreaty)) {
      TreatyResponse newTreatyResponse = a.reviewTreaty(newTreaty);
      if (newTreatyResponse.response) {
        this.activeTreaties.add(newTreaty);
        a.activeTreaties.add(newTreaty);
      }
    }
  }

  TreatyResponse reviewTreaty(TreatyProposal treaty) {
    TreatyResponse response = new TreatyResponse(treaty, true);
    if (random(1) < 0.5) {
      response = new TreatyResponse(treaty, false);
    }
    return response;
  }

  boolean isDuplicateTreaty(TreatyProposal t1, TreatyProposal t2) {
    return (t1.treatyTo == t2.treatyTo && t1.treatyFrom == t2.treatyFrom) || (t1.treatyTo == t2.treatyFrom && t1.treatyFrom == t2.treatyTo) && t1.treatyType == t2.treatyType; // a treaty of (1,0,X) = (0,1,X)
  }

  boolean canOfferTreaty(TreatyProposal thisTreaty) {
    for (TreatyProposal otherTreaty : thisTreaty.treatyTo.activeTreaties) { //check what I'm proposing against the existing treaties that the other agent has
      if (this.isDuplicateTreaty(thisTreaty, otherTreaty)) {
        return false;
      }
    }
    return true;
  }

  utilityDecisionMessage decideUtilityAction() {
    float rand = random(1);

    if ( rand < 0.25) {
      return this.stockpileDefence();
    }
    if ( rand < 0.5) {
      return this.stockpileOffence();
    }
    if ( rand < 0.75) {
      return this.stockpileUtility();
    }
    return this.declareAttack();
  }

  AttackInfo compileAttack(Agent opponent, float contribution) {
    AttackInfo thisAttack = new AttackInfo(this, opponent, contribution);
    return thisAttack;
  }

  utilityDecisionMessage stockpileOffence() {
    float quantity = random(this.pointsToInvest);
    return new utilityDecisionMessage(this, "boostOffence", quantity);
  }

  utilityDecisionMessage stockpileDefence() {
    float quantity = random(this.pointsToInvest);
    return new utilityDecisionMessage(this, "boostDefence", quantity);
  }

  utilityDecisionMessage stockpileUtility() {
    float quantity = random(this.pointsToInvest);
    return new utilityDecisionMessage(this, "boostUtility", quantity);
  }
  
  utilityDecisionMessage declareAttack() {
    float quantity = random(this.offence);
    return new utilityDecisionMessage(this, "attack", quantity);
  }
}
