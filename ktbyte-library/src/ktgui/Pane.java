package ktgui;

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
public class Pane extends Controller {
	
	public Pane(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
	}

	public void updateGraphics() {
		// change thickness depending on the user-mouse behavior
		pg.beginDraw();
		pg.background(200, 100);
		pg.stroke(0);
		pg.strokeWeight(1);
		//pg.fill(200, 220, 200, 50);
		pg.rectMode(CORNER);
		pg.rect(0, 0, w, h);
		pg.noFill();
		pg.endDraw();
	}

	// process mouseMoved event received from PApplet
	public void processMouseMoved() {
		isHovered = isPointInside(pa.mouseX, pa.mouseY) ? true : false;
		for (KTGUIEventAdapter adapter : adapters) {
			adapter.onMouseMoved();
		}
	}

	// process mousePressed event received from PApplet
	public void processMousePressed() {
		if (isHovered) {
			isPressed = true;
			for (KTGUIEventAdapter adapter : adapters) {
				adapter.onMousePressed();
			}
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

