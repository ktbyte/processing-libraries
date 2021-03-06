package ktbyte.gui;

public class Window extends Controller {

	// Border border;
	private TitleBar	titleBar;
	// MenuBar menuBar;
	private Pane		pane;

	public Window(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		isDragable = true;
		createTitleBar();
		createPane();
		setTitle(title);
	}

	@Override
	public void updateGraphics() {
        super.updateGraphics();
		pg.beginDraw();
		pg.background(200, 50);
		pg.stroke(0);
		pg.noFill();
		pg.rectMode(CORNER);
		if(isSelected(this)) {
		    pg.strokeWeight(3f);
		} else {
		    pg.strokeWeight(1f);
		}
		pg.rect(0, 0, w, h, r1, r2, r3, r4);
		pg.endDraw();
	}

    /*   
     *  This method overrides the default Controller's implementation in
     *  order to prevent blocking processing of the mousePressed event if
     *  the controller has the childs. (in default Controller's implementation
     *  this was done in order to prevent 'duplicate' pressing/dragging.
     */
    @Override
    public void processMousePressed() {
        if (isActive) {
            // transfer mousePressed event to child controllers
            for (Controller child : controllers) {
                child.processMousePressed();
            }

            // process mousePressed event by own means
            //isPressed = isFocused = isHovered;
            isPressed = isHovered;
            if (isPressed) {
                for (EventAdapter adapter : adapters) {
                    adapter.onMousePressed();
                }
            }
        }
    }
	
	/*
	 * This particular implementation overrides the default Controller's 
	 * implementation and REDIFINES the window area that can be used to 
	 * process 'press/drag' mouse actions.  
	 */
	@Override
	public boolean isPointInside(int x, int y) {
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
		titleBar = new TitleBar(ktgui, "tb:" + title, 0, 0, w, KTGUI.DEFAULT_COMPONENT_WIDTH);
		// Prevent the child titleBar from being dragged. Instead, the Window can be 
		// dragged. And when this happens, all the child controllers (including titleBar
		// will be dragged to the same amount of distance and in the same direction.
		titleBar.isDragable = false;
		attachController(titleBar);
	}

	private void createPane() {
		pane = new Pane(ktgui, "pane:" + title, 0, KTGUI.DEFAULT_COMPONENT_WIDTH, w, h - KTGUI.DEFAULT_COMPONENT_WIDTH);
		pane.isDragable = false;
		attachController(pane);
	}

	/**
	 * Add child controller to the 'internal' pane instead of adding it to 'this' window    
	 */
	@Override
	public void addController(Controller child, int hAlign, int vAlign) {
		if (isActive) {
			child.alignAbout(pane, hAlign, vAlign);
			pane.attachController(child);
		}
	}

	/**
	 * Add child controller to the 'internal' pane instead of adding it to 'this' window    
	 */
	@Override
	public void addController(Controller child, int hAlign, int vAlign, int gap) {
		if (isActive) {
			child.alignAbout(pane, hAlign, vAlign, gap);
			pane.attachController(child);
		}
	}

	public Pane getPane() {
		return pane;
	}

}
