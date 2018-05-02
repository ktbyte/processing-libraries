import java.util.*;

KTGUI ktgui;
Button jumpButton, anotherButton, nextStageBtn;
Window w1, w2, w3;
Stage s1, s2, s3;
Stage alignStage;
boolean debug = true;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(800, 500);
  ktgui = new KTGUI(this); // default stage is automatically created

  // this button will be visible always because it will be located on default stage
  nextStageBtn = ktgui.createButton("NextStage", width - 120, height - 70, 100, 50);
  nextStageBtn.alignAboutApplet(RIGHT, BOTTOM);
  nextStageBtn.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Next-Stage-Button was pressed!");
      ktgui.stageManager.goToNextStage();
    }
  }
  );

  s1 = ktgui.stageManager.createStage("stage_1");
  anotherButton = ktgui.createButton("Go To Stage_2", 50, height - 70, 150, 50);
  anotherButton.alignAboutApplet(LEFT, BOTTOM);
  anotherButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The anotherButton (goToStage(1)) was pressed!");
      ktgui.stageManager.goToStage(1);
    }
  }
  );
  s1.registerController(anotherButton);

  // Now, the "s1" stage is "active". So, the both 'w1' and 'nextStageButton' are automatically attached to this stage. 
  // We can still use 's1.attachController(Controller) though.
  s2 = ktgui.stageManager.createStage("stage_2");
  Pane pane = ktgui.createPane((int)(width * 0.5 - 200), 240, 400, 200);  
  pane.alignAboutApplet(CENTER, BOTTOM);
  pane.isDragable = true;
  s2.registerController(pane);


  // Now, the "s2" stage is "active". So, the jumpButton is automatically attached to this stage.
  // We can use 's2.attachController(Controller) though.
  s3 = ktgui.stageManager.createStage("stage_3");
  jumpButton = ktgui.createButton("Jump!", 50, 50, 100, 50);
  jumpButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Jumping Button was pressed!");
      if (jumpButton.parentWindow == w3) {
        //w2.attachController(jumpButton);
        w2.addController(jumpButton, LEFT, 0);
      } else if (jumpButton.parentWindow == w2) {
        //w3.attachController(jumpButton);
        w3.addController(jumpButton, RIGHT, 0);
      }
    }
  }
  );

  // The "s2" stage is still "active". So, the both windows are automatically attached to this stage.
  // We can still use 's2.attachController(Controller) though.
  w2 = ktgui.createWindow("Window_2", 400, 220, 300, 200);
  w2.alignAboutApplet(LEFT, 0);
  s3.registerController(w2);

  w3 = ktgui.createWindow("Window_3", 10, 220, 300, 200);
  w3.alignAboutApplet(RIGHT, 0); 
  w3.addController(jumpButton, CENTER, CENTER);
  s3.registerController(w3);

  alignStage = ktgui.stageManager.createStage("Aligning");

  Pane p1 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  p1.alignAboutApplet(LEFT, TOP);
  Button p1b1 = ktgui.createButton("Top", 10, 10, 180, 40);
  p1b1.setPassiveColor(color(200, 120, 50));
  p1.addController(p1b1, CENTER, TOP);
  Button p1b2 = ktgui.createButton("Below & Center", 10, 10, 160, 40);
  p1.attachController(p1b2);
  p1b2.stackAbout(p1b1, BOTTOM, CENTER);
  Button p1b3 = ktgui.createButton("Below & Left", 10, 10, 140, 40);
  p1.attachController(p1b3);
  p1b3.stackAbout(p1b2, BOTTOM, LEFT);
  Button p1b4 = ktgui.createButton("Below & Right", 10, 10, 120, 40);
  p1.attachController(p1b4);
  p1b4.stackAbout(p1b3, BOTTOM, RIGHT);
  alignStage.registerController(p1);

  Pane p2 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  p2.alignAboutApplet(CENTER, TOP);
  Button p2b1 = ktgui.createButton("Center", 10, 10, 180, 40);
  p2b1.setPassiveColor(color(20, 200, 150));
  p2.addController(p2b1, CENTER, CENTER);
  Button p2b2 = ktgui.createButton("Below & Center", 10, 10, 160, 40);
  p2.attachController(p2b2);
  p2b2.stackAbout(p2b1, BOTTOM, CENTER);
  Button p2b3 = ktgui.createButton("Below & Left", 10, 10, 140, 40);
  p2.attachController(p2b3);
  p2b3.stackAbout(p2b2, BOTTOM, LEFT);
  Button p2b4 = ktgui.createButton("Below & Right", 10, 10, 120, 40);
  p2.attachController(p2b4);
  p2b4.stackAbout(p2b3, BOTTOM, RIGHT);
  alignStage.registerController(p2);

  Pane p3 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  p3.alignAboutApplet(RIGHT, TOP);
  Button p3b1 = ktgui.createButton("Bottom", 10, 10, 180, 40);
  p3b1.setPassiveColor(color(250, 20, 200));
  p3.addController(p3b1, CENTER, BOTTOM);
  Button p3b2 = ktgui.createButton("Above & Center", 10, 10, 160, 40);
  p3.attachController(p3b2);
  p3b2.stackAbout(p3b1, TOP, CENTER);
  Button p3b3 = ktgui.createButton("Above & Left", 10, 10, 140, 40);
  p3.attachController(p3b3);
  p3b3.stackAbout(p3b2, TOP, LEFT);
  Button p3b4 = ktgui.createButton("Above & Right", 10, 10, 120, 40);
  p3.attachController(p3b4);
  p3b4.stackAbout(p3b3, TOP, RIGHT);
  alignStage.registerController(p3);

  ktgui.stageManager.goToStage(alignStage);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw() {
  background(170, 220, 170);
  //
  fill(0);
  textSize(20);
  textAlign(RIGHT, CENTER);
  textFont(createFont("monospaced", 16));
  text("activeStage.name:" + ktgui.stageManager.activeStage.name, width - 10, 10);
  text("activeStage.index:" + ktgui.stageManager.stages.indexOf(ktgui.stageManager.activeStage), width - 10, 30);
  text("size():" + ktgui.stageManager.stages.size(), width - 10, 50);

  if (debug) {
    textSize(10);
    int YSHIFT = 12;  
    int ypos = 0;
    textAlign(LEFT, CENTER);
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    for (Controller controller : ktgui.stageManager.defaultStage.controllers) {
      if (controller.title != null) { 
        text("defaultStage: " + controller.title.replaceAll("\n", ""), 10, ypos+=YSHIFT);
      }
    }
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    for (Controller controller : ktgui.stageManager.activeStage.controllers) {
      if (controller.title != null) {
        text("activeStage: " + controller.title, 10, ypos+=YSHIFT);
      }
    }
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    for (Stage stage : ktgui.stageManager.stages) {
      for (Controller controller : stage.controllers) {
        if (controller.title != null) { 
          text("stage." + stage.name + ": " + controller.title, 10, ypos+=YSHIFT);
        }
      }
    }
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    text("alignStage.controllers.size():" + alignStage.controllers.size(), 10, ypos+=YSHIFT);
  }
}

void keyPressed() {
  ktgui.stageManager.goToNextStage();
}
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
  
  final int ALIGN_GAP = 20;

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
    for (Controller controller : stageManager.defaultStage.controllers) {
      controller.processMouseDragged();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.mousePressed event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mousePressed() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processMousePressed();
    }
    for (Controller controller : stageManager.defaultStage.controllers) {
      controller.processMousePressed();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.mouseReleased event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseReleased() { 
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processMouseReleased();
    }
    for (Controller controller : stageManager.defaultStage.controllers) {
      controller.processMouseReleased();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.mouseMoved event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseMoved() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processMouseMoved();
    }
    for (Controller controller : stageManager.defaultStage.controllers) {
      controller.processMouseMoved();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.keyPressed event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyPressed() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processKeyPressed();
    }
    for (Controller controller : stageManager.defaultStage.controllers) {
      controller.processKeyPressed();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the PApplet.keyReleased event to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyReleased() {
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processKeyReleased();
    }
    for (Controller controller : stageManager.defaultStage.controllers) {
      controller.processKeyReleased();
    }
  }
}
/**********************************************************************************************************************
 * A Stage can have multple controllers.
 * The KTGUI class should handle the transition from one Stage to another.
 * Only one Stage can be active at a time. 
 * Only the GUI elements from the active Stage will be displayed
 * This allows the sharing of variables between different Stages, by storing/retriving data from the 'context' object
 *********************************************************************************************************************/
public class Stage {
  List<Controller> controllers;
  String name;

  Stage(String name) {
    this.name = name;
    this.controllers = new ArrayList<Controller>();
  }

  void draw() {
    for (Controller controller : controllers) {
      if (controller.isActive) {
        controller.updateGraphics();
        controller.draw();
      }
    }
  }

  void registerController(Controller controller) {
    String controllerClassName = controller.getClass().getName();
    String[] tokens = splitTokens(controllerClassName, ".$");
    if (tokens.length > 1) controllerClassName = tokens[1];
    println("Trying to register '" + controller.title + "' " + controllerClassName + " in '" + name + "' stage.");

 
    // try to remove controller from default stage then
    if (ktgui.stageManager.defaultStage.controllers.contains(controller)) {
      println("\tdefaultStage already contains this controller: --> removing from default stage.");
      ktgui.stageManager.defaultStage.unregisterController(controller);
    }

    // try to remove controller from active stage then
    if (ktgui.stageManager.activeStage != null) {
      if (ktgui.stageManager.activeStage.controllers.contains(controller)) {
      println("\tactiveStage already contains this controller: --> removing from active stage.");
        ktgui.stageManager.activeStage.unregisterController(controller);
      }
    }

    // add controller to this stage
    if (!controllers.contains(controller)) {
      controllers.add(controller);
      controller.parentStage = this;
      println("\tAdded to controllers list successfully, new parentStage is (" + name + ")");
      if (tokens.length > 1) {
        // try to add all child components of controller, if it is of type Window
        if (tokens[1].contains("Window")) {
          Window window = (Window) controller;
          window.registerChildControllers();
        }
        // try to add all child components of controller, if it is of type Pane
        if (tokens[1].contains("Pane")) {
          Pane pane = (Pane) controller;
          pane.registerChildControllers();
        }
      } else {
        println("....Cannot register child controllers of '" + name + "'");
      }
    } else {
      println("\talready exist.");
    }
    println("------------------------------------------------------------------------------------");
  }

  void unregisterController(Controller controller) {
    if (controllers.contains(controller)) {
      println("\t" + name + " already contains controller '" + controller.title + "': --> removing from '" + name + "' stage.");
      controllers.remove(controller);
      controller.parentStage = null;
    }
  }
}
/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
class StageManager {

  List<Stage> stages; // replace 'List' with 'Set' to prevent duplicates
  Stage activeStage;
  Stage defaultStage;

  StageManager() {
    stages = new ArrayList<Stage>();
    defaultStage = new Stage("Default");
    activeStage = defaultStage;
  }

  Stage createStage(String name) {
    Stage stage = new Stage(name);
    stages.add(stage);
    activeStage = stage;
    return stage;
  }

  void goToStage(Stage stage) {
    activeStage = stage;
  }

  void goToStage(int numStage) {
    if (numStage > 0 && numStage < stages.size()) {
      activeStage = stages.get(numStage);
    }
  }

  void goToNextStage() {
    int indexOfCurrentStage = stages.indexOf(activeStage);
    if (indexOfCurrentStage < stages.size() - 1) {
      activeStage = stages.get(indexOfCurrentStage + 1);
    } else {
      activeStage = stages.get(0);
    }
  }

  void closeWindow(Window window) {
    println("closeWindow(Window) for window:" + window.title + " has been called.");
    
    for (Controller controller : window.controllers) {
      println("Controller:" + controller.title + " 'isActive' variable is set to FALSE");  
      controller.isActive = false;
      ktgui.garbageList.put(controller, millis());
    }
    
    window.isActive = false;
    ktgui.garbageList.put(window, millis());
  } //<>//
}
/**********************************************************************************************************************
 * This class automatically receives events from PApplet when they happen.
 * Every KTGUI component (controller) should extend this class in order to be able to receive the mouse and keyboard 
 * events.
 * One should override only the 'needed' event methods. This allows to save time and decrease the amount of code.
 * One should always overridde the 'draw' method.
 *********************************************************************************************************************/
public abstract class Controller {
  String title;
  int posx, posy, w, h;  
  boolean isPressed, isHovered;
  boolean isActive = true;
  boolean isDragable = true;
  ArrayList<KTGUIEventAdapter> adapters = new ArrayList<KTGUIEventAdapter>();
  Window parentWindow = null;
  Pane parentPane = null;
  Stage parentStage = null;
  PGraphics pg;
  color hoveredColor = ktgui.COLOR_FG_HOVERED;
  color pressedColor = ktgui.COLOR_FG_PRESSED;
  color passiveColor = ktgui.COLOR_FG_PASSIVE;

  void updateGraphics() {
  }
  void draw() {
  }
  void processMouseMoved() {
  }
  void processMousePressed() {
  }
  void processMouseReleased() {
  }
  void processMouseDragged() {
  }
  void processKeyPressed() {
  }
  void processKeyReleased() {
  }
  void addEventAdapter(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
  }
  void setParentWindow(Window window) {
    this.parentWindow = window;
  }
  void setParentPane(Pane pane) {
    this.parentPane = pane;
  }
  void setTitle(String title) {
    this.title = title;
  }
  void setHoveredColor(color c) {
    hoveredColor = c;
  }
  void setPressedColor(color c) {
    pressedColor = c;
  }
  void setPassiveColor(color c) {
    passiveColor = c;
  }
  PGraphics getGraphics() {
    return pg;
  }
  int getPosX() {
    return posx;
  }
  int getPosY() {
    return posy;
  }
  void setPosX(int posx) {
    this.posx = posx;
  }
  void setPosY(int posy) {
    this.posy = posy;
  }

  void alignAboutApplet(int hAlign, int vAlign) {
    switch (hAlign) {
    case LEFT:
      this.posx = ktgui.ALIGN_GAP;
      break;
    case RIGHT:
      this.posx = width - this.w - ktgui.ALIGN_GAP;
      break;
    case CENTER:
      this.posx = (int)(width * 0.5 - this.w * 0.5);
      break;
    default:
      break;
    }
    //
    switch (vAlign) {
    case TOP:
      this.posy = ktgui.ALIGN_GAP;
      break;
    case BOTTOM:
      this.posy = height - this.h - ktgui.ALIGN_GAP; 
      break;
    case CENTER:
      this.posy = (int)(height * 0.5 - this.h * 0.5);
      break;
    default:
      break;
    }
  }

  void alignAbout(Controller controller, int hAlign, int vAlign) {
    switch (hAlign) {
    case LEFT:
      this.posx = ktgui.ALIGN_GAP;
      break;
    case RIGHT:
      this.posx = controller.w - this.w - ktgui.ALIGN_GAP;
      break;
    case CENTER:
      this.posx = (int)(controller.w * 0.5 - this.w * 0.5);
      break;
    default:
      break;
    }
    //
    switch (vAlign) {
    case TOP:
      this.posy = ktgui.ALIGN_GAP;
      break;
    case BOTTOM:
      this.posy = controller.h - this.h - ktgui.ALIGN_GAP; 
      break;
    case CENTER:
      this.posy = (int)(controller.h * 0.5 - this.h * 0.5);
      break;
    default:
      break;
    }
  }

  void stackAbout(Controller controller, int direction, int align) {
    switch (direction) {

    case TOP: // stack this controller above the given controller
      this.posy = controller.posy - this.h;
      switch (align) {
      case LEFT:
        this.posx = controller.posx;
        break;
      case RIGHT:
        this.posx = controller.posx + controller.w - this.w;
        break;
      case CENTER:
        this.posx = (int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5);
        break;
      default:
        break;
      }
      break;

    case BOTTOM: // stack this controller below the given controller
      this.posy = controller.posy + this.h; 
      switch (align) {
      case LEFT:
        this.posx = controller.posx;
        break;
      case RIGHT:
        this.posx = controller.posx + controller.w - this.w;
        break;
      case CENTER:
        this.posx = (int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5);
        break;
      default:
        break;
      }
      break;

    case LEFT: // stack this controller to the left about given controller
      this.posx = controller.posx - this.w;
      switch (align) {
      case TOP:
        this.posy = controller.posy;
        break;
      case BOTTOM:
        this.posy = controller.posy + controller.h - this.h;
        break;
      case CENTER:
        this.posy = (int)(controller.posy + controller.h * 0.5) - (int)(this.h * 0.5);
        break;
      default:
        break;
      }
      break;

    case RIGHT:  // stack this controller to the right about given controller
      this.posx = controller.posx + this.w;
      switch (align) {
      case TOP:
        this.posy = controller.posy;
        break;
      case BOTTOM:
        this.posy = controller.posy + controller.h - this.h;
        break;
      case CENTER:
        this.posy = (int)(controller.posy + controller.h * 0.5) - (int)(this.h * 0.5);
        break;
      default:
        break;
      }
      break;
      
    default: // do nothing
      break;
    }
  }
}
/**********************************************************************************************************************
 * This abstract class should be extended by the KTGUI components (controllers)
 *********************************************************************************************************************/
abstract class KTGUIEventAdapter {
  void onMousePressed() {
  }
  void onMouseReleased() {
  }
  void onMouseMoved() {
  }
  void onMouseDragged() {
  }
  void onKeyReleased() {
  }
  void onKeyPressed() {
  }
  void println(String string){
    PApplet.println(string);
  }
}
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

  CloseButton windowCloseBtn;
  // Border border;
  // TitleBar titleBar;
  // MenuBar menuBar;

  Window(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    updateSize(w, h);

    title = "a Window";

    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);

    windowCloseBtn = new CloseButton(w - TITLE_BAR_HEIGHT + 2, 2, TITLE_BAR_HEIGHT - 4, TITLE_BAR_HEIGHT - 4);
    attachController(windowCloseBtn);
    ktgui.stageManager.defaultStage.registerController(windowCloseBtn);
  }

  Window(String title, int posx, int posy, int w, int h) {
    this.title = title;
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    updateSize(w, h);

    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);

    windowCloseBtn = new CloseButton(w - TITLE_BAR_HEIGHT + 2, 2, TITLE_BAR_HEIGHT - 4, TITLE_BAR_HEIGHT - 4);
    setTitle(title);
    attachController(windowCloseBtn);
    ktgui.stageManager.defaultStage.registerController(windowCloseBtn);
  }

  void setTitle(String string) {
    title = string;
    windowCloseBtn.setTitle("CloseButton-of:" + title);
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
    if (isActive) {
      // detach from existing window first (if exist)
      if (controller.parentWindow != null) {
        controller.parentWindow.detachController(controller); // reset parentWindow
      }
      // add to the list of controllers
      if (!controllers.contains(controller)) {
        controllers.add(controller);
        controller.setParentWindow(this);
        // try to register in parentStage
        registerChildController(controller);
      }
    }
  }

  void addController(Controller controller, int hAlign, int vAlign) {
    if (isActive) {
      controller.alignAbout(this, hAlign, vAlign);
      attachController(controller);
    }
  }

  void registerChildController(Controller controller) {
    if (parentStage != null) {
      parentStage.registerController(controller);
    }
  }

  void registerChildControllers() {
    if (parentStage != null) {
      for (Controller controller : controllers) {
        registerChildController(controller);
      }
    }
  }

  void detachController(Controller controller) {
    controller.parentWindow = null;
    controllers.remove(controller);
  }

  void detachAllControllers() {
    for (Controller controller : controllers) {
      detachController(controller);
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
    if (isDragable) {
      if (isTitleBarPressed) {
        posx += mouseX - pmouseX;
        posy += mouseY - pmouseY;
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMouseDragged();
        }
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
}


/*****************************************************************************************************
 * 
 ****************************************************************************************************/
class CloseButton extends Button {

  CloseButton(int posx, int posy, int w, int h) {
    super(posx, posy, w, h);
  }

  CloseButton(String title, int posx, int posy, int w, int h) {
    super(title, posx, posy, w, h);
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
    super.processMousePressed();
    if (isPressed) {
      ktgui.stageManager.closeWindow(parentWindow);
    }
  }
}

/**********************************************************************************************************************
 * This is an example of the KTGUI component (controller).
 * This class extends the 'Controller' class.
 * This class overrides only the 'mouse-related' methods of the 'Controller' class.
 * The object of this class can be 'Pressed', 'Hovered', 'Released' and 'Dragged'.
 *********************************************************************************************************************/
class Button extends Controller {

  Button(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    isActive = true;

    title = "a Button";
    pg = createGraphics(w + 1, h + 1);

    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  Button(String title, int posx, int posy, int w, int h) {
    this.title = title;
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    isActive = true;

    pg = createGraphics(w + 1, h + 1);

    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }
  void updateGraphics() {
    pg.beginDraw();
    pg.rectMode(CORNER);
    if (isHovered && !isPressed) {
      pg.fill(hoveredColor);
    } else if (isHovered && isPressed) {
      pg.fill(pressedColor);
    } else {
      pg.fill(passiveColor);
    }
    pg.rect(0, 0, w, h);
    pg.fill(255);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(14);
    pg.text(title, w*0.5, h*0.5);
    pg.endDraw();
  }

  void draw() {
    if (parentWindow == null && parentPane == null) {
      image(pg, posx, posy);
    }
  }

  // process mouseMoved event received from PApplet
  void processMouseMoved() {
    if (isPointInside(mouseX, mouseY)) {
      isHovered = true;
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseMoved();
      }
    } else {
      isHovered = false;
    }
  }

  // process mousePressed event received from PApplet
  void processMousePressed() {
    if (isActive) {
      if (isPointInside(mouseX, mouseY)) {
        isPressed = true;
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMousePressed();
        }
      } else {
        isPressed = false;
      }
    }
  }

  // process mouseReleased event received from PApplet
  void processMouseReleased() {
    isPressed = false;
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseReleased();
    }
  }

  // process mouseDragged event received from PApplet
  void processMouseDragged() {
    if (isDragable) {
      if (isPressed) {
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMouseDragged();
        }
      }
    }
  }

  boolean isPointInside(int x, int y) {
    boolean isInside = false;

    //int px = (parentWindow == null) ? 0 : parentWindow.posx;
    //int py = (parentWindow == null) ? 0 : parentWindow.posy;
    int px = 0;
    int py = 0;

    if (parentWindow == null && parentPane != null) {
      px = parentPane.posx;
      py = parentPane.posy;
    } else if (parentWindow != null && parentPane == null) {
      px = parentWindow.posx;
      py = parentWindow.posy;
    }

    if (x > px + posx && x < px + posx + w) {
      if (y > py + posy && y < py + posy + h) {
        isInside = true;
      }
    }

    return isInside;
  }
}
/**********************************************************************************************************************
 * There are two points to mention. 
 *
 * The first one: This class should be used with Window class. In particular, the object of this class should be  
 * contained in the 'Window' object as a 'part' of it. 
 *
 * The second one: This class should be possible to use as a standalone object.
 *********************************************************************************************************************/
class Pane extends Controller {

  ArrayList<Controller> controllers = new ArrayList<Controller>();

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
      pg.image(controller.getGraphics(), controller.getPosX(), controller.getPosY());
      pg.endDraw();
    }
  }

  void attachController(Controller controller) {
    if (isActive) {
      // detach from existing pane first (if exist)
      if (controller.parentPane != null) {
        controller.parentPane.detachController(controller); // reset parentWindow
      }
      // add to the list of controllers
      if (!controllers.contains(controller)) {
        controllers.add(controller);
        controller.setParentPane(this);
        // try to register in parentStage
        registerChildController(controller);
      }
    }
  }

  void addController(Controller controller, int hAlign, int vAlign) {
    if (isActive) {
      controller.alignAbout(this, hAlign, vAlign);
      attachController(controller);
    }
  }

  void detachController(Controller controller) {
    controller.parentPane = null;
    controllers.remove(controller);
  }

  void detachAllControllers() {
    for (Controller controller : controllers) {
      detachController(controller);
    }
  }

  void registerChildController(Controller controller) {
    if (parentStage != null) {
      parentStage.registerController(controller);
    }
  }

  void registerChildControllers() {
    if (parentStage != null) {
      for (Controller controller : controllers) {
        registerChildController(controller);
      }
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
