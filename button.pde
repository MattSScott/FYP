class Button {
  PVector pos;
  String text;
  float w;
  float h;
  Button(PVector pos) {
    this.pos = pos;
    this.w = 50;
    this.h = 20;
    this.text = "";
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

class ToggleActionButton extends Button {
  int currentActionCtr;
  String[] words;
  ToggleActionButton(PVector pos) {
    super(pos);
    this.currentActionCtr = 0;
    this.words = new String[]{"none", "utility", "offense", "defense"};
    this.updateText();
  }

  void updateText() {
    this.text = this.words[this.currentActionCtr];
  }

  String getText() {
    return this.text;
  }

  void count() {
    this.currentActionCtr++;
    this.currentActionCtr = this.currentActionCtr % this.words.length;
    updateText();
  }
}

class ShowTreatiesButton extends ToggleActionButton {
  ShowTreatiesButton(PVector pos){
    super(pos);
    this.words = new String[]{"on", "off"};
    this.updateText();
  }
}
