package ktgui;

public class Window extends Controller {

	// Border border;
	TitleBar	titleBar;
	// MenuBar menuBar;
	WindowPane	pane;

	public Window(KTGUI ktgui, int posx, int posy, int w, int h) {
		super(ktgui);
		this.title = "a Window";
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;
		
		this.isDragable = true;
		
		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);
		createTitleBar();
		createPane();
		StageManager.getInstance().defaultStage.registerController(this);
	}

	public Window(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui);
		this.title = title;
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;
		
		this.isDragable = true;
		
		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);
		createTitleBar();
		createPane();
		setTitle(title);
		StageManager.getInstance().defaultStage.registerController(this);
	}

	public void draw() {
		drawUserDefinedGraphics();
		pa.image(pg, posx, posy);
		pa.pushMatrix();
		pa.stroke(0);
		pa.rectMode(CORNER);
		pa.rect(posx, posy, w, h);
		pa.popMatrix();
	}

	public void addController(Controller controller, int hAlign, int vAlign) {
		if (isActive) {
			controller.alignAbout(pane, hAlign, vAlign);
			pane.attachController(controller);
		}
	}

	private void createTitleBar() {
		titleBar = new TitleBar(ktgui, "tb:" + title, this, posx, posy, w, KTGUI.TITLE_BAR_HEIGHT);
		titleBar.isDragable = true;
		attachController(titleBar);
		registerChildController(titleBar);
		titleBar.addEventAdapter(new KTGUIEventAdapter() {
			public void onMouseDragged() {
				int dx = pa.mouseX - pa.pmouseX;
				int dy = pa.mouseY - pa.pmouseY;
				pane.posx += dx;
				pane.posy += dy;
				posx += dx;
				posy += dy;
			}	
		});
	}

	private void createPane() {
		pane = new WindowPane(ktgui, "pane:" + title, this, posx, posy + titleBar.h, w, h - titleBar.h);
		pane.isDragable = false;
		attachController(pane);
		registerChildController(pane);
	}

	public Pane getPane() {
		return pane;
	}
}
