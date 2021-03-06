class Agent {
  protected AgentType type; // what is my social motive
  protected AgentType opposite; // what is my 'enemy'
  private PVector pos; // where am I on the screen
  private float baseSize;
  private float currSize;
  protected color col; // goody or baddie
  private int ID; // what's my name
  private float HP; //current HP
  int neighbourhood; // the other agents I'm close enough to interact with
  float minDistanceToNeighbourhood; // closest I am to other lads
  ArrayList<Treaty> activeTreaties; // what propositions have been made to me so far
  private PVector velocity; //destination used for smooth agent movement
  float pointsToInvest;
  float offence;
  float defence;
  float utility;
  protected float buyInProb; // how likely am I to not break treaties
  protected PVector motiveVector;
  int age;
  boolean showDialogueBox;
  boolean highlighted;
  HashMap<Agent, AgentProfile> agentProfiles; // map agent id to struct of utility choices and treaty choices

  Agent(int id, float x, float y, float size) {
    this.ID = id;
    this.pos = new PVector(x, y);
    this.type = AgentType.BASE;
    this.opposite = AgentType.BASE;
    this.baseSize = size;
    this.currSize = size;
    this.col = color(0, 0, 0);
    this.neighbourhood = -1;
    this.activeTreaties = new ArrayList<Treaty>();
    this.HP = 100;
    this.velocity = new PVector();
    this.offence = 5;
    this.defence = 5;
    this.utility = 0;
    this.pointsToInvest = 50;
    this.agentProfiles = new HashMap<Agent, AgentProfile>();
    this.age = 0;
    this.showDialogueBox = false;
    this.highlighted = false;
    this.buyInProb = config.startingBuyInProb;
    this.motiveVector = new PVector(0, 0, 0);
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

  PVector getPos() {
    return this.pos.copy();
  }

  PVector getVelocity() {
    return this.velocity.copy();
  }

  float getSize() {
    return this.currSize;
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

  void flock(ArrayList<Agent> allAgents) {
    ArrayList<Agent> boids = this.filterAgentsForFlocking(allAgents);
    this.velocity.add(this.calcFlock(boids)).mult(0.75);
    this.pos.add(this.velocity);
    this.agentConstrain();
  }

  void drawAgent(buttonReturn s) {

    switch (s) {
    case UTILITY:
      this.currSize = map(this.utility, 0, 500, this.baseSize/2, 60);
      break;
    case OFFENCE:
      this.currSize = map(this.offence, 0, 200, this.baseSize/2, 60);
      break;
    case DEFENCE:
      this.currSize = map(this.defence, 0, 200, this.baseSize/2, 60);
      break;
    default:
      this.currSize = this.baseSize;
    }


    if (this.showDialogueBox) {
      this.drawDialogueBox();
    }

    if (this.HP > 0) {
      fill(this.col);
    } else {
      fill(0);
    }

    if (this.highlighted) {
      stroke(0, 255, 0);
      strokeWeight(5);
    } else {
      stroke(0);
      strokeWeight(1);
    }

    ellipse(this.pos.x, this.pos.y, this.currSize, this.currSize);
    fill(0);
    textAlign(CENTER);
    text(this.ID, this.pos.x, this.pos.y+5);
    stroke(0); // reset drawing tools if highlighted
    strokeWeight(1);
  }

  void drawDialogueBox() {
    float rectW = 120;
    float rectH = 80;
    float topLeftX = this.pos.x - rectW/2 + 5;
    float topLeftY = this.pos.y - this.currSize / 2 - 1.3*rectH;

    // Draw outer text box //
    rectMode(CENTER);
    noFill();
    stroke(0);
    rect(this.pos.x, this.pos.y - this.currSize / 2 - rectH, rectW, rectH);

    // Draw text //
    fill(0);
    textAlign(CORNER);
    text("Type: " + this.type, topLeftX, topLeftY);
    text("Age: " + this.age, topLeftX, topLeftY+10);
    text("Attack: " + this.offence, topLeftX, topLeftY+20);
    text("Defence: " + this.defence, topLeftX, topLeftY+30);
    text("Utility: " + this.utility, topLeftX, topLeftY+40);
    text("Treaty Count: " + this.activeTreaties.size(), topLeftX, topLeftY+50);
    text("P(BuyIn): " + this.buyInProb, topLeftX, topLeftY+60);
  }

  // TREATY SESSION //

  ArrayList<Treaty> offerAllTreaties(ArrayList<Agent> nearbyAgents) {
    ArrayList<Treaty> allTreatyOffers = new ArrayList<Treaty>();
    for (Agent a : nearbyAgents) {
      if (this.willOfferTreaty(a)) {
        Treaty offer = this.generateTreaty(a);
        if (this.canOfferTreaty(offer)) {
          allTreatyOffers.add(offer);
        }
      }
    }
    return allTreatyOffers;
  }


  Treaty generateTreaty(Agent a) { // selectively generate treaty based on agent
    TreatyInfo t = globalTreatyCache[0];
    return new Treaty(this, a, t);
  }

  boolean willOfferTreaty(Agent a) { // check if treaty will be offered based on trust/behaviour etc
    return random(1) < 0.001 && a.getID() > 0;
  }

  TreatyResponse reviewTreaty(Treaty treaty) {
    TreatyResponse response = new TreatyResponse(treaty, true);
    if (random(1) < 0.5) {
      response = new TreatyResponse(treaty, false);
    }
    return response;
  }

  boolean isDuplicateTreaty(Treaty t1, Treaty t2) {
    return (this.findTreatyWith(t1) == this.findTreatyWith(t2)) && (t1.treatyInfo.treatyName == t2.treatyInfo.treatyName); // a treaty of (1,0,X) = (0,1,X)
  }


  boolean canOfferTreaty(Treaty t) {
    for (Treaty other : this.activeTreaties) {
      if (this.isDuplicateTreaty(t, other)) {
        return false;
      }
    }
    return true;
  }

  void initialiseAgentProfiles(ArrayList<Agent> allAgents) {
    for (Agent other : allAgents) {
      if (other != this) {
        this.agentProfiles.put(other, new AgentProfile());
      }
    }
  }

  void updateAgentProfile(Agent agent, float aggUpdate, float treatyUpdate, float hedUpdate) {
    AgentProfile profile = this.agentProfiles.get(agent);
    profile.aggression = constrain(profile.aggression + aggUpdate, -10, 10);
    profile.treatyScore = constrain(profile.treatyScore + treatyUpdate, -10, 10);
    profile.hedonism = constrain(profile.hedonism + hedUpdate, -10, 10);
  }

  void handleTreatyResponse(TreatyResponse tr) { // update profile based on treaty responses
    Agent responder = tr.proposal.treatyTo;
    if (tr.response) {
      this.updateAgentProfile(responder, 1, -1, 1);
    } else {
      this.updateAgentProfile(responder, -1, 0, 0);
    }
  }

  Agent findTreatyWith(Treaty tr) {
    if (tr.treatyTo != this) {
      return tr.treatyTo;
    }
    return tr.treatyFrom;
  }

  // ACTION SESSION //

  Agent chooseOpponent(ArrayList<Agent> nearbyAgents) {

    if (nearbyAgents.size() > 0) {
      int rand = int(random(nearbyAgents.size()));
      return nearbyAgents.get(rand);
    }
    return null;
  }

  ActionMessage decideAction(Agent opponent) {

    if (opponent != null) {

      float randAct = random(1);

      ActionType action = compileHawkDoveStrategyBorda(opponent);

      if (randAct < 0.25) {
        return this.stockpileUtility();
      } else if (randAct < 0.5) {
        return this.stockpileOffence();
      } else {
        switch(action) {
        case boostDefence:
          return this.stockpileDefence();
        case launchAttack:
          return this.declareAttack(opponent);
        default:
          return this.stockpileUtility();
        }
      }
    } else {
      return this.stockpileUtility();
    }
  }

  ActionMessage decideActionIfInvalid(ActionMessage action) {
    //println("agent " + this.getID() + " tried to perform " + action.type + " but failed. Boosting utility with P=" + this.buyInProb);
    if (random(1) < this.buyInProb) {
      return this.stockpileUtility();
    }
    return action; // don't trust the system - break the treaty anyway
  }

  boolean handleBrokenTreaty(Treaty t) { // update Agent profile and decide if cancelling treaty
    Agent breaker = this.findTreatyWith(t);
    boolean willCancelTreaty = false;

    this.updateAgentProfile(breaker, 3, -2, 0);

    if (random(1) > this.buyInProb) {
      willCancelTreaty = true;
      //println("agent " + this.ID + " ended " + t.treatyInfo.treatyName + " with agent " + breaker.getID());
    }

    this.buyInProb = max(this.buyInProb - 0.05, 0);
    return willCancelTreaty;
  }

  ActionMessage stockpileOffence() {
    float quantity = random(this.pointsToInvest);
    return new ActionMessage(this, ActionType.boostOffence, quantity);
  }

  ActionMessage stockpileDefence() {
    float quantity = random(this.pointsToInvest);
    return new ActionMessage(this, ActionType.boostDefence, quantity);
  }

  ActionMessage stockpileUtility() {
    float quantity = random(this.pointsToInvest);
    return new ActionMessage(this, ActionType.boostUtility, quantity);
  }

  ActionMessage declareAttack(Agent target) {
    float quantity = random(this.offence);
    return new AttackMessage(this, ActionType.launchAttack, quantity, target);
  }

  void receiveAttackNotif(AttackInfo atk) {
    float dmg = atk.damageDealt();
    //this.updateAgentProfile(atk.attacker, dmg/10.0, 0, -dmg/10.0);
    this.buyInProb = max(this.buyInProb - dmg/100.0, 0);
  }

  float applyNoisePred(float axis) {
    float vae = (1 - this.buyInProb) * 3;
    float mean = axis / 10.0;
    float x = randomGaussian();
    x *= vae;
    x += mean;
    return x;
  }

  AgentProfile whoAmI() {
    PVector dir = this.motiveVector.copy();
    float magScale = dir.mag();
    dir.setMag(magScale * ((this.buyInProb * 2.0) - 1.0));
    return new AgentProfile(this.applyNoisePred(dir.x), this.applyNoisePred(dir.y), this.applyNoisePred(dir.z));
  }

  boolean requestWhoAmI(Agent opponent) {

    if (opponent == null) {
      return false;
    }

    AgentProfile oppData = this.agentProfiles.get(opponent);
    float motiveToVal = abs(oppData.aggression) + abs(oppData.treatyScore) + abs(oppData.hedonism);

    //println(oppData.profileToMotive() == opponent.type);

    return motiveToVal < 15; // for 10x10x10 system, 5x5x5 is '50%' sure
  }

  void processWhoAmI(AgentProfile resp, Agent opponent) {
    this.updateAgentProfile(opponent, resp.aggression, resp.treatyScore, resp.hedonism);
  }


  // FLOCKING //

  ArrayList<Agent> filterAgentsForFlocking(ArrayList<Agent> allAgents) { // override to flock conditionally
    ArrayList<Agent> flockmates = new ArrayList<Agent>();
    for (Agent a : allAgents) {
      if (a != this) {
        AgentProfile p = this.agentProfiles.get(a);
        if ((!config.oppositesAttract && p.profileToMotive() == this.type)
          || (config.oppositesAttract && p.profileToMotive() == this.opposite)) {
          flockmates.add(a);
        }
      }
    }

    if (flockmates.size() > 0) {
      return flockmates;
    }
    return allAgents;
  }

  PVector calcFlockCohesion(ArrayList<Agent> boids) {
    PVector avgPos = new PVector();


    for (Agent boid : boids) {
      //if (boid != this) {
      avgPos.add(boid.pos);
      //}
    }

    avgPos.div(max(1, boids.size()));

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

  // TREATIES //

  //retrieve all treaty parameters when evaluating actions for treaties
  HashMap<TreatyVariable, Float> fetchTreatyVariableCache(ActionMessage action) {
    HashMap<TreatyVariable, Float> varCache = new HashMap<TreatyVariable, Float>();
    varCache.put(TreatyVariable.AGE, float(this.age));
    varCache.put(TreatyVariable.OFFENCE, this.offence);
    varCache.put(TreatyVariable.DEFENCE, this.defence);
    varCache.put(TreatyVariable.UTILITY, this.utility);
    varCache.put(TreatyVariable.NEIGHBOURHOOD, float(this.neighbourhood));
    switch (action.type) {
    case launchAttack:
      AttackMessage attack = (AttackMessage)action;
      varCache.put(TreatyVariable.ATTACK_LAUNCHED, 1.0);
      varCache.put(TreatyVariable.ATTACK_AGAINST, float(attack.target.ID));
      varCache.put(TreatyVariable.ATTACK_INVESTMENT, attack.quantity);
      break;
    case boostOffence:
      varCache.put(TreatyVariable.OFFENCE_INVESTMENT, action.quantity);
      break;
    case boostDefence:
      varCache.put(TreatyVariable.DEFENCE_INVESTMENT, action.quantity);
      break;
    case boostUtility:
      varCache.put(TreatyVariable.UTILITY_INVESTMENT, action.quantity);
      break;

    default:
    }
    return varCache;
  }

  ArrayList<Treaty> findRelevantTreaties(ActionType action) {
    ArrayList<Treaty> relevant = new ArrayList<Treaty>();
    for (Treaty contract : this.activeTreaties) {
      TreatyInfo T = contract.treatyInfo;
      for (ActionType a : T.treatyCategory) {
        if (a == action) {
          relevant.add(contract);
          break;
        }
      }
    }
    return relevant;
  }

  float[] fetchVarsFromCache(TreatyVariable[] reqVars, ActionMessage action) {
    float[] output = new float[reqVars.length+1];
    HashMap<TreatyVariable, Float> cache = fetchTreatyVariableCache(action);
    for (int i=0; i<reqVars.length; i++) {
      TreatyVariable v = reqVars[i];
      if (cache.containsKey(v)) {
        output[i] = cache.get(v);
      } else {
        output[i] = 0;
      }
    }
    output[reqVars.length] = 1;
    return output;
  }


  boolean evalMatrix(float[] L, float[] R, TreatyOpCode[] Aug) {  // multiply required variables with their weightings
    float sum = 0;
    try {
      if (R.length % L.length != 0) {
        throw new Exception("Treaty Matrix Dimensions Disagree");
      }
      for (int i=0; i<R.length; i++) {
        int j = i % L.length;
        sum += L[j] * R[i];
        if ((i+1) % L.length == 0 && i != 0) {
          int augInd = floor(i / L.length);
          if (!opToBool(sum, Aug[augInd])) {
            return false;
          } else {
            sum = 0;
          }
        }
      }
      return true;
    }
    catch(Exception e) {
      println(e);
      return false;
    }
  }

  boolean opToBool(float n, TreatyOpCode o) {
    switch(o) {
    case EQ:
      return n == 0;
    case NEQ:
      return n != 0;
    case LT:
      return n < 0;
    case GT:
      return n > 0;
    case LEQ:
      return n <= 0;
    default:
      return n >= 0;
    }
  }


  // STRATEGY

  ArrayList<Treaty> treatiesBroken(ActionMessage action) {
    ArrayList<Treaty> relevant = this.findRelevantTreaties(action.type);
    ArrayList<Treaty> affectedIfBroken = new ArrayList<Treaty>();
    for (Treaty t : relevant) {
      float[] mulMatL = this.fetchVarsFromCache(t.treatyInfo.reqVars, action);
      float[] mulMatR = t.treatyInfo.matReqVars;
      TreatyOpCode[] aug = t.treatyInfo.auxiliary;
      if (!evalMatrix(mulMatL, mulMatR, aug)) {
        affectedIfBroken.add(t);
      }
    }
    return affectedIfBroken;
  }

  boolean actionCompliesWithTreaties(ActionMessage action) {
    ArrayList<Treaty> affected = this.treatiesBroken(action);

    if (affected.size() == 0) {
      return true;
    }
    return false;
  }

  ActionType compileHawkDoveStrategyMixed(Agent opponent) {
    StrategyProfiler profilePlayer = new StrategyProfiler(this.type, opponent.utility, opponent.offence, this.defence);
    float atkProb = profilePlayer.mixedStrategyProb();

    if (random(1) < atkProb) {
      return ActionType.launchAttack;
    }
    return ActionType.boostDefence;
  }


  ActionType compileHawkDoveStrategyBorda(Agent opponent) {

    AgentProfile oppData = this.agentProfiles.get(opponent);

    StrategyProfiler profilePlayer = new StrategyProfiler(this.type, opponent.utility, opponent.offence, this.defence);
    StrategyProfiler profileOpponent = new StrategyProfiler(oppData.profileToMotive(), this.utility, this.offence, opponent.defence);

    int[] playerStrat = profilePlayer.scoresToPreferenceOrder();
    int[] opponentStrat = profileOpponent.scoresToPreferenceOrder();

    int idealQuadrant = this.aggregateStrats(playerStrat, opponentStrat);

    if (idealQuadrant < 2) { // ideal quadrant = 0 or 1, so attack
      return ActionType.launchAttack;
    }
    return ActionType.boostDefence;
  }

  int aggregateStrats(int[] p1Strat, int[] p2Strat) {
    // using Borda count
    int[] bordaVotes = new int[]{0, 0, 0, 0};

    for (int i=0; i<4; i++) {
      int votep1 = p1Strat[i];
      int votep2 = p2Strat[i];

      bordaVotes[votep1] += 4-i;
      bordaVotes[votep2] += 4-i;
    }

    int maxVote = max(bordaVotes);

    for (int i=0; i<4; i++) {
      if (bordaVotes[i] == maxVote) {
        return i;
      }
    }
    return 0;
  }
}
