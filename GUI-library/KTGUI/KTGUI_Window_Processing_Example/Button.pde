
/**********************************************************************************************************************
 * This is an example of the KTGUI component (controller).
 * This class extends the 'Controller' class.
 * This class overrides only the 'mouse-related' methods of the 'Controller' class.
 * The object of this class can be 'Pressed', 'Hovered', 'Released' and 'Dragged'.
 *********************************************************************************************************************/
class Button extends Controller {

  Button(int posx, int posy, int w, int h) {
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    isActive = true;

    title = "a Button";
    pg = createGraphics(w + 1, h + 1);

    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }

  Button(String title, int posx, int posy, int w, int h) {
    this.title = title;
    this.posx = posx;
    this.posy = posy;
    this.w = w;
    this.h = h;
    isActive = true;

    pg = createGraphics(w + 1, h + 1);

    // automatically register the newly created window in default stage of stageManager
    ktgui.stageManager.defaultStage.registerController(this);
  }
  
  void updateGraphics() {
    pg.beginDraw();
    pg.rectMode(CORNER);
    if (isHovered && !isPressed) {
      pg.fill(hoveredColor);
    } else if (isHovered && isPressed) {
      pg.fill(pressedColor);
    } else {
      pg.fill(passiveColor);
    }
    pg.rect(0, 0, w, h);
    pg.fill(255);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(14);
    pg.text(title, w*0.5, h*0.5);
    pg.endDraw();
  }

  void draw() {
    // if this button don't belongs to any window or pane 
    // then draw directly on the PApplet canvas 
    if (parentController == null) {
      image(pg, posx, posy);
    }
  }

  // process mouseMoved event received from PApplet
  void processMouseMoved() {
    if (isPointInside(mouseX, mouseY)) {
      isHovered = true;
      for (KTGUIEventAdapter adapter : adapters) {
        adapter.onMouseMoved();
      }
    } else {
      isHovered = false;
    }
  }

  // process mousePressed event received from PApplet
  void processMousePressed() {
    if (isActive) {
      if (isPointInside(mouseX, mouseY)) {
        isPressed = true;
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMousePressed();
        }
      } else {
        isPressed = false;
      }
    }
  }

  // process mouseReleased event received from PApplet
  void processMouseReleased() {
    isPressed = false;
    for (KTGUIEventAdapter adapter : adapters) {
      adapter.onMouseReleased();
    }
  }

  // process mouseDragged event received from PApplet
  void processMouseDragged() {
    if (isDragable) {
      if (isPressed) {
        for (KTGUIEventAdapter adapter : adapters) {
          adapter.onMouseDragged();
        }
      }
    }
  }

  boolean isPointInside(int x, int y) {
    boolean isInside = false;

    int px = (parentController == null) ? 0 : parentController.posx;
    int py = (parentController == null) ? 0 : parentController.posy;

    if (x > px + posx && x < px + posx + w) {
      if (y > py + posy && y < py + posy + h) {
        isInside = true;
      }
    }

    return isInside;
  }
}


/*****************************************************************************************************
 * 
 ****************************************************************************************************/
class CloseButton extends Button {

  CloseButton(int posx, int posy, int w, int h) {
    super(posx, posy, w, h);
  }

  CloseButton(String title, int posx, int posy, int w, int h) {
    super(title, posx, posy, w, h);
  }

  void updateGraphics() {
    pg.beginDraw();
    pg.rectMode(CORNER);
    if (isHovered && !isPressed) {
      pg.fill(ktgui.COLOR_FG_HOVERED);
    } else if (isHovered && isPressed) {
      pg.fill(ktgui.COLOR_FG_PRESSED);
    } else {
      //pg.fill(ktgui.COLOR_FG_PASSIVE);
      pg.fill(200, 200);
    }
    pg.stroke(0);
    pg.strokeWeight(1);
    pg.rectMode(CORNER);
    pg.rect(0, 0, w, h);
    pg.line(w * 0.2, h * 0.2, w * 0.8, h * 0.8);
    pg.line(w * 0.2, h * 0.8, w * 0.8, h * 0.2);
    pg.endDraw();
  }

  void processMousePressed() {
    super.processMousePressed();
    if (isPressed) {
      closeControllerRecursivelyUpward(parentController); // closeButton --> TitleBar --> Window --> Pane, Button, Button, Window --> TitleBar
    }
  }
}
