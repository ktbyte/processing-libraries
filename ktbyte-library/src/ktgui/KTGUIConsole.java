package ktgui;

import java.util.HashMap;

public class KTGUIConsole extends Controller {
	private final static int		BOX_ROUNDING				= 7;
	private final static int		SCROLL_BAR_WIDTH			= 20;
	private final static float		INPUT_BOX_HEIGHT_PERCENTAGE	= 0.1f;



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

		int inputBoxHeight = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);

		dict = new HashMap<String, String>();

		inputBox = new InputTextBox(ktgui, "ConsoleTextBox", x, y + h - inputBoxHeight, w, inputBoxHeight);
		inputBox.setHandleFocus(true);
		inputBox.setTextSize(16);
		inputBox.setBorderRoundings(0, 0, BOX_ROUNDING, BOX_ROUNDING);
		inputBox.addEventAdapter(new KTGUIEventAdapter() {
			public void onEnterKeyPressed() {
				handleConsoleInput();
			}
		});

		textArea = new ScrollableTextArea(ktgui, "sta:" + title, x, y, w, h - inputBox.getHeight());
		textArea.setRoundings(BOX_ROUNDING, 0, 0, 0);
		
		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created window in default stage of stageManager
		StageManager.getInstance().getDefaultStage().registerController(this);
	}

	/**
	 * This is a register method and should not be called directly
	 */
	public void draw() {
		//pa.pushStyle();
		//drawConsoleTextBox();
		//drawScrollBar();
		//pa.popStyle();
	}

	private void drawScrollBar() {
//		int consoleTextBoxHeight = h - inputBoxHeight;
//		int consoleTextBoxWidth = w - SCROLL_BAR_WIDTH;
//		pa.noStroke();
//		pa.fill(50);
//		pa.rect(posx + consoleTextBoxWidth, posy, SCROLL_BAR_WIDTH, consoleTextBoxHeight, 0, BOX_ROUNDING, 0, 0);
//		//upBtn = new ArrowButton(x + consoleTextBoxWidth, y, SCROLL_BAR_WIDTH, UP, 0, BOX_RONDING, 0, 0);
//		//downBtn = new ArrowButton(x + consoleTextBoxWidth, y + consoleTextBoxHeight - 20, SCROLL_BAR_WIDTH, DOWN);
//		pa.fill(120);
//
//		float scrollBarHeight = scrollBarMaxHeight;
//		if (lines.size() > maxLinesToDisplay) {
//			scrollBarHeight = PApplet.max(25, ((float) maxLinesToDisplay / lines.size()) * scrollBarMaxHeight);
//		}
//		int consoleScrollableLines = lines.size() - maxLinesToDisplay;
//		float scrollableAreaHeight = consoleTextBoxHeight - SCROLL_BAR_WIDTH * 2 - scrollBarHeight;
//		float scrollBarYCoordinate = posy + SCROLL_BAR_WIDTH + scrollableAreaHeight;
//		if (lines.size() > maxLinesToDisplay) {
//			scrollBarYCoordinate = posy + SCROLL_BAR_WIDTH + scrollableAreaHeight
//					+ (lineScrollOffset * (scrollableAreaHeight / consoleScrollableLines));
//		}
//		pa.rectMode(CORNER);
//		pa.rect(posx + consoleTextBoxWidth, scrollBarYCoordinate, SCROLL_BAR_WIDTH, scrollBarHeight);

		//upBtn.drawButton();
		//downBtn.drawButton();
	}

	public void enableLineStartMarks(boolean val) {
		textArea.enableLineStartMarks(val);
	}
	
	public void processMousePressed() {
//		if (isPointInside(pa.mouseX, pa.mouseY)) {
//			isFocused = true;
//			inputBox.setIsFocused(true);
//		} else {
//			isFocused = false;
//			inputBox.setIsFocused(false);
//		}
//		//		if (upBtn.isPressed(pa.mouseX, pa.mouseY)) {
//		//			if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
//		//				lineScrollOffset--;
//		//			}
//		//		} else if (downBtn.isPressed(pa.mouseX, pa.mouseY)) {
//		//			if (lineScrollOffset < 0) {
//		//				lineScrollOffset++;
//		//			}
//		//		}
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

}
