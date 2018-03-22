Button btn;

/************************************************************************************************
 *
 ************************************************************************************************/
void setup() {
  size(400, 400);
  noSmooth();
  
  btn = new Button(100, 100, 200, 100);
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void draw() {
  background(220);
  btn.draw();
  fill(0);
  text(mouseX + ", " + mouseY, 10, 20);
  text("btn.isPointInside=" + str(btn.isPointInside(mouseX, mouseY)), 10, 30);
  text("btn.isHovered=" + str(btn.isHovered), 10, 40);
  text("btn.isPressed=" + str(btn.isPressed), 10, 50);
  
  tickle();
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void tickle(){
  if(btn.isPressed){
    pushMatrix();
    translate(width/2 + random(-5, 5), height*0.75 + random(-5, 5));
    pushStyle();
    textSize(36);
    textAlign(CENTER, CENTER);
    text("TICKLE", 0, 0);
    popStyle();
    popMatrix();
  }
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void mouseMoved() {
  btn.processMouseHovered(mouseX, mouseY);
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void mousePressed() {
  btn.processMousePressed(mouseX, mouseY);
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void mouseReleased() {
  btn.processMouseReleased();
}




//**********************************************************************************************
//
//**********************************************************************************************
class Button {
  private boolean isPressed, isHovered;
  private int x, y, width, height;
  private color HOVERED = color(100, 100, 200, 250);
  private color PRESSED = color(250, 50, 50);
  private color PASSIVE = color(180);

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  Button(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void draw() {
    pushMatrix();
    translate(x, y);
    pushStyle();
    if (isHovered) {
      strokeWeight(5);
      stroke(50, 200, 50);
      fill(HOVERED);
    } else {
      strokeWeight(2);
      stroke(50, 50, 200);
      fill(PASSIVE);
    }
    if (isPressed) {
      fill(PRESSED);
    }
    rectMode(CORNER);
    rect(0, 0, this.width, this.height, 10);

    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Press and hold me", this.width/2, this.height/2);
    popMatrix();
    popStyle();

    pushStyle();
    pushMatrix();
    popMatrix();
    popStyle();
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  boolean isPointInside(int ptx, int pty) {
    boolean value = false;
    if (ptx > x && ptx < x + width) {
      if (pty > y && pty < y + height) {
        value = true;
      }
    }
    return value;
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void processMouseHovered(int x, int y) {
    if (isPointInside(x, y)) {
      isHovered = true;
    } else {
      isHovered = false;
    }
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void processMousePressed(int x, int y) {
    if (isPointInside(x, y)) {
      isPressed = true;
    }
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void processMouseReleased() {
    isPressed = false;
  }

  
}
