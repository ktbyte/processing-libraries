package ktbyte.gui;

import java.util.HashMap;

import processing.core.PApplet;

public class Console extends Controller {
    private final static int        BOX_ROUNDING                = 7;
    private final static float      INPUT_BOX_HEIGHT_PERCENTAGE = 0.1f;

    private InputTextBox            inputBox;
    private ScrollableTextArea      textArea;
    private ScrollBar               scrollBar;

    private int                     inputTextColor              = 0xFFFFFF;
    private int                     outputTextColor             = 0x000000;

    private HashMap<String, String> dict;
    private String                  lastVariableName;
    int                             inputBoxWidth               = (int) (INPUT_BOX_HEIGHT_PERCENTAGE
            * h);

    public Console(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
        super(ktgui, title, posx, posy, w, h);
        this.dict = new HashMap<String, String>();
        createScrollableTextArea();
        createInputBox();
        createScrollBar();
    }

    private void createScrollableTextArea() {
        textArea = new ScrollableTextArea(ktgui, "sta:" + title,
                0, 0,
                w - inputBoxWidth, h - inputBoxWidth);
        textArea.setBorderRoundings(BOX_ROUNDING, 0, 0, 0);
        textArea.addEventAdapter(new EventAdapter() {
            public void onMouseWheel(int count) {
                // int lineCount = textArea.getLineCount();
                // int startLinePosition = textArea.getStartLinePosition();
                int maxLineToDisplay = textArea.getMaxLinesToDisplay();
                // int calculatedEndLineNumber = PApplet.min(
                // lineCount, startLinePosition + maxLineToDisplay);
                int correctedEndLineNumber = textArea.getEndLinePosition();
                float mappedScrollBarPos = PApplet.map(
                        correctedEndLineNumber, 0, textArea.getLineCount() - maxLineToDisplay, 0, 100);
                scrollBar.setNormalizedValue(mappedScrollBarPos);
            }
        });
        attachController(textArea);
    }

    private void createScrollBar() {
        scrollBar = new ScrollBar(ktgui, "sb:" + title,
                w - inputBoxWidth, 0,
                inputBoxWidth, h - inputBoxWidth,
                0, 100);
        scrollBar.addEventAdapter(new EventAdapter() {
            public void onValueChanged() {
                textArea.setNormalizedLinePosition(scrollBar.getNormalizedValue());
            }
        });
        attachController(scrollBar);
    }

    private void createInputBox() {
        inputBox = new InputTextBox(ktgui, "ib:" + title,
                0, h - inputBoxWidth,
                w, inputBoxWidth);
        inputBox.setHandleFocus(true);
        inputBox.setTextSize(16);
        inputBox.setBorderRoundings(0, 0, BOX_ROUNDING, BOX_ROUNDING);
        inputBox.addEventAdapter(new EventAdapter() {
            public void onEnterKeyPressed() {
                KTGUI.debug("Processing input...");
                handleConsoleInput();
            }
        });
        attachController(inputBox);
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
        textArea.enableBlockMarks(val);
    }

    private void handleConsoleInput() {
        // process InputBox onEnterKeyPressedEvent by own means
        String textInput = inputBox.getText();
        textArea.appendTextBlock(textInput, inputTextColor);
        textArea.scrollToBottom();
        inputBox.setText("");
        dict.put(lastVariableName, textInput);
        // updateScrollBar();

        // notify listeners about onEnterKeyPressedEvent
        for (EventAdapter adapter : adapters) {
            adapter.onConsoleInput(textInput, lastVariableName);
        }
    }

    // private void updateScrollBar() {
    // //scrollBar.setRangeEnd(textArea.getLineNumbers());
    // scrollBar.setRangeEnd(textArea.getMaximumAllowedPositionOfStartLine());
    // scrollBar.setValue((int) (scrollBar.getRangeEnd() - getStartLinePosition()));
    // }

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

    public void setInputFocused(boolean value) {
        inputBox.setFocused(value);
    }

    public int getStartLinePosition() {
        return textArea.getStartLinePosition();
    }

    public void setInputTextColor(int c) {
        inputTextColor = c;
    }

    public void setOutputTextColor(int c) {
        outputTextColor = c;
    }

    public void enableBlockMarks(boolean val) {
        textArea.enableBlockMarks(val);
    }

    public void enableLineNumbers(boolean val) {
        textArea.enableLineNumbers(val);
        ;
    }

    public String getLine(int index) {
        return textArea.getTextLine(index);
    }

    public String getBlock(int index) {
        return textArea.getTextBlock(index);
    }

    public int getLineCount() {
        return textArea.getLineCount();
    }

    public int getBlockCount() {
        return textArea.getBlockCount();
    }

    public String getLastLine() {
        String textLine = "_NO_LINES_EXIST_YET_";
        if (getLineCount() > 0)
            textLine = getLine(getLineCount() - 1);
        return textLine;
    }

    public String getLastBlock() {
        String textBlock = "_NO_BLOCKS_EXIST_YET_";
        if (getBlockCount() > 0)
            textBlock = getBlock(getBlockCount() - 1);
        return textBlock;
    }

    public InputTextBox getInputBox() {
        return inputBox;
    }

    public ScrollableTextArea getTextArea() {
        return textArea;
    }

    public ScrollBar getScrollBar() {
        return scrollBar;
    }
}
