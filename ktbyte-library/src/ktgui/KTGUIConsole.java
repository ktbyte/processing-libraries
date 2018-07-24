package ktgui;

import java.util.HashMap;

public class KTGUIConsole extends Controller {
	private final static int		BOX_ROUNDING				= 7;
	private final static int		SCROLL_BAR_WIDTH			= 20;
	private final static float		INPUT_BOX_HEIGHT_PERCENTAGE	= 0.1f;

	//	private InputTextBox			inputBox;
	//	private ScrollableTextArea		textArea;
	public InputTextBox				inputBox;
	public ScrollableTextArea		textArea;
	private ScrollBar				scrollBar;

	private int						inputTextColor				= 0xFFFFFF;
	private int						outputTextColor				= 0x000000;

	private HashMap<String, String>	dict;
	private String					lastVariableName;

	public KTGUIConsole(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		
		this.dict = new HashMap<String, String>();

		int inputBoxHeight = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);
		
		inputBox = new InputTextBox(ktgui, "ConsoleTextBox", posx, posy + h - inputBoxHeight, w, inputBoxHeight);
		inputBox.setHandleFocus(true);
		inputBox.setTextSize(16);
		inputBox.setBorderRoundings(0, 0, BOX_ROUNDING, BOX_ROUNDING);
		inputBox.addEventAdapter(new KTGUIEventAdapter() {
			public void onEnterKeyPressed() {
				println("Processing input...");
				handleConsoleInput();
			}
		});
		//attachController(inputBox);
		//registerChildController(inputBox);
		
		textArea = new ScrollableTextArea(ktgui, "sta:" + title, posx, posy, w - inputBoxHeight, h - inputBoxHeight);
		textArea.setBorderRoundings(BOX_ROUNDING, 0, 0, 0);
		//attachController(textArea);
		//registerChildController(textArea);
		
		scrollBar = new ScrollBar(ktgui, "scrollbar:" + title, posx + w - inputBoxHeight, posy, inputBoxHeight, h - inputBoxHeight);
		//attachController(scrollBar);
		//registerChildController(scrollBar);
		
		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		// automatically register the newly created window in default stage of stageManager
		StageManager.getInstance().getDefaultStage().registerController(this);
	}

	// overrides the 'draw()' method of parent class (Controller)
	// to prevent drawing the TitleBar and Pane second time.   	
	public void draw() {}

	/**
	 * Returns a stored value from the console's memory
	 * 
	 * @param name
	 *          the key of the stored entry
	 *          
	 * @return a stored value from the console's memory
	 */
	public String getValue(String name) {
		return dict.get(name);
	}

	/**
	 * Sets the name of the next console's entry
	 * 
	 * @param name
	 *          the key of the next stored entry
	 */
	public void readInput(String name) {
		lastVariableName = name;
	}

	public void setBorderRoundings(int r1, int r2, int r3, int r4) {
		textArea.setBorderRoundings(r1, r2, 0, 0);
		inputBox.setBorderRoundings(0, 0, r3, r4);
		//		inputBox.setRoundings(0, 0, 0, r4);
		//		textArea.setRoundings(r1, 0, 0, 0);
		//		scrollBar.setRoundings(0, r2, r3, 0);
	}

	public void enableLineStartMarks(boolean val) {
		textArea.enableTextBlockStartMarks(val);
	}

	private void handleConsoleInput() {
		String textInput = inputBox.getText();
		textArea.appendTextBlock(textInput, inputTextColor);
		textArea.scrollToBottom();
		inputBox.setText("");
		dict.put(lastVariableName, textInput);
		for (KTGUIEventAdapter adapter : adapters) {
			adapter.onConsoleInput(textInput, lastVariableName);
		}
	}

	public void setInputTextSize(int size) {
		inputBox.setTextSize(size);
	}

	public void setOutputTextSize(int size) {
		textArea.setTextSize(size);
	}

	public void writeOutput(String textBlock) {
		textArea.appendTextBlock(textBlock, outputTextColor);
		textArea.scrollToBottom();
	}

	public void setInputTextColor(int c) {
		inputTextColor = c;
	}

	public void setOutputTextColor(int c) {
		outputTextColor = c;
	}

	public String getLine(int index) {
		return textArea.getTextLine(index);
	}

	public String getBlock(int index) {
		return textArea.getTextBlock(index);
	}

	public int getLineCount() {
		return textArea.getLineNumbers();
	}

	public int getBlockCount() {
		return textArea.getBlockNumbers();
	}

	public String getLastLine() {
		String textLine = "";
		if (getLineCount() > 0)
			textLine = getLine(getLineCount() - 1);
		return textLine;
	}

	public String getLastBlock() {
		String textBlock = "";
		if (getBlockCount() > 0)
			textBlock = getBlock(getBlockCount() - 1);
		return textBlock;
	}

	private class ScrollBar extends Controller {
		DirectionButton scrollUpButton, scrollDownButton;

		public ScrollBar(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
			super(ktgui, title, posx, posy, w, h);
			createButtons();
		}

		public void draw() {
			// add the background shape drawing here
			drawControllers();
		}
		
		private void createButtons() {
			scrollUpButton = new DirectionButton(ktgui, "db-up:" + title, posx, posy, w, w);
			scrollUpButton.setDirection(UP);
			scrollUpButton.addEventAdapter(new KTGUIEventAdapter() {
				public void onMousePressed() {
					System.out.println(scrollUpButton.title + " pressed.");
				}
			});
			attachController(scrollUpButton);
			//registerChildController(scrollUpButton);

			scrollDownButton = new DirectionButton(ktgui, "db-down:" + title, posx, posy - w, w, w);
			scrollDownButton.setDirection(DOWN);
			scrollDownButton.addEventAdapter(new KTGUIEventAdapter() {
				public void onMousePressed() {
					System.out.println(scrollDownButton.title + " pressed.");
				}
			});
			attachController(scrollDownButton);
			//registerChildController(scrollDownButton);
		}

	}

	private class DirectionButton extends Button {

		int direction = UP;

		public DirectionButton(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
			super(ktgui, title, posx, posy, w, h);
		}

		public void updateGraphics() {
			pg.beginDraw();
			pg.rectMode(CORNER);
			if (isHovered && !isPressed) {
				pg.fill(KTGUI.COLOR_FG_HOVERED);
			} else if (isHovered && isPressed) {
				pg.fill(KTGUI.COLOR_FG_PRESSED);
			} else {
				//pg.fill(ktgui.COLOR_FG_PASSIVE);
				pg.fill(200, 200);
			}
			pg.stroke(0);
			pg.strokeWeight(1);
			pg.rect(0, 0, w, h, r1, r2, r3, r4);
			pg.pushMatrix();
			pg.translate(w * 0.5f, h * 0.5f);
			if (direction == UP) {
				pg.rotate(PI);
			} else if (direction == RIGHT) {
				pg.rotate(PI + HALF_PI);
			} else if (direction == DOWN) {
				pg.rotate(0);
			} else if (direction == LEFT) {
				pg.rotate(HALF_PI);
			}
			pg.line(-0.4f * w, -0.4f * h, 0, 0.4f * h);
			pg.line(0.4f * w, -0.4f * h, 0, 0.4f * h);
			pg.popMatrix();
			pg.endDraw();
		}

		public void setDirection(int direction) {
			this.direction = direction;
		}
	}
}
