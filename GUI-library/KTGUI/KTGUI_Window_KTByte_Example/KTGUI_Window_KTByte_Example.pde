KTGUI ktgui;
Button jumpButton, anotherButton, nextStageBtn;
Pane pane;
Window w1, w2, w3;
Stage s1, s2, s3;
Stage alignStage;
boolean debug = false;
Button dbgButton;
double counter = 0;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(800, 500);
  ktgui = new KTGUI(this); // default stage is automatically created

  dbgButton = ktgui.createButton("Debug", 20, 50, 100, 50);
  dbgButton.alignAboutApplet(CENTER, BOTTOM);
  dbgButton.addEventAdapter(new KTGUIEventAdapter() {
    void onMousePressed() {
      debug = !debug;
    }
  }
  );

  // this button will be visible always because it will be located on default stage
  nextStageBtn = ktgui.createButton("NextStage", width - 120, height - 70, 100, 50);
  nextStageBtn.alignAboutApplet(RIGHT, BOTTOM);
  nextStageBtn.addEventAdapter(new KTGUIEventAdapter() { 
    void onMousePressed() {
      msg("Callback message: The Next-Stage-Button was pressed!");
      ktgui.stageManager.goToNextStage();
    }
  }
  );

  s1 = ktgui.stageManager.createStage("stage_1");
  anotherButton = ktgui.createButton("Go To Stage_2", 50, height - 70, 150, 50);
  anotherButton.alignAboutApplet(LEFT, BOTTOM);
  anotherButton.addEventAdapter(new KTGUIEventAdapter() {
    void onMousePressed() {
      msg("Callback message: The anotherButton (goToStage(1)) was pressed!");
      ktgui.stageManager.goToStage(s2);
    }
  }
  );
  s1.registerController(anotherButton);

  // Now, the "s1" stage is "active". So, the both 'w1' and 'nextStageButton' are automatically attached to this stage. 
  // We can still use 's1.attachController(Controller) though.
  s2 = ktgui.stageManager.createStage("stage_2");
  pane = ktgui.createPane((int)(width * 0.5 - 200), 200, 400, 200);  
  pane.alignAboutApplet(CENTER, CENTER);
  pane.isDragable = true;
  s2.registerController(pane);


  // Now, the "s2" stage is "active". So, the jumpButton is automatically attached to this stage.
  // We can use 's2.attachController(Controller) though.
  s3 = ktgui.stageManager.createStage("stage_3");
  jumpButton = ktgui.createButton("Jump!", 50, 50, 100, 50);
  jumpButton.addEventAdapter(new KTGUIEventAdapter() {
    void onMousePressed() {
      msg("Callback message: The Jumping Button was pressed!");
      if (jumpButton.parentController == w3.pane) {
        //w2.attachController(jumpButton);
        w2.addController(jumpButton, 0, TOP);
      } else if (jumpButton.parentController == w2.pane) {
        //w3.attachController(jumpButton);
        w3.addController(jumpButton, 0, BOTTOM);
      }
    }
  }
  );

  // The "s3" stage is still "active". So, the both windows are automatically attached to this stage.
  // We can still use 's3.attachController(Controller) though.
  w2 = ktgui.createWindow("Window_2", 10, 220, 300, 200);
  w2.alignAboutApplet(LEFT, BOTTOM);
  s3.registerController(w2);

  w3 = ktgui.createWindow("Window_3", 400, 220, 300, 200);
  //w3.alignAboutApplet(RIGHT, 0);
  w3.stackAbout(w2, TOP, CENTER);
  w3.addController(jumpButton, CENTER, CENTER);
  s3.registerController(w3);

  //   alignStage = ktgui.stageManager.createStage("Aligning");

  //   Pane p1 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  //   p1.alignAboutApplet(LEFT, TOP);
  //   Button p1b1 = ktgui.createButton("Top", 10, 10, 180, 40);
  //   p1b1.setPassiveColor(color(200, 120, 50));
  //   p1.addController(p1b1, CENTER, TOP);
  //   Button p1b2 = ktgui.createButton("Below & Center", 10, 10, 160, 40);
  //   p1.attachController(p1b2);
  //   p1b2.stackAbout(p1b1, BOTTOM, CENTER);
  //   Button p1b3 = ktgui.createButton("Below & Left", 10, 10, 140, 40);
  //   p1.attachController(p1b3);
  //   p1b3.stackAbout(p1b2, BOTTOM, LEFT);
  //   Button p1b4 = ktgui.createButton("Below & Right", 10, 10, 120, 40);
  //   p1.attachController(p1b4);
  //   p1b4.stackAbout(p1b3, BOTTOM, RIGHT);
  //   alignStage.registerController(p1);

  //   Pane p2 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  //   p2.alignAboutApplet(CENTER, TOP);
  //   Button p2b1 = ktgui.createButton("Center", 10, 10, 180, 40);
  //   p2b1.setPassiveColor(color(20, 200, 150));
  //   p2.addController(p2b1, CENTER, CENTER);
  //   Button p2b2 = ktgui.createButton("Below & Center", 10, 10, 160, 40);
  //   p2.attachController(p2b2);
  //   p2b2.stackAbout(p2b1, BOTTOM, CENTER);
  //   Button p2b3 = ktgui.createButton("Below & Left", 10, 10, 140, 40);
  //   p2.attachController(p2b3);
  //   p2b3.stackAbout(p2b2, BOTTOM, LEFT);
  //   Button p2b4 = ktgui.createButton("Below & Right", 10, 10, 120, 40);
  //   p2.attachController(p2b4);
  //   p2b4.stackAbout(p2b3, BOTTOM, RIGHT);
  //   alignStage.registerController(p2);

  //   Pane p3 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  //   p3.alignAboutApplet(RIGHT, TOP);
  //   Button p3b1 = ktgui.createButton("Bottom", 10, 10, 180, 40);
  //   p3b1.setPassiveColor(color(250, 20, 200));
  //   p3.addController(p3b1, CENTER, BOTTOM);
  //   Button p3b2 = ktgui.createButton("Above & Center", 10, 10, 160, 40);
  //   p3.attachController(p3b2);
  //   p3b2.stackAbout(p3b1, TOP, CENTER);
  //   Button p3b3 = ktgui.createButton("Above & Left", 10, 10, 140, 40);
  //   p3.attachController(p3b3);
  //   p3b3.stackAbout(p3b2, TOP, LEFT);
  //   Button p3b4 = ktgui.createButton("Above & Right", 10, 10, 120, 40);
  //   p3.attachController(p3b4);
  //   p3b4.stackAbout(p3b3, TOP, RIGHT);
  //   alignStage.registerController(p3);

  //ktgui.stageManager.goToStage(s1);

  //   msg(w2.pane.w + ":" + w2.pane.h);
  //msg("Ready!");
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw() {
  background(170, 220, 170);
  noSmooth();
  //
  updateWarning();
  updateDebugInfo();
  updatePaneCanvas();
  updateSecondWindowCanvas();
  updateThirdWindowCanvas();
  fill(0);
}


void updateWarning() {
  textFont(createFont("monospaced", 26));
  textAlign(CENTER, CENTER);
  fill(0);
  text("GO TO STAGE_2 TO SEE THE DYNAMIC SHAPES\n DRAWED ON THE PANE'S CANVAS", width * 0.5, height * 0.75);
}

void updatePaneCanvas() {
  PGraphics g = createGraphics(pane.w, pane.h);
  g.beginDraw();
  g.fill(200, 100, 100);
  g.textSize(36);
  g.textAlign(CENTER);
  g.text("Drag this pane!", pane.w * 0.5, 40);
  g.pushMatrix();
  g.translate(pane.w * 0.5, pane.h * 0.5);
  g.rotate((float)(counter+=0.01));
  g.rectMode(CENTER);
  g.fill(200);
  g.stroke(0);
  g.ellipse(0, 0, 300, 20);
  g.popMatrix();
  g.pushMatrix();
  g.translate(pane.w * 0.25, pane.h * 0.5);
  g.rotate(-frameCount*0.01);
  g.rectMode(CENTER);
  g.fill(200);
  g.stroke(0);
  g.rect(0, 0, 100, 20);
  g.popMatrix();
  g.pushMatrix();
  g.translate(pane.w * 0.75, pane.h * 0.5);
  g.rotate(-frameCount*0.01);
  g.rectMode(CENTER);
  g.fill(200);
  g.stroke(0);
  g.rect(0, 0, 100, 20);
  g.popMatrix();
  g.endDraw();
  pane.updateUserDefinedGraphics(g);
}


void updateSecondWindowCanvas() {
  PGraphics g = createGraphics(w2.pane.w, w2.pane.h);
  g.beginDraw();
  g.fill(100, 100, 250);
  g.textSize(36);
  g.textAlign(CENTER);
  g.text("Drag this window!", w2.pane.w * 0.5, 40);
  g.translate(w2.pane.w * 0.5, w2.pane.h * 0.5);
  g.rotate(frameCount*0.05);
  g.translate(w2.pane.w * 0.25, 0);
  g.rotate(-frameCount*0.2);
  g.pushMatrix();
  g.stroke(0);
  g.strokeWeight(1);
  g.line(-5, 5, 0, 45);
  g.line(0, 45, 5, 5);
  g.line(5, 5, 45, 0);
  g.line(45, 0, 5, -5);
  g.line(5, -5, 0, -45);
  g.line(0, -45, -5, -5);
  g.line(-5, -5, -45, 0);
  g.line(-45, 0, -5, 5);
  g.popMatrix();
  g.endDraw();
  w2.pane.updateUserDefinedGraphics(g);
}


void updateThirdWindowCanvas() {
  PGraphics g = createGraphics(w3.pane.w, w3.pane.h);
  g.beginDraw();
  g.fill(250, 50, 90);
  g.textSize(36);
  g.textAlign(CENTER);
  g.text("Press the button!", w3.pane.w * 0.5, 40);
  g.endDraw();
  w3.pane.updateUserDefinedGraphics(g);
}

void msg(String msg) {
  if (debug) {
    println(msg);
  }
}

void updateDebugInfo() {
  int YSHIFT = 12;  
  int ypos = 0;
  textFont(createFont("monospaced", 16));
  textAlign(RIGHT, CENTER);
  textSize(14);
  YSHIFT = 12;  
  ypos = 0;
  textAlign(LEFT, CENTER);
  fill(0);
  text("----------------------------------------------------", 10, ypos+=YSHIFT);
  text("mouseX:" + mouseX + ", mouseY:" + mouseY, 10, ypos+=YSHIFT);
  text("----------------------------------------------------", 10, ypos+=YSHIFT);
  text("frameRate:" + frameRate, 10, ypos+=YSHIFT);
  text("----------------------------------------------------", 10, ypos+=YSHIFT);
  if (debug) {
    for (Controller controller : ktgui.stageManager.defaultStage.controllers) {
      if (controller.title != null) { 
        text("defaultStage: " + controller.title + 
          ", posx:" + controller.posx + 
          ", posy:" + controller.posy
          , 10, ypos+=YSHIFT);
      }
    }
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    for (Controller controller : ktgui.stageManager.activeStage.controllers) {
      if (controller.title != null) { 
        text("activeStage: " + controller.title + 
          ", posx:" + controller.posx + 
          ", posy:" + controller.posy
          , 10, ypos+=YSHIFT);
      }
    }

    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    for (Stage stage : ktgui.stageManager.stages) {
      text("stage: " + stage.name, 10, ypos+=YSHIFT);
    }
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
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
  ArrayList<Controller> controllers;
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
    msg("Trying to register '" + controller.title + "' " + controllerClassName + " in '" + name + "' stage.");

    // try to remove controller from default stage then
    if (ktgui.stageManager.defaultStage.controllers.contains(controller)) {
      msg("\tdefaultStage already contains this controller: --> removing from default stage.");
      ktgui.stageManager.defaultStage.unregisterController(controller);
    }

    // try to remove controller from active stage 
    if (ktgui.stageManager.activeStage != null) {
      if (ktgui.stageManager.activeStage.controllers.contains(controller)) {
        msg("\tactiveStage already contains this controller: --> removing from active stage.");
        ktgui.stageManager.activeStage.unregisterController(controller);
      }
    }

    // add controller to this stage
    String[] tokens = splitTokens(controllerClassName, ".$");
    if (tokens.length > 1) controllerClassName = tokens[1];
    if (!this.controllers.contains(controller)) {
      msg("Before: controllers.size() of stage '" + name + "':" + this.controllers.size());
      msg("Before: stageManager.stages.size() of stage '" + name + "':" + this.controllers.size());
      this.controllers.add(controller);
      controller.parentStage = this;
      msg("\tAdding '"  + controller.title + "' to '" + name + "' stage controllers list. Successfully.");
      if (tokens.length > 1) {
        // // try to add all child components of controller, if it is of type Window
        // if (tokens[1].equalsIgnoreCase("Window")) {
        //   Window window = (Window) controller;
        //   window.registerChildControllers();
        // }
        // // try to add all child components of controller, if it is of type Pane
        // if (tokens[1].equalsIgnoreCase("Pane")) {
        //   Pane pane = (Pane) controller;
        //   pane.registerChildControllers();
        // }
        // // try to add all child components of controller, if it is of type WindowPane
        // if (tokens[1].equalsIgnoreCase("WindowPane")) {
        //   WindowPane windowPane = (WindowPane) controller;
        //   windowPane.registerChildControllers();
        // }
        if (controller.controllers.size() > 0) {
          controller.registerChildControllers();
        }
        msg("After: controllers.size() of stage '" + name + "':" + this.controllers.size());
      } else {
        msg("....Cannot register child controllers of '" + controller.title + "' in stage '" + name + "'");
      }
    } else {
      msg("'" + controller.title + "' already present in stage '" + name + "'. --- skip ---");
    }
    msg("(ktgui.stageManager.activeStage == null):" + (ktgui.stageManager.activeStage == null));
    msg("------------------------------------------------------------------------------------");
  }

  void unregisterController(Controller controller) {
    if (controllers.contains(controller)) {
      msg("Unregistering controller '" + controller.title + "' from '" + name + "' stage.");
      this.controllers.remove(controller);
      controller.parentStage = null;
    }
  }
}
/********************************************************************************************************************** 
 * 
 *********************************************************************************************************************/
public class StageManager {

  List<Stage> stages; // replace 'List' with 'Set' to prevent duplicates
  private Stage activeStage;
  private Stage defaultStage;

  StageManager() {
    stages = new ArrayList<Stage>();
    defaultStage = new Stage("Default");
    activeStage = defaultStage;
    msg("StageManager is created. activeStage.name is '" + activeStage.name + "'");
    msg("------------------------------------------------------------------------------------");
  }

  Stage createStage(String name) {
    Stage stage = new Stage(name);
    stages.add(stage);
    activeStage = stage;
    msg("stage '" + name + "' is created. activeStage.name is '" + activeStage.name + "'");
    msg("------------------------------------------------------------------------------------");
    return stage;
  }

  void goToStage(Stage stage) {
    if (stage != null) {
      activeStage = stage;
    }
  }

  void goToStage(int numStage) {
    if (numStage > -1 && numStage < stages.size()) {
      activeStage = stages.get(numStage - 1);
    }
  }

  void goToNextStage() {
    msg("Go to next stage initiated!");
    int indexOfCurrentStage = stages.indexOf(activeStage);
    if (indexOfCurrentStage < stages.size() - 1) {
      activeStage = stages.get(indexOfCurrentStage + 1);
    } else {
      activeStage = stages.get(0);
    }
    msg("The name of the actveStage is '" + activeStage.name + "'");
  }


  public Stage getActiveStage() {
    return activeStage;
  }

  public Stage getDefaultStage() {
    return defaultStage;
  }
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
    msg("KTGUI instance created!");
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
    msg("Mouse pressed at " + mouseX + ":" + mouseY);
    msg("Trying to process... ");
    // msg("ktgui.stageManager == null):" + (ktgui.stageManager == null) + ". ");
    // msg("ktgui.stageManager.defaultStage == null):" + (ktgui.stageManager.defaultStage == null) + ". ");
    // msg("ktgui.stageManager.activeStage == null):" + (ktgui.stageManager.activeStage == null) + ". ");
    msg(" in activeStage(" + ktgui.stageManager.activeStage.name + ") ... ");
    for (Controller controller : stageManager.activeStage.controllers) {
      controller.processMousePressed();
    }
    msg(" in defaultStage(" + stageManager.defaultStage.name + ") ... ");
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

/**********************************************************************************************************************
 * 
 * 
 *********************************************************************************************************************/
public class EventProcessor {
  boolean isPressed, isHovered;
  boolean isActive = true;
  boolean isDragable = true;

  ArrayList<KTGUIEventAdapter> adapters = new ArrayList<KTGUIEventAdapter>();

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
}


/**********************************************************************************************************************
 * This class automatically receives events from PApplet when they happen.
 * Every KTGUI component (controller) should extend this class in order to be able to receive the mouse and keyboard 
 * events.
 * One should override only the 'needed' event methods. This allows to save time and decrease the amount of code.
 * One should always overridde the 'draw' method.
 *********************************************************************************************************************/
public abstract class Controller extends EventProcessor {
  String title;
  int posx, posy, w, h;  

  ArrayList<Controller> controllers = new ArrayList<Controller>();
  Controller parentController;
  Stage parentStage;

  PGraphics pg;
  PGraphics userpg;

  color hoveredColor = ktgui.COLOR_FG_HOVERED;
  color pressedColor = ktgui.COLOR_FG_PRESSED;
  color passiveColor = ktgui.COLOR_FG_PASSIVE;

  void updateGraphics() {
  }
  void updateUserDefinedGraphics(PGraphics userpg) {
    this.userpg = userpg;
  } 
  void draw() {
    drawControllers();
    drawUserDefinedGraphics();
    image(pg, posx, posy);
  }
  void drawControllers() {
    for (Controller controller : controllers) {
      pg.beginDraw();
      pg.image(controller.getGraphics(), controller.posx, controller.posy);
      pg.endDraw();
    }
  }
  void drawUserDefinedGraphics() {
    pg.beginDraw();
    pg.image(userpg, 0, 0);
    pg.endDraw();
  }
  void setParentController(Controller controller) {
    this.parentController = controller;
  }
  void setTitle(String title) {
    this.title = title;
  }
  void setWidth(int w) {
    this.w = w;
  }
  void setHeight(int h) {
    this.h = h;
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

  void addController(Controller controller, int hAlign, int vAlign) {
    if (isActive) {
      controller.alignAbout(this, hAlign, vAlign);
      attachController(controller);
    }
  }
  void attachController(Controller controller) {
    if (isActive) {
      // detach from existinler first (if exist)
      if (controller.parentController != null) {
        Controller pc = (Controller)controller.parentController;
        pc.detachController(controller); // reset parentWindow
      }
      // add to the list of controllers
      if (!controllers.contains(controller)) {
        controllers.add(controller);
      }
      // set 'this' controller as parent
      controller.setParentController(this);
      // register in parentStage
      registerChildController(controller);
    }
  }
  // register child controller and all its childs (recursively)
  void registerChildController(Controller controller) {
    if (parentStage != null) {
      parentStage.registerController(controller);
      if (controller.controllers.size() > 0) {
        ArrayList<Controller> childControllers = controller.controllers;
        for (Controller child : childControllers) {
          registerChildController(child);
        }
      }
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
    controller.parentController = null;
    controllers.remove(controller);
  }
  void detachAllControllers() {
    for (Controller controller : controllers) {
      detachController(controller);
    }
  }

  // update child controllers positions and all their childs (recursively)
  void updateChildrenPositions(int dx, int dy) {
    for (Controller controller : controllers) {
      controller.posx += dx;
      controller.posy += dy;
      if (controller.controllers.size() > 0) {
        ArrayList<Controller> childControllers = controller.controllers;
        for (Controller child : childControllers) {
          child.updateChildrenPositions(dx, dy);
        }
      }
    }
  }

  void closeControllerRecursively(Controller controller) {
    closeParent(controller);
    closeChilds(controller);
  }

  void closeParent(Controller controller) {
    if (controller.parentController != null) closeParent(controller.parentController);
    for (Controller childController : controllers) {
      closeChilds(childController);
    }
    closeChilds(controller);
  }

  void closeChilds(Controller controller) {
    for (Controller childController : controller.controllers) {
      closeChilds(childController);
      closeController(childController);
    }
  }

  void closeController(Controller controller) {
    msg("Closing '" + controller.title + "' controller.");
    controller.isActive = false;
    ktgui.garbageList.put(controller, millis());
  }

  void alignAboutApplet(int hAlign, int vAlign) {
    switch (hAlign) {
    case LEFT:
      updateChildrenPositions(ktgui.ALIGN_GAP - this.posx, 0);
      this.posx = ktgui.ALIGN_GAP;
      break;
    case RIGHT:
      updateChildrenPositions(width - this.w - ktgui.ALIGN_GAP - this.posx, 0);
      this.posx = width - this.w - ktgui.ALIGN_GAP;
      break;
    case CENTER:
      updateChildrenPositions((int)(width * 0.5 - this.w * 0.5) - this.posx, 0);
      this.posx = (int)(width * 0.5 - this.w * 0.5);
      break;
    default:
      break;
    }
    //
    switch (vAlign) {
    case TOP:
      updateChildrenPositions(0, ktgui.ALIGN_GAP - this.posy);
      this.posy = ktgui.ALIGN_GAP;
      break;
    case BOTTOM:
      updateChildrenPositions(0, height - this.h - ktgui.ALIGN_GAP - this.posy);
      this.posy = height - this.h - ktgui.ALIGN_GAP; 
      break;
    case CENTER:
      updateChildrenPositions(0, (int)(height * 0.5 - this.h * 0.5) - this.posy);
      this.posy = (int)(height * 0.5 - this.h * 0.5);
      break;
    default:
      break;
    }
  }

  void alignAbout(Controller controller, int hAlign, int vAlign) {
    switch (hAlign) {
    case LEFT:
      updateChildrenPositions(ktgui.ALIGN_GAP - this.posx, 0);
      this.posx = ktgui.ALIGN_GAP;
      break;
    case RIGHT:
      updateChildrenPositions(controller.w - this.w - ktgui.ALIGN_GAP - this.posx, 0);
      this.posx = controller.w - this.w - ktgui.ALIGN_GAP;
      break;
    case CENTER:
      updateChildrenPositions((int)(controller.w * 0.5 - this.w * 0.5) - this.posx, 0);
      this.posx = (int)(controller.w * 0.5 - this.w * 0.5);
      break;
    default:
      break;
    }
    //
    switch (vAlign) {
    case TOP:
      updateChildrenPositions(0, ktgui.ALIGN_GAP - this.posy);
      this.posy = ktgui.ALIGN_GAP;
      break;
    case BOTTOM:
      updateChildrenPositions(0, controller.h - this.h - ktgui.ALIGN_GAP - this.posy);
      this.posy = controller.h - this.h - ktgui.ALIGN_GAP; 
      break;
    case CENTER:
      updateChildrenPositions(0, (int)(controller.h * 0.5 - this.h * 0.5) - this.posy);
      this.posy = (int)(controller.h * 0.5 - this.h * 0.5);
      break;
    default:
      break;
    }
  }

  void stackAbout(Controller controller, int direction, int align) {
    switch (direction) {

    case TOP: // stack this controller above the given controller
      updateChildrenPositions(0, controller.posy - this.h - this.posy);
      this.posy = controller.posy - this.h;
      switch (align) {
      case LEFT:
        updateChildrenPositions(controller.posx - this.posx, 0);
        this.posx = controller.posx;
        break;
      case RIGHT:
        updateChildrenPositions((int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5) - this.posx, 0);
        this.posx = controller.posx + controller.w - this.w;
        break;
      case CENTER:
        updateChildrenPositions(controller.posx - this.posx, 0);
        this.posx = (int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5);
        break;
      default:
        break;
      }
      break;

    case BOTTOM: // stack this controller below the given controller
      updateChildrenPositions(controller.posy + this.h - this.posy, 0);
      this.posy = controller.posy + this.h; 
      switch (align) {
      case LEFT:
        updateChildrenPositions(controller.posx - this.posx, 0);
        this.posx = controller.posx;
        break;
      case RIGHT:
        updateChildrenPositions((int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5) - this.posx, 0);
        this.posx = controller.posx + controller.w - this.w;
        break;
      case CENTER:
        updateChildrenPositions(controller.posx - this.posx, 0);
        this.posx = (int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5);
        break;
      default:
        break;
      }
      break;

    case LEFT: // stack this controller to the left about given controller
      updateChildrenPositions(controller.posx - this.w - this.posx, 0);
      this.posx = controller.posx - this.w;
      switch (align) {
      case TOP:
        updateChildrenPositions(controller.posy - this.posy, 0);
        this.posy = controller.posy;
        break;
      case BOTTOM:
        updateChildrenPositions(controller.posy + controller.h - this.h - this.posy, 0);
        this.posy = controller.posy + controller.h - this.h;
        break;
      case CENTER:
        updateChildrenPositions((int)(controller.posy + controller.h * 0.5) - (int)(this.h * 0.5) - this.posy, 0);
        this.posy = (int)(controller.posy + controller.h * 0.5) - (int)(this.h * 0.5);
        break;
      default:
        break;
      }
      break;

    case RIGHT:  // stack this controller to the right about given controller
      updateChildrenPositions(controller.posx + this.w - this.posx, 0);
      this.posx = controller.posx + this.w;
      switch (align) {
      case TOP:
        updateChildrenPositions(controller.posy - this.posy, 0);
        this.posy = controller.posy;
        break;
      case BOTTOM:
        updateChildrenPositions(controller.posy + controller.h - this.h - this.posy, 0);
        this.posy = controller.posy + controller.h - this.h;
        break;
      case CENTER:
        updateChildrenPositions((int)(controller.posy + controller.h * 0.5) - (int)(this.h * 0.5) - this.posy, 0);
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
public abstract class KTGUIEventAdapter {
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
  void println(String string) {
    PApplet.println(string);
  }
}

/**********************************************************************************************************************
 * This is a KTGUI component (controller).
 * This class extends the 'Controller' class.
 * 
 * This class should contain the Border object that can change 
 * the type of cursor depending on the type of action
 * the type of cursor depending on the type of action
 * ARROW - when the pointer is outside the 'window' area or border
 * HAND  - when the pointer is over the 'window' area or border
 * CROSS - when the user is dragging the border of the 'window' 
 * MOVE  - when the user is moving the 'window' 
 * 
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
    this.isDragable = false;
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
    this.isDragable = false;
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
    titleBar = new TitleBar("tb:" + title, this, posx, posy, w, Bar.HEIGHT);
    attachController(titleBar);
    registerChildController(titleBar);
    titleBar.addEventAdapter(new KTGUIEventAdapter() {
      void onMouseDragged() {
        // pane.posx += mouseX - pmouseX;
        // pane.posy += mouseY - pmouseY;
        pane.posx = titleBar.posx;
        pane.posy = titleBar.posy + Bar.HEIGHT;
      }
    }
    );
  }

  void createPane() {
    pane = new WindowPane("pane:" + title, this, posx, posy + titleBar.h, w, h - titleBar.h);
    //pane.isDragable = true;
    attachController(pane);
    registerChildController(pane);
  }

  void draw() {
    // override the 'draw()' method of parent class (Controller)
    // to prevent drawing the TitleBar and Pane second time.
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

/**********************************************************************************************************************
 * This is a KTGUI component (controller).
 * This class extends the 'Controller' class.
 * The object of this class can be 'Pressed', 'Hovered', 'Released' and 'Dragged'.
 *********************************************************************************************************************/
public class Button extends Controller {

  Button(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    isActive = true;

    title = "a Button";
    pg = createGraphics(w + 1, h + 1);
    userpg = createGraphics(w + 1, h + 1);

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
    userpg = createGraphics(w + 1, h + 1); 

    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);

    msg("Button '" + title + "' has been created. posx:" + posx + ", posy:" + posy + ", w:" + w + ", h:" + h);
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
    // if this button don't belongs to any window or pane 
    // then draw directly on the PApplet canvas 
    if (parentController == null) {
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
      msg("Controller '" + title + "' isActive:" + isActive);
      msg("Controller '" + title + "' (parentController == null):" + (parentController == null));
      msg("Controller '" + title + "' posx:" + posx + ", posy:" + posy);

      if (isPointInside(mouseX, mouseY)) {
        isPressed = true;
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMousePressed();
        }
      } else {
        isPressed = false;
      }
      msg("Controller '" + title + "' isPressed:" + isPressed);
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

    int px = (parentController == null) ? 0 : parentController.posx;
    int py = (parentController == null) ? 0 : parentController.posy;

    if (x > px + posx && x < px + posx + w) {
      if (y > py + posy && y < py + posy + h) {
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
      closeControllerRecursively(this); // closeButton --> TitleBar --> Window --> Pane, Button, Button, Window --> TitleBar
    }
  }
}


/**********************************************************************************************************************
 *
 * 
 * 
 *********************************************************************************************************************/
class Pane extends Controller {

  Pane(int posx, int posy, int w, int h) {
    this.title = "a Pane";
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
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
    this.pg = createGraphics(w + 1, h + 1);
    this.userpg = createGraphics(w + 1, h + 1);

    // automatically register the newly created pane in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
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
  }

  // process mouseMoved event received from PApplet
  void processMouseMoved() {
    if (isDragable) {
      isHovered = isPointInside(mouseX, mouseY) ? true : false;
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseMoved();
      }
    }
  }

  // process mousePressed event received from PApplet
  void processMousePressed() {
    if (isDragable) {
      if (isHovered) {
        isPressed = true;
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMousePressed();
        }
      }
    }
  }

  // process mouseReleased event received from PApplet
  void processMouseReleased() {
    if (isDragable) {
      isPressed = false;
      if (isHovered) {
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMouseReleased();
        }
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


/**********************************************************************************************************************
 * 
 * This is the parent class for all GUI components
 * 
 *********************************************************************************************************************/
class Bar extends Controller {

  final static int HEIGHT = 14;

  Bar(int x, int y, int w, int h) {
    this.posx = x;
    this.posy = y;
    this.w  = w;
    this.h = h;
    this.title = "a Bar";
    pg = createGraphics(w + 1, h + 1);
    userpg = createGraphics(w + 1, h + 1);
    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  Bar(String title, int x, int y, int w, int h) {
    this.title = title;
    this.posx = x;
    this.posy = y;
    this.w  = w;
    this.h = h;
    pg = createGraphics(w + 1, h + 1);
    userpg = createGraphics(w + 1, h + 1);
    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  void updateGraphics() {
    // drawBar and title
    pg.beginDraw();
    pg.background(200, 200);
    pg.rectMode(CORNER);
    pg.fill(180);
    pg.stroke(15);
    pg.strokeWeight(1);
    pg.rect(0, 0, w, Bar.HEIGHT);
    pg.fill(25);
    pg.textAlign(LEFT, CENTER);
    pg.textSize(Bar.HEIGHT*0.65);
    pg.text(title, 10, Bar.HEIGHT*0.5);
    pg.endDraw();
  }

  ///*
  //  Note: the first added is drawn last
  //*/
  //void draw() {
  //  drawControllers();  
  //  // if this button doesn't belongs to any parent controller then draw it directly on the PApplet canvas 
  //  //if (parentController == null) {
  //    image(pg, posx, posy);
  //  //}
  //}

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

/**********************************************************************************************************************
 * 
 * 
 *********************************************************************************************************************/
class TitleBar extends Bar { 
  CloseButton closeButton;
  Window parentWindow;

  TitleBar(Window window, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.parentWindow = window;
    closeButton = new CloseButton(w - HEIGHT + 2, 2, HEIGHT - 4, HEIGHT - 4);
    attachController(closeButton);
    registerChildController(closeButton);
  }

  TitleBar(String title, Window window, int x, int y, int w, int h) {
    super(title, x, y, w, h);
    this.parentWindow = window;
    closeButton = new CloseButton("cb:" + this.title, w - HEIGHT + 2, 2, HEIGHT - 4, HEIGHT - 4);
    attachController(closeButton);
    registerChildController(closeButton);
  }
}
