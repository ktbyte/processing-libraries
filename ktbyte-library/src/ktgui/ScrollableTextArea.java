package ktgui;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.event.MouseEvent;

public class ScrollableTextArea extends Controller {
	private float					textSize	= 14;
	private float					padding		= 6;

	private ArrayList<TextLine>		textLines	= new ArrayList<>();
	private ArrayList<TextBlock>	textBlocks	= new ArrayList<>();
	private int						startLine	= 0;

	public ScrollableTextArea(KTGUI ktgui, String title, int x, int y, int w, int h) {
		super(ktgui);

		this.title = title;
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		StageManager.getInstance().getDefaultStage().registerController(this);
	}

	public void appendTextBlock(String text) {
		TextBlock textBlock = new TextBlock(text);
		textBlocks.add(textBlock);
		textBlock.appendAsWrappedLines();
	}

	public void appendTextBlock(String text, int color) {
		TextBlock textBlock = new TextBlock(text, color);
		textBlocks.add(textBlock);
		textBlock.appendAsWrappedLines();
	}

	private void updateWrappedLines() {
		textLines = new ArrayList<TextLine>();
		for (TextBlock block : textBlocks) {
			block.appendAsWrappedLines();
		}
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
		updateTextAreaGraphics();
		updateScrollBarGraphics();
	}

	private void updateTextAreaGraphics() {
		pg.beginDraw();
		pg.pushStyle();
		if (isFocused) {
			pg.fill(bgPressedColor);
			pg.stroke(50);
			pg.strokeWeight(3f);
		} else {
			pg.fill(bgPassiveColor);
			pg.stroke(0, 50, 0);
			pg.strokeWeight(1f);
		}
		pg.rect(0, 0, w, h, r1, r2, r3, r4);

		int consoleEndLine = PApplet.min(textLines.size() - 1, startLine + getMaxLinesToDisplay());
		for (int i = 0; i <= consoleEndLine - startLine; i++) {
			TextLine line = textLines.get(i + startLine);
			pg.fill(line.textColor);
			pg.textAlign(LEFT, BOTTOM);
			pg.textSize(this.textSize);
			pg.text(line.content, padding, (int) (padding * 0.5) + (i + 1) * getTextHeight());
			if (line.isHead) {
				pg.strokeWeight(3);
				pg.point(padding - 5, (int) (padding * 0.5 + (i + 1) * getTextHeight() - getTextHeight() * 0.5));
			}
		}

		pg.popStyle();
		pg.endDraw();
	}

	private void updateScrollBarGraphics() {

	}

	public void processMouseWheel(MouseEvent me) {
		mouseScrolled(me.getCount());
	}

	public void processMousePressed() {
		if (pa.mouseX > posx && pa.mouseX < posx + w
				&& pa.mouseY > posy && pa.mouseY < posy + h) {
			isFocused = true;
		} else {
			isFocused = false;
		}

	}

	public void mouseScrolled(int mouseWheelDelta) {
		if (isFocused) {
			if (mouseWheelDelta < 0) {
				if (startLine > 0) {
					decrementStartLine();
				}
			} else if (mouseWheelDelta > 0) {
				if (startLine < textLines.size() - getMaxLinesToDisplay()) {
					incrementStartLine();
				}
			}
		}
	}

	public void incrementStartLine() {
		if (startLine < textLines.size() - getMaxLinesToDisplay()) {
			startLine++;
		}
	}

	public void decrementStartLine() {
		if (startLine > 0) {
			startLine--;
		}
	}

	public ArrayList<TextLine> getTextLines() {
		return textLines;
	}

	public ArrayList<TextBlock> getTextBlocks() {
		return textBlocks;
	}

	public float getTextSize() {
		return textSize;
	}

	public float getPadding() {
		return padding;
	}

	public void setPadding(float padding) {
		this.padding = padding;
		updateWrappedLines();
	}

	public void setTextSize(float textSize) {
		this.textSize = textSize;
		updateWrappedLines();
	}

	public int getMaxLinesToDisplay() {
		return (int) ((h - padding - padding) / getTextHeight()) + 1;
	}

	private float getTextHeight() {
		pa.textSize(textSize);
		return pa.textAscent() + pa.textDescent();
	}

	public int getStartLine() {
		return startLine;
	}

	public void setStartLine(int startLine) {
		this.startLine = startLine;
	}

	private class TextLine {
		public String	content;
		public int		textColor	= pa.color(0, 10, 30);
		public boolean	isHead;

		@SuppressWarnings("unused") public TextLine(String content, boolean isHead) {
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
		private String			content;
		private StringBuilder	sb;
		private boolean			isHeadAlreadyMarked;
		private int				textColor	= pa.color(0);

		public TextBlock(String content) {
			this.content = content;
		}

		public TextBlock(String content, int textColor) {
			this.content = content;
			this.textColor = textColor;
		}

		public void appendAsWrappedLines() {
			// reset the flag and 'sb' after previous call to this method 
			// in order to allow correct head marking in case the padding 
			// or text size will change
			isHeadAlreadyMarked = false;
			sb = new StringBuilder();
			// calculate the wrapped width of the line as it will be shown
			int wrappedWidth = (int) (w - padding - padding);
			// update the PApplet's textSize value in order to accurately
			// calculate text width
			pa.textSize(textSize);
			// go through all the characters in the text block splitting it
			// by text chunks which has the width equals to the 'paddedWidth' 
			for (int i = 0; i < content.length(); i++) {
				int chunkWidth = (int) (pa.textWidth(sb.toString()));
				if (chunkWidth > wrappedWidth) {
					addWrappedLine();
					sb = new StringBuilder();
				}
				sb.append(content.charAt(i));
			}
			addWrappedLine();
		}

		private void addWrappedLine() {
			if (!isHeadAlreadyMarked) {
				textLines.add(new TextLine(sb.toString(), textColor, true)); // add last line
				isHeadAlreadyMarked = true;
			} else {
				textLines.add(new TextLine(sb.toString(), textColor, false)); // add last line
			}
		}
	}
}
