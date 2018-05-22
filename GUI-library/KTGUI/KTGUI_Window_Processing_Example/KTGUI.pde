/**********************************************************************************************************************
 * This class is used to 'transfer' the 'draw', 'mouse' and 'keyboard' events from PApplet to KTGUI components 
 * (controllers).
 * The main idea is to eliminate the need of adding the callback methods directly in the Processing's 'mouseXXXXX()' 
 * and 'keyXXXXX()' methods.
 * This class is used also as a factory to create the KTGUI components (controllers). 
 * When this class creates a KTGUI component it also automatically registers this component in components list.
 * When some event is received from PApplet, this class automatically iterates through all the components in the 
 * components list and 'transfers' the events to each component.
 *********************************************************************************************************************/
public class KTGUI {
  PApplet pa;
  StageManager stageManager;
  HashMap<Controller, Integer> garbageList = new HashMap<Controller, Integer>();

  color COLOR_FG_HOVERED = color(10, 150, 10); 
  color COLOR_FG_PRESSED = color(10, 200, 10);
  color COLOR_FG_PASSIVE = color(100, 100, 200); 
  color COLOR_BG_HOVERED = color(100); 
  color COLOR_BG_PASSIVE = color(100); 
  color COLOR_BG_PRESSED = color(200);
<<<<<<< HEAD

  int TITLE_BAR_HEIGHT = 14;
=======
  

>>>>>>> test/eclipse-library
  int MENU_BAR_HEIGHT = 20;
  int BORDER_THICKNESS = 3;

  int ALIGN_GAP = 20;

  /*
  * The constructor automatically registers the 'draw', 'mouseEvent' and 'keyEvent' of this class in PApplet's EDT 
   * thread.
   */
  public KTGUI(PApplet pa) {
    this.pa = pa;
    this.pa.registerMethod("draw", this);
    this.pa.registerMethod("mouseEvent", this);
    this.pa.registerMethod("keyEvent", this);

    stageManager = new StageManager();
  }

  //-------------------------------------------------------------------------------------------------------------------
  // Transfer 'draw' event from PApplet to KTGUI components. 
  // This method will be called at the end of the PApplet.draw().
  //-------------------------------------------------------------------------------------------------------------------
  void draw() {
    stageManager.defaultStage.draw();
    stageManager.activeStage.draw();
    collectGarbage();
  }

  void collectGarbage() {
    for (Map.Entry me : garbageList.entrySet()) {
      Controller controller = (Controller)me.getKey();
      int time = (Integer)me.getValue();
      if (millis() - time > 100) {
        if (controller.parentStage != null) { 
          controller.parentStage.unregisterController(controller);
        }
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Button createButton(int x, int y, int w, int h) {
    Button btn = new Button(x, y, w, h);
    return btn;
  }
  Button createButton(String title, int x, int y, int w, int h) {
    Button btn = new Button(title, x, y, w, h);
    return btn;
  }
  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Window createWindow(int x, int y, int w, int h) {
    Window window = new Window(x, y, w, h);
    return window;
  }
  Window createWindow(String title, int x, int y, int w, int h) {
    Window window = new Window(title, x, y, w, h);
    return window;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Pane createPane(int x, int y, int w, int h) {
    Pane pane = new Pane(x, y, w, h);
    return pane;
  }
  Pane createPane(String title, int x, int y, int w, int h) {
    Pane pane = new Pane(title, x, y, w, h);
    return pane;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This method 'redirects' the incoming mouse events from PApplet to 'transfer' methods.
  // This method will be called when the PApplet.mouseEvent is happening.
  //-------------------------------------------------------------------------------------------------------------------
  void mouseEvent(MouseEvent e) {
    switch (e.getAction()) {
    case MouseEvent.PRESS:
      this.mousePressed();
      break;
    case MouseEvent.RELEASE:
      this.mouseReleased();
      break;
    case MouseEvent.DRAG:
      this.mouseDragged();
      break;
    case MouseEvent.MOVE:
      this.mouseMoved();
      break;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This method 'redirects' the incoming keyboard events from PApplet to 'transfer' methods.
  // This method will be called when the PApplet.keyEvent is happening.
  //-------------------------------------------------------------------------------------------------------------------
  void keyEvent(KeyEvent e) {
    switch (e.getAction()) {
    case KeyEvent.PRESS:
      this.keyPressed();
      break;
    case KeyEvent.RELEASE:
      this.keyReleased();
      break;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.mouseDragged event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseDragged() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processMouseDragged();
    }
    if (stageManager.getActiveStage() != stageManager.getDefaultStage()) {
      for (Controller controller : stageManager.defaultStage.controllers) {
        controller.processMouseDragged();
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.mousePressed event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mousePressed() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processMousePressed();
    }
    if (stageManager.getActiveStage() != stageManager.getDefaultStage()) {
      for (Controller controller : stageManager.defaultStage.controllers) {
        controller.processMousePressed();
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.mouseReleased event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseReleased() { 
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processMouseReleased();
    }
    if (stageManager.getActiveStage() != stageManager.getDefaultStage()) {
      for (Controller controller : stageManager.defaultStage.controllers) {
        controller.processMouseReleased();
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.mouseMoved event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseMoved() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processMouseMoved();
    }
    if (stageManager.getActiveStage() != stageManager.getDefaultStage()) {
      for (Controller controller : stageManager.defaultStage.controllers) {
        controller.processMouseMoved();
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.keyPressed event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyPressed() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processKeyPressed();
    }
    if (stageManager.getActiveStage() != stageManager.getDefaultStage()) {
      for (Controller controller : stageManager.defaultStage.controllers) {
        controller.processKeyPressed();
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.keyReleased event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyReleased() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processKeyReleased();
    }
    if (stageManager.getActiveStage() != stageManager.getDefaultStage()) {
      for (Controller controller : stageManager.defaultStage.controllers) {
        controller.processKeyReleased();
      }
    }
  }
}
