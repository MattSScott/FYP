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
  boolean allowTreaties;

  Config() {
    this.agents = new HashMap<AgentType, Integer>();
    agents.put(AgentType.NARCISSIST, 10);
    agents.put(AgentType.ALTRUIST, 10);
    agents.put(AgentType.COMPETITIVE, 10);
    agents.put(AgentType.AGGRESSIVE, 10);
    agents.put(AgentType.INDIVIDUAL, 10);
    agents.put(AgentType.MARTYR, 10);
    agents.put(AgentType.EQUITABLE, 10);
    agents.put(AgentType.COOPERATIVE, 10);
    agents.put(AgentType.BASE, 0);
    this.randomAgents = 0;
    this.agentSize = 30;
    this.investmentPerTurn = 5;
    this.seeInteractionsOnClick = true;
    this.addAgentCooldown = 50;
    this.replaceUtilityOrDistuv = true;
    this.startingBuyInProb = 1.0;
    this.oppositesAttract = false;
    this.maxTurns = 150;
    this.allowTreaties = true;
  }
}
