/**********************************************************************************************************************
 * This is an example of the KTGUI component (controller).
 * This class extends the 'Controller' class.
 * This class overrides only the 'mouse-related' methods of the 'Controller' class.
 * The object of this class can be 'Pressed', 'Hovered', 'Released' and 'Dragged'.
 *********************************************************************************************************************/
class Button extends Controller {
  int posx, posy;
  int width, height;
  boolean isPressed, isHovered;

  ArrayList<KTGUIEventAdapter> adapters;

  Button(int posx, int posy, int width, int height) {
    this.posx = posx;
    this.posy = posy;
    this.width = width;
    this.height = height;
    title = "Button";
    adapters = new ArrayList<KTGUIEventAdapter>();
  }

  void addEventAdapters(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
  }

  void draw() {
    
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    rectMode(CORNER);
    if (isHovered && !isPressed) {
      fill(ktgui.COLOR_FG_HOVERED);
    } else if (isHovered && isPressed) {
      fill(ktgui.COLOR_FG_PRESSED);
    } else {
      fill(ktgui.COLOR_FG_PASSIVE);
    }
    rect(0, 0, this.width, this.height);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(title, this.width/2, this.height/2);
    popStyle();
    popMatrix();
  }

  // process mouseMoved event received from PApplet
  void processMouseMoved() {
    isHovered = isPointInside(mouseX, mouseY) ? true : false;
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseMoved();
    }
  }

  // process mousePressed event received from PApplet
  void processMousePressed() {
    isPressed = isHovered;
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMousePressed();
    }
  }

  // process mouseReleased event received from PApplet
  void processMouseReleased() {
    isPressed = false;
    if (isHovered) {
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseReleased();
      }
    }
  }

  // process mouseDragged event received from PApplet
  void processMouseDragged() {
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseDragged();
    }
  }

  boolean isPointInside(int x, int y) {
    boolean isInside = false;
    if (x > posx && x < posx + this.width) {
      if (y > posy && y < posy + this.height) {
        isInside = true;
      }
    }
    return isInside;
  }
}
