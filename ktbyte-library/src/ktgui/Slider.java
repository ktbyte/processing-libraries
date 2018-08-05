package ktgui;

import processing.core.PApplet;

/************************************************************************************************
*
************************************************************************************************/
public class Slider extends Controller {

	private int		handlePos			= 0;
	private int		rangeStart			= 0;
	private int		rangeEnd			= 100;
	private float	value				= rangeStart;
	private float	roundingTemplate	= 10;
	private boolean	isValueVisible		= true;

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
		///////////////////////////////////////////////////////////////////////
		pg.beginDraw(); // start drawing the slider
		///////////////////////////////////////////////////////////////////////
		// add rectangle that shows the slider boundaries
		pg.fill(isHovered ? KTGUI.COLOR_BG_HOVERED : KTGUI.COLOR_BG_PASSIVE);
		pg.rectMode(CORNER);
		pg.rect(0, 0, this.w, this.h);
		///////////////////////////////////////////////////////////////////////
		// add rectangle that represents the current handle position
		pg.fill(isHovered ? KTGUI.COLOR_FG_HOVERED : KTGUI.COLOR_FG_PASSIVE);
		if (w > h) {
			pg.rect(0, 0, handlePos, this.h);
		} else {
			pg.rect(0, this.h - handlePos, this.w, handlePos);
		}
		///////////////////////////////////////////////////////////////////////
		// add text label that displays the current value of the slider
		if (isValueVisible) {
			pg.fill(0);
			pg.textAlign(LEFT, CENTER);
			if (w > h) {
				pg.text(PApplet.str(value), 10, h * 0.5f);
				pg.textAlign(LEFT, BOTTOM);
				pg.text(title, 10, -2);
			} else {
				pg.text(PApplet.str(value), 1, h * 0.5f);
			}
		}
		///////////////////////////////////////////////////////////////////////
		pg.endDraw(); // stop drawing the slider
		///////////////////////////////////////////////////////////////////////
	}

	public void addEventAdapter(KTGUIEventAdapter adapter) {
		adapters.add(adapter);
	}

	public float getValue() {
		return value;
	}

	public void setValue(int val) {
		if (val >= rangeStart && val <= rangeEnd) {
			value = val;
			updateHandlePositionFromValue();
		} else {
			System.out.println("You're trying to set the value of the slider "
					+ "to be outside its range.");
		}
	}

	public int getHandlePos() {
		return handlePos;
	}

	public void setHandlePos(int pos) {
		if (pos >= 0 && pos <= this.h) {
			handlePos = pos;
			updateValueFromHandlePosition();
		} else {
			System.out.println("You're trying to set the position of the slider "
					+ "to be outside its height.");
		}
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

	public void setRounding(int n) {
		roundingTemplate = (float) Math.pow(10, n);
	}

	public boolean getIsValueVisible() {
		return isValueVisible;
	}

	public void setIsValueVisible(boolean visible) {
		this.isValueVisible = visible;
	}

	/**
	 * This method is called when the user change the <b>value</b> of the slider 
	 * without the mouse, using the setValue(int) method.
	 */
	private void updateHandlePositionFromValue() {
		if (w > h) {
			handlePos = (int) PApplet.map(value, rangeStart, rangeEnd, 0, this.w);
		} else {
			handlePos = (int) PApplet.map(value, rangeStart, rangeEnd, 0, this.h);
		}
	}

	/**
	 * This method is called when the user change the <b>position</b> of the slider 
	 * with the mouse.
	 */
	private void updateHandlePositionFromMouse() {
		if (w > h) {
			handlePos = PApplet.constrain(pa.mouseX - getAbsolutePosX(), 0, this.w);
		} else {
			handlePos = PApplet.constrain(this.h - (pa.mouseY - getAbsolutePosY()), 0, this.h);
		}
	}

	/**
	 * This method is called to recalculate the value within the given range 
	 *  when the user change the <b>position</b> of the slider with the mouse.
	 */
	private void updateValueFromHandlePosition() {
		if (w > h) {
			value = PApplet.map(handlePos, 0, this.w, rangeStart, rangeEnd);
		} else {
			value = PApplet.map(handlePos, 0, this.h, rangeStart, rangeEnd);
		}

		// based on
		// https://stackoverflow.com/questions/10430370/truncate-a-float-in-java-1-5-excluding-setroundingmode
		if (roundingTemplate > 0) {
			value = Math.round(value * roundingTemplate) / roundingTemplate;
		} else {
			value = (float) Math.floor(value);
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
