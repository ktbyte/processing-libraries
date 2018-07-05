package ktgui;

import processing.core.PApplet;

public class InputTextBox extends Controller {

	private final static int	BACKSPACE_ASCII_CODE	= 8;
	private final static int	ENTER_ASCII_CODE		= 10;
	private final static int	BASIC_ASCII_LOWER_LIMIT	= 32;
	private final static int	BASIC_ASCII_UPPER_LIMIT	= 126;

	private int					r1, r2, r3, r4;					// box rounding parameters
	private boolean				handleFocus				= true;
	private String				textInput;
	private int					textSize;
	private float				textHeight;
	private float				padding;

	public InputTextBox(KTGUI ktgui, String title, int x, int y, int w, int h) {
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
		updateTextBox();
		updateBlinkingCursorGraphics();
	}

	private void updateTextBox() {
		pg.beginDraw();
		pg.pushStyle();
		pg.fill(255);
		pg.noStroke();
		pg.rect(0, 0, w, h, r1, r2, r3, r4);
		pg.fill(0);
		pg.textSize(textSize);
		pg.textAlign(LEFT, CENTER);
		pg.text(getTrimmedInputText(textInput), padding, h * 0.5f);
		pg.popStyle();
		pg.endDraw();
	}

	private void updateBlinkingCursorGraphics() {
		if (!isFocused) {
			return;
		}
		if (pa.frameCount % 60 < 30) {
			pa.textSize(textSize);
			float cursorX = PApplet.min(w - padding, pa.textWidth(textInput) + padding);
			pg.beginDraw();
			pg.stroke(0);
			pg.strokeWeight(2);
			pg.line(cursorX, h * 0.5f - textHeight * 0.5f, cursorX, h * 0.5f + textHeight * 0.5f);
			pg.endDraw();
		}
	}

	public void processMousePressed() {
		if (!handleFocus) {
			return;
		}

		if (this.isPointInside(pa.mouseX, pa.mouseY)) {
			if (!isFocused) {
				setText("");
			}
			this.isFocused = true;
		} else {
			this.isFocused = false;
		}
	}

	public void processKeyPressed() {
		if (!isFocused) {
			return;
		}

		if ((int) pa.key == BACKSPACE_ASCII_CODE && textInput.length() > 0) {
			textInput = textInput.substring(0, textInput.length() - 1);
		}
		if ((int) pa.key == ENTER_ASCII_CODE) {
			for (KTGUIEventAdapter adapter : adapters) {
				adapter.onEnterKeyPressed();
			}
		} else if ((int) pa.key >= BASIC_ASCII_LOWER_LIMIT && (int) pa.key <= BASIC_ASCII_UPPER_LIMIT) {
			byte b = (byte) pa.key;
			char ch = (char) b;
			textInput += ch;
		}
	}

	private boolean isPointInside(int x, int y) {
		return x > posx && x < posx + w && y > posy && y < posy + h;
	}

	public void setIsFocused(boolean val) {
		isFocused = val;
	}

	public void setHandleFocus(boolean val) {
		handleFocus = val;
	};
	
	/**
	 * Sets the current text
	 * 
	 * @param text
	 *   The text that should be displayed inside the box
	 */
 	public void setText(String text) {
		this.textInput = text;
	}

	public String getText() {
		return textInput;
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
		System.out.println("textSize in computeDefaultAttributes: " + textSize);
		System.out.println("textHeight in computeDefaultAttributes: " + textHeight);
		computeTextSize();
	}

	private void computeTextSize() {
		while (textHeight > h - padding * 2) {
			this.textSize--;
			pa.textSize(this.textSize);
			this.textHeight = pa.textAscent() + pa.textDescent();
		}
		System.out.println("textSize in computeTextSize: " + textSize);
		System.out.println("textHeight in computeTextSize: " + textHeight);
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
	}

}
