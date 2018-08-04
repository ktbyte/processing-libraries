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

	// -----------------------------------------------------------------------------------------------
	//
	// -----------------------------------------------------------------------------------------------
	Slider(KTGUI ktgui, String title, int posx, int posy, int w, int h, int sr, int er) {
		super(ktgui, title, posx, posy, w, h);
		this.rangeStart = sr;
		this.rangeEnd = er;
		updateHandlePositionFromMouse();
		updateValueFromHandlePosition();
	}

	@Override
	public void updateGraphics() {
		ktgui.drawCallStack.add(title + ".updateGraphics()");
		pg.beginDraw();
		pg.fill(isHovered ? KTGUI.COLOR_BG_HOVERED : KTGUI.COLOR_BG_PASSIVE);
		pg.rectMode(CORNER);
		pg.rect(0, 0, this.w, this.h);
		pg.fill(isHovered ? KTGUI.COLOR_FG_HOVERED : KTGUI.COLOR_FG_PASSIVE);
		if (w > h) {
			pg.rect(0, 0, pos, this.h);
		} else {
			// pg.rect(0, 0, this.w, pos);
			pg.rect(0, pos, this.w, this.h - pos);
		}
		pg.fill(0);
		pg.textAlign(LEFT, CENTER);
		if (w > h) {
			pg.text(PApplet.str(value), 10, h * 0.5f);
			pg.textAlign(LEFT, BOTTOM);
			pg.text(title, 10, -2);
		} else {
			pg.text(PApplet.str(value), 1, h * 0.5f);
		}
		pg.endDraw();
	}

	public void addEventAdapter(KTGUIEventAdapter adapter) {
		adapters.add(adapter);
	}

	public float getValue() {
		return value;
	}

	public int getPos() {
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
		if (w > h) {
			pos = PApplet.constrain(pa.mouseX - getAbsolutePosX(), 0, this.w);
		} else {
			pos = PApplet.constrain(pa.mouseY - getAbsolutePosY(), 0, this.h);
		}
	}

	void updateValueFromHandlePosition() {
		if (w > h) {
			value = PApplet.map(pos, 0, this.w, rangeStart, rangeEnd);
		} else {
			value = PApplet.map(pos, 0, this.h, rangeStart, rangeEnd);
		}
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
