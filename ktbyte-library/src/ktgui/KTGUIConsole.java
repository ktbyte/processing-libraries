package ktgui;

import java.util.ArrayList;
import java.util.HashMap;

import processing.core.PApplet;
import processing.event.MouseEvent;

public class KTGUIConsole extends Controller {
	private final static int		BOX_ROUNDING				= 7;
	private final static int		SCROLL_BAR_WIDTH			= 20;
	private final static float		INPUT_BOX_HEIGHT_PERCENTAGE	= 0.1f;

	private int						inputTextColor;
	private int						outputTextColor;
	private int						inputBoxHeight;
	private int						globalPadding;
	private int						lineScrollOffset;
	private boolean					isFocused;
	private int						textSize;
	private int						maxLinesToDisplay;
	private float					textHeight;
	private float					scrollBarMaxHeight;
	private ArrayList<Line>			lines;
	private HashMap<String, String>	dict;
	//	private ConsoleInputListener consoleInputListener;
	//	private String lastVariableName;
	//	private ArrowButton upBtn;
	//	private ArrowButton downBtn;
	private InputTextBox			inputBox;
	private ScrollableTextArea		textArea;
	
	public KTGUIConsole(KTGUI ktgui, String title, int x, int y, int w, int h) {
		super(ktgui);
		this.title = title;
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;
		this.inputTextColor = pa.color(255);
		this.outputTextColor = pa.color(170);

		globalPadding = 10;

		inputBoxHeight = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);

		lines = new ArrayList<>();

		dict = new HashMap<String, String>();

		//inputBox = new InputTextBox(ktgui, "ConsoleTextBox", x, y + h - inputBoxHeight, w, inputBoxHeight);
		inputBox = new InputTextBox(ktgui, "ConsoleTextBox", x, y + h - 40, w, 40);
		inputBox.setHandleFocus(true);
		inputBox.setTextSize(16);
		inputBox.setBorderRoundings(0, 0, 7, 7);
		inputBox.addEventAdapter(new KTGUIEventAdapter() {
			public void onEnterKeyPressed() {
				handleConsoleInput();
			}
		});

		textArea = new ScrollableTextArea(ktgui, "sta:" + title, x, y, w, h - inputBox.getHeight());
		textArea.setRoundings(7, 0, 0, 0);
		
		computeDefaultAttributes();

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created window in default stage of stageManager
		StageManager.getInstance().getDefaultStage().registerController(this);
	}

	/**
	 * This is a register method and should not be called directly
	 */
	public void draw() {
		pa.pushStyle();
		//drawConsoleTextBox();
		//drawScrollBar();
		pa.popStyle();
	}

	private void drawConsoleTextBox() {
		pa.rectMode(CORNER);
		pa.fill(0);
		pa.noStroke();
		pa.rect(posx, posy, w - SCROLL_BAR_WIDTH, h - inputBoxHeight, BOX_ROUNDING, 0, 0, 0);
		pa.textSize(textSize);
		pa.textAlign(LEFT, TOP);
		int consoleStartLine = PApplet.max(0, lines.size() - maxLinesToDisplay + lineScrollOffset);
		int consoleEndLine = PApplet.min(lines.size(), consoleStartLine + maxLinesToDisplay);

		for (int i = consoleStartLine, j = 0; i < consoleEndLine; i++, j++) {
			pa.stroke(lines.get(i).textColor);
			pa.fill(lines.get(i).textColor);
			pa.text(lines.get(i).text, posx + globalPadding, posy + j * (textHeight + 2) + globalPadding);
		}
	}

	private void drawScrollBar() {
		int consoleTextBoxHeight = h - inputBoxHeight;
		int consoleTextBoxWidth = w - SCROLL_BAR_WIDTH;
		pa.noStroke();
		pa.fill(50);
		pa.rect(posx + consoleTextBoxWidth, posy, SCROLL_BAR_WIDTH, consoleTextBoxHeight, 0, BOX_ROUNDING, 0, 0);
		//upBtn = new ArrowButton(x + consoleTextBoxWidth, y, SCROLL_BAR_WIDTH, UP, 0, BOX_RONDING, 0, 0);
		//downBtn = new ArrowButton(x + consoleTextBoxWidth, y + consoleTextBoxHeight - 20, SCROLL_BAR_WIDTH, DOWN);
		pa.fill(120);

		float scrollBarHeight = scrollBarMaxHeight;
		if (lines.size() > maxLinesToDisplay) {
			scrollBarHeight = PApplet.max(25, ((float) maxLinesToDisplay / lines.size()) * scrollBarMaxHeight);
		}
		int consoleScrollableLines = lines.size() - maxLinesToDisplay;
		float scrollableAreaHeight = consoleTextBoxHeight - SCROLL_BAR_WIDTH * 2 - scrollBarHeight;
		float scrollBarYCoordinate = posy + SCROLL_BAR_WIDTH + scrollableAreaHeight;
		if (lines.size() > maxLinesToDisplay) {
			scrollBarYCoordinate = posy + SCROLL_BAR_WIDTH + scrollableAreaHeight
					+ (lineScrollOffset * (scrollableAreaHeight / consoleScrollableLines));
		}
		pa.rectMode(CORNER);
		pa.rect(posx + consoleTextBoxWidth, scrollBarYCoordinate, SCROLL_BAR_WIDTH, scrollBarHeight);

		//upBtn.drawButton();
		//downBtn.drawButton();
	}

	private void computeDefaultAttributes() {
		//		if (h < 400) {
		this.textSize = 18;
		//		} else if (h < 900) {
		//			this.textSize = 22;
		//		} else {
		//			this.textSize = 24;
		//		}
		pa.textSize(this.textSize);
		this.textHeight = pa.textAscent() + pa.textDescent();
		this.maxLinesToDisplay = computeMaxLinesToDisplay();
		this.scrollBarMaxHeight = h - inputBoxHeight - SCROLL_BAR_WIDTH * 2;
		System.out.println("textSize in computeDefaultAttributes: " + textSize);
		System.out.println("textHeight in computeDefaultAttributes: " + textHeight);
	}

	private int computeMaxLinesToDisplay() {
		return (int) ((0.9 * h - globalPadding * 2) / (textHeight + 2));
	}

	public void processMousePressed() {
		if (isPointInside(pa.mouseX, pa.mouseY)) {
			isFocused = true;
			inputBox.setIsFocused(true);
		} else {
			isFocused = false;
			inputBox.setIsFocused(false);
		}
		//		if (upBtn.isPressed(pa.mouseX, pa.mouseY)) {
		//			if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
		//				lineScrollOffset--;
		//			}
		//		} else if (downBtn.isPressed(pa.mouseX, pa.mouseY)) {
		//			if (lineScrollOffset < 0) {
		//				lineScrollOffset++;
		//			}
		//		}
	}

	public void processMouseWheel(MouseEvent me) {
		mouseScrolled(me.getCount());
	}

	private void mouseScrolled(int mouseWheelDelta) {
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

	private void handleConsoleInput() {
		String textInput = inputBox.getText();
		//splitCommandBasedOnConsoleWidth(new Command(textInput, true));
		textArea.appendTextBlock(textInput);
		textArea.scrollToBottom();
		inputBox.setText("");
		
		//		dict.put(lastVariableName, textInput);
		//		if (consoleInputListener != null) {
		//			consoleInputListener.onConsoleInput(lastVariableName, textInput);
		//		}
		//		inputBox.setText("");
	}

	private boolean isPointInside(int x, int y) {
		return x > posx && x < posx + w && y > posy && y < posy + h;
	}

	private void splitCommandBasedOnConsoleWidth(Command command) {
		Line line = new Line();
		pa.textSize(textSize);
		String[] wordsFromCommand = PApplet.split(command.text, " ");
		int i = 0;
		while (i < wordsFromCommand.length) {
			if (pa.textWidth(line.text + " ") + pa.textWidth(wordsFromCommand[i]) < w - SCROLL_BAR_WIDTH) {
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

	private class Command {
		public String	text;
		public boolean	isInput;

		Command(String text, boolean isInput) {
			this.text = text;
			this.isInput = isInput;
		}
	}

	private class Line {
		public String	text;
		public int		textColor;

		Line() {
			this.text = "";
		}
	}
}
