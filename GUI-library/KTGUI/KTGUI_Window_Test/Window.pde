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
  int BAR_HEIGHT = 20;
  
  ArrayList<Controller> controllers = new ArrayList<Controller>();
  String title = "A window.";
  int posx, posy, w, h;
  PApplet parent;
  
  Window(int posx, int posy, int w, int h){
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
  }
  
  void attachController(Controller controller){
    controllers.add(controller);
  }

  void attachControllers(ArrayList<Controller> controllers){
    controllers.addAll(controllers);
  }
  
  void draw(){
    drawTitleBar();
    drawBorder();
    drawContents();
  }
  
  void drawTitleBar(){
    // drawBar
    // drawButtons (minimize, maximize, close)
    // drawTitle 
  }

  void drawBorder(){
    // change thickness depending on the user-mouse behavior
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    stroke(255);
    popStyle();
    popMatrix();
  }
  
  void drawContents(){
  }
}
