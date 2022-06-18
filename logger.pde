class Logger {
  JSONObject simulation;
  JSONObject currTurn;
  JSONObject currEnvironment;
  int turn;
  String currEnvName;
  ArrayList<String> envNames;
  ArrayList<JSONObject> envList;
  Logger() {
    this.simulation = new JSONObject();
    this.currTurn = new JSONObject();
    this.currEnvironment = new JSONObject();
    this.currEnvName = null;
    this.turn = 0;
    this.envNames = new ArrayList<String>();
    this.envList = new ArrayList<JSONObject>();
    this.initJSON();
  }

  void initJSON() {
    JSONData turnData = new JSONData(
      new String[]{"max_turns", "starting_buy_in", "treaties_allowed", "reinjection_rate"},
      new String[]{str(config.maxTurns), str(config.startingBuyInProb), str(config.allowTreaties), str(config.addAgentCooldown)});
    this.Print("config", turnData.formJSON());
    this.newEnv("Turns");
  }

  void startTurn() {
    this.newEnv("Turn " + str(this.turn));
  }

  void Print(String field, String data) {
    JSONObject json = parseJSONObject(data);
    if (this.currEnvName != null) {
      this.currEnvironment.setJSONObject(field, json);
    } else {
      this.simulation.setJSONObject(field, json);
    }
  }

  void PrintBack(String field, String data) {
    if (this.envList.size() > 1) {
      JSONObject json = parseJSONObject(data);
      JSONObject destination = this.envList.get(this.envList.size() - 2);
      destination.setJSONObject(field, json);
    }
  }

  void PrintArray(String field, JSONArray json) {
    if (this.currEnvName != null) {
      this.currEnvironment.setJSONArray(field, json);
    } else {
      this.simulation.setJSONArray(field, json);
    }
  }

  void newEnv(String name) {
    //this.currEnvironment = new JSONObject();
    this.envNames.add(name);
    JSONObject addedEnv = new JSONObject();
    this.envList.add(addedEnv);
    this.currEnvironment = addedEnv;
    this.currEnvName = name;
  }

  void closeEnv() {

    if (this.envList.size() > 1) {
      JSONObject destination = this.envList.get(this.envList.size() - 2);
      destination.setJSONObject(this.currEnvName, this.currEnvironment);
      this.envList.remove(this.currEnvironment);
      this.envNames.remove(this.currEnvName);
      int loc = this.envList.size() - 1;
      this.currEnvironment = this.envList.get(loc);
      this.currEnvName = this.envNames.get(loc);
    } else {
      this.simulation.setJSONObject(this.currEnvName, this.currEnvironment);
      this.envList.remove(this.currEnvironment);
      this.envNames.remove(this.currEnvName);
      this.currEnvName = null;
      this.currEnvironment = new JSONObject();
    }
  }

  void endTurn() {
    this.closeEnv();
    this.turn++;
  }

  void endSim() {
    this.endTurn();
    this.closeEnv();
    saveJSONObject(this.simulation, "output/log.json");
  }
}



class JSONData {
  String[] input;
  String[] output;
  JSONData(String[] input, String[] output) {
    this.input = input;
    this.output = output;
  }

  String valToJSON(String in) {
    String token = "\"";
    return token + in + token;
  }

  String formJSON() {
    try {
      if (this.input.length != this.output.length) {
        throw new Exception("fields and values must be the same size");
      }
      String fullString = "{ ";
      for (int i=0; i<this.input.length; i++) {
        String in = this.input[i];
        String out = this.output[i];
        if (i < this.input.length - 1) {
          fullString += (this.valToJSON(in) + ": " + this.valToJSON(out) + ", ");
        } else {
          fullString += (this.valToJSON(in) + ": " + this.valToJSON(out) + "}");
        }
      }
      return fullString;
    }
    catch(Exception e) {
      println(e);
      return "";
    }
  }
}
