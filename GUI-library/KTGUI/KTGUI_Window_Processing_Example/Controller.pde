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
}
