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
  int maxTurns;

  Config() {
    this.agents = new HashMap<AgentType, Integer>();
    agents.put(AgentType.NARCISSIST, 8);
    agents.put(AgentType.ALTRUIST, 8);
    agents.put(AgentType.COMPETITIVE, 8);
    agents.put(AgentType.AGGRESSIVE, 8);
    agents.put(AgentType.INDIVIDUAL, 8);
    agents.put(AgentType.MARTYR, 8);
    agents.put(AgentType.EQUITABLE, 8);
    agents.put(AgentType.COOPERATIVE, 8);
    agents.put(AgentType.BASE, 0);
    this.randomAgents = 0;
    this.agentSize = 30;
    this.investmentPerTurn = 5;
    this.seeInteractionsOnClick = true;
    this.addAgentCooldown = 50;
    this.replaceUtilityOrDistuv = true;
    this.startingBuyInProb = 0.8;
    this.oppositesAttract = false;
    this.maxTurns = 100;
  }
}
