package ktgui;

import java.util.HashMap;

public class KTGUIConsole extends Controller {
	private final static int		BOX_ROUNDING				= 7;
	private final static int		SCROLL_BAR_WIDTH			= 20;
	private final static float		INPUT_BOX_HEIGHT_PERCENTAGE	= 0.1f;

	private InputTextBox			inputBox;
	private ScrollableTextArea		textArea;
	//private ScrollBar scrollBar;

	private int						inputTextColor				= 0xFFFFFF;
	private int						outputTextColor				= 0x000000;

	private HashMap<String, String>	dict;
	private String					lastVariableName;

	public KTGUIConsole(KTGUI ktgui, String title, int x, int y, int w, int h) {
		super(ktgui);
		this.title = title;
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;
		this.dict = new HashMap<String, String>();

		int inputBoxHeight = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);

		inputBox = new InputTextBox(ktgui, "ConsoleTextBox", x, y + h - inputBoxHeight, w, inputBoxHeight);
		inputBox.setHandleFocus(true);
		inputBox.setTextSize(16);
		inputBox.setBorderRoundings(0, 0, BOX_ROUNDING, BOX_ROUNDING);
		inputBox.addEventAdapter(new KTGUIEventAdapter() {
			public void onEnterKeyPressed() {
				println("Processing input...");
				handleConsoleInput();
			}
		});

		textArea = new ScrollableTextArea(ktgui, "sta:" + title, x, y, w, h - inputBox.getHeight());
		textArea.setBorderRoundings(BOX_ROUNDING, 0, 0, 0);

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
}
