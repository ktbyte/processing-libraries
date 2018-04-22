package ktbyte.gui;

import processing.event.*;
import processing.core.*;

public class TextBox implements PConstants {
	private final static int BACKSPACE_ASCII_CODE = 8;
	private final static int ENTER_ASCII_CODE = 10;
	private final static int BASIC_ASCII_LOWER_LIMIT = 32;
	private final static int BASIC_ASCII_UPPER_LIMIT = 126;

	private PApplet parent;
	private int x, y, w, h;
	private int r1, r2, r3, r4; // box rounding parameters
	private boolean handleFocus, isFocused;
	private String textInput;
	private int textSize;
	private float textHeight;
	private KeyEventListener keyEventListener;
	private float padding;

	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize the Console
	 * 
	 * @example TextBox_basic1
	 * @param x
	 * @param y
	 * @param width
	 * @param height
	 */
	public TextBox(PApplet pap, int x, int y, int width, int height) {
		this.parent = pap;
		this.parent.registerMethod("draw", this);
		this.parent.registerMethod("mouseEvent", this);
		this.parent.registerMethod("keyEvent", this);
		this.x = x;
		this.y = y;
		this.w = width;
		this.h = height;
		this.textInput = "";
		this.textSize = 18;
		computeDefaultAttributes();
	}

	public void setBorderRoundings(int r1, int r2, int r3, int r4) {
		this.r1 = r1;
		this.r2 = r2;
		this.r3 = r3;
		this.r4 = r4;
	}

	private void computeDefaultAttributes() {
		this.padding = 0.08f * h;
		parent.textSize(this.textSize);
		this.textHeight = parent.textAscent() + parent.textDescent();
		computeTextSize();
	}

	private void computeTextSize() {
		while (textHeight > h - padding * 2) {
			this.textSize--;
			parent.textSize(this.textSize);
			this.textHeight = parent.textAscent() + parent.textDescent();
		}
	}

	public void draw() {
		parent.pushStyle();
		parent.fill(255);
		parent.noStroke();
		parent.rect(x, y, w, h, r1, r2, r3, r4);
		parent.fill(0);
		parent.textSize(textSize);
		parent.textAlign(LEFT, CENTER);
		parent.text(getTrimmedInputText(textInput), x + padding, y + h / 2);
		drawBlinkingInputCursor();
		parent.popStyle();
	}
	
	private void drawBlinkingInputCursor() {
		if (!isFocused) {
			return;
		}
		parent.stroke(0);
		if (parent.frameCount % 60 < 30) {
			float cursorX = PApplet.min(x + w - padding, x + parent.textWidth(textInput) + padding);
			parent.line(cursorX, y + h / 2 - textHeight / 2, cursorX, y + h / 2 + textHeight / 2);
		}
	}

	public void mouseEvent(MouseEvent e) {
		if (e.getAction() == MouseEvent.PRESS) {
			this.mousePressed();
		}
	}

	public void keyEvent(KeyEvent e) {
		if (e.getAction() == KeyEvent.PRESS) {
			this.keyPressed();
		}
	}

	private void keyPressed() {
		if (!isFocused) {
			return;
		}

		if ((int) parent.key == BACKSPACE_ASCII_CODE && textInput.length() > 0) {
			textInput = textInput.substring(0, textInput.length() - 1);
		}
		if ((int) parent.key == ENTER_ASCII_CODE) {
			if (keyEventListener != null) {
				keyEventListener.onEnterKey();
				if (handleFocus) {
					isFocused = false;
				}
			}
		} else if ((int) parent.key >= BASIC_ASCII_LOWER_LIMIT && (int) parent.key <= BASIC_ASCII_UPPER_LIMIT) {
			byte b = (byte) parent.key;
			char ch = (char) b;
			textInput += ch;
		}
	}

	private void mousePressed() {
		if (!handleFocus) {
			return;
		}
		
		if (this.isInside()) {
			this.isFocused = true;
		} else {
			this.isFocused = false;
		}
	}

	boolean isInside() {
		return parent.mouseX > x && parent.mouseX < x + w && parent.mouseY > y && parent.mouseY < y + h;
	}

	public boolean isFocused() {
		return isFocused;
	}

	void setIsFocused(boolean isFocused) {
		this.isFocused = isFocused;
	}
	
	public void setText(String text) {
		this.textInput = text;
	}

	public void setTextSize(int textSize) {
		this.textSize = textSize;
		computeDefaultAttributes();
	}

	public String getText() {
		return this.textInput;
	}

	public void setKeyEventListener(KeyEventListener keyEventListener) {
		this.keyEventListener = keyEventListener;
	}

	private String getTrimmedInputText(String textInput) {
		String trimmedTextInput = "";
		char[] textInputCharArray = textInput.toCharArray();
		for (int i = textInputCharArray.length - 1; i >= 0; i--) {
			if (parent.textWidth(trimmedTextInput) + parent.textWidth(textInputCharArray[i]) < w - padding * 2) {
				trimmedTextInput = textInputCharArray[i] + trimmedTextInput;
			} else {
				break;
			}
		}
		return trimmedTextInput;
	};
}