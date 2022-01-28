import java.util.Map;

enum agentType {
  ALTRUIST,
    NARCISSIST
}


enum actionType {
  boostOffence,
    boostDefence,
    boostUtility,
    launchAttack
}

FlockingData flockData;

Server server;

void setup() {
  frameRate(15);
  size(700, 700);
  server = new Server(4, 20);
  flockData = new FlockingData(1,12.5,30,100); //cohesion, alignment, separation, separation distance
}

void draw() {
  background(255);
  
  server.run();
}
