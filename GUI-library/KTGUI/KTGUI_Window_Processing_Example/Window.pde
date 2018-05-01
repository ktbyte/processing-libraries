// This class should contain the Border object that can change 
// the type of cursor depending on the type of action
// ARROW - when the pointer is outside the 'window' area or border
// HAND  - when the pointer is over the 'window' area or border
// CROSS - when the user is dragging the border of the 'window' 
// MOVE  - when the user is moving the 'window' 
/**********************************************************************************************************************
 * This is a KTGUI component (controller).
 * This class extends the 'Controller' class.
 *********************************************************************************************************************/

class Window extends Controller {

  // Border border;
  TitleBar titleBar;
  // MenuBar menuBar;
  WindowPane pane;

  Window(int posx, int posy, int w, int h) {
    this.title = "a Window";
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    this.pg = createGraphics(w + 1, h + 1);
    ktgui.stageManager.defaultStage.registerController(this);
    createTitleBar();
    createPane();
  }

  Window(String title, int posx, int posy, int w, int h) {
    this.title = title;
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    this.pg = createGraphics(w + 1, h + 1);
    ktgui.stageManager.defaultStage.registerController(this);
    setTitle(title);
    createTitleBar();
    createPane();
  }

  void createTitleBar() {
    titleBar = new TitleBar("tb:" + title, this, posx, posy, w, ktgui.TITLE_BAR_HEIGHT);
    attachController(titleBar);
    registerChildController(titleBar);
    titleBar.addEventAdapter(new KTGUIEventAdapter() {
      public void onMouseDragged() {
        titleBar.parentController.posx += mouseX - pmouseX;
        titleBar.parentController.posy += mouseY - pmouseY;
        pane.posx += mouseX - pmouseX;
        pane.posy += mouseY - pmouseY;
      }
    }
    );
  }

  void createPane() {
    pane = new WindowPane("pane:" + title, this, posx, posy + titleBar.h, w, h - titleBar.h);
    pane.isDragable = true;
    attachController(pane);
    registerChildController(pane);
  }

  void setTitle(String string) {
    title = string;
  }

  void draw() {
    //pg.beginDraw();
    //pg.background(200, 200);
    //pg.endDraw();
    //drawBorder();
    drawControllers();

    image(pg, posx, posy);
  }

  void updateGraphics() {
  }

  void drawBorder() {
    // change thickness depending on the user-mouse behavior
    pg.beginDraw();
    pg.stroke(0);
    pg.strokeWeight(1);
    pg.noFill();
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
  }

  // process mousePressed event received from PApplet
  void processMousePressed() {
  }

  // process mouseReleased event received from PApplet
  void processMouseReleased() {
  }

  // process mouseDragged event received from PApplet
  void processMouseDragged() {
  }
}
