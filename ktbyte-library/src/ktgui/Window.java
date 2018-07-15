package ktgui;

public class Window extends Controller {

	// Border border;
	TitleBar	titleBar;
	// MenuBar menuBar;
	WindowPane	pane;

	public Window(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		isDragable = true;
		createTitleBar();
		createPane();
		setTitle(title);
	}
	
	@Override
	public void updateGraphics() {
		pg.beginDraw();
		pg.background(200, 50);
		pg.endDraw();
	}
	
	/*
	 * This particular implementation defines the area that can be (pressed/dragged)
	 * as area of child titleBar 
	 */
	@Override public boolean isPointInside(int x, int y) {
		boolean isInside = false;
		if (isActive) {
			if (x > getAbsolutePosX() && x < getAbsolutePosX() + w) {
				if (y > getAbsolutePosY() && y < getAbsolutePosY() + titleBar.h) {
					isInside = true;
				}
			}
		}
		return isInside;
	}
	
	private void createTitleBar() {
		titleBar = new TitleBar(ktgui, "tb:" + title, 0, 0, w, KTGUI.TITLE_BAR_HEIGHT);
		// Prevent the child titleBar from being dragged. Instead, the Window can be 
		// dragged. And whent this happens, all the child controllers (including titleBar
		// will be dragged to the same amount of distance and in the same direction.
		titleBar.isDragable = false; 
		attachController(titleBar);
	}
	
	private void createPane() {
		
	}

	@Override
	public void addController(Controller controller, int hAlign, int vAlign) {
		if (isActive) {
			controller.alignAbout(pane, hAlign, vAlign);
			pane.attachController(controller);
		}
	}

	public Pane getPane() {
		return pane;
	}
}
