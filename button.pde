class ToggleActionButton {
  PVector pos;
  int currentActionCtr;
  String text;
  String[] metrics;
  float w;
  float h;
  ToggleActionButton(PVector pos) {
    this.pos = pos;
    this.currentActionCtr = 0;
    this.metrics = new String[]{"none", "utility", "offense", "defense"};
    updateText();
    this.w = 50;
    this.h = 20;
  }

  void updateText() {
    this.text = this.metrics[this.currentActionCtr];
  }

  String getText() {
    return this.text;
  }

  void count() {
    this.currentActionCtr++;
    this.currentActionCtr = this.currentActionCtr % 4;
    updateText();
  }

  void show() {
    fill(200);
    rectMode(CENTER);
    rect(this.pos.x, this.pos.y, w, h);
    fill(0);
    text(this.text, this.pos.x, this.pos.y);
  }
  
  boolean overButton() {
    float xMin = this.pos.x - this.w;
    float xMax = this.pos.x + this.w;
    float yMin = this.pos.y - this.h;
    float yMax = this.pos.y + this.h;
    
    return mouseX > xMin && mouseX < xMax && mouseY > yMin && mouseY < yMax;
  }
}
