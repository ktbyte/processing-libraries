import java.util.*;

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
  btn = ktgui.createButton(width/2 - 75, 50, 150, 40);
  btn.setTitle("The Button");
  btn.addEventAdapters(new KTGUIEventAdapter() {
    // we can override only those callback methods which we really need
    public void onMousePressed() {
      println("MousePressedEvent message from Button Callback!");
      btn.setTitle(btn.isPressed ? "Pressed" : "The Button");
    }
    // we can override only those callback methods which we really need
    public void onMouseReleased() {
      println("MouseReleasedEvent message from Button Callback!");
      btn.setTitle(btn.isPressed ? "The Button" : "Released");
    }
    // we can override only those callback methods which we really need
    public void onMouseMoved() {
      println("MouseMovedEvent message from Button Callback!");
      btn.setTitle(btn.isHovered ? "Hovered" : "The Button");
    }
    // we can override only those callback methods which we really need
    public void onMouseDragged() {
      println("MouseDraggedEvent message from Button Callback!");
      if (btn.isPressed) {
        btn.setTitle("Dragged");
        btn.posx += mouseX - pmouseX;
        btn.posy += mouseY - pmouseY;
      } else {
        btn.setTitle("The Button");
      }
    }
  }
  );

  // instance of the KTGUI 'Button' component
  slider = ktgui.createSlider(width/2 - 200, 150, 400, 40, 0, 1000);
  slider.setTitle("The Slider");
  slider.addEventAdapters(new KTGUIEventAdapter() {
    // we can override only those callback methods which we really need
    public void onMousePressed() {
      println("MousePressedEvent message from Slider Callback!");
      slider.setTitle(slider.isPressed ? "Pressed" : "The Slider");
      if (slider.isPressed) {
        int sliderValue = (int)slider.getValue();
        int mappedPos = (int)map(sliderValue, slider.sr, slider.er, 0, width - btn.width);
        btn.posx = mappedPos;
      }
    }
    // we can override only those callback methods which we really need
    public void onMouseReleased() {
      println("MouseReleasedEvent message from Slider Callback!");
      slider.setTitle(slider.isPressed ? "The Slider" : "Released");
    }
    // we can override only those callback methods which we really need
    public void onMouseMoved() {
      println("MouseMovedEvent message from Slider Callback!");
      slider.setTitle(slider.isHovered ? "Hovered" : "The Slider");
    }
    // we can override only those callback methods which we really need
    public void onMouseDragged() {
      println("MouseDraggedEvent message from Slider Callback!");
      slider.setTitle(slider.isPressed ? "Dragged" : "The Slider");
      if (slider.isPressed) {
        int sliderValue = (int)slider.getValue();
        int mappedPos = (int)map(sliderValue, slider.sr, slider.er, 0, width - btn.width);
        btn.posx = mappedPos;
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
  text("Drag the button!", width/2, height/2);
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

  public void draw() {
  }
  public void processMouseMoved() {
  }
  public void processMousePressed() {
  }
  public void processMouseReleased() {
  }
  public void processMouseDragged() {
  }
  public void processKeyPressed() {
  }
  public void processKeyReleased() {
  }
  void setTitle(String title) {
    this.title = title;
  }
}


/************************************************************************************************
 *
 ************************************************************************************************/
class Slider extends Controller {
  int posx, posy;               // corner location
  int width, height;      // width and height   
  int sr, er;             // start and end of range
  int pos;                // 'real' slider position 
  float value;            // 'mapped' slider position

  boolean isPressed, isHovered;

  ArrayList<KTGUIEventAdapter> adapters;

  color BG_PASSIVE_COLOR = color(180);          // background 'passive' color
  color BG_HOVERED_COLOR = color(220);          // background 'hovered' color
  color FG_PASSIVE_COLOR = color(50, 180, 50); // foreground 'passive' color
  color FG_HOVERED_COLOR = color(50, 220, 50); // foreground 'hovered' color

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  Slider(int posx, int posy, int width, int height, int sr, int er) {
    this.posx = posx;
    this.posy = posy;
    this.width = width;
    this.height = height;
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
    fill(isHovered ? BG_HOVERED_COLOR : BG_PASSIVE_COLOR);
    rectMode(CORNER);
    rect(0, 0, this.width, this.height);
    fill(isHovered ? FG_HOVERED_COLOR : FG_PASSIVE_COLOR);
    rect(0, 0, pos, this.height);
    fill(0);
    textAlign(LEFT, CENTER);
    text(str(value), 10, height/2);
    textAlign(LEFT, BOTTOM);
    text(title, 10, -2);
    popStyle();
    popMatrix();
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void addEventAdapters(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  boolean isPointInside(int ptx, int pty) {
    boolean isInside = false;
    if (ptx > this.posx  && ptx < this.posx + this.width) {
      if (pty > this.posy && pty < this.posy + this.height ) {
        isInside = true;
      }
    }
    return isInside;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  float getValue() {
    return value;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void setValue(float value) {
    this.value = value;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  int getPosition() {
    return pos;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void setPosition(int pos) {
    this.pos = pos;
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void updateHandlePositionFromMouse() {
    pos = constrain(mouseX - posx, 0, this.width);
  }

  //-----------------------------------------------------------------------------------------------
  //
  //-----------------------------------------------------------------------------------------------
  void updateValueFromHandlePosition() {
    value = map(pos, 0, this.width, sr, er);
  }

  //-----------------------------------------------------------------------------------------------
  // process mouseMoved event received from PApplet
  //-----------------------------------------------------------------------------------------------
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

  //-----------------------------------------------------------------------------------------------
  // process mousePressed event received from PApplet
  //-----------------------------------------------------------------------------------------------
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

  //-----------------------------------------------------------------------------------------------
  // process mouseReleased event received from PApplet
  //-----------------------------------------------------------------------------------------------
  void processMouseReleased() {
    isPressed = false;
    if (isHovered) {
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseReleased();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------
  // process mouseDragged event received from PApplet
  //-----------------------------------------------------------------------------------------------
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
  int posx, posy;
  int width, height;
  boolean isPressed, isHovered;

  ArrayList<KTGUIEventAdapter> adapters;

  Button(int posx, int posy, int width, int height) {
    this.posx = posx;
    this.posy = posy;
    this.width = width;
    this.height = height;
    title = "Button";
    adapters = new ArrayList<KTGUIEventAdapter>();
  }

  void addEventAdapters(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
  }

  void draw() {
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    rectMode(CORNER);
    if (isHovered) {
      fill(KTGUI.COLOR_HOVERED);
    } else if (isPressed) {
      fill(KTGUI.COLOR_PRESSED);
    } else {
      fill(KTGUI.COLOR_PASSIVE);
    }
    rect(0, 0, this.width, this.height);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(title, this.width/2, this.height/2);
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
    if (x > posx && x < posx + this.width) {
      if (y > posy && y < posy + this.height) {
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

  final static color COLOR_HOVERED = #3232FF;
  final static color COLOR_PASSIVE = #3232A8;
  final static color COLOR_PRESSED = #32C832;

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
    println("Controller:" + controller.getClass().getCanonicalName() + " has been registered!");
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
