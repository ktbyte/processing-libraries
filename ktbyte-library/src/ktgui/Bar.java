package ktgui;

public class Bar extends Controller {

	public Bar(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		this.isDragable = true;
	}

	public void updateGraphics() {
		ktgui.drawCallStack.add(title + ".updateGraphics()");
		// draw bar and title
		pg.beginDraw();
		pg.background(200, 200);
		pg.rectMode(CORNER);
		pg.fill(bgPassiveColor);
		pg.stroke(15);
		pg.strokeWeight(1);
		pg.rect(0, 0, w, h);
		pg.fill(25);
		pg.textAlign(LEFT, CENTER);
		pg.textSize(h * 0.65f);
		pg.text(title, 10, h * 0.5f);
		pg.endDraw();
	}

	// process mouseMoved event received from PApplet
	public void processMouseMoved() {
		// transfer mouseMoved event to child controllers
		for(Controller child : controllers) {
			child.processMouseMoved();
		}
		// process mouseMoved event by own means
		isHovered = isPointInside(pa.mouseX, pa.mouseY) ? true : false;
		for (KTGUIEventAdapter adapter : adapters) {
			adapter.onMouseMoved();
		}
	}

	// process mousePressed event received from PApplet
	public void processMousePressed() {
		// transfer mousePressed event to child controllers
		for(Controller child : controllers) {
			child.processMousePressed();
		}
		// process mousePressed event by own means
		if (isHovered) {
			isPressed = true;
			for (KTGUIEventAdapter adapter : adapters) {
				adapter.onMousePressed();
			}
		} else {
			isPressed = false;
		}
	}

	// process mouseReleased event received from PApplet
	public void processMouseReleased() {
		// transfer mouseReleased event to child controllers
		for(Controller child : controllers) {
			child.processMouseReleased();
		}
		// process mouseReleased event by own means
		isPressed = false;
		if (isHovered) {
			for (KTGUIEventAdapter adapter : adapters) {
				adapter.onMouseReleased();
			}
		}
	}

	// process mouseDragged event received from PApplet
	public void processMouseDragged() {
		// transfer mouseDragged event to child controllers
		for(Controller child : controllers) {
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

	boolean isPointInside(int x, int y) {
		boolean isInside = false;
		if (x > posx && x < posx + this.w) {
			if (y > posy && y < posy + this.h) {
				isInside = true;
			}
		}
		return isInside;
	}
}

