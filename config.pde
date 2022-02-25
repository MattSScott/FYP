class Config {
  HashMap<AgentType, Integer> agents;
  int randomAgents;
  int agentSize;
  
  Config() {
    this.agents = new HashMap<AgentType, Integer>();
    agents.put(AgentType.NARCISSIST, 0);
    agents.put(AgentType.ALTRUIST, 2);
    this.randomAgents = 0;
    this.agentSize = 20;
  }
}
