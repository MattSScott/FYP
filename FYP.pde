int n = 3;
//int aliveAgents = 3;
int agentSize = 40;
int neighbourhoods = 2;
String[] agentTypes = {"ALTRUIST", "NARCISSIST"};
Agent[] agents = new Agent[n];

void setup() {
  //frameRate(5);
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

  if(n > 1){
    genNeighbourhoods(agents, neighbourhoods);
    runTreatySession(agents);
  }


  for (Agent a : agents) {
    a.drawAgent();
    //a.moveRandom();
    a.moveCalculated();
    //a.fight?
    //a.setHP(max(0,a.getHP()-1));
    //print(a.getHP());
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
      drawLine(agents[agentFrom].pos, a.pos);
      text(t.treatyType, midpoint.x, midpoint.y);
    }
  }
}

void runTreatySession(Agent[] agents) {
  compileTreaties(agents);
  for (Agent a : agents) {
    a.reviewTreaties();
  }
  visualiseTreaties(agents);
}

void drawArrow(PVector from, PVector to) {
  fill(0);
  line(from.x, from.y, to.x, to.y);
  pushMatrix();
  translate(to.x, to.y);
  PVector dir = to.copy().sub(from);
  float heading = PVector.angleBetween(new PVector(0, 1), dir);
  if (heading > PI/2) {
    rotate(-heading);
  } else {
    rotate(heading);
  }
  triangle(-10, -agentSize, 0, 20-agentSize, 10, -agentSize);
  popMatrix();
}

void drawLine(PVector from, PVector to) {
  line(from.x, from.y, to.x, to.y);
}
