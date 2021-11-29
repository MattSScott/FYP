class TreatyProposal {
  String treatyType;
  int treatyTo;
  int treatyFrom;
  TreatyProposal(int treatyTo, int treatyFrom, String treatyType) {
    this.treatyTo = treatyTo;
    this.treatyFrom = treatyFrom;
    this.treatyType = treatyType;
  }
  void Print(){
    println(this.treatyFrom, this.treatyTo, this.treatyType);
  }
}

class TreatyResponse {
  TreatyProposal treaty;
  boolean response;
  TreatyResponse(TreatyProposal treaty, boolean response) {
    this.treaty = treaty;
    this.response = response;
  }
}
