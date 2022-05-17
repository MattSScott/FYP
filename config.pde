class Config {
  HashMap<AgentType, Integer> agents;
  int randomAgents;
  int agentSize;
  float investmentPerTurn;

  Config() {
    this.agents = new HashMap<AgentType, Integer>();
    agents.put(AgentType.NARCISSIST, 1);
    agents.put(AgentType.ALTRUIST, 6);
    this.randomAgents = 0;
    this.agentSize = 20;
    this.investmentPerTurn = 5;
  }
}
