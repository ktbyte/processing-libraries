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

	public int						fgHoveredColor;
	public int						fgPressedColor;
	public int						fgPassiveColor;
	public int						bgHoveredColor;
	public int						bgPressedColor;
	public int						bgPassiveColor;

	public Controller(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		System.out.println("Creating " + title + ".");
		this.ktgui = ktgui;
		this.pa = KTGUI.getParentPApplet();
		this.title = title;
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created window in default stage of stageManager
		StageManager.getInstance().defaultStage.registerController(this);

		initColors();
	}

	public void initColors() {
		fgHoveredColor = KTGUI.COLOR_FG_HOVERED;
		fgPressedColor = KTGUI.COLOR_FG_PRESSED;
		fgPassiveColor = KTGUI.COLOR_FG_PASSIVE;
		bgHoveredColor = KTGUI.COLOR_BG_HOVERED;
		bgPressedColor = KTGUI.COLOR_BG_PRESSED;
		bgPassiveColor = KTGUI.COLOR_BG_PASSIVE;
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
		if (controllers.size() > 0) {
			ktgui.drawCallStack.add(title + ".drawControllers()");
			for (Controller child : controllers) {
				pg.beginDraw();
				ktgui.drawCallStack.add("pg.image(" + child.title + ").getGraphics: " + child.posx + ", " + child.posy);
				pg.image(child.getGraphics(), child.posx, child.posy);
				pg.endDraw();
			}
		}
	}

	private void drawGraphics() {
		if (parentController == null) {
			ktgui.drawCallStack.add(title + ".drawGraphics()");
			pa.image(pg, posx, posy);
		}
	}

	public void draw() {
		drawControllers();
		drawUserDefinedGraphics(); // draw 'userpg' on 'pg' 
		drawGraphics(); // draw 'pg' on PApplet canvas
	}

	public void setParentController(Controller controller) {
		this.parentController = controller;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getWidth() {
		return w;
	}

	public void setWidth(int w) {
		this.w = w;
	}

	public int getHeight() {
		return h;
	}

	public void setHeight(int h) {
		this.h = h;
	}

	public void setHoveredColor(int c) {
		fgHoveredColor = c;
	}

	public void setPressedColor(int c) {
		fgPressedColor = c;
	}

	public void setPassiveColor(int c) {
		fgPassiveColor = c;
	}

	public void setBorderRoundings(int r1, int r2, int r3, int r4) {
		this.r1 = r1;
		this.r2 = r2;
		this.r3 = r3;
		this.r4 = r4;
	}

	public void setHandleFocus(boolean val) {
		handleFocus = val;
	}

	public PGraphics getGraphics() {
		return pg;
	}

	public void addController(Controller controller, int hAlign, int vAlign) {
		if (isActive) {
			controller.alignAbout(this, hAlign, vAlign);
			attachController(controller);
			//registerChildController(controller);
		}
	}

	public void addController(Controller controller, int hAlign, int vAlign, int gap) {
		if (isActive) {
			controller.alignAbout(this, hAlign, vAlign, gap);
			attachController(controller);
			//registerChildController(controller);
		}
	}

	public void positionAboutOtherController(Controller controller, int relativePosx, int relativePosy) {
		this.posx = controller.posx + relativePosx;
		this.posy = controller.posy + relativePosy;
	}

	public void attachController(Controller controller) {
		if (isActive) {
			System.out.println("Attaching " + controller.title + " to " + title + " ...");
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
			System.out.println("\t" + controller.title + ".parentController is " + controller.parentController.title);
			// unregister the controller from all stages
			StageManager.getInstance().unregisterControllerFromAllStages(controller);
		}
	}

	//	// register child controller and all its childs (recursively)
	//	public void registerChildController(Controller controller) {
	//		if (parentStage != null) {
	//			parentStage.registerController(controller);
	//			if (controller.controllers.size() > 0) {
	//				ArrayList<Controller> childControllers = controller.controllers;
	//				for (Controller child : childControllers) {
	//					registerChildController(child);
	//				}
	//			}
	//		}
	//	}

	//	public void registerChildControllers() {
	//		if (parentStage != null) {
	//			for (Controller controller : controllers) {
	//				registerChildController(controller);
	//			}
	//		}
	//	}

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
		if (controller.parentController != null) {
			closeParent(controller.parentController);
			closeController(controller.parentController);
		}
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

	public void alignAboutCanvas(int hAlign, int vAlign) {
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

	public void alignAbout(Controller controller, int hAlign, int vAlign, int gap) {
		switch (hAlign) {
		case PConstants.LEFT:
			updateChildrenPositions(gap - this.posx, 0);
			this.posx = gap;
			break;
		case PConstants.RIGHT:
			updateChildrenPositions(controller.w - this.w - gap - this.posx, 0);
			this.posx = controller.w - this.w - gap;
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
			updateChildrenPositions(0, gap - this.posy);
			this.posy = gap;
			break;
		case PConstants.BOTTOM:
			updateChildrenPositions(0, controller.h - this.h - gap - this.posy);
			this.posy = controller.h - this.h - gap;
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
