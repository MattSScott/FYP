enum agentType {
  ALTRUIST,
    NARCISSIST
}

Server server;

void setup() {
  frameRate(15);
  size(400, 400);  
  server = new Server(4, 40);
}

void draw() {
  background(255);
    
  server.run();
  
}
