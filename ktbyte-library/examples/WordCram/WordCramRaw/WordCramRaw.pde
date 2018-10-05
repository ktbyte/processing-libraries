WordCram wc;

void setup() {
  size(400, 400);
  wc = new WordCram(this);
}

void draw() {
  background(235);
  ellipse(mouseX, mouseY, 30, 30);
}