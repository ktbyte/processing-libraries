package ktgui;

import ktbyte.gui.KeyEventListener;
import processing.core.PApplet;

public class KTGUITextBox extends Controller {

	private final static int	BACKSPACE_ASCII_CODE	= 8;
	private final static int	ENTER_ASCII_CODE		= 10;
	private final static int	BASIC_ASCII_LOWER_LIMIT	= 32;
	private final static int	BASIC_ASCII_UPPER_LIMIT	= 126;

	//private PApplet				pa; // handled by super() 
	//private int					x, y, w, h; // handled by super() 
	private int					r1, r2, r3, r4;					// box rounding parameters
	private boolean				handleFocus				= true;
	private boolean				isFocused;
	private String				textInput;
	private int					textSize;
	private float				textHeight;
	private KeyEventListener	keyEventListener;
	private float				padding;

	public KTGUITextBox(KTGUI ktgui, String title, int x, int y, int w, int h) {
		super(ktgui);
		this.title = title;
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;
		this.textInput = "";
		this.textSize = 18;
		computeDefaultAttributes();

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created window in default stage of stageManager
		ktgui.getStageManager().getDefaultStage().registerController(this);
	}

	/**
	 * This is a automatically registered method and it should not be called directly
	 */
	public void draw() {
		//		pa.pushStyle();
		//		pa.fill(255);
		//		pa.noStroke();
		//		pa.rect(posx, posy, w, h, r1, r2, r3, r4);
		//		pa.fill(0);
		//		pa.textSize(textSize);
		//		pa.textAlign(LEFT, CENTER);
		//		pa.text(getTrimmedInputText(textInput), posx + padding, posy + h * 0.5f);
		//		drawBlinkingInputCursor();
		//		pa.popStyle();
		// if this button don't belongs to any window or pane 
		// then draw directly on the PApplet canvas 
		//if (parentController == null) {
			pa.image(pg, posx, posy);
		//}
	}

	public void updateGraphics() {
		pg.beginDraw();
		pg.pushStyle();
		pg.fill(255);
		pg.noStroke();
		pg.rect(0, 0, w, h, r1, r2, r3, r4);
		pg.fill(0);
		pg.textSize(textSize);
		pg.textAlign(LEFT, CENTER);
		pg.text(getTrimmedInputText(textInput), padding, h * 0.5f);
		updateBlinkingCursorGraphics();
		pg.popStyle();
		pg.endDraw();
	}

	private void updateBlinkingCursorGraphics() {
		if (!isFocused) {
			return;
		}
		//		pa.stroke(0);
		//		if (pa.frameCount % 60 < 30) {
		//			float cursorX = PApplet.min(posx + w - padding, posx + pa.textWidth(textInput) + padding);
		//			pa.line(cursorX, posy + h * 0.5f - textHeight * 0.5f, cursorX, posy + h * 0.5f + textHeight * 0.5f);
		//		}
		if (pa.frameCount % 60 < 30) {
			float cursorX = PApplet.min(w - padding, pa.textWidth(textInput) + padding);
			pg.beginDraw();
			pg.stroke(0);
			pg.line(cursorX, h * 0.5f - textHeight * 0.5f, cursorX, h * 0.5f + textHeight * 0.5f);
			pg.endDraw();
		}
	}

	/**
	 * Sets the current text
	 * 
	 * @param text
	 *   The text that should be displayed inside the box
	 */
	public void setText(String text) {
		this.textInput = text;
	}

	/**
	 * Sets the text size
	 * 
	 * @param textSize
	 *   The text size
	 */
	public void setTextSize(int textSize) {
		this.textSize = textSize;
		computeDefaultAttributes();
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

	private void computeDefaultAttributes() {
		this.padding = 0.08f * h;
		pa.textSize(this.textSize);
		this.textHeight = pa.textAscent() + pa.textDescent();
		computeTextSize();
	}

	private void computeTextSize() {
		while (textHeight > h - padding * 2) {
			this.textSize--;
			pa.textSize(this.textSize);
			this.textHeight = pa.textAscent() + pa.textDescent();
		}
	}

	private String getTrimmedInputText(String textInput) {
		String trimmedTextInput = "";
		char[] textInputCharArray = textInput.toCharArray();
		for (int i = textInputCharArray.length - 1; i >= 0; i--) {
			if (pa.textWidth(trimmedTextInput) + pa.textWidth(textInputCharArray[i]) < w - padding * 2) {
				trimmedTextInput = textInputCharArray[i] + trimmedTextInput;
			} else {
				break;
			}
		}
		return trimmedTextInput;
	};
}