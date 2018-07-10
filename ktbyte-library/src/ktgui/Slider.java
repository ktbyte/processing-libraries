package ktgui;

import processing.core.PApplet;

/************************************************************************************************
*
************************************************************************************************/
public class Slider extends Controller {

	int		pos			= 0;
	int		rangeStart	= 0;
	int		rangeEnd	= 100;
	float	value		= rangeStart;

	//-----------------------------------------------------------------------------------------------
	//
	//-----------------------------------------------------------------------------------------------
	Slider(KTGUI ktgui, int posx, int posy, int width, int height, int sr, int er) {
		super(ktgui);
		this.posx = posx;
		this.posy = posy;
		this.w = width;
		this.h = height;
		this.rangeStart = sr;
		this.rangeEnd = er;
		this.title = "The Slider";
		updateHandlePositionFromMouse();
		updateValueFromHandlePosition();

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created window in default stage of stageManager
		StageManager.getInstance().getDefaultStage().registerController(this);
	}

	//-----------------------------------------------------------------------------------------------
	//
	//-----------------------------------------------------------------------------------------------
	public void draw() {
//		pa.pushMatrix();
//		pa.translate(posx, posy);
//		pa.pushStyle();
//		pa.fill(isHovered ? KTGUI.COLOR_BG_HOVERED : KTGUI.COLOR_BG_PASSIVE);
//		pa.rectMode(CORNER);
//		pa.rect(0, 0, this.w, this.h);
//		pa.fill(isHovered ? KTGUI.COLOR_FG_HOVERED : KTGUI.COLOR_FG_PASSIVE);
//		pa.rect(0, 0, pos, this.h);
//		pa.fill(0);
//		pa.textAlign(LEFT, CENTER);
//		pa.text(PApplet.str(value), 10, h * 0.5f);
//		pa.textAlign(LEFT, BOTTOM);
//		pa.text(title, 10, -2);
//		pa.popStyle();
//		pa.popMatrix();
		if (parentController == null) {
			pa.image(pg, posx, posy);
		}
	}

	public void updateGraphics() {
		pg.beginDraw();
		pg.fill(isHovered ? KTGUI.COLOR_BG_HOVERED : KTGUI.COLOR_BG_PASSIVE);
		pg.rectMode(CORNER);
		pg.rect(0, 0, this.w, this.h);
		pg.fill(isHovered ? KTGUI.COLOR_FG_HOVERED : KTGUI.COLOR_FG_PASSIVE);
		pg.rect(0, 0, pos, this.h);
		pg.fill(0);
		pg.textAlign(LEFT, CENTER);
		pg.text(PApplet.str(value), 10, h * 0.5f);
		pg.textAlign(LEFT, BOTTOM);
		pg.text(title, 10, -2);
		pg.endDraw();
	}
	
	public void addEventAdapter(KTGUIEventAdapter adapter) {
		adapters.add(adapter);
	}

	boolean isPointInside(int ptx, int pty) {
		boolean isInside = false;
		if (ptx > this.posx && ptx < this.posx + this.w) {
			if (pty > this.posy && pty < this.posy + this.h) {
				isInside = true;
			}
		}
		return isInside;
	}

	public float getValue() {
		return value;
	}

	int getPosition() {
		return pos;
	}

	public int getRangeStart() {
		return rangeStart;
	}

	public void setRangeStart(int rangeStart) {
		this.rangeStart = rangeStart;
		updateValueFromHandlePosition();
	}

	public int getRangeEnd() {
		return rangeEnd;
	}

	public void setRangeEnd(int rangeEnd) {
		this.rangeEnd = rangeEnd;
		updateValueFromHandlePosition();
	}

	void updateHandlePositionFromMouse() {
		pos = PApplet.constrain(pa.mouseX - posx, 0, this.w);
	}

	void updateValueFromHandlePosition() {
		value = PApplet.map(pos, 0, this.w, rangeStart, rangeEnd);
	}

	// process mouseMoved event received from PApplet
	public void processMouseMoved() {
		if (isPointInside(pa.mouseX, pa.mouseY)) {
			isHovered = true;
		} else {
			isHovered = false;
		}

		for (KTGUIEventAdapter adapter : adapters) {
			adapter.onMouseMoved();
		}
	}

	// process mousePressed event received from PApplet
	public void processMousePressed() {
		if (isHovered) {
			isPressed = true;
		} else {
			isPressed = false;
		}

		if (isPressed) {
			updateHandlePositionFromMouse();
			updateValueFromHandlePosition();
		}

		for (KTGUIEventAdapter adapter : adapters) {
			adapter.onMousePressed();
		}
	}

	// process mouseReleased event received from PApplet
	public void processMouseReleased() {
		isPressed = false;
		if (isHovered) {
			for (KTGUIEventAdapter adapter : adapters) {
				adapter.onMouseReleased();
			}
		}
	}

	// process mouseDragged event received from PApplet
	public void processMouseDragged() {
		if (isPressed) {
			updateHandlePositionFromMouse();
			updateValueFromHandlePosition();
		}
		for (KTGUIEventAdapter adapter : adapters) {
			adapter.onMouseDragged();
		}
	}
}
