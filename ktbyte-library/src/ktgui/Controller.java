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

		StageManager.getInstance();
		// automatically register the newly created window in default stage of stageManager
		StageManager.getDefaultStage().registerController(this);

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
		ktgui.drawCallStack.add(title + ".drawUserDefinedGraphics()" + "-'");
		pg.beginDraw();
		pg.image(userpg, 0, 0);
		pg.endDraw();
	}

	public void drawControllers() {
//		if (controllers.size() > 0) {
			ktgui.drawCallStack.add(title + ".drawControllers()" + "-'");
			for (Controller child : controllers) {
				child.updateGraphics();
				child.draw();
				pg.beginDraw();
				ktgui.drawCallStack.add("pg.image(" + child.title + ").getGraphics: " +
						child.posx + ", " + child.posy + "-'  ");
				ktgui.drawCallStack.add("(" + child.title + ").apos:" +
						child.getAbsolutePosX() + ", " + child.getAbsolutePosY() + "-'    ");
				pg.image(child.getGraphics(), child.posx, child.posy);
				pg.endDraw();
			}
//		}
	}

	private void drawGraphics() {
		if (parentController == null) {
			ktgui.drawCallStack.add(title + ".drawGraphics()" + "-'");
			pa.image(pg, posx, posy);
		}
	}

	public void draw() {
		ktgui.drawCallStack.add(title + ".draw()" + "|");
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

	public int getAbsolutePosX() {
		int px = 0;
		if (parentController != null) {
			px += parentController.getAbsolutePosX();
		}
		px += this.posx;
		return px;
	}

	public int getAbsolutePosY() {
		int py = 0;
		if (parentController != null) {
			py += parentController.getAbsolutePosY();
		}
		py += this.posy;
		return py;
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
				System.out.println(title + ".controllers.contains(" +
						controller.title + ") == " + controllers.contains(controller));
				controllers.add(controller);
			}
			// set 'this' controller as parent
			controller.setParentController(this);
			System.out.println("\t" + controller.title + ".parentController is " + controller.parentController.title);
			
			// unregister the controller from all stages
			StageManager.unregisterControllerFromAllStages(controller);
			
			for(Controller child : controller.controllers) {
				
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
			//updateChildrenPositions(KTGUI.ALIGN_GAP - this.posx, 0);
			this.posx = KTGUI.ALIGN_GAP;
			break;
		case PConstants.RIGHT:
			//updateChildrenPositions(pa.width - this.w - KTGUI.ALIGN_GAP - this.posx, 0);
			this.posx = pa.width - this.w - KTGUI.ALIGN_GAP;
			break;
		case PConstants.CENTER:
			//updateChildrenPositions((int) (pa.width * 0.5 - this.w * 0.5) - this.posx, 0);
			this.posx = (int) (pa.width * 0.5 - this.w * 0.5);
			break;
		default:
			break;
		}
		//
		switch (vAlign) {
		case PConstants.TOP:
			//updateChildrenPositions(0, KTGUI.ALIGN_GAP - this.posy);
			this.posy = KTGUI.ALIGN_GAP;
			break;
		case PConstants.BOTTOM:
			//updateChildrenPositions(0, pa.height - this.h - KTGUI.ALIGN_GAP - this.posy);
			this.posy = pa.height - this.h - KTGUI.ALIGN_GAP;
			break;
		case PConstants.CENTER:
			//updateChildrenPositions(0, (int) (pa.height * 0.5 - this.h * 0.5) - this.posy);
			this.posy = (int) (pa.height * 0.5 - this.h * 0.5);
			break;
		default:
			break;
		}
	}

	public void alignAboutCanvas(int hAlign, int vAlign, int gap) {
		switch (hAlign) {
		case PConstants.LEFT:
			this.posx = gap;
			break;
		case PConstants.RIGHT:
			this.posx = pa.width - this.w - gap;
			break;
		case PConstants.CENTER:
			this.posx = (int) (pa.width * 0.5 - this.w * 0.5);
			break;
		default:
			break;
		}
		//
		switch (vAlign) {
		case PConstants.TOP:
			this.posy = gap;
			break;
		case PConstants.BOTTOM:
			this.posy = pa.height - this.h - gap;
			break;
		case PConstants.CENTER:
			this.posy = (int) (pa.height * 0.5 - this.h * 0.5);
			break;
		default:
			break;
		}
	}

	public void alignAbout(Controller controller, int hAlign, int vAlign) {
		switch (hAlign) {
		case PConstants.LEFT:
			this.posx = KTGUI.ALIGN_GAP;
			break;
		case PConstants.RIGHT:
			this.posx = controller.w - this.w - KTGUI.ALIGN_GAP;
			break;
		case PConstants.CENTER:
			this.posx = (int) (controller.w * 0.5 - this.w * 0.5);
			break;
		default:
			break;
		}
		//
		switch (vAlign) {
		case PConstants.TOP:
			this.posy = KTGUI.ALIGN_GAP;
			break;
		case PConstants.BOTTOM:
			this.posy = controller.h - this.h - KTGUI.ALIGN_GAP;
			break;
		case PConstants.CENTER:
			this.posy = (int) (controller.h * 0.5 - this.h * 0.5);
			break;
		default:
			break;
		}
	}

	public void alignAbout(Controller controller, int hAlign, int vAlign, int gap) {
		switch (hAlign) {
		case PConstants.LEFT:
			this.posx = gap;
			break;
		case PConstants.RIGHT:
			this.posx = controller.w - this.w - gap;
			break;
		case PConstants.CENTER:
			this.posx = (int) (controller.w * 0.5 - this.w * 0.5);
			break;
		default:
			break;
		}
		//
		switch (vAlign) {
		case PConstants.TOP:
			this.posy = gap;
			break;
		case PConstants.BOTTOM:
			this.posy = controller.h - this.h - gap;
			break;
		case PConstants.CENTER:
			this.posy = (int) (controller.h * 0.5 - this.h * 0.5);
			break;
		default:
			break;
		}
	}

	public void stackAbout(Controller controller, int direction, int align) {
		switch (direction) {

		case PConstants.TOP: // stack this controller above the given controller
			this.posy = controller.posy - this.h;
			switch (align) {
			case PConstants.LEFT:
				this.posx = controller.posx;
				break;
			case PConstants.RIGHT:
				this.posx = controller.posx + controller.w - this.w;
				break;
			case PConstants.CENTER:
				this.posx = (int) (controller.posx + controller.w * 0.5) - (int) (this.w * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.BOTTOM: // stack this controller below the given controller
			this.posy = controller.posy + this.h;
			switch (align) {
			case PConstants.LEFT:
				this.posx = controller.posx;
				break;
			case PConstants.RIGHT:
				this.posx = controller.posx + controller.w - this.w;
				break;
			case PConstants.CENTER:
				this.posx = (int) (controller.posx + controller.w * 0.5) - (int) (this.w * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.LEFT: // stack this controller to the left about given controller
			this.posx = controller.posx - this.w;
			switch (align) {
			case PConstants.TOP:
				this.posy = controller.posy;
				break;
			case PConstants.BOTTOM:
				this.posy = controller.posy + controller.h - this.h;
				break;
			case PConstants.CENTER:
				this.posy = (int) (controller.posy + controller.h * 0.5) - (int) (this.h * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.RIGHT: // stack this controller to the right about given controller
			this.posx = controller.posx + this.w;
			switch (align) {
			case PConstants.TOP:
				this.posy = controller.posy;
				break;
			case PConstants.BOTTOM:
				this.posy = controller.posy + controller.h - this.h;
				break;
			case PConstants.CENTER:
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

	/*   
	 *  This method overrides the KTGUIEventProcessor's `mouseMoved()` method and 
	 *  implements its own behaviour. In particular, when this event is received 
	 *  from the parent PApplet, this implementation defines the <b>"hovering"</b> 
	 *  state/behaviour.(the <i>"hovered"</i> state is  defined by the <b>isHovered</b> 
	 *  variable, which can be set to true or false).
	 */
	@Override public void processMouseMoved() {
		if (isActive) {
			// transfer mouseMoved event to child controllers
			for (Controller child : controllers) {
				child.processMouseMoved();
			}
			// process mouseMoved event by own means
			isHovered = isPointInside(pa.mouseX, pa.mouseY) ? true : false;
			if (isHovered) {
				for (KTGUIEventAdapter adapter : adapters) {
					adapter.onMouseMoved();
				}
			}
		}
	}

	/*   
	 *  This method overrides the KTGUIEventProcessor's `mousePressed()` method and 
	 *  implements its own behaviour. In particular, when this event is received from 
	 *  the parent PApplet, this implementation decides when the state of this 
	 *  controller is changing from <b>Pressed</b> to <b>Released</b> and vice versa 
	 *  (the state is defined by the  <i>isPressed</i> variable, which can be set 
	 *  to true or false).
	 */
	@Override public void processMousePressed() {
		if (isActive) {
			// transfer mousePressed event to child controllers
			for (Controller child : controllers) {
				child.processMousePressed();
			}
			// process mousePressed event by own means
			isPressed = isHovered;
			if (isPressed) {
				for (KTGUIEventAdapter adapter : adapters) {
					adapter.onMousePressed();
				}
			}
		}
	}

	/*   
	 *  This method overrides the KTGUIEventProcessor's `mouseReleased` method and
	 *  implements its own behaviour. In particular, when this event is received 
	 *  from the parent, this implementation always sets the <i>isPressed</i> 
	 *  variable to false. I.e. it changes the state of the controller to 'released'
	 *  (unpressed).
	 */
	@Override public void processMouseReleased() {
		if (isActive) {
			// transfer mouseReleased event to child controllers
			for (Controller child : controllers) {
				child.processMouseReleased();
			}
			// process mouseReleased event by own means
			isPressed = false;
			for (KTGUIEventAdapter adapter : adapters) {
				adapter.onMouseReleased();
			}
		}
	}

	/*   
	 *  This method overrides the KTGUIEventProcessor's `mouseDragged` method and 
	 *  implements its own behaviour. In particular, when this event is received 
	 *  from the parent PApplet, this implementation defines the <i>"dragging"</i> 
	 *  state/behaviour.
	 */
	@Override public void processMouseDragged() {
		if (isActive) {
			// transfer mouseDragged event to child controllers
			for (Controller child : controllers) {
				child.processMouseDragged();
			}
			// process mouseDragged event by own means
			if (isDragable) {
				if (isPressed) {
					posx += pa.mouseX - pa.pmouseX;
					posy += pa.mouseY - pa.pmouseY;
					for (KTGUIEventAdapter adapter : adapters) {
						adapter.onMouseDragged();
					}
				}
			}
		}
	}

	@Override public boolean isPointInside(int x, int y) {
		boolean isInside = false;
		if (isActive) {
			if (x > getAbsolutePosX() && x < getAbsolutePosX() + w) {
				if (y > getAbsolutePosY() && y < getAbsolutePosY() + h) {
					isInside = true;
				}
			}
		}
		return isInside;
	}
}
