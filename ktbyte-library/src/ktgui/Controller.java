package ktgui;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PGraphics;

/**********************************************************************************************************************
 * This class automatically receives events from PApplet when they happen.
 * Every KTGUI component (controller) should extend this class in order to be able to receive the mouse and keyboard 
 * events.
 * One should override only the 'needed' event methods. This allows to save time and decrease the amount of code.
 * One should always overridde the 'draw' method.
 *********************************************************************************************************************/
public abstract class Controller extends KTGUIEventProcessor implements PConstants {
	public String					title;
	public int						posx, posy, w, h, r1, r2, r3, r4;

	public ArrayList<Controller>	controllers			= new ArrayList<Controller>();
	public PApplet					pa;
	public KTGUI					ktgui;
	public Controller				parentController	= null;
	public Stage					parentStage			= null;

	public PGraphics				pg;
	public PGraphics				userpg;

	public int						hoveredColor;
	public int						pressedColor;
	public int						passiveColor;

	public Controller(KTGUI ktgui) {
		this.ktgui = ktgui;
		this.pa = KTGUI.getParentPApplet();
		init();
	}

	public void init() {
		hoveredColor = KTGUI.COLOR_FG_HOVERED;
		pressedColor = KTGUI.COLOR_FG_PRESSED;
		passiveColor = KTGUI.COLOR_FG_PASSIVE;
	}

	public void updateGraphics() {}

	public void updateUserDefinedGraphics(PGraphics userpg) {
		this.userpg = userpg;
	}

	public void drawUserDefinedGraphics() {
		pg.beginDraw();
		pg.image(userpg, 0, 0);
		pg.endDraw();
	}

	public void drawControllers() {
		for (Controller controller : controllers) {
			pg.beginDraw();
			pg.image(controller.getGraphics(), controller.posx, controller.posy);
			pg.endDraw();
		}
	}

	public void draw() {
		drawControllers();
		drawUserDefinedGraphics();
		pa.image(pg, posx, posy);
	}

	public void setParentController(Controller controller) {
		this.parentController = controller;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void setWidth(int w) {
		this.w = w;
	}

	public void setHeight(int h) {
		this.h = h;
	}

	public void setHoveredColor(int c) {
		hoveredColor = c;
	}

	public void setPressedColor(int c) {
		pressedColor = c;
	}

	public void setPassiveColor(int c) {
		passiveColor = c;
	}

	public void setRoundings(int r1, int r2, int r3, int r4) {
		this.r1 = r1;
		this.r2 = r2;
		this.r3 = r3;
		this.r4 = r4;
	}
	
	public PGraphics getGraphics() {
		return pg;
	}

	public void addController(Controller controller, int hAlign, int vAlign) {
		if (isActive) {
			controller.alignAbout(this, hAlign, vAlign);
			attachController(controller);
		}
	}

	public void attachController(Controller controller) {
		if (isActive) {
			// detach from existinler first (if exist)
			if (controller.parentController != null) {
				Controller pc = controller.parentController;
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
			// prevent the child controller from being dragged 
			// while it's inside the parent controller
			controller.isDragable = false;
		}
	}

	// register child controller and all its childs (recursively)
	public void registerChildController(Controller controller) {
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

	public void registerChildControllers() {
		if (parentStage != null) {
			for (Controller controller : controllers) {
				registerChildController(controller);
			}
		}
	}

	public void detachController(Controller controller) {
		controller.parentController = null;
		controllers.remove(controller);
	}

	public void detachAllControllers() {
		for (Controller controller : controllers) {
			detachController(controller);
		}
	}

	// update child controllers positions and all their childs (recursively)
	public void updateChildrenPositions(int dx, int dy) {
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

	public void closeControllerRecursively(Controller controller) {
		closeParent(controller);
		closeChilds(controller);
	}

	public void closeParent(Controller controller) {
		if (controller.parentController != null)
			closeParent(controller.parentController);
		for (Controller childController : controllers) {
			closeChilds(childController);
		}
		closeChilds(controller);
	}

	public void closeChilds(Controller controller) {
		for (Controller childController : controller.controllers) {
			closeChilds(childController);
			closeController(childController);
		}
	}

	public void closeController(Controller controller) {
		PApplet.println("Closing '" + controller.title + "' controller.");
		controller.isActive = false;
		ktgui.addToGarbage(controller, pa.millis());
	}

	public void alignAboutApplet(int hAlign, int vAlign) {
		switch (hAlign) {
		case PConstants.LEFT:
			updateChildrenPositions(KTGUI.ALIGN_GAP - this.posx, 0);
			this.posx = KTGUI.ALIGN_GAP;
			break;
		case PConstants.RIGHT:
			updateChildrenPositions(pa.width - this.w - KTGUI.ALIGN_GAP - this.posx, 0);
			this.posx = pa.width - this.w - KTGUI.ALIGN_GAP;
			break;
		case PConstants.CENTER:
			updateChildrenPositions((int) (pa.width * 0.5 - this.w * 0.5) - this.posx, 0);
			this.posx = (int) (pa.width * 0.5 - this.w * 0.5);
			break;
		default:
			break;
		}
		//
		switch (vAlign) {
		case PConstants.TOP:
			updateChildrenPositions(0, KTGUI.ALIGN_GAP - this.posy);
			this.posy = KTGUI.ALIGN_GAP;
			break;
		case PConstants.BOTTOM:
			updateChildrenPositions(0, pa.height - this.h - KTGUI.ALIGN_GAP - this.posy);
			this.posy = pa.height - this.h - KTGUI.ALIGN_GAP;
			break;
		case PConstants.CENTER:
			updateChildrenPositions(0, (int) (pa.height * 0.5 - this.h * 0.5) - this.posy);
			this.posy = (int) (pa.height * 0.5 - this.h * 0.5);
			break;
		default:
			break;
		}
	}

	public void alignAbout(Controller controller, int hAlign, int vAlign) {
		switch (hAlign) {
		case PConstants.LEFT:
			updateChildrenPositions(KTGUI.ALIGN_GAP - this.posx, 0);
			this.posx = KTGUI.ALIGN_GAP;
			break;
		case PConstants.RIGHT:
			updateChildrenPositions(controller.w - this.w - KTGUI.ALIGN_GAP - this.posx, 0);
			this.posx = controller.w - this.w - KTGUI.ALIGN_GAP;
			break;
		case PConstants.CENTER:
			updateChildrenPositions((int) (controller.w * 0.5 - this.w * 0.5) - this.posx, 0);
			this.posx = (int) (controller.w * 0.5 - this.w * 0.5);
			break;
		default:
			break;
		}
		//
		switch (vAlign) {
		case PConstants.TOP:
			updateChildrenPositions(0, KTGUI.ALIGN_GAP - this.posy);
			this.posy = KTGUI.ALIGN_GAP;
			break;
		case PConstants.BOTTOM:
			updateChildrenPositions(0, controller.h - this.h - KTGUI.ALIGN_GAP - this.posy);
			this.posy = controller.h - this.h - KTGUI.ALIGN_GAP;
			break;
		case PConstants.CENTER:
			updateChildrenPositions(0, (int) (controller.h * 0.5 - this.h * 0.5) - this.posy);
			this.posy = (int) (controller.h * 0.5 - this.h * 0.5);
			break;
		default:
			break;
		}
	}

	public void stackAbout(Controller controller, int direction, int align) {
		switch (direction) {

		case PConstants.TOP: // stack this controller above the given controller
			updateChildrenPositions(0, controller.posy - this.h - this.posy);
			this.posy = controller.posy - this.h;
			switch (align) {
			case PConstants.LEFT:
				updateChildrenPositions(controller.posx - this.posx, 0);
				this.posx = controller.posx;
				break;
			case PConstants.RIGHT:
				updateChildrenPositions((int) (controller.posx + controller.w * 0.5) - (int) (this.w * 0.5) - this.posx,
						0);
				this.posx = controller.posx + controller.w - this.w;
				break;
			case PConstants.CENTER:
				updateChildrenPositions(controller.posx - this.posx, 0);
				this.posx = (int) (controller.posx + controller.w * 0.5) - (int) (this.w * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.BOTTOM: // stack this controller below the given controller
			updateChildrenPositions(controller.posy + this.h - this.posy, 0);
			this.posy = controller.posy + this.h;
			switch (align) {
			case PConstants.LEFT:
				updateChildrenPositions(controller.posx - this.posx, 0);
				this.posx = controller.posx;
				break;
			case PConstants.RIGHT:
				updateChildrenPositions((int) (controller.posx + controller.w * 0.5) - (int) (this.w * 0.5) - this.posx,
						0);
				this.posx = controller.posx + controller.w - this.w;
				break;
			case PConstants.CENTER:
				updateChildrenPositions(controller.posx - this.posx, 0);
				this.posx = (int) (controller.posx + controller.w * 0.5) - (int) (this.w * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.LEFT: // stack this controller to the left about given controller
			updateChildrenPositions(controller.posx - this.w - this.posx, 0);
			this.posx = controller.posx - this.w;
			switch (align) {
			case PConstants.TOP:
				updateChildrenPositions(controller.posy - this.posy, 0);
				this.posy = controller.posy;
				break;
			case PConstants.BOTTOM:
				updateChildrenPositions(controller.posy + controller.h - this.h - this.posy, 0);
				this.posy = controller.posy + controller.h - this.h;
				break;
			case PConstants.CENTER:
				updateChildrenPositions((int) (controller.posy + controller.h * 0.5) - (int) (this.h * 0.5) - this.posy,
						0);
				this.posy = (int) (controller.posy + controller.h * 0.5) - (int) (this.h * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.RIGHT: // stack this controller to the right about given controller
			updateChildrenPositions(controller.posx + this.w - this.posx, 0);
			this.posx = controller.posx + this.w;
			switch (align) {
			case PConstants.TOP:
				updateChildrenPositions(controller.posy - this.posy, 0);
				this.posy = controller.posy;
				break;
			case PConstants.BOTTOM:
				updateChildrenPositions(controller.posy + controller.h - this.h - this.posy, 0);
				this.posy = controller.posy + controller.h - this.h;
				break;
			case PConstants.CENTER:
				updateChildrenPositions((int) (controller.posy + controller.h * 0.5) - (int) (this.h * 0.5) - this.posy,
						0);
				this.posy = (int) (controller.posy + controller.h * 0.5) - (int) (this.h * 0.5);
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
