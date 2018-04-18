// This class should change the type of cursor depending on the type of action
// ARROW - when the pointer is outside the 'window' area or border
// HAND  - when the pointer is over the 'window' area or border
// CROSS - when the user is dragging the border of the 'window' 
// MOVE  - when the user is moving the 'window' 

// Potentially, this class and the KTGUI library class should use the PGraphics in order to 
// be able to share/switch graphic context. If this is possible, then we will be able
// to implement the 'minimize' feature.

// We should implement the synchronized motion of both, the parent and the child components.
// For this, we could draw the border, background ant title bar. Then, we can use the 
// title bar to move the window and use the border to change the size of the window.
// When the window has moved, all the 'child' gui elements should receive the 'event'
// that forces them to change their position the same amount of dx and dy as the 
// parent window.

// The extents 'clipping' of the gui components which are crossing or even outside the
// window area is done using the PGraphics.

// In order to register all the 'child' components we are using the ArrayList<Controller>.

// !!! The Window should contain a TitleBar and Panel.
// !!! The TitleBar should contain a Button.
// !!! The Panel chould contain a Border.

class Window extends Controller {
  int TITLE_BAR_HEIGHT = 14;
  int MENU_BAR_HEIGHT = 20;
  int BORDER_THICKNESS = 3;

  ArrayList<Controller> controllers = new ArrayList<Controller>();

  boolean isTitleBarHovered, isTitleBarPressed;  
  boolean isWindowHovered, isWindowPressed;  
  boolean isBorderHovered, isBorderPressed;  

  WindowCloseButton windowCloseBtn;
  // Border border;
  // TitleBar titleBar;
  // MenuBar menuBar;

  Window(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    updateSize(w, h);

    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);

    windowCloseBtn = new WindowCloseButton(w - TITLE_BAR_HEIGHT + 2, 2, TITLE_BAR_HEIGHT - 4, TITLE_BAR_HEIGHT - 4);
    attachController(windowCloseBtn);
    ktgui.stageManager.defaultStage.registerController(windowCloseBtn);
  }

  void updateSize(int wdth, int hght) {
    pg = createGraphics(wdth + 1, hght + 1);
  }

  void draw() {
    drawTitleBar();
    drawBorder();
    drawControllers();
    image(pg, posx, posy);
  }

  void drawTitleBar() {
    // drawBar and title
    pg.beginDraw();
    pg.background(200, 200);
    pg.rectMode(CORNER);
    pg.fill(180);
    pg.stroke(15);
    pg.strokeWeight(1);
    pg.rect(0, 0, w, TITLE_BAR_HEIGHT);
    pg.fill(25);
    pg.textAlign(LEFT, CENTER);
    pg.textSize(TITLE_BAR_HEIGHT*0.65);
    pg.text(title, 10, TITLE_BAR_HEIGHT*0.5);
    pg.endDraw();
  }

  void drawBorder() {
    // change thickness depending on the user-mouse behavior
    pg.beginDraw();
    pg.stroke(0);
    pg.strokeWeight(1);
    pg.noFill();
    pg.rectMode(CORNER);
    pg.rect(0, TITLE_BAR_HEIGHT, w, h - TITLE_BAR_HEIGHT);
    pg.endDraw();
  }

  void drawControllers() {
    for (Controller controller : controllers) {
      pg.beginDraw();
      pg.image(controller.getGraphics(), controller.getPosX(), controller.getPosY());
      pg.endDraw();
    }
  }

  void attachController(Controller controller) {
    if (controller.parentWindow != null) {
      controller.parentWindow.controllers.remove(controller); // reset parentWindow
    }
    if (!controllers.contains(controller)) {
      controllers.add(controller);
      controller.setParentWindow(this);
    }
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
      if (y > posy && y < posy + TITLE_BAR_HEIGHT) {
        isInside = true;
      }
    }
    return isInside;
  }

  boolean isPointInsideWindow(int x, int y) {
    boolean isInside = false;
    if (x > posx && x < posx + this.w) {
      if (y > posy + TITLE_BAR_HEIGHT && y < posy + this.h) {
        isInside = true;
      }
    }
    return isInside;
  }
}


/*****************************************************************************************************
 * 
 ****************************************************************************************************/
class WindowCloseButton extends Button {

  WindowCloseButton(int posx, int posy, int w, int h) {
    super(posx, posy, w, h);
  }

  void updateGraphics() {
    pg.beginDraw();
    pg.rectMode(CORNER);
    if (isHovered && !isPressed) {
      pg.fill(ktgui.COLOR_FG_HOVERED);
    } else if (isHovered && isPressed) {
      pg.fill(ktgui.COLOR_FG_PRESSED);
    } else {
      //pg.fill(ktgui.COLOR_FG_PASSIVE);
      pg.fill(200, 200);
    }
    pg.stroke(0);
    pg.strokeWeight(1);
    pg.rectMode(CORNER);
    pg.rect(0, 0, w, h);
    pg.line(w * 0.2, h * 0.2, w * 0.8, h * 0.8);
    pg.line(w * 0.2, h * 0.8, w * 0.8, h * 0.2);
    pg.endDraw();
  }

  void processMousePressed() {
    isAlive = false;
    super.processMousePressed();
    if (isPressed) {
      //parentWindow.parentStage.controllers.remove(parentWindow);
      //ktgui.stageManager.defaultStage.controllers.remove(parentWindow);
      //ktgui.stageManager.activeStage.controllers.remove(parentWindow);
      ktgui.stageManager.closeWindow(parentWindow);
    }
  }
}
