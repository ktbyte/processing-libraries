class Bar extends Controller {
  final static int HEIGHT = 14;


  /*
 
   See the notes in KTBYTEDEV-678
   
   */


  Bar(int x, int y, int w, int h) {
    this.posx = x;
    this.posy = y;
    this.w  = w;
    this.h = h;
    this.title = "a Bar";
    pg = createGraphics(w + 1, h + 1);
    userpg = createGraphics(w + 1, h + 1);
    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  Bar(String title, int x, int y, int w, int h) {
    this.title = title;
    this.posx = x;
    this.posy = y;
    this.w  = w;
    this.h = h;
    pg = createGraphics(w + 1, h + 1);
    userpg = createGraphics(w + 1, h + 1);
    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  void updateGraphics() {
    // drawBar and title
    pg.beginDraw();
    pg.background(200, 200);
    pg.rectMode(CORNER);
    pg.fill(180);
    pg.stroke(15);
    pg.strokeWeight(1);
    pg.rect(0, 0, w, HEIGHT);
    pg.fill(25);
    pg.textAlign(LEFT, CENTER);
    pg.textSize(HEIGHT*0.65);
    pg.text(title, 10, HEIGHT*0.5);
    pg.endDraw();
  }

  ///*
  //  Note: the first added is drawn last
  //*/
  //void draw() {
  //  drawControllers();  
  //  // if this button doesn't belongs to any parent controller then draw it directly on the PApplet canvas 
  //  //if (parentController == null) {
  //    image(pg, posx, posy);
  //  //}
  //}

  void drawControllers() {
    for (Controller controller : controllers) {
      pg.beginDraw();
      pg.image(controller.getGraphics(), controller.posx, controller.posy);
      pg.endDraw();
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
    if (isDragable) {
      if (isPressed) {
        posx += mouseX - pmouseX;
        posy += mouseY - pmouseY;
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMouseDragged();
        }
      }
    }
  }
  
  boolean isPointInside(int x, int y) {
    boolean isInside = false;
    if (x > posx && x < posx + this.w) {
      if (y > posy && y < posy + this.h) {
        isInside = true;
      }
    }
    return isInside;
  }
}

class TitleBar extends Bar {
   
  CloseButton closeButton;
  Window parentWindow;
  
  TitleBar(Window window, int x, int y, int w, int h) {
    super(x, y, w, h);
    this.parentWindow = window;
    closeButton = new CloseButton(w - HEIGHT + 2, 2, HEIGHT - 4, HEIGHT - 4);
    attachController(closeButton);
    registerChildController(closeButton);
  }

  TitleBar(String title, Window window, int x, int y, int w, int h) {
    super(title, x, y, w, h);
    this.parentWindow = window;
    closeButton = new CloseButton("cb:" + this.title, w - HEIGHT + 2, 2, HEIGHT - 4, HEIGHT - 4);
    attachController(closeButton);
    registerChildController(closeButton);
  }

}
