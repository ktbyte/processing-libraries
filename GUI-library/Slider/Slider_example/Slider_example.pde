Slider slider;
PFont font;

/************************************************************************************************
 *
 ************************************************************************************************/
void setup() {
  size(400, 400);
  noSmooth();
  slider = new Slider(100, 200, 200, 20, 0, 1000);
  font = createFont("monospace", 12);
  textFont(font);
  textAlign(LEFT, BOTTOM);
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void draw() {
  background(200);
  slider.draw();
  fill(0);
  text(mouseX + ", " + mouseY, 10, 20);
  text("slider.isPointInside = " + str(slider.isPointInside(mouseX, mouseY)), 10, 30);
  text("slider.isHovered     = " + str(slider.isHovered), 10, 40);
  text("slider.isPressed     = " + str(slider.isPressed), 10, 50);
  text("slider.sr            = " + str(slider.sr), 10, 60);
  text("slider.er            = " + str(slider.er), 10, 70);
  text("slider.value         = " + str(slider.value), 10, 80);
  text("slider.pos           = " + str(slider.pos), 10, 90);

  float linePos = map(slider.getValue(), slider.sr, slider.er, 0, width);
  line(linePos, 0, linePos, height);
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void mousePressed(){
  slider.processMousePressed();
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void mouseMoved(){
  slider.processMouseMoved();
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void mouseDragged(){
  slider.processMouseDragged();
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void mouseReleased(){
  slider.isPressed = false;
}


/************************************************************************************************
 *
 ************************************************************************************************/
interface SliderListener {
  void onDragged();
  int getValue();
}

/************************************************************************************************
 *
 ************************************************************************************************/
class Slider {
  int x, y;               // corner location
  int width, height;      // width and height   
  int sr, er;             // start and end of range
  int pos;                // 'real' slider position 
  float value;            // 'mapped' slider position
  
  boolean isHovered;
  boolean isPressed;

  color BG_PASSIVE_COLOR = color(180);
  color BG_HOVERED_COLOR = color(220);
  color BAR_PASSIVE_COLOR = color(50, 180, 50);
  color BAR_HOVERED_COLOR = color(50, 220, 50);

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  Slider(int x, int y, int width, int height, int sr, int er) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.sr = sr;
    this.er = er;
    update();
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void draw() {
    pushMatrix();
    translate(x, y);
    pushStyle();
    fill(isHovered ? BG_HOVERED_COLOR : BG_PASSIVE_COLOR);
    rectMode(CORNER);
    rect(0, 0, this.width, this.height);
    fill(isHovered ? BAR_HOVERED_COLOR : BAR_PASSIVE_COLOR);
    rect(0, 0, pos, this.height);
    fill(0);
    textAlign(LEFT, CENTER);
    text(str(value), 10, height/2);
    popStyle();
    popMatrix();
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  boolean isPointInside(int ptx, int pty) {
    boolean isInside = false;
    if (ptx > this.x  && ptx < this.x + this.width) {
      if (pty > this.y && pty < this.y + this.height ) {
        isInside = true;
      }
    }
    return isInside;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  float getValue() {
    return value;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void update() {
    pos = constrain(mouseX - x, 0, this.width);
    value = map(pos, 0, this.width, sr, er);
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void processMouseMoved() {
    if(isPointInside(mouseX, mouseY)){
      isHovered = true;
    }else{
      isHovered = false;
    }
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void processMousePressed() {
    if(isPointInside(mouseX, mouseY)){
      isPressed = true;
      update();
    }else{
      isPressed = false;
    }
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void processMouseDragged() {
    if(isPressed){
      update();
    }
  }
}
