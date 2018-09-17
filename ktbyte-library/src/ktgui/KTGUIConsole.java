package ktgui;

import java.util.HashMap;

public class KTGUIConsole extends Controller {
    private final static int        BOX_ROUNDING                = 7;
    private final static float      INPUT_BOX_HEIGHT_PERCENTAGE = 0.1f;

    //	private InputTextBox			inputBox;
    //	private ScrollableTextArea		textArea;
    public InputTextBox             inputBox;
    public ScrollableTextArea       textArea;
    private ScrollBar               scrollBar;

    private int                     inputTextColor              = 0xFFFFFF;
    private int                     outputTextColor             = 0x000000;

    private HashMap<String, String> dict;
    private String                  lastVariableName;

    public KTGUIConsole(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
        super(ktgui, title, posx, posy, w, h);
        this.dict = new HashMap<String, String>();

        int inputBoxWidth = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);

        inputBox = new InputTextBox(ktgui, "inptxtbx:" + title,
                posx, posy + h - inputBoxWidth, w, inputBoxWidth);
        inputBox.setHandleFocus(true);
        inputBox.setTextSize(16);
        inputBox.setBorderRoundings(0, 0, BOX_ROUNDING, BOX_ROUNDING);
        inputBox.addEventAdapter(new KTGUIEventAdapter() {
            public void onEnterKeyPressed() {
                KTGUI.debug("Processing input...");
                handleConsoleInput();
            }
        });
        //attachController(inputBox);

        textArea = new ScrollableTextArea(ktgui, "scrlbltxtar:" + title, 
                posx, posy, w - inputBoxWidth, h - inputBoxWidth);
        textArea.setBorderRoundings(BOX_ROUNDING, 0, 0, 0);
        //attachController(textArea);

        scrollBar = new ScrollBar(ktgui, "scrlbar:" + title, 
                posx + w - inputBoxWidth, posy, inputBoxWidth, h - inputBoxWidth, 0, 100);
        //attachController(scrollBar);

    }

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
        textArea.setBorderRoundings(r1, 0, 0, 0);
        inputBox.setBorderRoundings(0, 0, r3, r4);
        scrollBar.setBorderRoundings(0, r2, 0, 0);
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

}
