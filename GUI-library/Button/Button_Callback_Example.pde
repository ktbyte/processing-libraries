color bg;
Button btn;
boolean doTickle = true;
boolean doFlow = false;

/************************************************************************************************
 *
 ************************************************************************************************/
void setup() {
  size(400, 400);
  noSmooth();
  frameRate(25);
  
  btn = new Button(100, 100, 200, 100);
  btn.setTitle("Press and hold me!");
  
  btn.addListener(new ButtonListener() {
    void onPressed() {
      bg = color(random(0, 255),random(0, 255),random(0, 255));
      doTickle = doTickle ? false : true;
    }
  });

  btn.addListener(new ButtonListener() {
    void onPressed() {
      doFlow = doFlow ? false : true;
    }
  });
    
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void draw() {
  background(bg);

  btn.draw();
  
  drawDebugInfo();
  
  if(doTickle) tickle();
  if(doFlow) flow();
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void drawDebugInfo(){
  pushMatrix();
  pushStyle();
  fill(0);
  text(mouseX + ", " + mouseY, 10, 20);
  text("btn.isPointInside=" + str(btn.isPointInside(mouseX, mouseY)), 10, 30);
  text("btn.isHovered=" + str(btn.isHovered), 10, 40);
  text("btn.isPressed=" + str(btn.isPressed), 10, 50);
  text("doTickle =" + str(doTickle), 10, 60);
  popStyle();
  popMatrix();
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void tickle(){
  pushMatrix();
  translate(width/2 + random(-5, 5), height*0.75 + random(-5, 5));
  pushStyle();
  textSize(36);
  textAlign(CENTER, CENTER);
  text("TICKLE", 0, 0);
  popStyle();
  popMatrix();
}


//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void flow(){
  pushMatrix();
  translate(width/2 + sin(frameCount)*50, height*0.75 + cos(frameCount)*50);
  pushStyle();
  textSize(36);
  textAlign(CENTER, CENTER);
  text("FLOW", 0, 0);
  popStyle();
  popMatrix();
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
public class Button {
  private boolean isPressed, isHovered;
  private int x, y, width, height;
  private ArrayList<ButtonListener> btnListeners;
  private color HOVERED = color(100, 100, 200, 250);
  private color PRESSED = color(250, 50, 50);
  private color PASSIVE = color(180);
  private String title;

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  Button(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    btnListeners = new ArrayList<ButtonListener>();
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
      strokeWeight(2);
      stroke(50, 50, 200);
      fill(PASSIVE);
    }
    if (isPressed) {
      fill(PRESSED);
    }
    pushMatrix();
    translate(x, y);
    rectMode(CORNER);
    rect(0, 0, this.width, this.height, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    text(title, this.width/2, this.height/2);
    popMatrix();
    popStyle();
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  boolean isPointInside(int ptx, int pty) {
    boolean isInside = false;
    if (ptx > x && ptx < x + width) {
      if (pty > y && pty < y + height) {
        isInside = true;
      }
    }
    return isInside;
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
      
      // notify listeners
      for(ButtonListener listener: btnListeners){
        listener.onPressed();
      }
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
    btnListeners.add(listener);
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void setTitle(String title){
    this.title = title;
  }
}
