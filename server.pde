class Server {
  private ArrayList<Agent> totalAgents;
  private ArrayList<Agent> aliveAgents;
  private int agentSize;
  private int numAliveAgents;
  private int agentCtr;
  Config config;

  Server(Config config) {
    this.config = config;
    this.agentSize = config.agentSize;
    this.totalAgents = new ArrayList<Agent>();
    this.aliveAgents = new ArrayList<Agent>();
    this.initialiseAgents();
    this.numAliveAgents = this.aliveAgents.size();
    this.agentCtr = 0;
  }


  ArrayList<Agent> getAliveAgents() {
    return this.aliveAgents;
  }

  void addAgent(AgentType motive) {
    Agent agent;
    switch(motive) {
    case ALTRUIST:
      agent = new Altruist(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    case NARCISSIST:
      agent = new Narcissist(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    default:
      agent = new Agent(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    }
    this.totalAgents.add(agent);
    this.aliveAgents.add(agent);
    this.agentCtr++;
    this.numAliveAgents++;
  }

  void initialiseAgents() {

    for (Map.Entry<AgentType, Integer> numMotive : this.config.agents.entrySet()) { // add fixed agent types
      AgentType motive = numMotive.getKey();
      int count = numMotive.getValue();
      for (int i=0; i<count; i++) {
        this.addAgent(motive);
      }
    }

    AgentType[] socialMotives = AgentType.values();
    for (int i=0; i<this.config.randomAgents; i++) { // then add random agents
      int socialMotiveIndex = int(random(socialMotives.length));
      AgentType motive = socialMotives[socialMotiveIndex];
      this.addAgent(motive);
    }
  }

  void filterDeadAgents() {
    for (int i=this.aliveAgents.size() - 1; i>=0; i--) {
      Agent curr = this.aliveAgents.get(i);
      if (curr.getHP() == 0) {
        this.aliveAgents.remove(i);
        println("agent " + curr.getID() + " is dead");
        this.numAliveAgents--;
      }
    }
  }

  void printTreaties() {
    for (Agent a : this.aliveAgents) {
      ArrayList<Treaty> setOfTreaties = a.activeTreaties;
      println("AGENT " + a.getID() + " TREATIES:");
      for (Treaty t : setOfTreaties) {
        t.Print();
      }
    }
  }

  void visualiseTreaties() {
    for (Agent a : this.aliveAgents) {
      ArrayList<Treaty> setOfTreaties = a.activeTreaties;
      for (Treaty t : setOfTreaties) {
        Agent agentFrom = t.treatyFrom;
        if (a != agentFrom) { // AGENT 1 MAKES TREATY (0, 1, NICE), THEN VISUALISES 1,1. THIS AVOIDS THIS BUG
          PVector midpoint = new PVector(0.5*(a.pos.x + agentFrom.pos.x), 0.5*(a.pos.y + agentFrom.pos.y));
          fill(0);
          this.drawLine(agentFrom.pos, a.pos);
          text(t.treatyInfo.treatyName, midpoint.x, midpoint.y);
        }
      }
    }
  }

  void updateUtility(ActionMessage msg) {
    switch (msg.type) {
    case boostDefence:
      println("agent " + msg.sender.getID() + " boosted defence from " + msg.sender.defence + " to " +  (msg.sender.defence + msg.quantity));
      msg.sender.defence += msg.quantity;
      break;
    case boostOffence:
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
    atk.target.receiveAttackNotif(atk);
    float dmg = atk.damageDealt();
    float contrib = atk.resourcesContributed;
    float newHP =  max(0, (atk.target.getHP() - dmg));
    atk.attacker.offence -= contrib;
    atk.target.defence = max(atk.target.defence - contrib, 0);
    println("agent " + atk.target.getID() + "'s health has dropped from " + atk.target.getHP() + " to " + newHP);
    atk.target.setHP(newHP);
  }


  void processAction(ActionMessage msg) {
    if (msg.type != ActionType.launchAttack) {
      this.updateUtility(msg);
    } else {
      AttackMessage atk = (AttackMessage)msg;
      AttackInfo attackHandler = new AttackInfo(atk.sender, atk.target, atk.quantity);
      this.resolveAttack(attackHandler);
    }
  }

  void runInteractionSession() {
    for (Agent a : this.aliveAgents) {
      if (a.getHP() > 0) { // ensure that agents who die in this turn can't attack before they get removed in the next turn
        ArrayList<Agent> nearby = this.getNearbyAgents(a);
        this.runTreatySession(a, nearby);
        this.runActionSession(a, nearby);
        //a.pointsToInvest += 10;
      }
    }
    if (toggleTreaties.getText() == "on") {
      this.visualiseTreaties();
    }
  }

  ArrayList<Agent> getNearbyAgents(Agent a) {
    ArrayList<Agent> allowed = new ArrayList<Agent>();
    for (Agent other : this.aliveAgents) {
      if (agentsCanInteract(a, other)) {
        allowed.add(other);
      }
    }
    return allowed;
  }

  void runTreatySession(Agent a, ArrayList<Agent> nearbyAgents) {
    ArrayList<Treaty> proposals = a.offerAllTreaties(nearbyAgents); // receive list of treaty offers for each agent
    for (Treaty proposal : proposals) {
      Agent receiver = proposal.treatyTo;
      TreatyResponse newTreatyResponse = receiver.reviewTreaty(proposal); // make subject of treaty review it
      a.handleTreatyResponse(newTreatyResponse); // update agent image
      if (newTreatyResponse.response) {
        a.activeTreaties.add(proposal);
        receiver.activeTreaties.add(proposal);
      }
    }
  }

  void filterExpiredTreaties() {
    for (Agent a : this.aliveAgents) {
      for (int i=a.activeTreaties.size() - 1; i>=0; i--) {
        Treaty t = a.activeTreaties.get(i);
        if (t.treatyFrom.getHP() == 0 || t.treatyTo.getHP() == 0) {
          a.activeTreaties.remove(i);
        }
      }
    }
  }

  void runActionSession(Agent a, ArrayList<Agent> nearbyAgents) {
    ActionMessage action = a.decideAction(nearbyAgents);
    this.processAction(action);
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
    return a1 != a2 && a1.neighbourhood == a2.neighbourhood;
  }

  void showAgents() {
    for (Agent a : this.aliveAgents) {
      a.drawAgent(toggleActionButton.text);
      //a.moveRandom();
      //a.moveCalculated();
      a.flock(this.aliveAgents);
      //println(a.activeTreaties);
    }
    this.drawHealthBars();
  }
  
  void handleEndOfTurn() {
    this.filterDeadAgents();
    this.filterExpiredTreaties();
    for (Agent a : this.aliveAgents){
      a.pointsToInvest += 10;
      a.age++;
    }
  }

  void run() {
    if (this.numAliveAgents > 1) {
      genNeighbourhoods(this.aliveAgents, this.numAliveAgents / 2); // have num clusters = floor(1/2 total agents)
      this.runInteractionSession();
    }

    //this.filterDeadAgents();
    //this.filterExpiredTreaties();
    this.showAgents();

    if (frameCount % 100 == 0) {
      this.addAgent(AgentType.NARCISSIST);
    }

    if (this.numAliveAgents == 1) {
      println("Agent " + this.aliveAgents.get(0).getID() + " is victorious!");
      println();
      println("SIMULATION END");
      println();
    } else {
      this.handleEndOfTurn();
      println();
      println("NEW TURN");
      println();
    }
  }
}
