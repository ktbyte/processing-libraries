package ktbyte.gui;

import processing.event.*;
import processing.core.*;

/**
 * 
 * This GUI element is a rectangle input in which text can be entered if the box is focused.
 */
public class TextBox implements PConstants {
	
	private final static int BACKSPACE_ASCII_CODE = 8;
	private final static int ENTER_ASCII_CODE = 10;
	private final static int BASIC_ASCII_LOWER_LIMIT = 32;
	private final static int BASIC_ASCII_UPPER_LIMIT = 126;

	private PApplet parent;
	private int x, y, w, h;
	private int r1, r2, r3, r4; // box rounding parameters
	private boolean handleFocus = true, isFocused;
	private String textInput;
	private int textSize;
	private float textHeight;
	private KeyEventListener keyEventListener;
	private float padding;

	/**
	 * This constructs a new TextBox object within the current context (PApplet),
	 *  starting from the x and y coordinates, having the specified width and height.
	 * 
	 * @param x
	 *   x coordinate
	 * @param y
	 *   y coordinate
	 * @param width
	 * 	width of the TextBox
	 * @param height
	 * 	height of the TextBox
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

	/**
	 * This is a register method and should not be called directly
	 */
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

	/**
	 * This is a register method and should not be called directly
	 * @param e
	 * 	The received mouse event
	 */
	public void mouseEvent(MouseEvent e) {
		if (e.getAction() == MouseEvent.PRESS) {
			this.mousePressed();
		}
	}

	/**
	 * This is a register method and should not be called directly
	 * @param e
	 * 	The received key event
	 */
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

	private boolean isInside() {
		return parent.mouseX > x && parent.mouseX < x + w && parent.mouseY > y && parent.mouseY < y + h;
	}

	/**
	 * Returns the whether the elements is focused or not
	 * 
	 * @return <code>true</code> if the element is focused; <code>false</code> otherwise
	 */
	public boolean isFocused() {
		return isFocused;
	}

	/**
	 * Sets the focus of the element
	 * 
	 * @param isFocused
	 *   <code>true</code> to make the element to be focused; <code>false</code> otherwise
	 */
	void setIsFocused(boolean isFocused) {
		this.isFocused = isFocused;
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
	 * Returns the current text
	 * 
	 * @return the current text from inside the box
	 */
	public String getText() {
		return this.textInput;
	}
	
	public void setHandleFocus(boolean handleFocus) {
		this.handleFocus = handleFocus;
	}

	/**
	 * Sets the key-event listener of the TextBox
	 * 
	 * @param keyEventListener
	 *   The key-event listener
	 */
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