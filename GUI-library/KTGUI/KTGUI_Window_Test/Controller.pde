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