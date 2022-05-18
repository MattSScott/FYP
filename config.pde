class Config {
  HashMap<AgentType, Integer> agents;
  int randomAgents;
  int agentSize;
  float investmentPerTurn;

  Config() {
    this.agents = new HashMap<AgentType, Integer>();
    agents.put(AgentType.NARCISSIST, 2);
    agents.put(AgentType.ALTRUIST, 4);
    this.randomAgents = 0;
    this.agentSize = 20;
    this.investmentPerTurn = 1;
  }
}
