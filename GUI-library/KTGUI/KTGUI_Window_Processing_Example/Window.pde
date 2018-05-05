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
    pg = createGraphics(w + 1, h + 1);
    userpg = createGraphics(w + 1, h + 1);
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
    pg = createGraphics(w + 1, h + 1);
    userpg = createGraphics(w + 1, h + 1);
    ktgui.stageManager.defaultStage.registerController(this);
    setTitle(title);
    createTitleBar();
    createPane();
  }

  void addController(Controller controller, int hAlign, int vAlign) {
    if (isActive) {
      controller.alignAbout(pane, hAlign, vAlign);
      pane.attachController(controller);
    }
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
    attachController(pane);
    registerChildController(pane);
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
