package ktgui;

public class VerticalScrollBar extends Controller {

	private DirectionButton upButton, downButton;
	private Slider slider;
	
	public VerticalScrollBar(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		createButtons();
		createSlider();
		setBorderRoundings(5, 5, 5, 5);
	}

	@Override
	public void updateGraphics() {
		ktgui.drawCallStack.add(title + ".updateGraphics()");
		pg.beginDraw();
		pg.rectMode(CORNER);
		pg.rect(0, upButton.h,
				upButton.w, h - upButton.h - downButton.h,
				r1, r2, r3, r4);
		pg.endDraw();
	}

	private void createButtons() {
		upButton = new DirectionButton(ktgui, "upBtn:" + title, 0, 0,
				w, w,
				UP);
		upButton.isDragable = false;
		attachController(upButton);

		downButton = new DirectionButton(ktgui, "downBtn:" + title, 0, h - w,
				w, w,
				DOWN);
		downButton.isDragable = false;
		attachController(downButton);
	}

	private void createSlider() {
		slider = new Slider(ktgui, "slider:" + title, 0, upButton.h, 
				w, h - upButton.h - downButton.h, 0, 100);
		slider.isDragable = false;
		attachController(slider);
	}

	@Override
	public void setBorderRoundings(int r1, int r2, int r3, int r4) {
		upButton.setBorderRoundings(r1, r2, 0, 0);
		downButton.setBorderRoundings(0, 0, r3, r4);
	}
}
