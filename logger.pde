class Logger {
  JSONObject simulation;
  JSONObject currTurn;
  int turn;
  Logger() {
    this.simulation = new JSONObject();
    this.currTurn = new JSONObject();
    this.turn = 0;
  }

  void startTurn() {
    this.currTurn = new JSONObject();
  }

  void Print(int agentID, String data) {
    JSONObject json = parseJSONObject(data);
    this.currTurn.setJSONObject("Agent " + str(agentID), json);
  }

  void endTurn() {
    String turnFmt = this.turn < 10 ? "0" + str(this.turn) : str(this.turn);
    this.simulation.setJSONObject("Turn " + turnFmt, this.currTurn);
    this.turn++;
  }

  void endSim() {
    saveJSONObject(this.simulation, "run.json");
  }
}
