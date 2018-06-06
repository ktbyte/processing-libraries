package ktgui;

import java.util.ArrayList;

public class ScrollableTextArea extends Controller {
	private final static int	SCROLL_BAR_WIDTH	= 20;
	private final static int	BOX_ROUNDING		= 7;

	private int					r1, r2, r3, r4;
	private float				textSize;

	private ArrayList<String>	text;
	private int					startLine;
	private int					endLine;

	public ScrollableTextArea(KTGUI ktgui, String title, int x, int y, int w, int h) {
		super(ktgui);

		this.title = title;
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		StageManager.getInstance().getDefaultStage().registerController(this);
	}

	/**
	 * This is an automatically registered method and it should not be called directly
	 */
	public void draw() {
		// if this button don't belongs to any window or pane 
		// then draw it directly on the PApplet canvas 
		if (parentController == null) {
			pa.image(pg, posx, posy);
		}
	}

	public void updateGraphics() {
		updateTextAreaGraphics();
		updateScrollBarGraphics();
	}

	private void updateTextAreaGraphics() {
		pg.beginDraw();
		pg.pushStyle();
		pg.fill(255, 100);
		pg.noStroke();
		pg.rect(0, 0, w, h, r1, r2, r3, r4);

		for (int i = startLine; i < endLine; i++) {
			String line = text.get(i);
			for (int j = 0; i < line.length(); j++) {
				if (w - SCROLL_BAR_WIDTH < pa.textWidth(line)) {

				} else {
					
				}
				//		pg.fill(0);
				//		pg.textSize(textSize);
				//		pg.textAlign(LEFT, CENTER);
				//		pg.text(getTrimmedInputText(textInput), padding, h * 0.5f);
			}
		}
		pg.popStyle();
		pg.endDraw();
	}

	private void updateScrollBarGraphics() {

	}

	/**
	 * Sets the rounding of the rectangle's border. The parameters should be entered in a clockwise order
	 * 
	 * @param r1
	 * 	Up
	 * @param r2
	 * 	Right
	 * @param r3
	 * 	Down
	 * @param r4
	 * 	Left
	 */
	public void setBorderRoundings(int r1, int r2, int r3, int r4) {
		this.r1 = r1;
		this.r2 = r2;
		this.r3 = r3;
		this.r4 = r4;
	}
}
