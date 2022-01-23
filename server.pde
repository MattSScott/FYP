class Server {
  private ArrayList<Agent> totalAgents;
  private ArrayList<Agent> aliveAgents;
  private int agentSize;
  private int numInitialAgents;
  private int numAliveAgents;


  Server(int numInit, int size) {
    this.numInitialAgents = numInit;
    this.numAliveAgents = numInit;
    this.agentSize = size;
    this.totalAgents = new ArrayList<Agent>();
    this.initialiseAgents();
    this.aliveAgents = new ArrayList<Agent>(totalAgents);
  }

  void initialiseAgents() {
    agentType[] socialMotives = agentType.values();
    for (int i=0; i<this.numInitialAgents; i++) {
      int socialMotiveIndex = int(random(socialMotives.length));
      agentType motive = socialMotives[socialMotiveIndex];
      Agent agent;
      switch(motive) {
      case ALTRUIST:
        agent = new Altruist(i, random(width), random(height), agentSize);
        break;
      case NARCISSIST:
        agent = new Narcissist(i, random(width), random(height), agentSize);
        break;
      default:
        agent = new Agent(i, random(width), random(height), agentSize);
        break;
      }
      this.totalAgents.add(agent);
    }
  }

  void filterDeadAgents() {
    for (int i=0; i<this.aliveAgents.size(); i++) {
      if (this.aliveAgents.get(i).getHP() == 0) {
        this.aliveAgents.remove(i);
        this.numAliveAgents--;
      }
    }
  }

  void printTreaties() {
    for (Agent a : this.aliveAgents) {
      ArrayList<TreatyProposal> setOfTreaties = a.activeTreaties;
      println("AGENT " + a.getID() + " TREATIES:");
      for (TreatyProposal t : setOfTreaties) {
        t.Print();
      }
    }
  }

  void visualiseTreaties() {
    for (Agent a : this.aliveAgents) {
      ArrayList<TreatyProposal> setOfTreaties = a.activeTreaties;
      for (TreatyProposal t : setOfTreaties) {
        Agent agentFrom = t.treatyFrom;
        if (a != agentFrom) { // AGENT 1 MAKES TREATY (0, 1, NICE), THEN VISUALISES 1,1. THIS AVOIDS THIS BUG
          PVector midpoint = new PVector(0.5*(a.pos.x + agentFrom.pos.x), 0.5*(a.pos.y + agentFrom.pos.y));
          this.drawLine(agentFrom.pos, a.pos);
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

  void updateInvestmentPointsAndHP() {
    for (Agent a : this.aliveAgents) {
      if (a.getHP() == 0) {
        println("agent " + a.getID() + " is dead");
      }
      a.pointsToInvest += 10;
    }
    this.filterDeadAgents(); // buggy
    //println(agents);
  }


  void runInteractionSession() {
    for (Agent a1 : this.aliveAgents) {
      for (Agent a2 : this.aliveAgents) {
        if (agentsCanInteract(a1, a2)) {
          a1.offerTreaty(a2);
          this.processUtilityAction(a1, a2);
        }
      }
    }
    this.visualiseTreaties();
    this.updateInvestmentPointsAndHP();
    //printTreaties(agents);
    println();
  }


  void drawLine(PVector from, PVector to) {
    line(from.x, from.y, to.x, to.y);
  }

  void drawHealthBars() {
    float hpBarWidth = 40;
    float hpBarHeight = 10;

    for (Agent a : this.aliveAgents) {
      float hp = a.getHP();
      float barWidth = map(hp, 0, 100, 0, hpBarWidth);
      rectMode(CENTER);
      fill(255);
      rect(a.pos.x, a.pos.y - agentSize/2 - hpBarHeight, hpBarWidth, hpBarHeight);
      rectMode(CORNER);
      fill(0, 0, 255);
      rect(a.pos.x - hpBarWidth/2, a.pos.y - agentSize/2 - 1.5*hpBarHeight, barWidth, hpBarHeight);
    }
  }

  boolean agentsCanInteract(Agent a1, Agent a2) {
    return a1 != a2 && a1.neighbourhood == a2.neighbourhood;// && a1.getHP() > 0 && a2.getHP() > 0; //Possible TODO - make an "alive agents" array and splice to avoid iteration???
  }
  
  void run() {
    if (this.numAliveAgents > 1) {
    genNeighbourhoods(this.aliveAgents, this.numAliveAgents / 2); // have num clusters = floor(1/2 total agents) 
    this.runInteractionSession();
  }


  for (Agent a : this.aliveAgents) {
    a.drawAgent();
    //a.moveRandom();
    a.moveCalculated();
  }
  this.drawHealthBars();
  //noLoop();
  }
}
