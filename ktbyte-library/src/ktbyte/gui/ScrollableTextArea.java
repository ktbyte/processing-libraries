package ktbyte.gui;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.event.MouseEvent;

public class ScrollableTextArea extends Controller {
    private float                textSize        = 14;
    private float                padding         = 6;

    private ArrayList<TextLine>  textLines       = new ArrayList<>();
    private ArrayList<TextBlock> textBlocks      = new ArrayList<>();
    private int                  startLineNumber = 0;
    private boolean              enableLineStartMarks;

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

        int calculatedEndLineNumber = PApplet.min(textLines.size() - 1, startLineNumber + getMaxLinesToDisplay());
        for (int i = 0; i <= calculatedEndLineNumber - startLineNumber; i++) {
            TextLine line = textLines.get(i + startLineNumber);
            pg.fill(line.textColor);
            pg.textAlign(LEFT, BOTTOM);
            pg.textSize(this.textSize);
            pg.text(line.content, padding, (int) (padding * 0.5) + (i + 1) * getTextHeight());
            if (line.isHead && enableLineStartMarks) {
                pg.strokeWeight(3);
                pg.point(padding - 5, (int) (padding * 0.5 + (i + 1) * getTextHeight() - getTextHeight() * 0.5));
            }
        }

        pg.popStyle();
        pg.endDraw();
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
                if (startLineNumber > 0) {
                    decrementStartLine();
                }
            } else if (mouseWheelDelta > 0) {
                if (startLineNumber < getMaximumAllowedPositionOfStartLine()) {
                    incrementStartLine();
                }
            }
        }
    }

    public void incrementStartLine() {
        if (startLineNumber < getMaximumAllowedPositionOfStartLine()) {
            startLineNumber++;
        }
    }

    public int getMaximumAllowedPositionOfStartLine() {
        return textLines.size() - getMaxLinesToDisplay();
    }

    public void decrementStartLine() {
        if (startLineNumber > 0) {
            startLineNumber--;
        }
    }

    public void scrollToTop() {
        while (startLineNumber > 0) {
            startLineNumber--;
        }
    }

    public void scrollToBottom() {
        while (startLineNumber < getMaximumAllowedPositionOfStartLine()) {
            startLineNumber++;
        }
    }

    public void scrollToPosition(int lineNumber) {
        if (lineNumber < 0 || lineNumber >= getMaximumAllowedPositionOfStartLine()) {
            KTGUI.debug("lineNumber[" + lineNumber + "] is out of range during 'scrollToLine' call.");
            return;
        }
        if (lineNumber > startLineNumber) {
            while (startLineNumber < lineNumber &&
                    startLineNumber < getMaximumAllowedPositionOfStartLine()) {
                startLineNumber++;
            }
        } else if (lineNumber < startLineNumber) {
            while (startLineNumber > lineNumber && startLineNumber > 0) {
                startLineNumber--;
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

    public int getMaxLinesToDisplay() {
        return PApplet.floor((h - padding - padding) / getTextHeight());
    }

    private float getTextHeight() {
        pa.textSize(textSize);
        return pa.textAscent() + pa.textDescent();
    }

    public int getStartLinePosition() {
        return startLineNumber;
    }
    //
    //	public void setStartLine(int lineNumber) {
    //		//this.startLineNumber = (lineNumber > 0) ? lineNumber : 0;
    //		this.startLineNumber = PApplet.constrain(lineNumber, 0, getLineNumbers());
    //	}

    public void enableTextBlockStartMarks(boolean val) {
        enableLineStartMarks = val;
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
        //private StringBuilder	sb;
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
