class StrategyProfiler {
  AgentType type;
  float value;
  float cost;
  float[][] payoffs;

  StrategyProfiler(AgentType type, float util, float off, float def) {
    this.type = type;
    this.value = util;
    this.cost = max(0, off - def);
    this.payoffs = this.payoffMatGen();
  }

  float[][] payoffMatGen() {
    float mutualAgg = 0.5 * (this.value - this.cost);
    float mutualDef = 0.5 * this.value;

    return new float[][]{ {mutualAgg, -mutualAgg}, {this.value, 0}, {0, this.value}, {mutualDef, mutualDef} };
  }

  int[] scoresToPreferenceOrder(float[] scores, boolean maximise) {
    float[][] augScores = new float[4][2];

    for (int i=0; i<4; i++) {
      augScores[i] = new float[]{scores[i], i}; // retain index/quadrant
    }

    for (int i = 0; i < 3; i++) { // easy bubble sort to preserve index
      for (int j = 0; j < 3 - i; j++) {
        if (augScores[j][0] > augScores[j+1][0]) {
          float[] tmp = augScores[j];
          augScores[j] = augScores[j+1];
          augScores[j+1] = tmp;
        }
      }
    }

    int[] prefOrder = new int[4];

    for (int i=0; i<4; i++) {
      prefOrder[i] = int(augScores[i][1]);
    }

    if (maximise) {
      return reverse(prefOrder);
    }
    return prefOrder;
  }


  int[] genStrategy() {
    float[] reformedPayoff = new float[4];

    switch(this.type) {
    case ALTRUIST : // maximise opp. payoff
      for (int i=0; i<4; i++) {
        reformedPayoff[i] = this.payoffs[i][1];
      }
      return this.scoresToPreferenceOrder(reformedPayoff, true);

    case AGGRESSIVE : // minimise opp. payoff
      for (int i=0; i<4; i++) {
        reformedPayoff[i] = this.payoffs[i][1];
      }
      return this.scoresToPreferenceOrder(reformedPayoff, false);

    case COMPETITIVE : // maximise payoff diff
      for (int i=0; i<4; i++) {
        reformedPayoff[i] = abs(this.payoffs[i][0] - this.payoffs[i][1]);
      }
      return this.scoresToPreferenceOrder(reformedPayoff, true);

    case EQUITABLE : // minimise payoff diff
      for (int i=0; i<4; i++) {
        reformedPayoff[i] = abs(this.payoffs[i][0] - this.payoffs[i][1]);
      }
      return this.scoresToPreferenceOrder(reformedPayoff, false);

    case COOPERATIVE : // maximise payoff sum
      for (int i=0; i<4; i++) {
        reformedPayoff[i] = this.payoffs[i][0] + this.payoffs[i][1];
      }
      return this.scoresToPreferenceOrder(reformedPayoff, true);

    case NARCISSIST : // minimise payoff sum
      for (int i=0; i<4; i++) {
        reformedPayoff[i] = this.payoffs[i][0] + this.payoffs[i][1];
      }
      return this.scoresToPreferenceOrder(reformedPayoff, false);

    case INDIVIDUAL : // maximise player payoff
      for (int i=0; i<4; i++) {
        reformedPayoff[i] = this.payoffs[i][0];
      }
      return this.scoresToPreferenceOrder(reformedPayoff, true);

    case MARTYR : // minimise player payoff
      for (int i=0; i<4; i++) {
        reformedPayoff[i] = this.payoffs[i][0];
      }
      return this.scoresToPreferenceOrder(reformedPayoff, false);

    default:
      return new int[]{0, 1, 2, 3};
    }
  }
}
