class Config {
  HashMap<AgentType, Integer> agents;
  int randomAgents;
  int agentSize;
  float investmentPerTurn;
  boolean seeInteractionsOnClick;
  float addAgentCooldown;
  boolean replaceUtilityOrDistuv;
  float startingBuyInProb;
  boolean oppositesAttract;

  Config() {
    this.agents = new HashMap<AgentType, Integer>();
    agents.put(AgentType.NARCISSIST, 5);
    agents.put(AgentType.ALTRUIST, 5);
    agents.put(AgentType.COMPETITIVE, 5);
    agents.put(AgentType.AGGRESSIVE, 5);
    agents.put(AgentType.INDIVIDUAL, 5);
    agents.put(AgentType.MARTYR, 5);
    agents.put(AgentType.EQUITABLE, 5);
    agents.put(AgentType.COOPERATIVE, 5);
    this.randomAgents = 0;
    this.agentSize = 30;
    this.investmentPerTurn = 5;
    this.seeInteractionsOnClick = true;
    this.addAgentCooldown = 100;
    this.replaceUtilityOrDistuv = true;
    this.startingBuyInProb = 0.25;
    this.oppositesAttract = false;
  }
}
