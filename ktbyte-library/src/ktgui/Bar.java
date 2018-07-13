package ktgui;

public class Bar extends Controller {
	/*
	 * 
	 */
	public Bar(KTGUI ktgui, int x, int y, int w, int h) {
		super(ktgui);
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;
		this.title = "a Bar";

		this.isDragable = true;

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);
		// automatically register the newly created window in default stage of stageManager
		StageManager.getInstance().defaultStage.registerController(this);
	}

	public Bar(KTGUI ktgui, String title, int x, int y, int w, int h) {
		super(ktgui);
		this.title = title;
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;

		this.isDragable = true;

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);
		// automatically register the newly created window in default stage of stageManager
		StageManager.getInstance().defaultStage.registerController(this);
	}

	public void updateGraphics() {
		// drawBar and title
		pg.beginDraw();
		pg.background(200, 200);
		pg.rectMode(CORNER);
		pg.fill(bgPassiveColor);
		pg.stroke(15);
		pg.strokeWeight(1);
		pg.rect(0, 0, w, KTGUI.TITLE_BAR_HEIGHT);
		pg.fill(25);
		pg.textAlign(LEFT, CENTER);
		pg.textSize(KTGUI.TITLE_BAR_HEIGHT * 0.65f);
		pg.text(title, 10, KTGUI.TITLE_BAR_HEIGHT * 0.5f);
		pg.endDraw();
	}

	public void drawControllers() {
		for (Controller controller : controllers) {
			pg.beginDraw();
			pg.image(controller.getGraphics(), controller.posx, controller.posy);
			pg.endDraw();
		}
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
		} else {
			isPressed = false;
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

