enum VariableFieldName {
  TREATY_WITH,
    MUTUAL_FOE,
    N_DAYS_PEACE,
};


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
