package ktbyte.gui;

import processing.event.*;
import processing.core.*;
import java.util.ArrayList;
import java.util.HashMap;

public class Console implements PConstants {
	private final static int BOX_RONDING = 7;
	private final static int SCROLL_BAR_WIDTH = 20;
	private final static float INPUT_BOX_HEIGHT_PERCENTAGE = 0.1f;

	private PApplet parent;
	private int x, y;
	private int w, h;
	private int inputTextColor;
	private int outputTextColor;
	private ArrayList<Line> lines;
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
	private TextBox inputBox;

	public Console(PApplet pap, int x, int y, int width, int height) {
		this.parent = pap;
		this.parent.registerMethod("draw", this);
		this.parent.registerMethod("mouseEvent", this);
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
		inputBox = new TextBox(this.parent, x, y + h - inputBoxHeight, w, inputBoxHeight);
		inputBox.setKeyEventListener(new KeyEventListener() {
	
			@Override
			public void onEnterKey() {
				handleConsoleInput();
			}
		});
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
		parent.textSize(this.textSize);
		this.textHeight = parent.textAscent() + parent.textDescent();
		this.maxLinesToDisplay = computeMaxLinesToDisplay();
		this.scrollBarMaxHeight = h - inputBoxHeight - SCROLL_BAR_WIDTH * 2;
	}

	int computeMaxLinesToDisplay() {
		return (int) ((0.9 * h - globalPadding * 2) / (textHeight + 2));
	}

	public void draw() {
		parent.pushStyle();
		drawConsoleTextBox();
		drawScrollBar();
		parent.popStyle();
	}

	void drawConsoleTextBox() {
		parent.rectMode(CORNER);
		parent.fill(0);
		parent.noStroke();
		parent.rect(x, y, w - SCROLL_BAR_WIDTH, h - inputBoxHeight, BOX_RONDING, 0, 0, 0);
		parent.textSize(textSize);
		parent.textAlign(LEFT, TOP);
		int consoleStartLine = PApplet.max(0, lines.size() - maxLinesToDisplay + lineScrollOffset);
		int consoleEndLine = PApplet.min(lines.size(), consoleStartLine + maxLinesToDisplay);

		for (int i = consoleStartLine, j = 0; i < consoleEndLine; i++, j++) {
			parent.stroke(lines.get(i).textColor);
			parent.fill(lines.get(i).textColor);
			parent.text(lines.get(i).text, x + globalPadding, y + j * (textHeight + 2) + globalPadding);
		}
	}

	void drawScrollBar() {
		parent.noStroke();
		parent.fill(50);
		parent.rect(x + w - SCROLL_BAR_WIDTH, y, SCROLL_BAR_WIDTH, h - inputBoxHeight, 0, BOX_RONDING, 0, 0);
		upBtn = new ArrowButton(x + w - SCROLL_BAR_WIDTH, y, SCROLL_BAR_WIDTH, UP, 0, BOX_RONDING, 0, 0);
		downBtn = new ArrowButton(x + w - SCROLL_BAR_WIDTH, y + h - inputBoxHeight - 20, SCROLL_BAR_WIDTH, DOWN);
		parent.fill(120);
		
		float scrollBarHeight = scrollBarMaxHeight;
		if (lines.size() > maxLinesToDisplay) {
			scrollBarHeight = PApplet.max(25, ((float) maxLinesToDisplay / lines.size()) * scrollBarMaxHeight);
		}
		int consoleScrollableLines = lines.size() - maxLinesToDisplay;
		float trackScrollArea = h - inputBoxHeight - SCROLL_BAR_WIDTH * 2 - scrollBarHeight;
		float scrollBarYCoordinate = y + SCROLL_BAR_WIDTH + trackScrollArea;
		if (lines.size() > maxLinesToDisplay) {
			scrollBarYCoordinate = y + SCROLL_BAR_WIDTH + trackScrollArea + (lineScrollOffset * ((float) trackScrollArea / consoleScrollableLines));
		}
		parent.rectMode(CORNER);
		parent.rect(x + w - SCROLL_BAR_WIDTH, scrollBarYCoordinate, SCROLL_BAR_WIDTH, scrollBarHeight);

		upBtn.drawButton();
		downBtn.drawButton();
	}

	public void write(String text) {
		splitCommandBasedOnConsoleWidth(new Command(text, false));
		lastVariableName = "";
	}

	void splitCommandBasedOnConsoleWidth(Command command) {
		Line line = new Line();
		parent.textSize(textSize);
		String[] wordsFromCommand = PApplet.split(command.text, " ");
		int i = 0;
		while (i < wordsFromCommand.length) {
			if (parent.textWidth(line.text + " ") + parent.textWidth(wordsFromCommand[i]) < w - SCROLL_BAR_WIDTH) {
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

	void mousePressed() {
		if (parent.mouseX > x && parent.mouseX < x + w && parent.mouseY > y && parent.mouseY < y + h) {
			isFocused = true;
			inputBox.setIsFocused(true);
		} else {
			isFocused = false;
			inputBox.setIsFocused(false);
		}
		if (upBtn.isPressed(parent.mouseX, parent.mouseY)) {
			if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
				lineScrollOffset--;
			}
		} else if (downBtn.isPressed(parent.mouseX, parent.mouseY)) {
			if (lineScrollOffset < 0) {
				lineScrollOffset++;
			}
		}
	}

	void handleConsoleInput() {
		String textInput = inputBox.getText();
		splitCommandBasedOnConsoleWidth(new Command(textInput, true));
		dict.put(lastVariableName, textInput);
		consoleInputListener.onConsoleInput(lastVariableName, textInput);
		inputBox.setText("");
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
		this.textHeight = parent.textAscent() + parent.textDescent();
		this.maxLinesToDisplay = computeMaxLinesToDisplay();
	}

	private class ArrowButton {
		private int x, y, s;
		private int r1, r2, r3, r4; // box rounding parameters
		private Point p1, p2, p3; // arrow definition points

		public int orientation;

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
			case UP:
				this.p1 = new Point(x + 0.2f * s, y + 0.8f * s);
				this.p2 = new Point(x + 0.8f * s, y + 0.8f * s);
				this.p3 = new Point(x + 0.5f * s, y + 0.2f * s);
				break;
			case RIGHT:
				this.p1 = new Point(x + 0.2f * s, y + 0.2f * s);
				this.p2 = new Point(x + 0.2f * s, y + 0.8f * s);
				this.p3 = new Point(x + 0.8f * s, y + 0.5f * s);
				break;
			case DOWN:
				this.p1 = new Point(x + 0.2f * s, y + 0.2f * s);
				this.p2 = new Point(x + 0.8f * s, y + 0.2f * s);
				this.p3 = new Point(x + 0.5f * s, y + 0.8f * s);
				break;
			case LEFT:
				this.p1 = new Point(x + 0.8f * s, y + 0.2f * s);
				this.p2 = new Point(x + 0.8f * s, y + 0.8f * s);
				this.p3 = new Point(x + 0.2f * s, y + 0.5f * s);
				break;
			default:
			}
		}

		void drawButton() {
			parent.rectMode(CORNER);
			parent.noStroke();
			parent.fill(80);
			parent.rect(this.x, this.y, s, s, r1, r2, r3, r4);
			parent.stroke(200);
			parent.line(p1.x, p1.y, p3.x, p3.y);
			parent.line(p2.x, p2.y, p3.x, p3.y);
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