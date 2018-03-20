Button btn;
color bg;

/************************************************************************************************
 *
 ************************************************************************************************/
void setup() {
  size(400, 400);
  noSmooth();
  
  btn = new Button(100, 100, 200, 100);
  btn.addListener(new ButtonListener() {
    //public void onPressed() {  // <--- use this if you want to run this code inside the Processing IDE
    void onPressed() {
      bg = color(random(0, 255),random(0, 255),random(0, 255));
      println("Call 'println()' iside the anonymous class method.");           //doesn't work !!!
    }
  }
  );
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void draw() {
  background(bg);
  btn.draw();
  fill(0);
  text(mouseX + ", " + mouseY, 10, 20);
  text("btn.isPointInside=" + str(btn.isPointInside(mouseX, mouseY)), 10, 30);
  text("btn.isHovered=" + str(btn.isHovered), 10, 40);
  text("btn.isPressed=" + str(btn.isPressed), 10, 50);
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
public interface ButtonListener {
  void onPressed();
}


//**********************************************************************************************
//
//**********************************************************************************************
class Button {
  private boolean isPressed, isHovered;
  private int x, y, width, height;
  private ButtonListener btnListener;
  private color HOVERED = color(100, 100, 200, 250);
  private color PRESSED = color(250, 50, 50);
  private color PASSIVE = color(100);

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
    pushStyle();
    if (isHovered) {
      strokeWeight(5);
      stroke(50, 200, 50);
      fill(HOVERED);
    } else {
      strokeWeight(1);
      stroke(50, 50, 200);
      fill(PASSIVE);
    }
    if (isPressed) {
      fill(PRESSED);
    }
    pushMatrix();
    translate(x, y);
    rectMode(CORNER);
    rect(0, 0, this.width, this.height);
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
      btnListener.onPressed();
      println("Call 'println()' outside the anonymous class method.");  //doesn't work !!!
    }
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void processMouseReleased() {
    isPressed = false;
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void addListener(ButtonListener listener) {
    btnListener = listener;
  }
  
}
