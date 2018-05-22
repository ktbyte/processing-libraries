package ktgui;

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
public class Pane extends Controller {

	public Pane(KTGUI ktgui, int posx, int posy, int w, int h) {
		super(ktgui);
		this.title = "a Pane";
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;
		this.pg = pa.createGraphics(w + 1, h + 1);
		this.userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created pane in default stage of stageManager
		ktgui.getStageManager().defaultStage.registerController(this);
	}

	public Pane(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui);
		this.title = title;
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;
		this.pg = pa.createGraphics(w + 1, h + 1);
		this.userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created pane in default stage of stageManager
		ktgui.getStageManager().defaultStage.registerController(this);
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

	private boolean isPointInside(int x, int y) {
		boolean isInside = false;
		if (x > posx && x < posx + this.w) {
			if (y > posy && y < posy + this.h) {
				isInside = true;
			}
		}
		return isInside;
	}
}

class WindowPane extends Pane {
	  Window parentWindow;
	  
	  WindowPane(KTGUI ktgui, Window window, int posx, int posy, int w, int h) {
	    super(ktgui, posx, posy, w, h);
	    this.parentWindow = window;
	    //isDragable = false;
	  }

	  WindowPane(KTGUI ktgui, String title, Window window, int posx, int posy, int w, int h) {
	    super(ktgui, title, posx, posy, w, h);
	    this.parentWindow = window;
	    //isDragable = false;
	  }
	}
