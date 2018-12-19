import ktbyte.sprite.*;
// Sprite tank;
Tank tank;
/***************************************************************************************************
 * 
 ***************************************************************************************************/
void setup() {
  size(600, 400);
  textFont(createFont("monospaced", 16));

  tank = new Tank(this);
  tank.init("tank.png", width * 0.5, height * 0.5, 120f, 120f);
  tank.frontAngle(-90);
}

/***************************************************************************************************
 *
 ***************************************************************************************************/
void draw() {
  background(220);
  drawGrid();
  tank.update();
  drawInstructions();
  drawDebugInfo();
}

void drawGrid() {
  stroke(100, 100);
  line(width * 0.5, 0, width * 0.5, height);
  line(0, height * 0.5, width, height * 0.5);
}

void drawInstructions() {
  pushStyle();
  fill(50, 50, 255);
  textAlign(CENTER);
  text("Press and hold the UP key + drag the mouse on the canvas", width * 0.5, 20);
  text("OR", width * 0.5, 40);
  text("Use the UP, DOWN, LEFT, RIGHT keys", width * 0.5, 60);
  text("To control the vehicle.", width * 0.5, 80);
  popStyle();
}

void drawDebugInfo() {
  pushStyle();
  fill(0);
  textAlign(LEFT);
  text("up:" + str(tank.up), 10, height - 80);
  text("down:" + str(tank.down), 10, height - 60);
  text("left:" + str(tank.left), 10, height - 40);
  text("right:" + str(tank.right), 10, height - 20);
  popStyle();
}

void keyPressed() {
  tank.updatePressedKeys();
}

void keyReleased() {
  tank.updateReleasedKeys();
}

void mouseClicked() {
  tank.turnToPoint(mouseX, mouseY);
}

void mouseDragged() {
  tank.turnToPoint(mouseX, mouseY);
}
