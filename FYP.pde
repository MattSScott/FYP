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
  //frameRate(35);
  size(800, 800);
  server = new Server(20, 20);
  flockData = new FlockingData(1,12.5,30,100); //cohesion, alignment, separation, separation distance
}

void draw() {
  background(255);

  server.run();
}
