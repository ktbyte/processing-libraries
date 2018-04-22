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
  ArrayList<KTGUIEventAdapter> adapters = new ArrayList<KTGUIEventAdapter>();
  Window parentWindow = null;
  Pane parentPane = null;
  Stage parentStage = null;
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
      this.posx = 10;
      break;
    case RIGHT:
      this.posx = width - this.w - 10;
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
      this.posy = 10;
      break;
    case BOTTOM:
      this.posy = height - this.h - 10; 
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
      controller.posx = 10;
      break;
    case RIGHT:
      controller.posx = this.w - controller.w - 10;
      break;
    case CENTER:
      controller.posx = (int)(this.w * 0.5 - controller.w * 0.5);
      break;
    default:
      break;
    }
    //
    switch (vAlign) {
    case TOP:
      controller.posy = 10;
      break;
    case BOTTOM:
      controller.posy = this.h - controller.h - 10; 
      break;
    case CENTER:
      controller.posy = (int)(this.h * 0.5 - controller.h * 0.5);
      break;
    default:
      break;
    }
  }
}
