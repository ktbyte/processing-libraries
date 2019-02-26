package ktbyte.gui;

import processing.core.PApplet;

public class InputTextBox extends Controller {

    private final static int BACKSPACE_ASCII_CODE    = 8;
    private final static int ENTER_ASCII_CODE        = 10;
    private final static int BASIC_ASCII_LOWER_LIMIT = 32;
    private final static int BASIC_ASCII_UPPER_LIMIT = 126;

    private String           welcomeText;
    private String           inputText;
    private int              textSize;
    private float            textHeight;
    private float            padding;

    InputTextBox(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
        super(ktgui, title, posx, posy, w, h);
        inputText = "";
        welcomeText = "Type text here ...";
        textSize = 18;
        updateTextAttributes();
    }

    public void updateGraphics() {
        super.updateGraphics();
        updateTextBox();
        updateBlinkingCursorGraphics();
    }

    private void updateTextBox() {
        pg.beginDraw();
        pg.pushStyle();

        if (isSelected(this)) {
            pg.fill(bgPressedColor);
            pg.stroke(50);
            pg.strokeWeight(3f);
        } else {
            pg.fill(bgPassiveColor);
            pg.stroke(0, 50, 0);
            pg.strokeWeight(1f);
        }
        pg.rect(0, 0, w, h, r1, r2, r3, r4);

        pg.textSize(textSize);
        pg.textAlign(LEFT, CENTER);
        if (inputText.length() > 0) {
            pg.fill(0);
            pg.text(getTrimmedInputText(), padding, h * 0.5f);
        } else {
            pg.fill(100);
            pg.text(welcomeText, padding, h * 0.5f);
        }

        pg.popStyle();
        pg.endDraw();
    }

    private void updateBlinkingCursorGraphics() {
        if (isSelected(this)) {
            if (pa.frameCount % 60 < 30) {
                // update the parent PApplet's textSize value in order to accurately calculate text width
                pa.textSize(this.textSize);
                float cursorX = PApplet.min(w - padding, padding + pa.textWidth(inputText));
                pg.beginDraw();
                pg.stroke(0);
                pg.strokeWeight(2);
                pg.line(cursorX, h * 0.5f - textHeight * 0.5f, cursorX,
                        h * 0.5f + textHeight * 0.5f);
                pg.endDraw();
            }
        }
    }

    @Override
    public void processMousePressed() {
        super.processMousePressed();
        // clear text only if this input box was not focused
        if (isSelected(this)) {
            welcomeText = "";
        }
    }

    @Override
    public void processKeyPressed() {
        if (!isSelected(this)) {
            return;
        }

        if ((int) pa.key == BACKSPACE_ASCII_CODE && inputText.length() > 0) {
            inputText = inputText.substring(0, inputText.length() - 1);
        }
        if ((int) pa.key == ENTER_ASCII_CODE) {
            for (EventAdapter adapter : adapters) {
                adapter.onEnterKeyPressed();
            }
        } else if ((int) pa.key >= BASIC_ASCII_LOWER_LIMIT
                && (int) pa.key <= BASIC_ASCII_UPPER_LIMIT) {
            byte b = (byte) pa.key;
            char ch = (char) b;
            inputText += ch;
        }
    }

    public void setFocused(boolean value) {
        // isFocused = value;
    }

    public void setWelcomeText(String text) {
        welcomeText = text;
    }

    /**
     * Sets the current text
     * 
     * @param text
     *   The text that should be displayed inside the box
     */
    public void setText(String text) {
        this.inputText = text;
    }

    public String getText() {
        return inputText;
    }

    /**
     * Sets the text size
     * 
     * @param textSize
     *   The text size
     */
    public void setTextSize(int textSize) {
        this.textSize = textSize;
        // update the parent PApplet's textSize value in order to accurately calculate text width
        pa.textSize(this.textSize);
        // update the local text attributes (padding and text height)
        updateTextAttributes();
    }

    private void updateTextAttributes() {
        this.padding = 0.08f * h;
        // update text height
        this.textHeight = pa.textAscent() + pa.textDescent();
    }

    private String getTrimmedInputText() {
        StringBuilder sb = new StringBuilder();
        int wrappedWidth = PApplet.floor(w - padding);
        // update the parent PApplet's textSize value in order to accurately calculate text width
        pa.textSize(this.textSize);
        for (int i = inputText.length() - 1; i >= 0; i--) {
            int chunkWidth = PApplet.ceil(pa.textWidth(sb.toString() + ":")); // + additional temp character
            if (chunkWidth >= wrappedWidth) {
                break;
            }
            sb.append(inputText.charAt(i));
        }
        return reverse(sb.toString());
    }

    private String reverse(String input) {
        char[] inChars = new char[input.length()];
        input.getChars(0, input.length(), inChars, 0);

        char[] outChars = new char[inChars.length];
        for (int i = inChars.length; i > 0; i--) {
            outChars[i - 1] = inChars[inChars.length - i];
        }

        return String.valueOf(outChars).toString();
    }
}
