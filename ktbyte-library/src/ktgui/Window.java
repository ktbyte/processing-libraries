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
		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);
		ktgui.getStageManager().defaultStage.registerController(this);
		createTitleBar();
		createPane();
	}

	public Window(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui);
		this.title = title;
		this.posx = posx;
		this.posy = posy;
		this.w = w;
		this.h = h;
		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);
		ktgui.getStageManager().defaultStage.registerController(this);
		setTitle(title);
		createTitleBar();
		createPane();
	}

	public void draw() {
		// overrides the 'draw()' method of parent class (Controller)
		// to prevent drawing the TitleBar and Pane second time.      
	}

	public void addController(Controller controller, int hAlign, int vAlign) {
		if (isActive) {
			controller.alignAbout(pane, hAlign, vAlign);
			pane.attachController(controller);
		}
	}

	private void createTitleBar() {
		titleBar = new TitleBar(ktgui, "tb:" + title, this, posx, posy, w, KTGUI.TITLE_BAR_HEIGHT);
		attachController(titleBar);
		registerChildController(titleBar);
		titleBar.addEventAdapter(new KTGUIEventAdapter() {
			public void onMouseDragged() {
				pane.posx += pa.mouseX - pa.pmouseX;
				pane.posy += pa.mouseY - pa.pmouseY;
			}
		});
	}

	private void createPane() {
		pane = new WindowPane(ktgui, "pane:" + title, this, posx, posy + titleBar.h, w, h - titleBar.h);
		attachController(pane);
		registerChildController(pane);
	}

	public Pane getPane() {
		return pane;
	}
}
