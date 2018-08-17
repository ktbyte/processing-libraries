package ktgui;

import processing.core.PApplet;

public class InputTextBox extends Controller {

    private final static int BACKSPACE_ASCII_CODE    = 8;
    private final static int ENTER_ASCII_CODE        = 10;
    private final static int BASIC_ASCII_LOWER_LIMIT = 32;
    private final static int BASIC_ASCII_UPPER_LIMIT = 126;

    private String           textInput;
    private int              textSize;
    private float            textHeight;
    private float            padding;

    InputTextBox(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
        super(ktgui, title, posx, posy, w, h);
        this.textInput = "";
        this.textSize = 18;
        updateTextAttributes();
    }

    /**
     * This is an automatically registered method and it should not be called directly
     */
    public void draw() {
        // if this button don't belongs to any window or pane 
        // then draw it directly on the PApplet canvas 
        if (parentController == null) {
            pa.image(pg, posx, posy);
        }
    }

    public void updateGraphics() {
        updateTextBox();
        updateBlinkingCursorGraphics();
    }

    private void updateTextBox() {
        pg.beginDraw();
        pg.pushStyle();
        pg.fill(255);
        pg.stroke(0);
        pg.strokeWeight(isFocused ? 2f : 1f);
        pg.rect(0, 0, w, h, r1, r2, r3, r4);
        pg.fill(0);
        pg.textSize(textSize);
        pg.textAlign(LEFT, CENTER);
        pg.text(getTrimmedInputText(), padding, h * 0.5f);
        pg.popStyle();
        pg.endDraw();
    }

    private void updateBlinkingCursorGraphics() {
        if (!isFocused) {
            return;
        }
        if (pa.frameCount % 60 < 30) {
            // update the parent PApplet's textSize value in order to accurately calculate text width
            pa.textSize(this.textSize);
            float cursorX = PApplet.min(w - padding, padding + pa.textWidth(textInput));
            pg.beginDraw();
            pg.stroke(0);
            pg.strokeWeight(2);
            pg.line(cursorX, h * 0.5f - textHeight * 0.5f, cursorX, h * 0.5f + textHeight * 0.5f);
            pg.endDraw();
        }
    }

    @Override
    public void processMousePressed() {
        isPressed = isHovered;

        if (isPressed) {
            // clear text only if this input box was not focused
            if (!isFocused) {
                setText("");
            }
            // mark it as focused
            isFocused = true;
            // notify listeners
            for (KTGUIEventAdapter adapter : adapters) {
                adapter.onMousePressed();
            }
        } else {
            isFocused = false;
        }
    }

    @Override
    public void processKeyPressed() {
        if (!isFocused) {
            return;
        }

        if ((int) pa.key == BACKSPACE_ASCII_CODE && textInput.length() > 0) {
            textInput = textInput.substring(0, textInput.length() - 1);
        }
        if ((int) pa.key == ENTER_ASCII_CODE) {
            for (KTGUIEventAdapter adapter : adapters) {
                adapter.onEnterKeyPressed();
            }
        } else if ((int) pa.key >= BASIC_ASCII_LOWER_LIMIT && (int) pa.key <= BASIC_ASCII_UPPER_LIMIT) {
            byte b = (byte) pa.key;
            char ch = (char) b;
            textInput += ch;
        }
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

    public String getText() {
        return textInput;
    }

    /**
     * Sets the text size
     * 
     * @param textSize
     *   The text size
     */
    public void setTextSize(int textSize) {
        // update the parent PApplet's textSize value in order to accurately calculate text width
        pa.textSize(this.textSize);
        // update the local text attributes (padding and text height)
        updateTextAttributes();
    }

    private void updateTextAttributes() {
        this.padding = 0.08f * h;
        // update text height
        this.textHeight = pa.textAscent() + pa.textDescent();
        while (textHeight > h - padding - padding) {
            this.textSize--;
            this.textHeight = pa.textAscent() + pa.textDescent();
        }
    }

    private String getTrimmedInputText() {
        StringBuilder sb = new StringBuilder();
        int wrappedWidth = PApplet.floor(w - padding);
        // update the parent PApplet's textSize value in order to accurately calculate text width
        pa.textSize(this.textSize);
        for (int i = textInput.length() - 1; i >= 0; i--) {
            int chunkWidth = PApplet.ceil(pa.textWidth(sb.toString() + ":")); // + additional temp character
            if (chunkWidth >= wrappedWidth) {
                break;
            }
            sb.append(textInput.charAt(i));
        }
        return sb.reverse().toString();
    }

}
