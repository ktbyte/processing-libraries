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

	public void updateGraphics() {
		pg.beginDraw();
		pg.background(200, 50);
		pg.endDraw();
	}
	
//	@Override
//	public void draw() {
//		//
//		// the following code block is only for debuggin purposes
//		// START OF DEBUGGIN BLOCK;
//		//
//		//		drawUserDefinedGraphics();
//		//		pg.beginDraw();
//		//		pg.pushMatrix();
//		//		pg.stroke(0);
//		//		pg.rectMode(CENTER);
//		//		pg.rect(w * 0.5f, h * 0.5f, w * 0.5f, h * 0.5f);
//		//		pg.popMatrix();
//		//		pg.endDraw();
//		//		pa.image(pg, posx, posy);
//
//		// the above code is only for debuggin purposes
//		// END OF DEBUGGIN BLOCK;
//		//
//	}
	
	/*   
	 *  This method overrides the KTGUIEventProcessor's `mouseMoved()` method and 
	 *  implements its own behaviour. In particular, when this event is received 
	 *  from the parent PApplet, this implementation defines the <b>"hovering"</b> 
	 *  state/behaviour.(the <i>"hovered"</i> state is  defined by the <b>isHovered</b> 
	 *  variable, which can be set to true or false).
	 */
	@Override public void processMouseMoved() {
		if (isActive) {
			// transfer mouseMoved event to child controllers
			for (Controller child : controllers) {
				child.processMouseMoved();
			}
			// process mouseMoved event by own means
			isHovered = isPointInside(pa.mouseX, pa.mouseY) ? true : false;
			if (isHovered) {
				for (KTGUIEventAdapter adapter : adapters) {
					adapter.onMouseMoved();
				}
			}
		}
	}
//	
//	@Override 
//	public void processMousePressed() {
//		if(isActive) {
//			for(Controller child : controllers) {
//				child.processMousePressed();
//			}
//		}
//	}
//	
//	@Override
//	public void processMouseReleased() {
//		if(isActive) {
//			for(Controller child : controllers) {
//				child.processMouseReleased();
//			}
//		}
//	}
//	
//	@Override
//	public void processMouseDragged() {
//		if(isActive) {
//			for(Controller child : controllers) {
//				child.processMouseDragged();
//			}
//		}
//	}
//	
//	@Override
//	public void updateGraphics() {
//		pg.beginDraw();
//		pg.strokeWeight(1f);
//		pg.line(0, 0, w, h);
//		pg.line(0, h, w, 0);
//		pg.endDraw();
//	}
	
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
		titleBar.isDragable = false;
		attachController(titleBar);
//		titleBar.addEventAdapter(new KTGUIEventAdapter() {
//			public void onMouseDragged() {
//				posx += pa.mouseX - pa.pmouseX;
//				posy += pa.mouseY - pa.pmouseY;
//				posx = titleBar.getAbsolutePosX();
//				posy = titleBar.getAbsolutePosY();
//			}
//		});
	}
	
	private void createPane() {
		
	}

	@Override
	public void addController(Controller controller, int hAlign, int vAlign) {
		if (isActive) {
			controller.alignAbout(pane, hAlign, vAlign);
			pane.attachController(controller);
			//pane.registerChildController(controller);
		}
	}

	//	private void createTitleBar() {
//		titleBar = new TitleBar(ktgui, "tb:" + title, posx, posy, w, KTGUI.TITLE_BAR_HEIGHT);
//		titleBar.isDragable = true;
//		attachController(titleBar);
//		registerChildController(titleBar);
//		titleBar.addEventAdapter(new KTGUIEventAdapter() {
//			public void onMouseDragged() {
//				int dx = pa.mouseX - pa.pmouseX;
//				int dy = pa.mouseY - pa.pmouseY;
//				pane.posx += dx;
//				pane.posy += dy;
//				posx += dx;
//				posy += dy;
//			}	
//		});
//	}
//
//	private void createPane() {
//		pane = new WindowPane(ktgui, "pane:" + title, this, posx, posy + titleBar.h, w, h - titleBar.h);
//		pane.isDragable = false;
//		attachController(pane);
//		registerChildController(pane);
//	}

	public Pane getPane() {
		return pane;
	}
}
