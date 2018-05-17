package ktgui;

/**********************************************************************************************************************
 * This is a KTGUI component (controller).
 * This class extends the 'Controller' class.
 * The object of this class can be 'Pressed', 'Hovered', 'Released' and 'Dragged'.
 *********************************************************************************************************************/
public class Button extends Controller {

	public Button(KTGUI ktgui, int posx, int posy, int w, int h) {
		super(ktgui);
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;
		isActive = true;

		title = "a Button";
		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created window in default stage of stageManager
		ktgui.getStageManager().getDefaultStage().registerController(this);
	}

	public Button(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui);
		this.title = title;
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;
		isActive = true;

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created window in default stage of stageManager
		ktgui.getStageManager().getDefaultStage().registerController(this);
	}

	public void updateGraphics() {
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
		pg.text(title, (int)(w * 0.5), (int)(h * 0.5));
		pg.endDraw();
	}

	public void draw() {
		// if this button don't belongs to any window or pane 
		// then draw directly on the PApplet canvas 
		if (parentController == null) {
			pa.image(pg, posx, posy);
		}
	}

	// process mouseMoved event received from PApplet
	public void processMouseMoved() {
		if (isPointInside(pa.mouseX, pa.mouseY)) {
			isHovered = true;
			for (KTGUIEventAdapter adapter : adapters) {
				adapter.onMouseMoved();
			}
		} else {
			isHovered = false;
		}
	}

	// process mousePressed event received from PApplet
	public void processMousePressed() {
		if (isActive) {
			if (isPointInside(pa.mouseX, pa.mouseY)) {
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
	public void processMouseReleased() {
		isPressed = false;
		for (KTGUIEventAdapter adapter : adapters) {
			adapter.onMouseReleased();
		}
	}

	// process mouseDragged event received from PApplet
	public void processMouseDragged() {
		if (isDragable) {
			if (isPressed) {
				for (KTGUIEventAdapter adapter : adapters) {
					adapter.onMouseDragged();
				}
			}
		}
	}

	private boolean isPointInside(int x, int y) {
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
