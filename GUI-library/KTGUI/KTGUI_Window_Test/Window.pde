// This class should change the type of cursor depending on the type of action
// ARROW - when the pointer is outside the 'window' area or border
// HAND  - when the pointer is over the 'window' area or border
// CROSS - when the user is dragging the border of the 'window' 
// MOVE  - when the user is moving the 'window' 

// Potentially, this class and the KTGUI library class should use the PGraphics in order to 
// be able to share/switch graphic context. If this is possible, the we will be able
// to implement the 'minimize' feature.

// The other way to implement the window is to 'mimic' the behavior of the window.
// I mean, we don't need to really implement _ALL_ the drawing methods of PApplet. 
// Instead, we can only implement the synchronized motion of both, the parent and
// and the child components.
// For this, we could draw the border, background ant title bar. Then, we can use the 
// title bar to move the window and use the border to change the size of the window.
// When the window has moved, all the 'child' gui elements should receive the 'event'
// that forces them to change their position the same amount of dx and dy as the 
// parent window.
// The only thing that is left to figure out is how to 'clip()' the extents of the 
// gui elements that are crossing or even outside the window area.

// Of course, we need to register all the 'child' components. Use the ArrayList for this.

class Window extends Controller {
  int TITLE_BAR_HEIGHT = 20;
  int MENU_BAR_HEIGHT = 20;

  // Border border;
  // TitleBar titleBar;
  // MenuBar menuBar;

  ArrayList<Controller> controllers = new ArrayList<Controller>();
  ArrayList<KTGUIEventAdapter> adapters = new ArrayList<KTGUIEventAdapter>();

  String title = "Window title bar. Drag it!";
  int posx, posy, w, h;
  PApplet parent;
  PGraphics pg;

  boolean isTitleBarHovered, isTitleBarPressed;  
  boolean isBorderHovered, isBorderPressed;  

  Window(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    updateSize(w, h);
  }

  void updateSize(int wdth, int hght) {
    pg = createGraphics(wdth, hght);
  }
  void draw() {
    drawContents();
    drawTitleBar();
    drawBorder();
  }

  void drawTitleBar() {
    // drawBar
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    rectMode(CORNER);
    fill(180);
    stroke(15);
    strokeWeight(1);
    rect(0, 0, w, TITLE_BAR_HEIGHT);
    fill(25);
    textAlign(LEFT, CENTER);
    textSize(TITLE_BAR_HEIGHT*0.75);
    text(title, 10, TITLE_BAR_HEIGHT*0.5 - 2);
    popStyle();
    popMatrix();

    // drawButtons (minimize, maximize, close)
    // drawTitle
  }

  void drawBorder() {
    // change thickness depending on the user-mouse behavior
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    stroke(0);
    strokeWeight(1);
    fill(220);
    rectMode(CORNER);
    rect(0, TITLE_BAR_HEIGHT, w, h - TITLE_BAR_HEIGHT);
    popStyle();
    popMatrix();
  }

  void drawContents() {
  }

  void attachController(Controller controller) {
    controllers.add(controller);
    controller.setParentWindow(this);
  }

  void attachControllers(ArrayList<Controller> controllers) {
    for (Controller controller : controllers) {
      attachController(controller);
    }
  }

  // process mouseMoved event received from PApplet
  void processMouseMoved() {
    isTitleBarHovered = isPointInsideTitleBar(mouseX, mouseY) ? true : false;
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseMoved();
    }
  }

  // process mousePressed event received from PApplet
  void processMousePressed() {
    if (isTitleBarHovered) {
      isTitleBarPressed = true;
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMousePressed();
      }
    }
  }

  // process mouseReleased event received from PApplet
  void processMouseReleased() {
    isTitleBarPressed = false;
    if (isTitleBarHovered) {
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseReleased();
      }
    }
  }

  // process mouseDragged event received from PApplet
  void processMouseDragged() {
    if (isTitleBarPressed) {
      posx += mouseX - pmouseX;
      posy += mouseY - pmouseY;
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseDragged();
      }
    }
  }

  boolean isPointInsideTitleBar(int x, int y) {
    boolean isInside = false;
    if (x > posx && x < posx + this.w) {
      if (y > posy && y < posy + this.h) {
        isInside = true;
      }
    }
    return isInside;
  }
}
