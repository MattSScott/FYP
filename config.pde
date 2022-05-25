class Config {
  HashMap<AgentType, Integer> agents;
  int randomAgents;
  int agentSize;
  float investmentPerTurn;
  boolean seeInteractionsOnClick;
  float addAgentCooldown;
  boolean replaceUtilityOrDistuv;

  Config() {
    this.agents = new HashMap<AgentType, Integer>();
    agents.put(AgentType.NARCISSIST, 1);
    agents.put(AgentType.ALTRUIST, 1);
    agents.put(AgentType.COMPETITIVE, 1);
    agents.put(AgentType.AGGRESSIVE, 1);
    agents.put(AgentType.INDIVIDUAL, 1);
    agents.put(AgentType.MARTYR, 1);
    agents.put(AgentType.EQUITABLE, 1);
    agents.put(AgentType.COOPERATIVE, 1);
    this.randomAgents = 0;
    this.agentSize = 30;
    this.investmentPerTurn = 5;
    this.seeInteractionsOnClick = true;
    this.addAgentCooldown = 100;
    this.replaceUtilityOrDistuv = true;
  }
}
