KTGUI ktgui;
Button btn;
Slider slider;

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
void setup() {
  size(600, 600);

  // instance of the KTGUI class
  ktgui = new KTGUI(this);

  // instance of the KTGUI 'Button' component
  btn = ktgui.createButton(300 - 100, 50, 100*2, 40);
  btn.setTitle("The Button");
  btn.addEventAdapters(new KTGUIEventAdapter() {
    // we can override only those callback methods which we really need
    void onMousePressed() {
      btn.setTitle(btn.isPressed ? "Pressed" : "The Button");
    }
    // we can override only those callback methods which we really need
    void onMouseReleased() {
      btn.setTitle(btn.isPressed ? "The Button" : "Released");
    }
    // we can override only those callback methods which we really need
    void onMouseMoved() {
      btn.setTitle(btn.isHovered ? "Hovered" : "The Button");
    }
    // we can override only those callback methods which we really need
    void onMouseDragged() {
      if (btn.isPressed) {
        btn.setTitle("Dragged");
        btn.posx += mouseX - pmouseX;
        btn.posy += mouseY - pmouseY;
        println("Button dragged!");
      } else {
        btn.setTitle("The Button");
      }
    }
  }
  );

  slider = ktgui.createSlider(300 - 200, 150, 200*2, 40, 0, width - btn.w);
  slider.setTitle("The Slider");
  slider.addEventAdapters(new KTGUIEventAdapter() {
    // we can override only those callback methods which we really need
    void onMousePressed() {
      slider.setTitle(slider.isPressed ? "Pressed" : "The Slider");
      if (slider.isPressed) {
        int sliderValue = (int)slider.getValue();
        btn.posx = sliderValue;
      }
    }
    // we can override only those callback methods which we really need
    void onMouseReleased() {
      slider.setTitle(slider.isPressed ? "The Slider" : "Released");
    }
    // we can override only those callback methods which we really need
    void onMouseMoved() {
      slider.setTitle(slider.isHovered ? "Hovered" : "The Slider");
    }
    // we can override only those callback methods which we really need
    void onMouseDragged() {
      slider.setTitle(slider.isPressed ? "Dragged" : "The Slider");
      if (slider.isPressed) {
        int sliderValue = (int)slider.getValue();
        int mappedBtnPosition = (int) map(sliderValue, slider.sr, slider.er, 0, width - btn.w);
        btn.posx = mappedBtnPosition;
      }
    }
  }
  );
}

// no more need to include the draw() methods of each KTGUI components here
void draw() {
  background(100, 20, 255);
  pushStyle();
  textAlign(CENTER, CENTER);
  textSize(24);
  text("Drag the button to change its position!", 300, 300);
  text("Drage the slider to change its value!", 300, 340);
  text("The button position also depends on the slider value.", 300, 380);
  popStyle();
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
  void println(String text){
    PApplet.println(text);
  }
  float map(float value, float sin, float ein, float sout, float eout){
    return PApplet.map(value,  sin,  ein,  sout, eout);
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
  ArrayList<KTGUIEventAdapter> adapters;

  void setTitle(String title) {
    this.title = title;
  }
  void addEventAdapters(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
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
}


/************************************************************************************************
 *
 ************************************************************************************************/
class Slider extends Controller {
  int posx, posy;         // upper left corner location
  int w, h;               // width and height   
  int sr, er;             // start and end of range
  int pos;                // 'real' slider position 
  float value;            // 'mapped' slider position

  boolean isPressed, isHovered;

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  Slider(int posx, int posy, int w, int h, int sr, int er) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    this.sr = sr;
    this.er = er;
    title = "The Slider";
    updateHandlePositionFromMouse();
    updateValueFromHandlePosition();
    adapters = new ArrayList<KTGUIEventAdapter>();
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void draw() {
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    if(isHovered){
      fill(ktgui.COLOR_BG_HOVERED);
    } else {
      fill(ktgui.COLOR_BG_PASSIVE);
    }
    rectMode(CORNER);
    rect(0, 0, w, h);

    if (isHovered && !isPressed) {
      fill(ktgui.COLOR_FG_HOVERED);
    } else if (isHovered && isPressed) {
      fill(ktgui.COLOR_FG_PRESSED);
    } else {
      fill(ktgui.COLOR_FG_PASSIVE);
    }
    rect(0, 0, pos, h);
    popStyle();
    popMatrix();

    pushMatrix();
    translate(posx, posy);
    pushStyle();
    fill(255);
    textSize(14);
    textAlign(LEFT, CENTER);
    text(str((int)value), 10, h*0.5);
    textAlign(LEFT, BOTTOM);
    text(title, 10, -2);
    popStyle();
    popMatrix();
  }

  //-----------------------------------------------------------------------------------------------
  // calculate if the point is inside (over) the slider
  //-----------------------------------------------------------------------------------------------
  boolean isPointInside(int ptx, int pty) {
    boolean isInside = false;
    if (ptx > posx  && ptx < posx + w) {
      if (pty > posy && pty < posy + h ) {
        isInside = true;
      }
    }
    return isInside;
  }

  //-----------------------------------------------------------------------------------------------
  // get the value of the slider
  //-----------------------------------------------------------------------------------------------
  float getValue() {
    return value;
  }

  //-----------------------------------------------------------------------------------------------
  // set the value of th slider
  //-----------------------------------------------------------------------------------------------
  void setValue(float value) {
    this.value = value;
  }

  //-----------------------------------------------------------------------------------------------
  // get the handle position
  //-----------------------------------------------------------------------------------------------
  int getPosition() {
    return pos;
  }

  //-----------------------------------------------------------------------------------------------
  // set the handle position
  //-----------------------------------------------------------------------------------------------
  void setPosition(int pos) {
    this.pos = pos;
  }

  //-----------------------------------------------------------------------------------------------
  // call this to recalculate the position of the handle based on the current value of the slider
  //-----------------------------------------------------------------------------------------------
  void updateHandlePositionFromMouse() {
    pos = constrain(mouseX - posx, 0, w);
  }

  //-----------------------------------------------------------------------------------------------
  // call this to recalculate the value of the slider (within the defined range) based on the
  // current handle position
  //-----------------------------------------------------------------------------------------------
  void updateValueFromHandlePosition() {
    value = map(pos, 0, w, sr, er);
  }

  // process mouseMoved event received from PApplet
  void processMouseMoved() {
    if (isPointInside(mouseX, mouseY)) {
      isHovered = true;
    } else {
      isHovered = false;
    }

    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseMoved();
    }
  }

  // process mousePressed event received from PApplet
  void processMousePressed() {
    if (isHovered) {
      isPressed = true;
    } else {
      isPressed = false;
    }

    if (isPressed) {
      updateHandlePositionFromMouse();
      updateValueFromHandlePosition();
    }

    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMousePressed();
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
      updateHandlePositionFromMouse();
      updateValueFromHandlePosition();
    }
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseDragged();
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

  String title;
  int posx, posy, w, h;
  boolean isPressed, isHovered;

  Button(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    this.title = "Button";
    adapters = new ArrayList<KTGUIEventAdapter>();
  }

  void draw() {
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    rectMode(CORNER);
    if (isHovered && !isPressed) {
      fill(ktgui.COLOR_FG_HOVERED);
    } else if (isHovered && isPressed) {
      fill(ktgui.COLOR_FG_PRESSED);
    } else {
      fill(ktgui.COLOR_FG_PASSIVE);
    }
    rect(0, 0, w, h);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("The Button", w*0.5, h*0.5);
    popStyle();
    popMatrix();
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
    isPressed = isHovered;
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMousePressed();
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
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseDragged();
    }
  }

  boolean isPointInside(int x, int y) {
    boolean isInside = false;
    if (x > posx && x < posx + w) {
      if (y > posy && y < posy + h) {
        isInside = true;
      }
    }
    return isInside;
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
  List<Controller> controllers;

  color COLOR_FG_HOVERED = color(10, 150, 10); 
  color COLOR_FG_PRESSED = color(10, 200, 10);
  color COLOR_FG_PASSIVE = color(10, 10, 200); 
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

    controllers = new ArrayList<Controller>();
  }

  //-------------------------------------------------------------------------------------------------------------------
  // Transfer 'draw' event from PApplet to KTGUI components
  //-------------------------------------------------------------------------------------------------------------------
  void draw() {
    for (Controller controller : controllers) {
      controller.draw();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Button createButton(int x, int y, int w, int h) {
    Button btn = new Button(x, y, w, h);
    registerController(btn);
    return btn;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'factory' method
  //-------------------------------------------------------------------------------------------------------------------
  Slider createSlider(int x, int y, int w, int h, int s, int e) {
    Slider slider = new Slider(x, y, w, h, s, e);
    registerController(slider);
    return slider;
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This method is used to automatically register each KTGUI component (controller) created by factory method
  //-------------------------------------------------------------------------------------------------------------------
  void registerController(Controller controller) {
    controllers.add(controller);
    //println("Controller:" + controller + " has been registered!");
    //println("Controller:" + controller.getClass().getCanonicalName() + " has been registered!");
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
    for (Controller controller : controllers) {
      controller.processMouseDragged();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mousePressed() {
    //println("Press at: " + mouseX + " " + mouseY);
    for (Controller controller : controllers) {
      controller.processMousePressed();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseReleased() {
    //println("Release at: " + mouseX + " " + mouseY);
    for (Controller controller : controllers) {
      controller.processMouseReleased();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void mouseMoved() {
    //println("Moved!");
    for (Controller controller : controllers) {
      controller.processMouseMoved();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyPressed() {
    //println("Pressed key: " + keyCode);
    for (Controller controller : controllers) {
      controller.processKeyPressed();
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  // This is a 'transfer' method - it 'redirects' the event from PApplet to KTGUI components (controllers)
  //-------------------------------------------------------------------------------------------------------------------
  void keyReleased() {
    //println("Released key: " + keyCode);
    for (Controller controller : controllers) {
      controller.processKeyReleased();
    }
  }
}
