import java.util.*;


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
  List<State> states;
  State activeState;

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

    states = new ArrayList<State>();
  }

  //-------------------------------------------------------------------------------------------------------------------
  // Transfer 'draw' event from PApplet to KTGUI components
  //-------------------------------------------------------------------------------------------------------------------
  void draw() {
    activeState.draw();
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  State createState(String name) {
    State state = new State(name);
    states.add(state);
    activeState = state;
    return state;
  }

  void makeStateActive(State state) {
    activeState = state;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Button createButton(State state, int x, int y, int w, int h) {
    Button btn = new Button(x, y, w, h);
    state.attachController(btn);
    return btn;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Slider createSlider(State state, int x, int y, int w, int h, int s, int e) {
    Slider slider = new Slider(x, y, w, h, s, e);
    state.attachController(slider);
    return slider;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Window createWindow(State state, int x, int y, int w, int h) {
    Window window = new Window(x, y, w, h);
    state.attachController(window);
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
    for (Controller controller : activeState.controllers) {
      controller.processMouseDragged();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mousePressed() {
    //println("Press at: " + mouseX + " " + mouseY);
    for (Controller controller : activeState.controllers) {
      controller.processMousePressed();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseReleased() {
    //println("Release at: " + mouseX + " " + mouseY);
    for (Controller controller : activeState.controllers) {
      controller.processMouseReleased();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseMoved() {
    //println("Moved!");
    for (Controller controller : activeState.controllers) {
      controller.processMouseMoved();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyPressed() {
    //println("Pressed key: " + keyCode);
    for (Controller controller : activeState.controllers) {
      controller.processKeyPressed();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyReleased() {
    //println("Released key: " + keyCode);
    for (Controller controller : activeState.controllers) {
      controller.processKeyReleased();
    }
  }
}