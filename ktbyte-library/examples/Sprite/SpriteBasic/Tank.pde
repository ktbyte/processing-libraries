class Tank extends Sprite {
  boolean up, down, left, right;

  public Tank(PApplet pa) {
    super(pa);
  }

  void update() {
    updateHeading();
    checkBoundaries();
    display();
  }

  void checkBoundaries() {
    if(getX() > width) setX(0);
    if(getX() < 0) setX(width);
    if(getY() > height) setY(0);
    if(getY() < 0) setY(height);
  }

  void updateHeading() {
    if (up) {
      forward(2);
    }
    if (down) {
      forward(-2);
    }
    if (right) {
      turn(1.0);
    }
    if (left) {
      turn(-1.0);
    }
  }

  void updatePressedKeys() {
    if (key == CODED) {
      if (keyCode == UP) {
        up = true;
      }
      if (keyCode == DOWN) {
        down = true;
      }
      if (keyCode == RIGHT) {
        right = true;
      }
      if (keyCode == LEFT) {
        left = true;
      }
    }
  }

  void updateReleasedKeys() {
    if (key == CODED) {
      if (keyCode == UP) {
        up = false;
      }
      if (keyCode == DOWN) {
        down = false;
      }
      if (keyCode == RIGHT) {
        right = false;
      }
      if (keyCode == LEFT) {
        left = false;
      }
    }
  }
}
