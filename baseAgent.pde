class Agent {
  private PVector pos; // where am I on the screen
  private float baseSize;
  protected color col; // goody or baddie
  private int ID; // what's my name
  private float HP; //current HP
  boolean alive; // am I alive or dead
  int neighbourhood; // the other agents I'm close enough to interact with
  float minDistanceToNeighbourhood; // closest I am to other lads
  ArrayList<TreatyProposal> activeTreaties; // what propositions have been made to me so far
  private float speed;
  private PVector velocity; //destination used for smooth agent movement
  private PVector target;
  float pointsToInvest;
  float offence;
  float defence;
  float utility;
  HashMap<Integer, AgentProfile> agentProfiles; // map agent id to struct of utility choices and treaty choices

  Agent(int id, float x, float y, float size) {
    this.ID = id;
    this.pos = new PVector(x, y);
    this.baseSize = size;
    this.col = color(0, 0, 0);
    this.alive = true;
    this.neighbourhood = -1;
    this.activeTreaties = new ArrayList<TreatyProposal>();
    this.HP = 100;
    this.speed = random(1, 6);
    //this.speed = 0;
    this.target = new PVector( random(width), random(height) );
    this.velocity = this.calculateVelocity(target.copy());
    //this.velocity = new PVector( random(-10, 10), random(-10, 10) );
    this.offence = 5;
    this.defence = 5;
    this.utility = 0;
    this.pointsToInvest = 50;
    this.agentProfiles = new HashMap<Integer, AgentProfile>();
  }


  int getID() {
    return this.ID;
  }

  void setHP(float newHP) {
    this.HP = newHP;
  }

  float getHP() {
    return this.HP;
  }

  //PVector getPos() {
  //  return this.pos.copy();
  //}

  PVector getVelocity() {
    return this.velocity.copy();
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
      this.velocity = this.calculateVelocity(this.target.copy());
    }
    this.pos.add(velocity);
    //println(this.pos, this.target);
    this.agentConstrain();
  }

  void flock(ArrayList<Agent> allAgents) {
    ArrayList<Agent> boids = this.filterAgentsForFlocking(allAgents);
    this.velocity.add(this.calcFlock(boids)).mult(0.75);
    this.pos.add(this.velocity);
    //this.agentConstrain();
    //println(this.velocity);
  }

  PVector calculateVelocity(PVector newPos) {
    PVector newDir = newPos.sub(this.pos);
    newDir.mult(speed/150.0);
    return newDir;
  }

  void drawAgent(String s) {

    float size;

    switch (s) {
    case "utility":
      size = map(this.utility, 0, 500, 5, 60);
      break;
    case "offense":
      size = map(this.offence, 0, 200, 5, 60);
      break;
    case "defence":
      size = map(this.defence, 0, 200, 5, 60);
      break;
    default:
      size = this.baseSize;
    }

    if (this.HP > 0) {
      fill(this.col);
    } else {
      fill(0);
    }
    ellipse(this.pos.x, this.pos.y, size, size);
    fill(0);
    textAlign(CENTER);
    text(this.ID, this.pos.x, this.pos.y);
  }

  // TREATY SESSION //

  ArrayList<TreatyProposal> offerAllTreaties(ArrayList<Agent> nearbyAgents) {
    ArrayList<TreatyProposal> allTreatyOffers = new ArrayList<TreatyProposal>();
    for (Agent a : nearbyAgents) {
      if (this.willOfferTreaty(a)) {
        TreatyProposal offer = this.generateTreaty(a);
        if (this.canOfferTreaty(offer)) {
          allTreatyOffers.add(offer);
        }
      }
    }
    return allTreatyOffers;
  }


  TreatyProposal generateTreaty(Agent a) { // selectively generate treaty based on agent
    return new TreatyProposal(this, a, "BaseTreaty");
  }

  boolean willOfferTreaty(Agent a) { // check if treaty will be offered based on trust/behaviour etc
    return random(1) < 0.001 && a.getID() > 0;
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

  void updateAgentProfile(int agentID, float treatyScore, float aggUpdate) {
    if (!this.agentProfiles.containsKey(agentID)) {
      this.agentProfiles.put(agentID, new AgentProfile());
    }
    AgentProfile profile = this.agentProfiles.get(agentID);
    profile.aggression += aggUpdate;
    profile.treatyScore += treatyScore;
    println(profile.treatyScore, profile.aggression);
  }

  void handleTreatyResponse(TreatyResponse tr) { // update profile based on treaty responses
    int responderID = tr.proposal.treatyTo.getID();
    if (tr.response) {
      this.updateAgentProfile(responderID, 10, 0);
    } else {
      this.updateAgentProfile(responderID, -1, 0);
    }
  }

  // ACTION SESSION //

  ActionMessage decideAction(ArrayList<Agent> nearbyAgents) {

    float rand = random(1);

    if ( rand < 0.25) {
      return this.stockpileDefence();
    }
    if ( rand < 0.5 || nearbyAgents.size() == 0) {
      return this.stockpileOffence();
    }
    if ( rand < 0.75) {
      return this.stockpileUtility();
    }
    int randomTarget = int(random(nearbyAgents.size()));
    return this.declareAttack(nearbyAgents.get(randomTarget));
  }


  ActionMessage stockpileOffence() {
    float quantity = random(this.pointsToInvest);
    return new ActionMessage(this, actionType.boostOffence, quantity);
  }

  ActionMessage stockpileDefence() {
    float quantity = random(this.pointsToInvest);
    return new ActionMessage(this, actionType.boostDefence, quantity);
  }

  ActionMessage stockpileUtility() {
    float quantity = random(this.pointsToInvest);
    return new ActionMessage(this, actionType.boostUtility, quantity);
  }

  ActionMessage declareAttack(Agent target) {
    float quantity = random(this.offence);
    return new AttackMessage(this, actionType.launchAttack, quantity, target);
  }

  void receiveAttackNotif(AttackInfo atk) {
    int attackerID = atk.attacker.getID();
    float dmg = atk.damageDealt();
    this.updateAgentProfile(attackerID, 0, -dmg/10.0);
  }


  // FLOCKING //

  ArrayList<Agent> filterAgentsForFlocking(ArrayList<Agent> allAgents) { // override to flock conditionally
    return allAgents;
  }

  PVector calcFlockCohesion(ArrayList<Agent> boids) {
    PVector avgPos = new PVector();


    for (Agent boid : boids) {
      //if (boid != this) {
      avgPos.add(boid.pos);
      //}
    }

    avgPos.div(boids.size());

    avgPos.sub(this.pos);

    return avgPos.mult(flockData.cohesionFactor / 100);
  }

  PVector calcFlockAlignment(ArrayList<Agent> boids) {
    PVector avgVel = new PVector();

    for (Agent boid : boids) {
      if (boid != this) {
        avgVel.add(boid.velocity);
      }
    }

    avgVel.div(max(1, boids.size() - 1));

    avgVel.sub(this.velocity);

    return avgVel.mult(flockData.alignmentFactor / 100);
  }

  PVector calcFlockSeparation(ArrayList<Agent> boids) {
    PVector separate = new PVector();

    for (Agent boid : boids) {
      if (boid != this) {
        PVector sep = boid.pos.copy().sub(this.pos);
        if (sep.mag() < flockData.separationDistance) {
          separate.sub(sep);
        }
      }
    }

    return separate.mult(flockData.separationFactor / 100);
  }

  PVector calcFlock(ArrayList<Agent> boids) {
    PVector c = this.calcFlockCohesion(boids);
    PVector a = this.calcFlockAlignment(boids);
    PVector s = this.calcFlockSeparation(boids);

    return c.add(a).add(s);
  }
}
