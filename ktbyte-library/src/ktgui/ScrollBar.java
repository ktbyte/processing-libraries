package ktgui;

public class ScrollBar extends Controller {

	private DirectionButton	backwardButton, forwardButton;
	private Slider			slider;

	public ScrollBar(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		createButtons();
		createSlider();
		setBorderRoundings(5, 5, 5, 5);
	}

	@Override
	public void updateGraphics() {
		ktgui.drawCallStack.add(title + ".updateGraphics()");
	}

	private void createButtons() {
		if (w > h) {
			backwardButton = new DirectionButton(ktgui, "bckwrdBtn:" + title, 0, 0, h, h, LEFT);
			forwardButton = new DirectionButton(ktgui, "frwrdBtn:" + title, w - h, 0, h, h, RIGHT);
		} else {
			forwardButton = new DirectionButton(ktgui, "frwrdBtn:" + title, 0, 0, w, w, UP);
			backwardButton = new DirectionButton(ktgui, "bckwrdBtn:" + title, 0, h - w, w, w, DOWN);
		}

		backwardButton.addEventAdapter(new KTGUIEventAdapter() {
			public void onMousePressed() {
				System.out.println("BackwardButton of " + title + " has been pressed!");
			}
		});
		forwardButton.addEventAdapter(new KTGUIEventAdapter() {
			public void onMousePressed() {
				System.out.println("ForwardButton of " + title + " has been pressed!");
			}
		});

		backwardButton.isDragable = false;
		forwardButton.isDragable = false;
		attachController(backwardButton);
		attachController(forwardButton);
	}

	private void createSlider() {
		if (w > h) {
			slider = new Slider(ktgui, "hSlider:" + title, backwardButton.w, 0,
					w - backwardButton.w - forwardButton.w, h, 0, 100);
		} else {
			slider = new Slider(ktgui, "vSlider:" + title, 0, backwardButton.h,
					w, h - backwardButton.h - forwardButton.h, 0, 100);
		}
		slider.isDragable = false;
		slider.setValue(0);
		attachController(slider);
	}

	@Override
	public void setBorderRoundings(int r1, int r2, int r3, int r4) {
		if (w > h) {
			backwardButton.setBorderRoundings(r1, 0, 0, r4);
			forwardButton.setBorderRoundings(0, r2, r3, 0);
		} else {
			forwardButton.setBorderRoundings(r1, r2, 0, 0);
			backwardButton.setBorderRoundings(0, 0, r3, r4);
		}
	}
}
