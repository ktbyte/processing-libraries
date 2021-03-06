/**********************************************************************************************************************
 * This class automatically receives events from PApplet when they happen.
 * Every KTGUI component (controller) should extend this class in order to be able to receive the mouse and keyboard 
 * events.
 * One should override only the 'needed' event methods. This allows to save time and decrease the amount of code.
 * One should always overridde the 'draw' method.
 *********************************************************************************************************************/
public abstract class Controller extends EventProcessor {
  String title;
  int posx, posy, w, h;  

  ArrayList<Controller> controllers = new ArrayList<Controller>();
  Controller parentController = null;
  Stage parentStage = null;

  PGraphics pg;
  PGraphics userpg;
  
  color hoveredColor = ktgui.COLOR_FG_HOVERED;
  color pressedColor = ktgui.COLOR_FG_PRESSED;
  color passiveColor = ktgui.COLOR_FG_PASSIVE;
  
  void updateGraphics() {
  }
  void updateUserDefinedGraphics(PGraphics userpg) {
    this.userpg = userpg;
  } 
  void drawUserDefinedGraphics() {
    pg.beginDraw();
    pg.image(userpg, 0, 0);
    pg.endDraw();
  }
  void drawControllers() {
    for (Controller controller : controllers) {
      pg.beginDraw();
      pg.image(controller.getGraphics(), controller.posx, controller.posy);
      pg.endDraw();
    }
  }
  void draw() {
    drawControllers();
    drawUserDefinedGraphics();
    image(pg, posx, posy);
  }
  void setParentController(Controller controller) {
    this.parentController = controller;
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

  void addController(Controller controller, int hAlign, int vAlign) {
    if (isActive) {
      controller.alignAbout(this, hAlign, vAlign);
      attachController(controller);
    }
  }
  void attachController(Controller controller) {
    if (isActive) {
      // detach from existinler first (if exist)
      if (controller.parentController != null) {
        Controller pc = (Controller)controller.parentController;
        pc.detachController(controller); // reset parentWindow
      }
      // add to the list of controllers
      if (!controllers.contains(controller)) {
        controllers.add(controller);
      }
      // set 'this' controller as parent
      controller.setParentController(this);
      // register in parentStage
      registerChildController(controller);
    }
  }
  // register child controller and all its childs (recursively)
  void registerChildController(Controller controller) {
    if (parentStage != null) {
      parentStage.registerController(controller);
      if (controller.controllers.size() > 0) {
        ArrayList<Controller> childControllers = controller.controllers;
        for (Controller child : childControllers) {
          registerChildController(child);
        }
      }
    }
  }
  void registerChildControllers() {
    if (parentStage != null) {
      for (Controller controller : controllers) {
        registerChildController(controller);
      }
    }
  }
  void detachController(Controller controller) {
    controller.parentController = null;
    controllers.remove(controller);
  }
  void detachAllControllers() {
    for (Controller controller : controllers) {
      detachController(controller);
    }
  }

  // update child controllers positions and all their childs (recursively)
  void updateChildrenPositions(int dx, int dy) {
    for (Controller controller : controllers) {
      controller.posx += dx;
      controller.posy += dy;
      if (controller.controllers.size() > 0) {
        ArrayList<Controller> childControllers = controller.controllers;
        for (Controller child : childControllers) {
          child.updateChildrenPositions(dx, dy);
        }
      }
    }
  }

  void closeControllerRecursively(Controller controller) {
    closeParent(controller);
    closeChilds(controller);
  }

  void closeParent(Controller controller) {
    if (controller.parentController != null) closeParent(controller.parentController);
    for (Controller childController : controllers) {
      closeChilds(childController);
    }
    closeChilds(controller);
  }
  
  void closeChilds(Controller controller) {
    for (Controller childController : controller.controllers) {
      closeChilds(childController);
      closeController(childController);
    }
  }
  
  void closeController(Controller controller) {
    msg("Closing '" + controller.title + "' controller.");
    controller.isActive = false;
    ktgui.garbageList.put(controller, millis());
  }

  void alignAboutApplet(int hAlign, int vAlign) {
    switch (hAlign) {
    case LEFT:
      updateChildrenPositions(ktgui.ALIGN_GAP - this.posx, 0);
      this.posx = ktgui.ALIGN_GAP;
      break;
    case RIGHT:
      updateChildrenPositions(width - this.w - ktgui.ALIGN_GAP - this.posx, 0);
      this.posx = width - this.w - ktgui.ALIGN_GAP;
      break;
    case CENTER:
      updateChildrenPositions((int)(width * 0.5 - this.w * 0.5) - this.posx, 0);
      this.posx = (int)(width * 0.5 - this.w * 0.5);
      break;
    default:
      break;
    }
    //
    switch (vAlign) {
    case TOP:
      updateChildrenPositions(0, ktgui.ALIGN_GAP - this.posy);
      this.posy = ktgui.ALIGN_GAP;
      break;
    case BOTTOM:
      updateChildrenPositions(0, height - this.h - ktgui.ALIGN_GAP - this.posy);
      this.posy = height - this.h - ktgui.ALIGN_GAP; 
      break;
    case CENTER:
      updateChildrenPositions(0, (int)(height * 0.5 - this.h * 0.5) - this.posy);
      this.posy = (int)(height * 0.5 - this.h * 0.5);
      break;
    default:
      break;
    }
  }

  void alignAbout(Controller controller, int hAlign, int vAlign) {
    switch (hAlign) {
    case LEFT:
      updateChildrenPositions(ktgui.ALIGN_GAP - this.posx, 0);
      this.posx = ktgui.ALIGN_GAP;
      break;
    case RIGHT:
      updateChildrenPositions(controller.w - this.w - ktgui.ALIGN_GAP - this.posx, 0);
      this.posx = controller.w - this.w - ktgui.ALIGN_GAP;
      break;
    case CENTER:
      updateChildrenPositions((int)(controller.w * 0.5 - this.w * 0.5) - this.posx, 0);
      this.posx = (int)(controller.w * 0.5 - this.w * 0.5);
      break;
    default:
      break;
    }
    //
    switch (vAlign) {
    case TOP:
      updateChildrenPositions(0, ktgui.ALIGN_GAP - this.posy);
      this.posy = ktgui.ALIGN_GAP;
      break;
    case BOTTOM:
      updateChildrenPositions(0, controller.h - this.h - ktgui.ALIGN_GAP - this.posy);
      this.posy = controller.h - this.h - ktgui.ALIGN_GAP; 
      break;
    case CENTER:
      updateChildrenPositions(0, (int)(controller.h * 0.5 - this.h * 0.5) - this.posy);
      this.posy = (int)(controller.h * 0.5 - this.h * 0.5);
      break;
    default:
      break;
    }
  }

  void stackAbout(Controller controller, int direction, int align) {
    switch (direction) {

    case TOP: // stack this controller above the given controller
      updateChildrenPositions(0, controller.posy - this.h - this.posy);
      this.posy = controller.posy - this.h;
      switch (align) {
      case LEFT:
        updateChildrenPositions(controller.posx - this.posx, 0);
        this.posx = controller.posx;
        break;
      case RIGHT:
        updateChildrenPositions((int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5) - this.posx, 0);
        this.posx = controller.posx + controller.w - this.w;
        break;
      case CENTER:
        updateChildrenPositions(controller.posx - this.posx, 0);
        this.posx = (int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5);
        break;
      default:
        break;
      }
      break;

    case BOTTOM: // stack this controller below the given controller
      updateChildrenPositions(controller.posy + this.h - this.posy, 0);
      this.posy = controller.posy + this.h; 
      switch (align) {
      case LEFT:
        updateChildrenPositions(controller.posx - this.posx, 0);
        this.posx = controller.posx;
        break;
      case RIGHT:
        updateChildrenPositions((int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5) - this.posx, 0);
        this.posx = controller.posx + controller.w - this.w;
        break;
      case CENTER:
        updateChildrenPositions(controller.posx - this.posx, 0);
        this.posx = (int)(controller.posx + controller.w * 0.5) - (int)(this.w * 0.5);
        break;
      default:
        break;
      }
      break;

    case LEFT: // stack this controller to the left about given controller
      updateChildrenPositions(controller.posx - this.w - this.posx, 0);
      this.posx = controller.posx - this.w;
      switch (align) {
      case TOP:
        updateChildrenPositions(controller.posy - this.posy, 0);
        this.posy = controller.posy;
        break;
      case BOTTOM:
        updateChildrenPositions(controller.posy + controller.h - this.h - this.posy, 0);
        this.posy = controller.posy + controller.h - this.h;
        break;
      case CENTER:
        updateChildrenPositions((int)(controller.posy + controller.h * 0.5) - (int)(this.h * 0.5) - this.posy, 0);
        this.posy = (int)(controller.posy + controller.h * 0.5) - (int)(this.h * 0.5);
        break;
      default:
        break;
      }
      break;

    case RIGHT:  // stack this controller to the right about given controller
      updateChildrenPositions(controller.posx + this.w - this.posx, 0);
      this.posx = controller.posx + this.w;
      switch (align) {
      case TOP:
        updateChildrenPositions(controller.posy - this.posy, 0);
        this.posy = controller.posy;
        break;
      case BOTTOM:
        updateChildrenPositions(controller.posy + controller.h - this.h - this.posy, 0);
        this.posy = controller.posy + controller.h - this.h;
        break;
      case CENTER:
        updateChildrenPositions((int)(controller.posy + controller.h * 0.5) - (int)(this.h * 0.5) - this.posy, 0);
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
