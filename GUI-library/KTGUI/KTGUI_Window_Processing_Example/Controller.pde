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

  public void updateGraphics() {
  }
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
  public void setParentWindow(Window window) {
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
