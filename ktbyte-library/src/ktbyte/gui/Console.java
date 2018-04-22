package ktbyte.gui;

import processing.event.*;
import processing.core.*;
import java.util.ArrayList;
import java.util.HashMap;

public class Console implements PConstants {
	private final static int BACKSPACE_ASCII_CODE = 8;
	private final static int ENTER_ASCII_CODE = 10;
	private final static int BASIC_ASCII_LOWER_LIMIT = 32;
	private final static int BASIC_ASCII_UPPER_LIMIT = 126;
	private final static int BOX_RONDING = 7;
	private final static int SCROLL_BAR_WIDTH = 20;
	private final static float INPUT_BOX_HEIGHT_PERCENTAGE = 0.1f;

	private int x, y;
	private int w, h;
	private int inputTextColor;
	private int outputTextColor;
	private ArrayList<Line> lines;
	private String textInput;
	private int inputBoxHeight;
	private HashMap<String, String> dict;
	private ConsoleInputListener consoleInputListener;
	private String lastVariableName;
	private int globalPadding;
	private int lineScrollOffset;
	private boolean isFocused;
	private int textSize;
	private int maxLinesToDisplay;
	private float textHeight;
	private ArrowButton upBtn;
	private ArrowButton downBtn;
	private float scrollBarMaxHeight;
	private PApplet pap;

	public Console(PApplet pap, int x, int y, int width, int height) {
		this.pap = pap;
		this.pap.registerMethod("draw", this);
		this.pap.registerMethod("mouseEvent", this);
		this.pap.registerMethod("keyEvent", this);
		this.inputTextColor = pap.color(255);
		this.outputTextColor = pap.color(170);
		this.x = x;
		this.y = y;
		this.w = width;
		this.h = height;
		this.globalPadding = 10;
		this.inputBoxHeight = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);
		this.lines = new ArrayList<>();
		this.dict = new HashMap<String, String>();
		this.textInput = "";
		computeDefaultAttributes();
	}

	void computeDefaultAttributes() {
		if (h < 400) {
			this.textSize = 18;
		} else if (h < 900) {
			this.textSize = 22;
		} else {
			this.textSize = 24;
		}
		pap.textSize(this.textSize);
		this.textHeight = pap.textAscent() + pap.textDescent();
		this.maxLinesToDisplay = computeMaxLinesToDisplay();
		this.scrollBarMaxHeight = h - inputBoxHeight - SCROLL_BAR_WIDTH * 2;
	}

	int computeMaxLinesToDisplay() {
		return (int) ((0.9 * h - globalPadding * 2) / (textHeight + 2));
	}

	public void draw() {
		pap.pushStyle();
		drawConsoleTextBox();
		drawInputBox();
		drawScrollBar();
		pap.popStyle();
	}

	void drawConsoleTextBox() {
		pap.rectMode(CORNER);
		pap.fill(0);
		pap.noStroke();
		pap.rect(x, y, w - SCROLL_BAR_WIDTH, h - inputBoxHeight, BOX_RONDING, 0, 0, 0);
		pap.textSize(textSize);
		pap.textAlign(LEFT, TOP);
		int consoleStartLine = PApplet.max(0, lines.size() - maxLinesToDisplay + lineScrollOffset);
		int consoleEndLine = PApplet.min(lines.size(), consoleStartLine + maxLinesToDisplay);

		for (int i = consoleStartLine, j = 0; i < consoleEndLine; i++, j++) {
			pap.stroke(lines.get(i).textColor);
			pap.fill(lines.get(i).textColor);
			pap.text(lines.get(i).text, x + globalPadding, y + j * (textHeight + 2) + globalPadding);
		}
	}

	void drawScrollBar() {
		pap.noStroke();
		pap.fill(50);
		pap.rect(x + w - SCROLL_BAR_WIDTH, y, SCROLL_BAR_WIDTH, h - inputBoxHeight, 0, BOX_RONDING, 0, 0);
		upBtn = new ArrowButton(x + w - SCROLL_BAR_WIDTH, y, SCROLL_BAR_WIDTH, 0, 0, BOX_RONDING, 0, 0);
		downBtn = new ArrowButton(x + w - SCROLL_BAR_WIDTH, y + h - inputBoxHeight - 20, SCROLL_BAR_WIDTH, 2);
		pap.fill(120);

		float scrollBarHeight = scrollBarMaxHeight;
		if (lines.size() > maxLinesToDisplay) {
			scrollBarHeight = PApplet.max(25, ((float) maxLinesToDisplay / lines.size()) * scrollBarMaxHeight);
		}
		int consoleScrollableLines = lines.size() - maxLinesToDisplay;
		float trackScrollArea = h - inputBoxHeight - SCROLL_BAR_WIDTH * 2 - scrollBarHeight;
		float scrollBarYCoordinate = y + SCROLL_BAR_WIDTH + trackScrollArea;
		if (lines.size() > maxLinesToDisplay) {
			scrollBarYCoordinate = y + SCROLL_BAR_WIDTH + trackScrollArea
					- (-lineScrollOffset * ((float) trackScrollArea / consoleScrollableLines));
		}
		pap.rectMode(CORNER);
		pap.rect(x + w - SCROLL_BAR_WIDTH, scrollBarYCoordinate, SCROLL_BAR_WIDTH, scrollBarHeight);

		upBtn.drawButton();
		downBtn.drawButton();
	}

	void drawInputBox() {
		pap.fill(255);
		pap.noStroke();
		pap.rect(x, y + h - inputBoxHeight, w, inputBoxHeight, 0, 0, BOX_RONDING, BOX_RONDING);
		pap.fill(0);
		pap.textSize(textSize);
		pap.textAlign(LEFT, CENTER);
		pap.text(getTrimmedInputText(textInput), x + globalPadding, y + 0.9f * h + inputBoxHeight / 2);
		drawBlinkingInputCursor();
	}

	String getTrimmedInputText(String textInput) {
		String trimmedTextInput = "";
		char[] textInputCharArray = textInput.toCharArray();
		for (int i = textInputCharArray.length - 1; i >= 0; i--) {
			if (pap.textWidth(trimmedTextInput) + pap.textWidth(textInputCharArray[i]) < w - globalPadding * 2) {
				trimmedTextInput = textInputCharArray[i] + trimmedTextInput;
			} else {
				break;
			}
		}
		return trimmedTextInput;
	};

	void drawBlinkingInputCursor() {
		if (!isFocused) {
			return;
		}
		pap.stroke(0);
		if (pap.frameCount % 60 < 30) {
			float cursorX = PApplet.min(x + w - globalPadding, x + pap.textWidth(textInput) + globalPadding);
			pap.line(cursorX, y + h - inputBoxHeight + 10, cursorX, y + h - 10);
		}
	}

	public void write(String text) {
		splitCommandBasedOnConsoleWidth(new Command(text, false));
		lastVariableName = "";
	}

	void splitCommandBasedOnConsoleWidth(Command command) {
		Line line = new Line();
		pap.textSize(textSize);
		String[] wordsFromCommand = PApplet.split(command.text, " ");
		int i = 0;
		while (i < wordsFromCommand.length) {
			if (pap.textWidth(line.text + " ") + pap.textWidth(wordsFromCommand[i]) < w - SCROLL_BAR_WIDTH) {
				line.text += wordsFromCommand[i] + " ";
				line.textColor = (command.isInput ? inputTextColor : outputTextColor);
				i++;
			} else {
				lines.add(line);
				line = new Line();
			}
		}
		lines.add(line);
	}

	public String getValue(String name) {
		return dict.get(name);
	}

	public void readInput(String name) {
		this.lastVariableName = name;
	}

	public void mouseEvent(MouseEvent e) {
		if (e.getAction() == MouseEvent.PRESS) {
			mousePressed();
		} else if (e.getAction() == MouseEvent.WHEEL) {
			mouseWheel(e);
		}
	}

	// used by processing.js
	void mouseScrolled(int mouseWheelDelta) {
		if (!this.isFocused) {
			return;
		}
		if (mouseWheelDelta < 0) {
			if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
				lineScrollOffset--;
			}
		} else if (mouseWheelDelta > 0) {
			if (lineScrollOffset < 0) {
				lineScrollOffset++;
			}
		}
	}

	void mouseWheel(MouseEvent e) {
		mouseScrolled(e.getCount());
	}

	public void keyEvent(KeyEvent e) {
		if (e.getAction() == KeyEvent.PRESS) {
			keyPressed();
		}
	}

	void keyPressed() {
		if (!isFocused) {
			return;
		}
		if ((int) pap.key == BACKSPACE_ASCII_CODE && textInput.length() > 0) {
			textInput = textInput.substring(0, textInput.length() - 1);
		} else if ((int) pap.key == ENTER_ASCII_CODE) {
			handleConsoleInput();
		} else if ((int) pap.key >= BASIC_ASCII_LOWER_LIMIT && (int) pap.key <= BASIC_ASCII_UPPER_LIMIT) {
			byte b = (byte) pap.key;
			char ch = (char) b;
			textInput += ch;
		}
	}

	void mousePressed() {
		if (pap.mouseX > x && pap.mouseX < x + w && pap.mouseY > y && pap.mouseY < y + h) {
			isFocused = true;
		} else {
			isFocused = false;
		}
		if (upBtn.isPressed(pap.mouseX, pap.mouseY)) {
			if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
				lineScrollOffset--;
			}
		} else if (downBtn.isPressed(pap.mouseX, pap.mouseY)) {
			if (lineScrollOffset < 0) {
				lineScrollOffset++;
			}
		}
	}

	void handleConsoleInput() {
		splitCommandBasedOnConsoleWidth(new Command(textInput, true));
		dict.put(lastVariableName, textInput);
		consoleInputListener.onConsoleInput(lastVariableName, textInput);
		textInput = "";
	}

	public void setConsoleInputListener(ConsoleInputListener consoleInputListener) {
		this.consoleInputListener = consoleInputListener;
	}

	public void setInputTextColor(int inputTextColor) {
		this.inputTextColor = inputTextColor;
	}

	public void setOutputTextColor(int outputTextColor) {
		this.outputTextColor = outputTextColor;
	}

	public void setTextSize(int textSize) {
		this.textSize = textSize;
		this.textHeight = pap.textAscent() + pap.textDescent();
		this.maxLinesToDisplay = computeMaxLinesToDisplay();
	}

	private class ArrowButton {
		private int x, y, s;
		private int r1, r2, r3, r4; // box-roundings
		private Point p1, p2, p3;

		// TODO - try to use an enum insted of ints
		public int orientation; // int from 0-3, clockwise

		ArrowButton(int x, int y, int s, int o) {
			this.x = x;
			this.y = y;
			this.s = s;
			this.orientation = o;
			computeArrowEndPoints();
		}

		ArrowButton(int x, int y, int s, int o, int r1, int r2, int r3, int r4) {
			this.x = x;
			this.y = y;
			this.s = s;
			this.orientation = o;
			this.r1 = r1;
			this.r2 = r2;
			this.r3 = r3;
			this.r4 = r4;
			computeArrowEndPoints();
		}

		void computeArrowEndPoints() {
			switch (orientation) {
			case 0: // UP
				this.p1 = new Point(x + 0.2f * s, y + 0.8f * s);
				this.p2 = new Point(x + 0.8f * s, y + 0.8f * s);
				this.p3 = new Point(x + 0.5f * s, y + 0.2f * s);
				break;
			case 1: // RIGHT
				this.p1 = new Point(x + 0.2f * s, y + 0.2f * s);
				this.p2 = new Point(x + 0.2f * s, y + 0.8f * s);
				this.p3 = new Point(x + 0.8f * s, y + 0.5f * s);
				break;
			case 2: // DOWN
				this.p1 = new Point(x + 0.2f * s, y + 0.2f * s);
				this.p2 = new Point(x + 0.8f * s, y + 0.2f * s);
				this.p3 = new Point(x + 0.5f * s, y + 0.8f * s);
				break;
			case 3: // LEFT
				this.p1 = new Point(x + 0.8f * s, y + 0.2f * s);
				this.p2 = new Point(x + 0.8f * s, y + 0.8f * s);
				this.p3 = new Point(x + 0.2f * s, y + 0.5f * s);
				break;
			default:
			}
		}

		void drawButton() {
			pap.rectMode(CORNER);
			pap.noStroke();
			pap.fill(80);
			pap.rect(this.x, this.y, s, s, r1, r2, r3, r4);
			pap.stroke(200);
			pap.line(p1.x, p1.y, p3.x, p3.y);
			pap.line(p2.x, p2.y, p3.x, p3.y);
		}

		boolean isPressed(float mx, float my) {
			return (mx > this.x && mx < this.x + s && my > this.y && my < this.y + s);
		}
	}

	private class Point {
		public float x, y;

		Point(float x, float y) {
			this.x = x;
			this.y = y;
		}
	}

	private class Command {
		public String text;
		public boolean isInput;

		Command(String text, boolean isInput) {
			this.text = text;
			this.isInput = isInput;
		}
	}

	private class Line {
		public String text;
		public int textColor;

		Line() {
			this.text = "";
		}
	}
}