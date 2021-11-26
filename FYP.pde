int n = 3;
//int aliveAgents = 3;
int agentSize = 40;
String[] agentTypes = {"ALTRUIST"};//, "NARCISSIST"};
Agent[] agents = new Agent[n];

void setup() {
  //noStroke();
  frameRate(5);
  size(400, 400);
  for (int i=0; i<agents.length; i++) {
    int agentTypeIndex = int(random(agentTypes.length));
    String agentType = agentTypes[agentTypeIndex];
    Agent agent;
    switch(agentType) {
    case "ALTRUIST":
      agent = new Altruist(i, random(0, width), random(0, height), agentSize);
      break;
    case "NARCISSIST":
      agent = new Narcissist(i, random(0, width), random(0, height), agentSize);
      break;
    default:
      agent = new Agent(i, random(0, width), random(0, height), agentSize);
      break;
    }
    agents[i] = agent;
  }
}

void draw() {
  background(255);

  for (Agent a : agents) {
    a.drawAgent();
    a.moveRandom();
  }
  
  runTreatySession(agents);
  
  //noLoop();
}

void compileTreaties(Agent[] agents){
  
  for(int i=0; i<agents.length; i++){
    ArrayList<TreatyProposal> setOfTreaties = agents[i].makeTreaties();
    for(TreatyProposal t : setOfTreaties){
      int to = t.treatyTo;
      agents[to].treaties.add(t);
    }
  }
  println();
}

void printTreaties(Agent[] agents){
  for(Agent a : agents){
    ArrayList<TreatyProposal> setOfTreaties = a.treaties;
    for(TreatyProposal t : setOfTreaties){
      println(t.treatyTo, t.treatyFrom, t.treatyType);
    }
  }
}

void visualiseTreaties(Agent[] agents){
   for(Agent a : agents){
    ArrayList<TreatyProposal> setOfTreaties = a.treaties;
    for(TreatyProposal t : setOfTreaties){
      int agentFrom = t.treatyFrom;
      PVector midpoint = new PVector(0.5*(a.pos.x + agents[agentFrom].pos.x), 0.5*(a.pos.y + agents[agentFrom].pos.y));
      line(agents[agentFrom].pos.x, agents[agentFrom].pos.y, a.pos.x, a.pos.y);
      text(t.treatyType, midpoint.x, midpoint.y);
    }
  }
}

void runTreatySession(Agent[] agents) {
  compileTreaties(agents);
  printTreaties(agents);
  visualiseTreaties(agents);
  println();
}
