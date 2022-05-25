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
    this.words = new String[]{"none", "utility", "offence", "defence"};
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
    this.updateText();
  }
}

class ShowTreatiesButton extends ToggleActionButton {
  ShowTreatiesButton(PVector pos) {
    super(pos);
    this.words = new String[]{"on", "off"};
    this.updateText();
  }
}

class PlayPause extends Button {
  boolean playing;
  float w;
  PlayPause(PVector pos) {
    super(pos);
    this.playing = true;
    this.w = 50;
  }

  boolean isPlaying() {
    return this.playing;
  }

  void toggle() {
    this.playing = !this.playing;
  }

  void show() {
    fill(112);
    ellipse(this.pos.x, this.pos.y, this.w, this.w);
    fill(0, 255, 0);
    if (playing) {
      rect(this.pos.x-this.w/6, this.pos.y, 10, 30);
      rect(this.pos.x+this.w/6, this.pos.y, 10, 30);
    } else {
      float x1 = this.pos.x - this.w/3;
      float y1 = this.pos.y - this.w/3;

      float x2 = this.pos.x - this.w/3;
      float y2 = this.pos.y + this.w/3;

      float x3 = this.pos.x + this.w/3;
      float y3 = this.pos.y;

      triangle(x1+5, y1, x2+5, y2, x3+5, y3);
    }
  }
}
