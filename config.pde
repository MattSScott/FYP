class Config {
  HashMap<agentType, Integer> agents;
  int randomAgents;
  int agentSize;
  
  Config() {
    this.agents = new HashMap<agentType, Integer>();
    agents.put(agentType.NARCISSIST, 3);
    agents.put(agentType.ALTRUIST, 0);
    this.randomAgents = 2;
    this.agentSize = 20;
  }
}