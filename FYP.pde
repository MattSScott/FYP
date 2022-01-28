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

Config config;

Server server;

ToggleActionButton toggleActionButton;

ShowTreatiesButton toggleTreaties;

void setup() {
  frameRate(25);
  size(700, 700);
  config = new Config();
  server = new Server(config);
  flockData = new FlockingData(1,12.5,30,100); //cohesion, alignment, separation, separation distance
  toggleActionButton = new ToggleActionButton(new PVector(width-40, height-30));
  toggleTreaties = new ShowTreatiesButton(new PVector(width-40, height-80));
}

void draw() {
  background(255);
  
  toggleActionButton.show();
  
  toggleTreaties.show();
  
  server.run();
}

void mousePressed() {
  if(toggleActionButton.overButton()){
    toggleActionButton.count();
  }
  if(toggleTreaties.overButton()){
    toggleTreaties.count();
  }
}
