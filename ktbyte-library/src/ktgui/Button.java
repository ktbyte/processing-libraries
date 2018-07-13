package ktgui;

/**********************************************************************************************************************
 * This is a KTGUI component (controller).
 * This class extends the 'Controller' class.
 * The object of this class can be 'Pressed', 'Hovered', 'Released' and 'Dragged'.
 *********************************************************************************************************************/
public class Button extends Controller {

	public Button(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
	}

	public void updateGraphics() {
		pg.beginDraw();
		pg.rectMode(CORNER);
		if (isHovered && !isPressed) {
			pg.fill(fgHoveredColor);
		} else if (isHovered && isPressed) {
			pg.fill(fgPressedColor);
		} else {
			pg.fill(fgPassiveColor);
		}
		pg.rect(0, 0, w, h, r1, r2, r3, r4);
		pg.fill(255);
		pg.textAlign(CENTER, CENTER);
		pg.textSize(14);
		pg.text(title, (int) (w * 0.5), (int) (h * 0.5));
		pg.endDraw();
	}

	public void draw() {
		// if this button don't belongs to any window or pane 
		// then draw directly on the PApplet canvas 
		if (parentController == null) {
			pa.image(pg, posx, posy);
		}
	}

	/*   
	 *  This method overrides the Controller's `mouseMoved()` method and implements
	 *  its own behaviour for when this event is received from the parent PApplet. 
	 *  In particular, this implementation defines the <b>"hovering"</b> behaviour.
	 *  (the <i>"hovered"</i> state is  defined by the <b>isHovered</b> variable, which 
	 *  can be set to true or false).
	 */
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

	/*   
	 *  This method overrides the Controller's `mousePressed()` method and implements
	 *  its own behaviour for when this event is received from the parent PApplet. 
	 *  In particular, this implementation decides when the state of this button is
	 *  changing from <b>Pressed</b> to <b>Released</b> and vice versa (the state is 
	 *  defined by the  <i>isPressed</i> variable, which can be set to true or false).
	 */
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

	/*   
	 *  This method overrides the Controller's `mouseReleased` method and implements
	 *  its own behaviour for when this event is received from the parent PApplet. 
	 *  In particular, this implementation always sets the <i>isPressed</i> variable 
	 *  to false.
	 */
	public void processMouseReleased() {
		isPressed = false;
		for (KTGUIEventAdapter adapter : adapters) {
			adapter.onMouseReleased();
		}
	}

	/*   
	 *  This method overrides the Controller's `mouseDragged` method and implements
	 *  its own behaviour for when this event is received from the parent PApplet. 
	 *  In particular, this implementation defines the <i>"dragging"</i> behaviour.
	 */
	public void processMouseDragged() {
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


