KTGUI ktgui;
Button jumpButton, anotherButton, nextStateBtn;
Window w1, w2, w3;
State s1, s2, s3;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(600, 500);
  ktgui = new KTGUI(this); // default state is automatically created

  s1 = ktgui.stateManager.createState("state_1");
  anotherButton = ktgui.createButton(50, 50, 100, 50);
  anotherButton.setTitle("Go To\nState_2");
  anotherButton.addEventAdapters(new KTGUIEventAdapter() {
    void onMousePressed() {
      println("Callback message: The anotherButton (goToState(1)) was pressed!");
      ktgui.stateManager.goToState(1);
    }  
  }
  );
  s1.registerController(anotherButton);

  
  // Now, the "s1" state is "active". So, the both 'w1' and 'nextStateButton' are automatically attached to this state. 
  // We can still use 's1.attachController(Controller) though.
  s2 = ktgui.stateManager.createState("state_2");
  w1 = ktgui.createWindow(10, 10, 300, 200);
  w1.setTitle("Window_1");
  nextStateBtn = ktgui.createButton(width - 120, height - 70, 100, 50);
  nextStateBtn.setTitle("NextState");
  nextStateBtn.addEventAdapters(new KTGUIEventAdapter() {
    void onMousePressed() {
      println("Callback message: The Nex-State-Button was pressed!");
      ktgui.stateManager.goToNextState();
    }
  }
  );
  s2.registerController(w1);


  // Now, the "s2" state is "active". So, the jumpButton is automatically attached to this state.
  // We can use 's2.attachController(Controller) though.
  s3 = ktgui.stateManager.createState("state_3");
  jumpButton = ktgui.createButton(50, 50, 100, 50);
  jumpButton.setTitle("Jump!");
  jumpButton.addEventAdapters(new KTGUIEventAdapter() {
    void onMousePressed() {
      println("Callback message: The Jumping Button was pressed!");
      if(jumpButton.parentWindow == w3){
        w2.attachController(jumpButton);
      }else if(jumpButton.parentWindow == w2){
        w3.attachController(jumpButton);
      }
    }  
  }
  );
  s3.registerController(jumpButton);
  
  // The "s2" state is still "active". So, the both windows are automatically attached to this state.
  // We can still use 's2.attachController(Controller) though.
  w2 = ktgui.createWindow(10, 10, 300, 200);
  w2.setTitle("Window_2");
  s3.registerController(w2);
  
  w3 = ktgui.createWindow(10, 230, 300, 200);
  w3.setTitle("Window_3");
  w3.attachController(jumpButton);
  s3.registerController(w3);
  
  s1.registerController(nextStateBtn);
  s2.registerController(nextStateBtn);
  s3.registerController(nextStateBtn);

  ktgui.stateManager.goToState(s3);
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
  text("activeState.name:" + ktgui.stateManager.activeState.name, width - 10, 10);
  text("activeState.index:" + ktgui.stateManager.states.indexOf(ktgui.stateManager.activeState), width - 10, 30);
  text("size():" + ktgui.stateManager.states.size(), width - 10, 50);
}

void keyPressed(){
  ktgui.stateManager.goToNextState();
}

/**********************************************************************************************************************
 * A state can have multple controllers.
 * The KTGUI class should handle the transition from one state to another.
 * Only one state can be active at a time. 
 * Only the GUI elements from the active state will be displayed
 * This allows the sharing of variables between different states, by storing/retriving data from the 'context' object
 *********************************************************************************************************************/
public class State {
  List<Controller> controllers;
  String name;

  State(String name) {
    this.name = name;
    this.controllers = new ArrayList<Controller>();
  }

  void draw() {
    for (Controller controller : controllers) {
      controller.updateGraphics();
      controller.draw();
    }
  }

  void registerController(Controller controller) {
    if (!controllers.contains(controller)) {
      println("Controller:" + controller.title + " is registered to the State:" + name);
      controllers.add(controller);
    }
  }

  void unregisterController(Controller controller) {
    if (controllers.contains(controller)) {
      println("Controller:" + controller.title + " is unregistered to the State:" + name);
      controllers.remove(controller);
    }
  }
}

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
class StateManager {
  List<State> states; // replace 'List' with 'Set' to prevent duplicates
  State activeState;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  StateManager() {
    states = new ArrayList<State>();
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  State createState(String name) {
    State state = new State(name);
    states.add(state);
    activeState = state;
    return state;
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  void goToState(State state) {
    activeState = state;
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  void goToState(int numState) {
    if (numState > 0 && numState < states.size()) {
      activeState = states.get(numState);
    }
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  void goToNextState() {
    int indexOfCurrentState = states.indexOf(activeState);
    println("Before...");
    println("indexOfCurrentState:" + indexOfCurrentState);

    if (indexOfCurrentState < states.size() - 1) {
        activeState = states.get(indexOfCurrentState + 1);
    } else {
        activeState = states.get(0);
    }
    
    println("After...");
    indexOfCurrentState = states.indexOf(activeState);
    println("indexOfCurrentState:" + indexOfCurrentState);
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  void printStates() {
    for (int i = 0; i < states.size(); i++) {
      println("[" + i + "] - " + states.get(i).name);
    }
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  List<State> getStates() {
    return states;
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
  StateManager stateManager;

  color COLOR_FG_HOVERED = color(10, 150, 10); 
  color COLOR_FG_PRESSED = color(10, 200, 10);
  color COLOR_FG_PASSIVE = color(100, 100, 200); 
  color COLOR_BG_HOVERED = color(100); 
  color COLOR_BG_PASSIVE = color(100); 
  color COLOR_BG_PRESSED = color(200);

  //-------------------------------------------------------------------------------------------------------------------
  // The constructor automatically registers the 'draw', 'mouseEvent' and 'keyEvent' of this class in PApplet's EDT 
  // thread.
  //-------------------------------------------------------------------------------------------------------------------
  public KTGUI(PApplet pa) {
    this.pa = pa;
    this.pa.registerMethod("draw", this);
    this.pa.registerMethod("mouseEvent", this);
    this.pa.registerMethod("keyEvent", this);

    stateManager = new StateManager();
  }

  //-------------------------------------------------------------------------------------------------------------------
  // Transfer 'draw' event from PApplet to KTGUI components
  //-------------------------------------------------------------------------------------------------------------------
  void draw() {
    stateManager.activeState.draw();
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Button createButton(int x, int y, int w, int h) {
    Button btn = new Button(x, y, w, h);
    //stateManager.activeState.attachController(btn);
    return btn;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Window createWindow(int x, int y, int w, int h) {
    Window window = new Window(x, y, w, h);
    //stateManager.activeState.attachController(window);
    return window;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This method 'redirects' the incoming mouse events from PApplet to 'transfer' methods 
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
  // This method 'redirects' the incoming keyboard events from PApplet to 'transfer' methods
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
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseDragged() {
    //println("Dragged!");
    for (Controller controller : stateManager.activeState.controllers) {
      controller.processMouseDragged();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mousePressed() {
    //println("Press at: " + mouseX + " " + mouseY);
    for (Controller controller : stateManager.activeState.controllers) {
      controller.processMousePressed();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseReleased() {
    //println("Release at: " + mouseX + " " + mouseY);
    for (Controller controller : stateManager.activeState.controllers) {
      controller.processMouseReleased();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseMoved() {
    //println("Moved!");
    for (Controller controller : stateManager.activeState.controllers) {
      controller.processMouseMoved();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyPressed() {
    //println("Pressed key: " + keyCode);
    for (Controller controller : stateManager.activeState.controllers) {
      controller.processKeyPressed();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyReleased() {
    //println("Released key: " + keyCode);
    for (Controller controller : stateManager.activeState.controllers) {
      controller.processKeyReleased();
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
  boolean isPressed, isHovered;

  Button(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    //title = "";
    adapters = new ArrayList<KTGUIEventAdapter>();
    pg = createGraphics(w + 1, h + 1);
  }

  void addEventAdapters(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
  }

  void updateGraphics() {
    pg.beginDraw();
    pg.rectMode(CORNER);
    if (isHovered && !isPressed) {
      pg.fill(ktgui.COLOR_FG_HOVERED);
    } else if (isHovered && isPressed) {
      pg.fill(ktgui.COLOR_FG_PRESSED);
    } else {
      pg.fill(ktgui.COLOR_FG_PASSIVE);
    }
    pg.rect(0, 0, w, h);
    pg.fill(255);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(14);
    pg.text(title, w*0.5, h*0.5);
    pg.endDraw();
  }

  void draw() {
    if (parentWindow == null) {
      image(pg, posx, posy);
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
    if (isPressed) {
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseDragged();
      }
    }
  }

  boolean isPointInside(int x, int y) {
    boolean isInside = false;

    int px = (parentWindow == null) ? 0 : parentWindow.posx;
    int py = (parentWindow == null) ? 0 : parentWindow.posy;

    if (x > px + posx && x < px + posx + w) {
      if (y > py + posy && y < py + posy + h) {
        isInside = true;
      }
    }

    return isInside;
  }
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
  ArrayList<KTGUIEventAdapter> adapters;
  Window parentWindow = null;
  PGraphics pg;

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
  void setParentWindow(Window window) {
    this.parentWindow = window;
  }
  void setTitle(String title) {
    this.title = title;
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

  //String title = "Window title bar. Drag it!";

  int posx, posy, w, h;

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
    pg = createGraphics(wdth + 1, hght + 1);
  }
  void draw() {
    drawChildrenControllers();
    drawTitleBar();
    drawBorder();
    updateControllers();
    image(pg, posx, posy);
  }

  void drawChildrenControllers() {
    for (Controller controller : controllers) {
      controller.draw();
    }
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

    // drawButtons (minimize, maximize, close)
  }

  void addEventAdapter(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
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

  void updateControllers() {
    for (Controller controller : controllers) {
      pg.beginDraw();
      pg.image(controller.getGraphics(), controller.getPosX(), controller.getPosY());
      pg.endDraw();
    }
  }

  void attachController(Controller controller) {
    // prevent one controller to be attached to two windows
    if (controller.parentWindow != null) {
      controller.parentWindow.controllers.remove(controller); 
    }
 
    if (!controllers.contains(controller)) {
      println("Controller:" + controller.title + " is attached to Window:" + title);
      controllers.add(controller);
      controller.setParentWindow(this);
    }
  }

  void detachController(Controller controller) {
    if (controllers.contains(controller)) {
      println("Controller:" + controller.title + " is detached from Window:" + title);
      controllers.remove(controller);
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
}
