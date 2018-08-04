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
		} else {
			backwardButton = new DirectionButton(ktgui, "bckwrdBtn:" + title, 0, 0, w, w, UP);
		}
		backwardButton.isDragable = false;
		attachController(backwardButton);

		if (w > h) {
			forwardButton = new DirectionButton(ktgui, "frwrdBtn:" + title, w - h, 0, h, h, RIGHT);
		} else {
			forwardButton = new DirectionButton(ktgui, "frwrdBtn:" + title, 0, h - w, w, w, DOWN);
		}
		forwardButton.isDragable = false;
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
			backwardButton.setBorderRoundings(r1, r2, 0, 0);
			forwardButton.setBorderRoundings(0, 0, r3, r4);
		}
	}
}
