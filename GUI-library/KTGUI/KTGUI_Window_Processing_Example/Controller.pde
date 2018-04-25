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
