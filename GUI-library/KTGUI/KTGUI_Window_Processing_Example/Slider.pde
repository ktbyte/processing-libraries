/************************************************************************************************
 *
 ************************************************************************************************/
class Slider extends Controller {
  int posx, posy;               // corner location
  int width, height;      // width and height   
  int sr, er;             // start and end of range
  int pos;                // 'real' slider position 
  float value;            // 'mapped' slider position

  boolean isPressed, isHovered;

  ArrayList<KTGUIEventAdapter> adapters;

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  Slider(int posx, int posy, int width, int height, int sr, int er) {
    this.posx = posx;
    this.posy = posy;
    this.width = width;
    this.height = height;
    this.sr = sr;
    this.er = er;
    title = "The Slider";
    updateHandlePositionFromMouse();
    updateValueFromHandlePosition();
    adapters = new ArrayList<KTGUIEventAdapter>();
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void draw() {
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    fill(isHovered ? ktgui.COLOR_BG_HOVERED : ktgui.COLOR_BG_PASSIVE);
    rectMode(CORNER);
    rect(0, 0, this.width, this.height);
    fill(isHovered ? ktgui.COLOR_FG_HOVERED : ktgui.COLOR_FG_HOVERED);
    rect(0, 0, pos, this.height);
    fill(0);
    textAlign(LEFT, CENTER);
    text(str(value), 10, height/2);
    textAlign(LEFT, BOTTOM);
    text(title, 10, -2);
    popStyle();
    popMatrix();
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void addEventAdapters(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  boolean isPointInside(int x, int y) {
    boolean isInside = false;
    
    int px = (parentWindow == null) ? 0 : parentWindow.posx;
    int py = (parentWindow == null) ? 0 : parentWindow.posy;

    if (x > px + posx && x < px + posx + w) {
      if (y > py + posy && y < py + posy + h) {
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
  void setValue(float value) {
    this.value = value;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  int getPosition() {
    return pos;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void setPosition(int pos) {
    this.pos = pos;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void updateHandlePositionFromMouse() {
    pos = constrain(mouseX - posx, 0, this.width);
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void updateValueFromHandlePosition() {
    value = map(pos, 0, this.width, sr, er);
  }

  //-----------------------------------------------------------------------------------------------
  // process mouseMoved event received from PApplet
  //-----------------------------------------------------------------------------------------------
  void processMouseMoved() {
    if (isPointInside(mouseX, mouseY)) {
      isHovered = true;
    } else {
      isHovered = false;
    }

    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseMoved();
    }
  }

  //-----------------------------------------------------------------------------------------------
  // process mousePressed event received from PApplet
  //-----------------------------------------------------------------------------------------------
  void processMousePressed() {
    if (isHovered) {
      isPressed = true;
    } else {
      isPressed = false;
    }

    if (isPressed) {
      updateHandlePositionFromMouse();
      updateValueFromHandlePosition();
    }

    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMousePressed();
    }
  }

  //-----------------------------------------------------------------------------------------------
  // process mouseReleased event received from PApplet
  //-----------------------------------------------------------------------------------------------
  void processMouseReleased() {
    isPressed = false;
    if (isHovered) {
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseReleased();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------
  // process mouseDragged event received from PApplet
  //-----------------------------------------------------------------------------------------------
  void processMouseDragged() {
    if (isPressed) {
      updateHandlePositionFromMouse();
      updateValueFromHandlePosition();
    }
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseDragged();
    }
  }
}
