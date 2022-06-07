class Server {
  private ArrayList<Agent> totalAgents;
  private ArrayList<Agent> aliveAgents;
  private int agentSize;
  private int numAliveAgents;
  private int agentCtr;
  private boolean showActiveNeighbourhoods;
  private Agent activeAgent;
  private int currTurn;
  ArrayList<TreatyButton> treatyButtons;
  Config config;

  Server(Config config) {
    this.config = config;
    this.agentCtr = 0;
    this.agentSize = config.agentSize;
    this.totalAgents = new ArrayList<Agent>();
    this.aliveAgents = new ArrayList<Agent>();
    this.initialiseAgents();
    this.numAliveAgents = this.aliveAgents.size();
    this.showActiveNeighbourhoods = false;
    this.activeAgent = null;
    this.initialiseAllAgentProfiles(this.aliveAgents);
    this.currTurn = 0;
    this.treatyButtons = this.createAllButtons();
  }


  ArrayList<Agent> getAliveAgents() {
    return this.aliveAgents;
  }

  Agent addAgent(AgentType motive) {
    Agent agent;
    switch(motive) {
    case ALTRUIST:
      agent = new Altruist(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    case COMPETITIVE:
      agent = new Competitive(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    case AGGRESSIVE:
      agent = new Aggressive(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    case INDIVIDUAL:
      agent = new Individual(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    case MARTYR:
      agent = new Martyr(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    case EQUITABLE:
      agent = new Equitable(this.agentCtr+1, random(width), random(height), this.agentSize);
      break;
    case COOPERATIVE:
      agent = new Cooperative(this.agentCtr+1, random(width), random(height), this.agentSize);
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
    return agent;
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

  void initialiseAllAgentProfiles(ArrayList<Agent> newAgents) {
    for (Agent a : this.aliveAgents) {
      a.initialiseAgentProfiles(newAgents);
    }
  }

  ArrayList<TreatyButton> createAllButtons() {
    ArrayList<TreatyButton> buttons = new ArrayList<TreatyButton>();
    for (int i=0; i<this.aliveAgents.size(); i++) {
      for (int j=i+1; j<this.aliveAgents.size(); j++) {
        Agent a1 = this.aliveAgents.get(i);
        Agent a2 = this.aliveAgents.get(j);
        buttons.add(new TreatyButton(a1, a2));
      }
    }
    return buttons;
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
    for (TreatyButton button : this.treatyButtons) {
      button.show();
    }
  }

  void updateUtility(ActionMessage msg) {

    JSONData data;

    switch (msg.type) {
    case boostDefence:
      //println("agent " + msg.sender.getID() + " boosted defence from " + msg.sender.defence + " to " +  (msg.sender.defence + msg.quantity));
      data = new JSONData(
        new String[] { "type", "action", "before", "after" },
        new String[] { msg.sender.type.name(), "boostDefence", str(msg.sender.defence), str(msg.sender.defence + msg.quantity) }
        );
      msg.sender.defence += msg.quantity;
      break;
    case boostOffence:
      //println("agent " + msg.sender.getID() + " boosted attack from " + msg.sender.offence + " to " +  (msg.sender.offence + msg.quantity));
      data = new JSONData(
        new String[] { "type", "action", "before", "after" },
        new String[] { msg.sender.type.name(), "boostOffence", str(msg.sender.offence), str(msg.sender.offence + msg.quantity) }
        );
      msg.sender.offence += msg.quantity;
      break;
    default:
      //println("agent " + msg.sender.getID() + " boosted personal utility from " + msg.sender.utility + " to " +  (msg.sender.utility + msg.quantity));
      data = new JSONData(
        new String[] { "type", "action", "before", "after" },
        new String[] { msg.sender.type.name(), "boostUtility", str(msg.sender.utility), str(msg.sender.utility + msg.quantity) }
        );
      msg.sender.utility += msg.quantity;
      break;
    }
    msg.sender.pointsToInvest -= msg.quantity;

    //logger.Print("Agent " + msg.sender.getID(), data.formJSON());
    logger.Print("action", data.formJSON());
  }


  void resolveAttack(AttackInfo atk) {
    atk.target.receiveAttackNotif(atk);
    float dmg = atk.damageDealt();
    float contrib = atk.resourcesContributed;
    float newHP =  max(0, (atk.target.getHP() - dmg));
    atk.attacker.offence -= contrib;
    atk.target.defence = max(atk.target.defence - contrib, 0);
    //println("agent " + atk.target.getID() + "'s health has dropped from " + atk.target.getHP() + " to " + newHP);
    atk.target.setHP(newHP);
    if (newHP == 0) {
      //logger.newEnv("kill");
      ////println("==== KILL ====");
      ////println("agent " + atk.attacker.getID() + " killed agent " + atk.target.getID() + "! Stealing utility = " + atk.target.utility);
      ////println("==== KILL ====");
      //JSONData data = new JSONData(
      //  new String[] { "type", "deceased", "utility stolen"},
      //  new String[] { atk.attacker.type.name(), str(atk.target.getID()), str(atk.target.utility) }
      //  );
      //logger.Print(atk.attacker.getID(), data.formJSON());
      //logger.closeEnv();
      JSONData dataKill = new JSONData(
        new String[] { "attacker", "target", "utility_gained" },
        new String[] { "Agent " + str(atk.attacker.getID()), "Agent " + str(atk.target.getID()), str(atk.target.utility) }
        );
      logger.Print("KILL", dataKill.formJSON());
      atk.attacker.utility += atk.target.utility;
    }
    JSONData data = new JSONData(
      new String[] { "type", "action", "target", "damage"},
      new String[] { atk.attacker.type.name(), "launchAttack", "Agent " + str(atk.target.getID()), str(dmg)}
      );
    //logger.Print("Agent " + atk.attacker.getID(), data.formJSON());
    logger.Print("action", data.formJSON());
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
        logger.newEnv("Agent " + str(a.getID()));
        ArrayList<Agent> nearby = this.getNearbyAgents(a);
        if (this.config.allowTreaties) {
          this.runTreatySession(a, nearby);
        }
        this.runActionSession(a, nearby);
        this.logAgentStatus(a);
        logger.closeEnv();
      }
    }
  }

  void logAgentStatus(Agent a) {
    String[] stats = new String[]{ "utility", "defence", "offence", "buy_in_prob", "pts_to_invest" };
    String[] vals = new String[]{ str(a.utility), str(a.defence), str(a.offence), str(a.buyInProb), str(a.pointsToInvest) };

    JSONData status = new JSONData(stats, vals);

    logger.Print("status", status.formJSON());
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
    JSONArray propList = new JSONArray();
    int totalProposals = 0;
    for (Treaty proposal : proposals) {
      Agent receiver = proposal.treatyTo;
      TreatyResponse newTreatyResponse = receiver.reviewTreaty(proposal); // make subject of treaty review it
      String[] fields = new String[]{"receiver", "response", "type"};
      String[] vals = new String[]{"Agent " + str(receiver.getID()), "no", proposal.treatyInfo.treatyName};
      a.handleTreatyResponse(newTreatyResponse); // update agent image
      if (newTreatyResponse.response) {
        a.activeTreaties.add(proposal);
        receiver.activeTreaties.add(proposal);
        vals[1] = "yes";
      }
      JSONData tty = new JSONData(fields, vals);
      String data = tty.formJSON();
      propList.setJSONObject(totalProposals, parseJSONObject(data));
      totalProposals++;
    }
    logger.PrintArray("proposals", propList);
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
    Agent opponent = a.chooseOpponent(nearbyAgents);
    ActionMessage action = a.decideAction(opponent);
    boolean requestIdentity = a.requestWhoAmI(opponent);

    if (requestIdentity) {
      a.processWhoAmI(opponent.whoAmI(), opponent);
    }

    //if(opponent != null) {
    //  a.stateInteracted(opponent);
    //}

    ArrayList<Treaty> treatiesAffected = a.treatiesBroken(action);

    if (treatiesAffected.size() != 0) {
      action = a.decideActionIfInvalid(action);
      if (action.type != ActionType.boostUtility) { // treaties broken -> utility necessary
        this.broadcastTreatyBreak(treatiesAffected, a);
      }
    }

    this.processAction(action);
  }

  void broadcastTreatyBreak(ArrayList<Treaty> treaties, Agent breaker) {
    for (Treaty t : treaties) {
      Agent affected = breaker.findTreatyWith(t);
      boolean result = affected.handleBrokenTreaty(t);
      if (result) {
        breaker.activeTreaties.remove(t);
        affected.activeTreaties.remove(t);
        JSONData data = new JSONData(
          new String[] { "type", "proposer", "accepter"},
          new String[] { t.treatyInfo.treatyName, "Agent " + str(t.treatyFrom.getID()), "Agent " + str(t.treatyTo.getID())}
          );
        logger.Print("TREATY BREAK", data.formJSON());
      }
    }
  }


  void drawLine(PVector from, PVector to) {
    line(from.x, from.y, to.x, to.y);
  }

  void drawHealthBars() {
    float hpBarWidth = 40;
    float hpBarHeight = 10;
    stroke(0);

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

  void showAgents(boolean playing) {
    for (Agent a : this.aliveAgents) {
      a.drawAgent(toggleActionButton.getText());
      this.highlightAgent(a);

      if (playing) {
        a.flock(this.aliveAgents);
      }
    }

    this.drawHealthBars();
  }

  void highlightAgent(Agent a) {
    if (a.getHP() > 0 && this.showActiveNeighbourhoods && a.neighbourhood == this.activeAgent.neighbourhood) {
      a.highlighted = true;
    } else {
      a.highlighted = false;
    }
  }

  void toggleAgentDialogue() {
    for (Agent a : this.aliveAgents) {
      if (dist(mouseX, mouseY, a.pos.x, a.pos.y) <= a.getSize()/2) {
        a.showDialogueBox = !a.showDialogueBox;
        if (config.seeInteractionsOnClick == true && a.showDialogueBox) {
          this.showActiveNeighbourhoods = true;
          this.activeAgent = a;
        } else {
          this.showActiveNeighbourhoods = false;
        }
      }
    }
  }

  void handleEndOfTurn() {
    this.filterDeadAgents();
    this.filterExpiredTreaties();
    for (Agent a : this.aliveAgents) {
      a.pointsToInvest += config.investmentPerTurn;
      a.age++;
    }
    this.currTurn++;
    logger.endTurn();
  }

  AgentType geneticReplacement() {
    // Input data into map
    HashMap<AgentType, Float> agentTally = new HashMap<AgentType, Float>();
    for (Agent a : this.aliveAgents) {
      float input = config.replaceUtilityOrDistuv ? a.utility : 1.0;
      if (agentTally.get(a.type) == null) {
        agentTally.put(a.type, input);
      } else {
        float curr = agentTally.get(a.type);
        agentTally.put(a.type, curr + input);
      }
    }
    // normalise map to reflect P(replacement)
    float runningTotal = 0;
    for (float v : agentTally.values()) {
      runningTotal += v;
    }

    float prob = random(1);
    float cumProb = 0;

    for (AgentType a : agentTally.keySet()) {
      float valRaw = agentTally.get(a);
      float valNorm = valRaw / runningTotal;
      cumProb += valNorm;
      if (prob < cumProb) {
        return a;
      }
    }

    return AgentType.NARCISSIST; // default return
  }

  void processNewAgent() {
    Agent added = this.addAgent(this.geneticReplacement());
    added.initialiseAgentProfiles(this.aliveAgents); // build up profile of all other agents
    ArrayList<Agent> addedList = new ArrayList<Agent>();
    addedList.add(added);
    this.initialiseAllAgentProfiles(addedList); // have all agents build profile of it
    JSONData newAg = new JSONData( new String[]{"type"}, new String[]{added.type.name()});
    logger.Print("NEW AGENT", newAg.formJSON());
  }


  float classificationError() {

    float wrongGuesses = 0;
    float totalGuesses = 0;

    for (Agent a1 : this.aliveAgents) {
      for (Agent a2 : this.aliveAgents) {
        if (a1 != a2) {
          AgentProfile prof = a1.agentProfiles.get(a2);
          if (!prof.hasInteracted()) {
            break;
          }
          AgentType guess = prof.profileToMotive();
          AgentType real = a2.type;
          if (guess != real) {
            wrongGuesses++;
          }
          totalGuesses++;
        }
      }
    }

    return totalGuesses > 0 ? wrongGuesses / totalGuesses : 0;
  }


  void run() {

    if (toggleTreaties.getText() == buttonReturn.ON) {
      this.visualiseTreaties();
    }

    this.showAgents(playPause.isPlaying());

    text("Classification Error: " + classificationError() * 100 + '%', width-100, 50);

    if (playPause.isPlaying()) {

      logger.startTurn();

      if (this.numAliveAgents > 1) {
        genNeighbourhoods(this.aliveAgents, this.numAliveAgents / 2); // have num clusters = floor(1/2 total agents)
        this.runInteractionSession();
      }


      if (frameCount % config.addAgentCooldown == 0) {
        this.processNewAgent();
      }

      if (this.currTurn == config.maxTurns) {
        println();
        println("SIMULATION END");
        println();
        logger.endSim();
        noLoop();
      } else if (this.numAliveAgents == 1) {
        println("agent " + this.aliveAgents.get(0).getID() + " is victorious!");
        println();
        println("SIMULATION END");
        println();
        logger.endSim();
        noLoop();
      } else {
        this.handleEndOfTurn();
        println();
        println("TURN " + this.currTurn);
        println();
      }
    }
  }
}
