/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
class Pane extends Controller {
  PGraphics userpg;
  
  Pane(int posx, int posy, int w, int h) {
    this.title = "a Pane";
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    this.isDragable = false;
    this.pg = createGraphics(w + 1, h + 1);
    this.userpg = createGraphics(w + 1, h + 1);


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
    this.pg = createGraphics(w + 1, h + 1);
    this.userpg = createGraphics(w + 1, h + 1);

    // automatically register the newly created pane in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  void updateUserDefinedGraphics(PGraphics userpg) {
    this.userpg = userpg;
  }  

  void drawUserDefinedGraphics() {
    pg.beginDraw();
    pg.image(userpg, 0, 0);
    //pg.fill(200);
    //pg.stroke(0);
    //pg.ellipse(w/2, h/2, 100, 100);
    pg.endDraw();
  }

  void draw() {
    drawControllers();
    image(pg, posx, posy);
  }

  void updateGraphics() {
    // change thickness depending on the user-mouse behavior
    pg.beginDraw();
    pg.background(200, 100);
    pg.stroke(0);
    pg.strokeWeight(1);
    //pg.fill(200, 220, 200, 50);
    pg.rectMode(CORNER);
    pg.rect(0, 0, w, h);
    pg.noFill();
    pg.endDraw();
    
    drawUserDefinedGraphics();
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

class WindowPane extends Pane {
  Window parentWindow;
  
  WindowPane(Window window, int posx, int posy, int w, int h) {
    super(posx, posy, w, h);
    this.parentWindow = window;
  }

  WindowPane(String title, Window window, int posx, int posy, int w, int h) {
    super(title, posx, posy, w, h);
    this.parentWindow = window;
  }
}
