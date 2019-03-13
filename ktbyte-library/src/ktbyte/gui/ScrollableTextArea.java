package ktbyte.gui;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.event.MouseEvent;

public class ScrollableTextArea extends Controller {
    private float                textSize          = 14;
    private float                padding           = 6;

    private ArrayList<TextLine>  textLines         = new ArrayList<>();
    private ArrayList<TextBlock> textBlocks        = new ArrayList<>();
    private int                  startLinePosition = 0;
    private boolean              enableBlockMarks;
    private boolean              enableLineNumbers;

    public ScrollableTextArea(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
        super(ktgui, title, posx, posy, w, h);
        setPadding(getTextSize() * 0.75f);
    }

    @Override
    public void updateGraphics() {
        super.updateGraphics();
        updateTextAreaGraphics();
    }

    private void updateTextAreaGraphics() {
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

        int correctedEndLinePosition = getEndLinePosition();

        //////////////////////////////////////////////////////////////////////////////////////
        ////// This method draws 'visible' text lines inside the ScrollableTextArea //////
        //////////////////////////////////////////////////////////////////////////////////////
        for (int i = 0; i <= correctedEndLinePosition - startLinePosition; i++) {
            TextLine line = textLines.get(i + startLinePosition);
            pg.fill(line.textColor);
            pg.textAlign(LEFT, BOTTOM);
            pg.textSize(this.textSize);
            pg.text(line.content, padding, (int) (padding * 0.5) + (i + 1) * getTextHeight());
            if (line.isHead && enableBlockMarks) {
                pg.strokeWeight(this.textSize * 0.33f);
                pg.stroke(line.textColor, 127);
                pg.point(w - padding + 6,
                        (int) (padding * 0.5 + (i + 1) * getTextHeight() - getTextHeight() * 0.5));
            }
            if (enableLineNumbers) {
                pg.textSize(this.textSize * 0.5f);
                pg.text(i + startLinePosition, padding - 5,
                        (int) (padding * 0.5 + (i + 1) * getTextHeight() - getTextHeight() * 0.5));
            }
        }
        //////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////

        pg.popStyle();
        pg.endDraw();
    }

    public int getEndLinePosition() {
        // this is a 'corrected' version
        return PApplet.min(
                textLines.size() - 1, startLinePosition + getMaxLinesToDisplay());
    }

    @Override
    public void processMouseWheel(MouseEvent me) {
        // process mouse event by own means
        mouseScrolled(me.getCount());
        // notify listeners that ScrollableTextArea received the MouseWheel event
        for (EventAdapter adapter : adapters) {
            adapter.onMouseWheel(me.getCount());
        }
    }

    public void mouseScrolled(int mouseWheelDelta) {
        if (isSelected(this)) {
            if (mouseWheelDelta < 0) {
                if (startLinePosition > 0) {
                    decrementStartLine();
                }
            } else if (mouseWheelDelta > 0) {
                if (startLinePosition < getMaxAllowedStartLinePos()) {
                    incrementStartLine();
                }
            }
        }
    }

    public void incrementStartLine() {
        if (startLinePosition < getMaxAllowedStartLinePos() - 1) {
            startLinePosition++;
        }
    }

    public void decrementStartLine() {
        if (startLinePosition > 0) {
            startLinePosition--;
        }
    }

    public int getMaxAllowedStartLinePos() {
        return textLines.size() - getMaxLinesToDisplay();
    }

    public int getMaxLinesToDisplay() {
        return PApplet.floor((h - padding - padding) / getTextHeight());
    }

    public void scrollToTop() {
        while (startLinePosition > 0) {
            startLinePosition--;
        }
    }

    public void scrollToBottom() {
        while (startLinePosition < getMaxAllowedStartLinePos()) {
            startLinePosition++;
        }
    }

    public void scrollToPosition(int lineNumber) {
        if (lineNumber < 0 || lineNumber >= getMaxAllowedStartLinePos()) {
            KTGUI.debug(
                    "lineNumber[" + lineNumber + "] is out of range during 'scrollToLine' call.");
            return;
        }
        if (lineNumber > startLinePosition) {
            while (startLinePosition < lineNumber &&
                    startLinePosition < getMaxAllowedStartLinePos()) {
                startLinePosition++;
            }
        } else if (lineNumber < startLinePosition) {
            while (startLinePosition > lineNumber && startLinePosition > 0) {
                startLinePosition--;
            }
        }
    }

    public ArrayList<TextLine> getTextLines() {
        return textLines;
    }

    public ArrayList<TextBlock> getTextBlocks() {
        return textBlocks;
    }

    public float getPadding() {
        return padding;
    }

    public void setPadding(float padding) {
        this.padding = padding;
        updateWrappedLines();
    }

    public float getTextSize() {
        return textSize;
    }

    public void setTextSize(float textSize) {
        this.textSize = textSize;
        updateWrappedLines();
    }

    public void appendTextBlock(String text) {
        TextBlock textBlock = new TextBlock(text);
        textBlocks.add(textBlock);
        textBlock.appendAsWrappedLines(textSize);
    }

    public void appendTextBlock(String text, int color) {
        TextBlock textBlock = new TextBlock(text, color);
        textBlocks.add(textBlock);
        textBlock.appendAsWrappedLines(textSize);
    }

    private void updateWrappedLines() {
        // reset current list of TextLines
        textLines = new ArrayList<TextLine>();
        // create the updated list of TextLines
        for (TextBlock block : textBlocks) {
            block.appendAsWrappedLines(textSize);
        }
    }

    private float getTextHeight() {
        pa.textSize(textSize);
        return pa.textAscent() + pa.textDescent();
    }

    public int getStartLinePosition() {
        return startLinePosition;
    }

    public void setStartLinePosition(int pos) {
        if (pos < 0 || pos > getMaxAllowedStartLinePos()) {
            return;
        }
        this.startLinePosition = PApplet.constrain(pos, 0, getMaxAllowedStartLinePos());
    }

    public void setNormalizedLinePosition(float pos) {
        int endOfScrollableRange = getLineCount() - getMaxLinesToDisplay() - 1;
        int normalizedPos = PApplet.floor(PApplet.map(pos, 0, 100f, endOfScrollableRange, 0));
        setStartLinePosition(normalizedPos);
    }

    public void enableBlockMarks(boolean val) {
        enableBlockMarks = val;
    }

    public void enableLineNumbers(boolean val) {
        enableLineNumbers = val;
    }

    public String getTextLine(int index) {
        String textLine = "-= textLine: out of range =-";
        if (textLines.size() - index > 0) {
            textLine = textLines.get(index).content;
        }
        return textLine;
    }

    public String getTextBlock(int index) {
        String textBlock = "-= textBlock: out of range =-";
        if (textBlocks.size() - index > 0) {
            textBlock = textBlocks.get(index).content;
        }
        return textBlock;
    }

    public int getLineCount() {
        return textLines.size();
    }

    public int getBlockCount() {
        return textBlocks.size();
    }

    private class TextLine {
        public String  content;
        public int     textColor = pa.color(0, 10, 30);
        public boolean isHead;

        @SuppressWarnings("unused")
        public TextLine(String content, boolean isHead) {
            this.content = content;
            this.isHead = isHead;
        }

        public TextLine(String content, int textColor, boolean isHead) {
            this.content = content;
            this.isHead = isHead;
            this.textColor = textColor;
        }
    }

    private class TextBlock {
        private String  content;
        private boolean isHeadAlreadyMarked;
        private int     textColor = pa.color(0);

        public TextBlock(String content) {
            this.content = content.trim().replaceAll("\n\t\r", " ");
        }

        public TextBlock(String content, int textColor) {
            this.content = content.trim().replaceAll("\n\t\r", " ");
            this.textColor = textColor;
        }

        public void appendAsWrappedLines(float _textSize) {
            // reset the flag and 'sb' after previous call to this method
            // in order to allow correct head marking in case the padding
            // or text size will change
            isHeadAlreadyMarked = false;
            StringBuilder sb = new StringBuilder();
            // calculate the wrapped width of the line as it will be shown
            int wrappedWidth = PApplet.floor(w - padding - padding);
            // update the PApplet's textSize value in order to accurately calculate text width
            // !!! textSize variable belongs to ScrollableTextArea
            pa.textSize(_textSize);
            // go through all the characters in the text block splitting it
            // by text chunks which has the width equals to the 'paddedWidth'
            for (int i = 0; i < content.length(); i++) {
                int chunkWidth = PApplet.ceil(pa.textWidth(sb.toString()));
                if (chunkWidth >= wrappedWidth) {
                    addWrappedLine(sb);
                    sb = new StringBuilder();
                }
                sb.append(content.charAt(i));
            }
            addWrappedLine(sb);
        }

        private void addWrappedLine(StringBuilder sb) {
            if (!isHeadAlreadyMarked) {
                textLines.add(new TextLine(sb.toString(), textColor, true)); // add last line
                isHeadAlreadyMarked = true;
            } else {
                textLines.add(new TextLine(sb.toString(), textColor, false)); // add last line
            }
        }
    }
}
