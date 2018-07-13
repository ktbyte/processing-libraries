package ktgui;

import java.util.HashMap;
import java.util.Map;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.event.KeyEvent;
import processing.event.MouseEvent;

/**********************************************************************************************************************
 * This is the <i>core</i> class of the KTGUI library. It is specifically designed to provide the ability of separating 
 * the 'main' code of the application from the 'GUI' related code. 
 * This class is used to 'transfer' the 'draw', 'mouse' and 'keyboard' events from PApplet to KTGUI components 
 * (controllers).
 * The main idea is to eliminate the need of adding the callback methods directly in the Processing's 'mouseXXXXX()' 
 * and 'keyXXXXX()' methods.
 * This class is used also as a factory to create the KTGUI components (controllers). 
 * When some event is received from PApplet, this class automatically iterates through all the components in the 
 * components list and 'transfers' the events to each component.
 * 
 *
<h4>The concept of &#39;main&#39; and &#39;GUI&#39; related code separation</h4>
<p>In order to separate the two types of the said codes, we can use the ability of the Processing library to &#39;register&#39; 
some of its &#39;specific&#39; methods in the external class. To register the &#39;specific&#39; methods in the external class, 
the <em>PApplet</em> uses the <code>registerMethod(String methodName, PApplet parentPApplet)</code> method. After these methods 
were being registered, they will be executed at a particular moments of the &#39;main&#39; code execution allowing to 
&#39;synchronize&#39; the execution of the &#39;main&#39; code with the execution of the particular methods of the external class. 
(More detailed information can be found in the Processing&#39;s 
documentation <a href='https://github.com/processing/processing/wiki/Library-Basics#library-methods'>here</a>).</p>
<p>The full list of these &#39;specific&#39; methods can be found 
<a href='https://github.com/processing/processing/wiki/Library-Basics#library-methods'>here</a>. We will be registering (in the 
external class) and using for separating the code <strong><em>only the following three methods</em></strong>:</p>
<ul>
<li><code>public void draw()</code> Method that&#39;s called at the end of  the <em>PApplet&#39;s</em> <code>draw()</code> method.</li>
<li><code>public void mouseEvent(MouseEvent e)</code> Method that&#39;s called when a mouse event occurs in the parent <em>PApplet</em>. 
Drawing inside this method is allowed because mouse events are queued, unless the sketch has called <code>noLoop()</code>.</li>
<li><code>public void keyEvent(KeyEvent e)</code> Method that&#39;s called when a key event occurs in the parent <em>PApplet.</em> 
Drawing is allowed because key events are queued, unless the sketch has called <code>noLoop()</code>.</li>
 *********************************************************************************************************************/
public class KTGUI implements PConstants {
	private static PApplet					pa;
	private StageManager					stageManager;
	private HashMap<Controller, Integer>	garbageList;

	public static int						COLOR_FG_HOVERED;
	public static int						COLOR_FG_PRESSED;
	public static int						COLOR_FG_PASSIVE;
	public static int						COLOR_BG_HOVERED;
	public static int						COLOR_BG_PASSIVE;
	public static int						COLOR_BG_PRESSED;
	public static int						TITLE_BAR_HEIGHT;
	public static int						MENU_BAR_HEIGHT;
	public static int						BORDER_THICKNESS;
	public static int						ALIGN_GAP;
	private boolean							debug	= false;

	/*************************************************************************************************************************
	 * This is a constructor of the KTGUI class.
	 * It automatically registers the 'draw', 'mouseEvent' and 'keyEvent' methods of this class in PApplet.
	 ************************************************************************************************************************/
	public KTGUI(PApplet pa) {
		System.out.println("Creating the KTGUI instance...");
		init(pa);
		System.out.println("Done.\n");
	}

	private void init(PApplet pa) {
		KTGUI.pa = pa;
		KTGUI.pa.registerMethod("draw", this);
		KTGUI.pa.registerMethod("mouseEvent", this);
		KTGUI.pa.registerMethod("keyEvent", this);

		garbageList = new HashMap<Controller, Integer>();

		COLOR_FG_PASSIVE = pa.color(50, 180, 50);
		COLOR_FG_HOVERED = pa.color(50, 220, 50);
		COLOR_FG_PRESSED = pa.color(10, 200, 10);
		COLOR_BG_HOVERED = pa.color(220);
		COLOR_BG_PASSIVE = pa.color(180);
		COLOR_BG_PRESSED = pa.color(200);
		TITLE_BAR_HEIGHT = 14;
		MENU_BAR_HEIGHT = 20;
		BORDER_THICKNESS = 3;
		ALIGN_GAP = 20;

		stageManager = StageManager.getInstance();
		stageManager.init(this);
	}

	public static PApplet getParentPApplet() {
		return pa;
	}

	/*************************************************************************************************************************
	 * This method is intended to be called <b>automatically</b> at the end of each draw() cycle of the parent PApplet. 
	 * This way, the KTGUI class automatically updates all the controllers on the <i>default</i> and <i>active</i> stages.
	 ************************************************************************************************************************/
	public void draw() {
		if(stageManager.getDefaultStage() != stageManager.getActiveStage()) {
			stageManager.getDefaultStage().draw();
			stageManager.getActiveStage().draw();
		} else {
			stageManager.getDefaultStage().draw();
		}
		collectGarbage();
		drawDebugInfo();
	}

	@SuppressWarnings("rawtypes") void collectGarbage() {
		for (Map.Entry me : garbageList.entrySet()) {
			Controller controller = (Controller) me.getKey();
			int time = (Integer) me.getValue();
			if (pa.millis() - time > 100) {
				if (controller.parentStage != null) {
					controller.parentStage.unregisterController(controller);
				}
			}
		}
	}

	void drawDebugInfo() {
		if (debug) {
			pa.fill(0);
			pa.textSize(20);
			pa.textAlign(RIGHT, CENTER);
			pa.textFont(pa.createFont("monospaced", 16));
			pa.text("activeStage.name:" + StageManager.getInstance().getActiveStage().getName(), pa.width - 10, 10);
			pa.text("activeStage.index:"
					+ StageManager.getInstance().stages.indexOf(StageManager.getInstance().getActiveStage()),
					pa.width - 10, 30);
			pa.text("size():" + StageManager.getInstance().stages.size(), pa.width - 10, 50);

			pa.textSize(11);
			int YSHIFT = 12;
			int ypos = 0;
			pa.textAlign(LEFT, CENTER);
			pa.text("----------------------------------------------------", 10, ypos += YSHIFT);
			for (Controller controller : StageManager.getInstance().getDefaultStage().getControllers()) {
				if (controller.title != null) {
					pa.text("defaultStage: " + controller.title +
							", parent:"
							+ ((controller.parentController != null) ? controller.parentController.title : "null") +
							", posx:" + controller.posx +
							", posy:" + controller.posy, 10, ypos += YSHIFT);
				}
			}
			pa.text("----------------------------------------------------", 10, ypos += YSHIFT);
			for (Controller controller : StageManager.getInstance().getActiveStage().getControllers()) {
				if (controller.title != null) {
					pa.text("activeStage: " + controller.title +
							", parent:"
							+ ((controller.parentController != null) ? controller.parentController.title : "null") +
							", posx:" + controller.posx +
							", posy:" + controller.posy,
							10, ypos += YSHIFT);
				}
			}
			pa.text("----------------------------------------------------", 10, ypos += YSHIFT);
		}
	}

	//-------------------------------------------------------------------------------------------------------------------
	// These are the 'factory' methods
	//-------------------------------------------------------------------------------------------------------------------

	public Button createButton(String title, int x, int y, int w, int h) {
		return new Button(this, title, x, y, w, h);
	}

	public Button createButton(int x, int y, int w, int h) {
		return new Button(this, "A Button", x, y, w, h);
	}

	public Slider createSlider(String title, int posx, int posy, int w, int h, int sr, int er) {
		return new Slider(this, title, posx, posy, w, h, sr, er);
	}

	public Slider createSlider(int posx, int posy, int w, int h, int sr, int er) {
		return new Slider(this, "A Slider", posx, posy, w, h, sr, er);
	}

	public Window createWindow(String title, int x, int y, int w, int h) {
		Window window = new Window(this, title, x, y, w, h);
		return window;
	}

	public Window createWindow(int x, int y, int w, int h) {
		Window window = new Window(this, "A Window", x, y, w, h);
		return window;
	}

	public Pane createPane(String title, int x, int y, int w, int h) {
		Pane pane = new Pane(this, title, x, y, w, h);
		return pane;
	}

	public Pane createPane(int x, int y, int w, int h) {
		Pane pane = new Pane(this, "A Pane", x, y, w, h);
		return pane;
	}

	/**
	 * This method 'redirects' the emitted mouse event from PApplet to KTGUI 'transfer' methods.
	 * This method will be called <b>automatically</b> when the PApplet.mouseEvent is happening.
	 */
	public void mouseEvent(MouseEvent e) {
		switch (e.getAction()) {
		case MouseEvent.PRESS:
			this.mousePressed();
			break;
		case MouseEvent.RELEASE:
			this.mouseReleased();
			break;
		case MouseEvent.DRAG:
			this.mouseDragged();
			break;
		case MouseEvent.MOVE:
			this.mouseMoved();
			break;
		case MouseEvent.WHEEL:
			this.mouseWheel(e);
			break;
		}
	}

	/**
	 * This method 'redirects' the emitted keyboard event from PApplet to KTGUI 'transfer' methods.
	 * This method will be called <b>automatically</b> when the PApplet.keyEvent is happening.
	 */
	public void keyEvent(KeyEvent e) {
		switch (e.getAction()) {
		case KeyEvent.PRESS:
			this.keyPressed();
			break;
		case KeyEvent.RELEASE:
			this.keyReleased();
			break;
		}
	}

	public void msg(String string) {
		if (debug)
			PApplet.println(string);
	}

	/**
	 * This is a 'transfer' method - it 'redirects' the PApplet.mouseDragged event to KTGUI components (controllers)
	 */
	private void mouseDragged() {
		for (Controller controller : stageManager.getActiveStage().controllers) {
			controller.processMouseDragged();
		}
		if (stageManager.getDefaultStage() != stageManager.getActiveStage()) {
			for (Controller controller : stageManager.getDefaultStage().controllers) {
				controller.processMouseDragged();
			}
		}
	}

	/**
	 * This is a 'transfer' method - it 'redirects' the PApplet.mousePressed event to KTGUI components (controllers)
	 */
	private void mousePressed() {
		for (Controller controller : stageManager.getActiveStage().controllers) {
			controller.processMousePressed();
		}

		if (stageManager.getDefaultStage() != stageManager.getActiveStage()) {
			for (Controller controller : stageManager.getDefaultStage().controllers) {
				controller.processMousePressed();
			}
		}
	}

	/**
	 * This is a 'transfer' method - it 'redirects' the PApplet.mouseReleased event to KTGUI components (controllers)
	 */
	private void mouseReleased() {
		for (Controller controller : stageManager.getActiveStage().controllers) {
			controller.processMouseReleased();
		}
		if (stageManager.getDefaultStage() != stageManager.getActiveStage()) {
			for (Controller controller : stageManager.getDefaultStage().controllers) {
				controller.processMouseReleased();
			}
		}
	}

	/***
	 * This is a 'transfer' method - it 'redirects' the PApplet.mouseMoved event to KTGUI components (controllers)
	 */
	private void mouseMoved() {
		for (Controller controller : stageManager.getActiveStage().controllers) {
			controller.processMouseMoved();
		}
		if (stageManager.getDefaultStage() != stageManager.getActiveStage()) {
			for (Controller controller : stageManager.getDefaultStage().controllers) {
				controller.processMouseMoved();
			}
		}
	}

	private void mouseWheel(MouseEvent me) {
		for (Controller controller : stageManager.getActiveStage().controllers) {
			controller.processMouseWheel(me);
		}
		if (stageManager.getDefaultStage() != stageManager.getActiveStage()) {
			for (Controller controller : stageManager.getDefaultStage().controllers) {
				controller.processMouseWheel(me);
			}
		}
	}

	/**
	 * This is a 'transfer' method - it 'redirects' the PApplet.keyPressed event to KTGUI components (controllers)
	 */
	private void keyPressed() {
		for (Controller controller : stageManager.getActiveStage().controllers) {
			controller.processKeyPressed();
		}
		if (stageManager.getDefaultStage() != stageManager.getActiveStage()) {
			for (Controller controller : stageManager.getDefaultStage().controllers) {
				controller.processKeyPressed();
			}
		}
	}

	/**
	 * This is a 'transfer' method - it 'redirects' the PApplet.keyReleased event to KTGUI components (controllers)
	 */
	private void keyReleased() {
		for (Controller controller : stageManager.getActiveStage().controllers) {
			controller.processKeyReleased();
		}
		if (stageManager.getDefaultStage() != stageManager.getActiveStage()) {
			for (Controller controller : stageManager.getDefaultStage().controllers) {
				controller.processKeyReleased();
			}
		}
	}

	public void addToGarbage(Controller controller, int millis) {
		garbageList.put(controller, millis);
	}

	public void setDebug(boolean debug) {
		this.debug = debug;
	}

	public boolean getDebug() {
		return debug;
	}

}
