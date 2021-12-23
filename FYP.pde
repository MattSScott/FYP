int n = 3;
//int aliveAgents = 3;
int agentSize = 40;
int neighbourhoods = 2;
String[] agentTypes = {"ALTRUIST", "NARCISSIST"};
Agent[] agents = new Agent[n];

void setup() {
  frameRate(10);
  size(400, 400);
  for (int i=0; i<agents.length; i++) {
    int agentTypeIndex = int(random(agentTypes.length));
    String agentType = agentTypes[agentTypeIndex];
    Agent agent;
    switch(agentType) {
    case "ALTRUIST":
      agent = new Altruist(i, random(width), random(height), agentSize);
      break;
    case "NARCISSIST":
      agent = new Narcissist(i, random(width), random(height), agentSize);
      break;
    default:
      agent = new Agent(i, random(width), random(height), agentSize);
      break;
    }
    agents[i] = agent;
  }
}

void draw() {
  background(255);

  if (n > 1) {
    genNeighbourhoods(agents, neighbourhoods);
    runInteractionSession(agents);
  }


  for (Agent a : agents) {
    a.drawAgent();
    //a.moveRandom();
    a.moveCalculated();
    //a.fight?
    //a.setHP(max(0,a.getHP()-1));
    //print(a.getHP());
  }
  drawHealthBars(agents);
  //noLoop();
}

void printTreaties(Agent[] agents) {
  for (Agent a : agents) {
    ArrayList<TreatyProposal> setOfTreaties = a.activeTreaties;
    println("AGENT " + a.getID() + " TREATIES:");
    for (TreatyProposal t : setOfTreaties) {
      t.Print();
    }
  }
}

void visualiseTreaties(Agent[] agents) {
  for (Agent a : agents) {
    ArrayList<TreatyProposal> setOfTreaties = a.activeTreaties;
    for (TreatyProposal t : setOfTreaties) {
      Agent agentFrom = t.treatyFrom;
      if (a != agentFrom) { // AGENT 1 MAKES TREATY (0, 1, NICE), THEN VISUALISES 1,1. THIS AVOIDS THIS BUG
        PVector midpoint = new PVector(0.5*(a.pos.x + agentFrom.pos.x), 0.5*(a.pos.y + agentFrom.pos.y));
        drawLine(agentFrom.pos, a.pos);
        text(t.treatyType, midpoint.x, midpoint.y);
      }
    }
  }
}

void updateUtility(utilityDecisionMessage msg) {
  switch (msg.type) {
  case "boostDefence":
    println("agent " + msg.sender.getID() + " boosted defence from " + msg.sender.defence + " to " +  (msg.sender.defence + msg.quantity));
    msg.sender.defence += msg.quantity;
    break;
  case "boostOffence":
    println("agent " + msg.sender.getID() + " boosted attack from " + msg.sender.offence + " to " +  (msg.sender.offence + msg.quantity));
    msg.sender.offence += msg.quantity;
    break;
  default:
    println("agent " + msg.sender.getID() + " boosted personal utility from " + msg.sender.utility + " to " +  (msg.sender.utility + msg.quantity));
    msg.sender.utility += msg.quantity;
    break;
  }
  msg.sender.pointsToInvest -= msg.quantity;
}

void resolveAttack(AttackInfo atk) {
  float dmg = atk.damageDealt();
  float contrib = atk.resourcesContributed;
  atk.attacker.offence -= contrib;
  atk.target.defence = max(atk.target.defence - contrib, 0);
  println("agent " + atk.target.getID() + "'s health has dropped from " + atk.target.getHP() + " to " + max(0, (atk.target.getHP() - dmg)));
  atk.target.setHP(max(0, atk.target.getHP() - dmg));
  if (atk.target.getHP() == 0) {
    println("agent " + atk.target.getID() + " is dead");
  }
}


void processUtilityAction(Agent a1, Agent a2) {
  utilityDecisionMessage msg = a1.decideUtilityAction();
  if (msg.type != "attack") {
    updateUtility(msg);
  } else {
    AttackInfo atk = a1.compileAttack(a2, msg.quantity);
    resolveAttack(atk);
  }
}

void updateInvestmentPointsAndHP(Agent[] agents) {
  for (Agent a : agents) {
    //a.setHP(a.getHP() - 0.5);
    a.pointsToInvest += 10;
  }
}


void runInteractionSession(Agent[] agents) {
  for (Agent a1 : agents) {
    for (Agent a2 : agents) {
      if (agentsCanInteract(a1, a2)) {
        a1.offerTreaty(a2);
        processUtilityAction(a1, a2);
      }
    }
  }
  visualiseTreaties(agents);
  updateInvestmentPointsAndHP(agents);
  //printTreaties(agents);
  println();
}


void drawLine(PVector from, PVector to) {
  line(from.x, from.y, to.x, to.y);
}

void drawHealthBars(Agent[] agents){
  float hpBarWidth = 40;
  float hpBarHeight = 10;
  
  for (Agent a : agents){
    float hp = a.getHP();
    float barWidth = map(hp, 0, 100, 0, hpBarWidth);
    rectMode(CENTER);
    fill(255);
    rect(a.pos.x, a.pos.y - agentSize/2 - hpBarHeight, hpBarWidth, hpBarHeight);
    rectMode(CORNER);
    fill(0,0,255);
    rect(a.pos.x - hpBarWidth/2, a.pos.y - agentSize/2 - 1.5*hpBarHeight, barWidth, hpBarHeight);
  }
}

boolean agentsCanInteract(Agent a1, Agent a2) {
  return a1 != a2 && a1.neighbourhood == a2.neighbourhood && a1.getHP() > 0 && a2.getHP() > 0; //Possible TODO - make an "alive agents" array and splice to avoid iteration???
}
