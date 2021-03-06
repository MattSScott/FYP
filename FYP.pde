import java.util.Map;

enum AgentType {
  BASE,
    ALTRUIST,
    NARCISSIST,
    COMPETITIVE,
    AGGRESSIVE,
    INDIVIDUAL,
    MARTYR,
    EQUITABLE,
    COOPERATIVE
}


enum ActionType {
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

PlayPause playPause;

Logger logger;

void setup() {
  frameRate(30);
  size(900, 750);
  config = new Config();
  server = new Server(config);
  flockData = new FlockingData(1, 12.5, 30, 100); //cohesion, alignment, separation, separation distance
  toggleActionButton = new ToggleActionButton(new PVector(width-40, height-30));
  toggleTreaties = new ShowTreatiesButton(new PVector(width-40, height-80));
  playPause = new PlayPause(new PVector(80, height-80));
  logger = new Logger();
}

void draw() {
  background(240);

  toggleActionButton.show();

  toggleTreaties.show();

  playPause.show();

  server.run();
}

void mousePressed() {
  if (toggleActionButton.overButton()) {
    toggleActionButton.count();
  }
  if (toggleTreaties.overButton()) {
    toggleTreaties.count();
  }

  if (playPause.overButton()) {
    playPause.toggle();
  }
  server.toggleAgentDialogue();
  
  for(TreatyButton button : server.treatyButtons) {
    if(button.overButton()){
      button.toggle();
    }
  }
}
