/**********************************************************************************************************************
 * There are two points to mention. 
 *
 * The first one: This class should be used with Window class. In particular, the object of this class should be  
 * contained in the 'Window' object as a 'part' of it. 
 *
 * The second one: This class should be possible to use as a standalone object.
 *********************************************************************************************************************/
class Pane extends Controller {

  Pane(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    this.isDragable = false;
    updateSize(w, h);

    title = "a Pane";

    // automatically register the newly created pane in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  Pane(String title, int posx, int posy, int w, int h) {
    this.title = title;
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    this.isDragable = false;
    updateSize(w, h);

    // automatically register the newly created pane in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  void updateSize(int wdth, int hght) {
    pg = createGraphics(wdth + 1, hght + 1);
  }

  void draw() {
    drawBorder();
    drawControllers();
    image(pg, posx, posy);
  }

  void drawBorder() {
    // change thickness depending on the user-mouse behavior
    pg.beginDraw();
    pg.stroke(0);
    pg.strokeWeight(1);
    pg.fill(200, 220, 200);
    pg.rectMode(CORNER);
    pg.rect(0, 0, w, h);
    pg.endDraw();
  }

  void drawControllers() {
    for (Controller controller : controllers) {
      pg.beginDraw();
      pg.image(controller.getGraphics(), controller.posx, controller.posy);
      pg.endDraw();
    }
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
    if (isHovered) {
      isPressed = true;
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMousePressed();
      }
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
    if (isDragable) {
      if (isPressed) {
        posx += mouseX - pmouseX;
        posy += mouseY - pmouseY;
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMouseDragged();
        }
      }
    }
  }

  boolean isPointInside(int x, int y) {
    boolean isInside = false;
    if (x > posx && x < posx + this.w) {
      if (y > posy && y < posy + this.h) {
        isInside = true;
      }
    }
    return isInside;
  }
}
