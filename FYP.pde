int n = 3;
//int aliveAgents = 3;
int agentSize = 40;
int neighbourhoods = 2;
String[] agentTypes = {"ALTRUIST", "NARCISSIST"};
Agent[] agents = new Agent[n];

void setup() {
  frameRate(1);
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

  for (Agent a : agents) {
  }

  genNeighbourhoods(agents, neighbourhoods);
  runTreatySession(agents);


  for (Agent a : agents) {
    a.drawAgent();
    a.moveRandom();
  }

  //noLoop();
}

void compileTreaties(Agent[] agents) { // take all proposals and give to agents

  for (int i=0; i<agents.length; i++) {
    ArrayList<TreatyProposal> setOfTreaties = agents[i].makeTreaties();
    for (TreatyProposal t : setOfTreaties) {
      int to = t.treatyTo;
      agents[to].treaties.add(t);
    }
  }
  println();
}

void printTreaties(Agent[] agents) {
  for (Agent a : agents) {
    ArrayList<TreatyProposal> setOfTreaties = a.treaties;
    for (TreatyProposal t : setOfTreaties) {
      t.Print();
    }
  }
}

void visualiseTreaties(Agent[] agents) {
  for (Agent a : agents) {
    ArrayList<TreatyProposal> setOfTreaties = a.treaties;
    for (TreatyProposal t : setOfTreaties) {
      int agentFrom = t.treatyFrom;
      PVector midpoint = new PVector(0.5*(a.pos.x + agents[agentFrom].pos.x), 0.5*(a.pos.y + agents[agentFrom].pos.y));
      line(agents[agentFrom].pos.x, agents[agentFrom].pos.y, a.pos.x, a.pos.y);
      text(t.treatyType, midpoint.x, midpoint.y);
    }
  }
}

void runTreatySession(Agent[] agents) {
  compileTreaties(agents);
  //printTreaties(agents);
  visualiseTreaties(agents);
  //println();
}
