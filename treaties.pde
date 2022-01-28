enum VariableFieldName {
  TREATY_WITH,
    MUTUAL_FOE,
    N_DAYS_PEACE,
};

class TreatyProposal {
  Agent treatyFrom;
  Agent treatyTo;
  String treatyType; //Treaty after MVP
  TreatyProposal(Agent treatyFrom, Agent treatyTo, String treatyType) {
    this.treatyFrom = treatyFrom;
    this.treatyTo = treatyTo;
    this.treatyType = treatyType;
  }
  void Print() {
    println(this.treatyFrom.getID(), this.treatyTo.getID(), this.treatyType);
  }
}

class TreatyResponse {
  TreatyProposal proposal;
  boolean response;
  TreatyResponse(TreatyProposal proposal, boolean response) {
    this.proposal = proposal;
    this.response = response;
  }
}

class Treaty {
  String treatyName;
  String description;
  VariableFieldName[] reqVars;
  float[] matReqVars;

  Treaty(String tn, String d, VariableFieldName[] rv, float[] mrv) {
    this.treatyName = tn;
    this.description = d;
    this.reqVars = rv;
    this.matReqVars = mrv;
  }

  String what() {
    return this.description;
  }
}


Treaty[] allTreaties = new Treaty[]{

  new Treaty("niceTreaty",
  "a nice treaty",
  new VariableFieldName[]{VariableFieldName.TREATY_WITH},
  new float[]{1, 0}
  ),



  new Treaty("nastyTreaty",
  "a not nice treaty",
  new VariableFieldName[]{VariableFieldName.TREATY_WITH},
  new float[]{1, 0}
  ),


  new Treaty("buddyTreaty",
  "a not nice treaty",
  new VariableFieldName[]{VariableFieldName.TREATY_WITH, VariableFieldName.MUTUAL_FOE},
  new float[]{1, 1, 0}
  ),


};
