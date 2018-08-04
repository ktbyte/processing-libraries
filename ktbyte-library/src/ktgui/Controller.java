package ktgui;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PGraphics;
import processing.event.MouseEvent;

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
		System.out.println("Creating " + title + " started.");
		this.ktgui = ktgui;
		this.pa = KTGUI.getParentPApplet();
		this.title = title;
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		if (w < 5 || h < 5) {
			System.out.println("w:" + w + ", h:" + h);
			System.out.println("!!! Width and height of the controller must be greater than 5 px. "
					+ title + " is not created. Exiting Controller constructor. Exiting app.");
			pa.exit();
			//return;
		}

		StageManager.getInstance();
		// automatically register the newly created window in default stage of stageManager
		StageManager.getInstance().getDefaultStage().registerController(this);

		initColors();
		System.out.println("Creating " + title + " completed.");
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
		ktgui.drawCallStack.add(title + ".drawControllers()" + "-'");
		for (Controller child : controllers) {
			child.updateGraphics();
			child.draw();

			pg.beginDraw();
			ktgui.drawCallStack
					.add("pg.image(" + child.title + ").getGraphics: " + child.posx + ", " + child.posy + "-'  ");
			ktgui.drawCallStack.add("(" + child.title + ").apos:" + child.getAbsolutePosX() + ", "
					+ child.getAbsolutePosY() + "-'    ");
			pg.image(child.getGraphics(), child.posx, child.posy);
			pg.endDraw();
		}
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

	public String getInfo() {
		StringBuilder info = new StringBuilder();
		info.append("[" + ((title != null) ? title : "null") + "]");
		info.append(", pStage:" + ((parentStage != null) ? parentStage.getName() : "null"));
		info.append(", pCtrlr:" + ((parentController != null) ? parentController.title : "null"));
		info.append(", childs.sz():" + controllers.size());
		info.append(", isPrsd:" + isPressed);
		info.append(", isHvrd:" + isHovered);
		info.append(", rpsx:" + posx);
		info.append(", rpsy:" + posy);
		return info.toString();
	}

	public ArrayList<String> getFullInfoList(int level) {
		int recursyLevel = level;

		ArrayList<String> list = new ArrayList<>();
		StringBuilder prefix = new StringBuilder();

		if (recursyLevel > 0) {
			prefix.append("'");
			for (int i = 0; i < recursyLevel; i++) {
				prefix.append("-");
			}
		} else {
			prefix.append("+");
		}

		list.add(prefix.toString() + getInfo());

		if (controllers.size() > 0) {
			recursyLevel++;
			for (Controller child : controllers) {
				list.addAll(child.getFullInfoList(recursyLevel));
			}
		}
		return list;
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

	public void addController(Controller child, int hAlign, int vAlign) {
		if (isActive) {
			child.alignAbout(this, hAlign, vAlign);
			attachController(child);
		}
	}

	public void addController(Controller child, int hAlign, int vAlign, int gap) {
		if (isActive) {
			child.alignAbout(this, hAlign, vAlign, gap);
			attachController(child);
			//registerChildController(controller);
		}
	}

	public void positionAboutOtherController(Controller controller, int relativePosx, int relativePosy) {
		this.posx = controller.posx + relativePosx;
		this.posy = controller.posy + relativePosy;
	}

	public void attachController(Controller controller) {
		if (isActive) {
			System.out.println("Attaching " + controller.title + " to " + title + " started.");

			// detach from existing controller first (if exist)
			if (controller.parentController != null) {
				Controller pc = controller.parentController;
				pc.detachController(controller); // reset parentWindow
			}
			// add to the list of (child) controllers of 'this' controller
			if (!controllers.contains(controller)) {
				System.out.println(title + ".controllers.contains(" + controller.title + ") == " +
						controllers.contains(controller));
				controllers.add(controller);
			}
			// set 'this' controller as parent of the controller being processed
			controller.setParentController(this);
			System.out.println("\t" + controller.title + ".parentController is " + controller.parentController.title);

			// unregister the controller from all stages
			StageManager.getInstance().unregisterControllerFromAllStages(controller);

			System.out.println("Attaching " + controller.title + " to " + title + " completed.");
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

	public void closeParent() {
		if (parentController != null) {
			parentController.close();
		}
		closeAllChildsRecursively();
	}

	public void closeAllChildsRecursively() {
		for (Controller childController : controllers) {
			childController.closeAllChildsRecursively();
			childController.close();
		}
	}

	public void close() {
		PApplet.println("Closing '" + title + "' controller.");
		isActive = false;
		ktgui.addToGarbage(this, pa.millis());
	}

	/**
	 * @see #alignAboutCanvas(int, int, int) alignAboutCanvas
	 * @param hAlign
	 * 	the horizontal alignment position
	 * @param vAlign
	 * 	the vertical alignment position 
	 */
	public void alignAboutCanvas(int hAlign, int vAlign) {
		alignAboutCanvas(hAlign, vAlign, KTGUI.ALIGN_GAP);
	}

	/**
	 * @param hAlign
	 * 	the horizontal alignment position 
	 * @param vAlign
	 * 	the vertical alignment position
	 * @param gap
	 *  the gap between the outer boundary of the PApplet canvas and 
	 *  the side of the controller to be aligned. 
	 */
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

	/**
	 * @param controller
	 * 	the controller whos position is used as a 'reference' for aligning process
	 * @param hAlign
	 * 	the horizontal alignment position 
	 * @param vAlign
	 * 	the vertical alignment position 
	 */
	public void alignAbout(Controller controller, int hAlign, int vAlign) {
		alignAbout(controller, hAlign, vAlign, KTGUI.ALIGN_GAP);
	}

	/**
	 * This method is used to align one controller about the other (reference) controller. 
	 * By 'aligning' we understand the process of changing the X and Y coordinates. 
	 * The X and Y position, and width and height of the controller being used as 
	 * a reference are used to calculate the new position of the controller to 
	 * be aligned. The said values identify the 'boundary rectangle' of the reference controller.
	 * The named constants LEFT, RIGHT, BOTTOM, TOP and CENTER are used to identify
	 * the sides and the center of the bounding rectangle. The sides and center 
	 * of the reference rectangle are used for calculation of the relative 
	 * distances that are used to 'shift' the position of the controller to be 
	 * aligned. The direction of shifting is <b>inward</b> - i.e. the changing of relative 
	 * position is made from the sides of the bounding rectangle <i>to the center</i> of the 
	 * bounding rectangle.
	 * 
	 * @param controller
	 *  the 'reference' controller.
	 * @param hAlign
	 * 	the horizontal alignment direction. The following named constants can be used:</br>
	 * <ul>
	 * <li>
	 * LEFT - the controller will be placed so that its <i>left</i> side will be 
	 * aligned to the <i>left</i> side of the reference controller.</br>
	 * </li>
	 * <li>
	 * RIGHT - the controller will be placed so that its <i>right</i> side will be 
	 * aligned to the <i>right</i> side of the reference controller.</br>
	 * </li>
	 * <li>
	 * CENTER - the controller will be placed so that its <i>center</i> will be 
	 * aligned to the <i>center</i> of the reference controller.</br> 
	 * </li>
	 * </ul>
	 * @param vAlign
	 * 	the vertical alignment direction. The following named constants can be used:</br> 
	 * <ul>
	 * <li>
	 *  TOP - the controller will be placed so that its <i>top</i> side will be 
	 *  aligned to the <i>top</i> side of the reference controller.</br>
	 * </li>
	 * <li>
	 *  BOTTOM - the controller will be placed so that its <i>bottom</i> side will be 
	 *  aligned to the <i>bottom</i> side of the reference controller.</br>
	 * </li>
	 * <li>
	 *  CENTER - the controller will be placed so that its <i>center</i> will be 
	 *  aligned to the <i>center</i> of the reference controller. </br>
	 * </li>
	 * </ul>
	 * @param gap
	 *  the gap between aligned sides. If the CENTER constant is used as hAlign 
	 *  or vAlign argument then the gap is <b>not</b> added in that direction.
	 */
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
			this.posy = controller.posy + controller.h;
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
				this.posy = controller.posy - this.h;
				break;
			case PConstants.BOTTOM:
				this.posy = controller.posy + controller.h;
				break;
			case PConstants.CENTER:
				this.posy = (int) (controller.posy + controller.h * 0.5) - (int) (this.h * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.RIGHT: // stack this controller to the right about given controller
			this.posx = controller.posx + controller.w;
			switch (align) {
			case PConstants.TOP:
				this.posy = controller.posy - this.h;
				break;
			case PConstants.BOTTOM:
				this.posy = controller.posy + controller.h;
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

	public void stackAbout(Controller controller, int direction, int align, int gap) {
		switch (direction) {

		case PConstants.TOP: // stack this controller above the given controller
			this.posy = controller.posy - this.h - gap;
			switch (align) {
			case PConstants.LEFT:
				this.posx = controller.posx - gap;
				break;
			case PConstants.RIGHT:
				this.posx = controller.posx + controller.w - this.w + gap;
				break;
			case PConstants.CENTER:
				this.posx = (int) (controller.posx + controller.w * 0.5) - (int) (this.w * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.BOTTOM: // stack this controller below the given controller
			this.posy = controller.posy + controller.h + gap;
			switch (align) {
			case PConstants.LEFT:
				this.posx = controller.posx - gap;
				break;
			case PConstants.RIGHT:
				this.posx = controller.posx + controller.w - this.w + gap;
				break;
			case PConstants.CENTER:
				this.posx = (int) (controller.posx + controller.w * 0.5) - (int) (this.w * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.LEFT: // stack this controller to the left about given controller
			this.posx = controller.posx - this.w - gap;
			switch (align) {
			case PConstants.TOP:
				this.posy = controller.posy - this.h - gap;
				break;
			case PConstants.BOTTOM:
				this.posy = controller.posy + controller.h + gap;
				break;
			case PConstants.CENTER:
				this.posy = (int) (controller.posy + controller.h * 0.5) - (int) (this.h * 0.5);
				break;
			default:
				break;
			}
			break;

		case PConstants.RIGHT: // stack this controller to the right about given controller
			this.posx = controller.posx + controller.w + gap;
			switch (align) {
			case PConstants.TOP:
				this.posy = controller.posy - this.h - gap;
				break;
			case PConstants.BOTTOM:
				this.posy = controller.posy + controller.h + gap;
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
	@Override
	public void processMouseMoved() {
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
	@Override
	public void processMousePressed() {
		if (isActive) {
			// transfer mousePressed event to child controllers
			for (Controller child : controllers) {
				child.processMousePressed();
			}
			// process mousePressed event by own means
			isPressed = isFocused = isHovered;
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
	@Override
	public void processMouseReleased() {
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
	@Override
	public void processMouseDragged() {
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

	@Override
	public boolean isPointInside(int x, int y) {
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

	@Override
	public void processKeyPressed() {
		if (isActive) {
			// transfer keyPressed event to child controllers
			for (Controller child : controllers) {
				child.processKeyPressed();
			}
		}
	}

	@Override
	public void processKeyReleased() {
		if (isActive) {
			// transfer keyReleased event to child controllers
			for (Controller child : controllers) {
				child.processKeyReleased();
			}
		}
	}

	@Override
	public void processMouseWheel(MouseEvent me) {
		if (isActive) {
			// transfer mouseWheel event to child controllers
			for (Controller child : controllers) {
				child.processMouseWheel(me);
			}
		}
	}
}
