package ktgui;

import java.util.ArrayList;

import processing.core.PApplet;

public class ScrollableTextArea extends Controller {
	private final static int	SCROLL_BAR_WIDTH	= 20;
	private final static int	BOX_ROUNDING		= 8;

	private int					r1, r2, r3, r4;

	private float				textSize			= 14;
	//private float				padding;
	public float				padding;

	public ArrayList<Line>		textLines;
	//	private ArrayList<Line>		textLines;
	public int					startLine			= 0;
	//	private int					startLine			= 0;
	//	private int					endLine;

	public ScrollableTextArea(KTGUI ktgui, String title, int x, int y, int w, int h) {
		super(ktgui);

		this.title = title;
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;

		padding = 8;

		textLines = new ArrayList<>();
		addTextBlock("A first line.");
		addTextBlock("A HashMap stores a collection of objects, each referenced by a key."
				+ " This is similar to an Array, only instead of accessing elements with "
				+ "a numeric index, a String is used. (If you are familiar with associative "
				+ "arrays from other languages, this is the same idea.) The above example "
				+ "covers basic use, but there's a more extensive example included with the "
				+ "Processing examples. In addition, for simple pairings of Strings and "
				+ "integers, Strings and floats, or Strings and Strings, you can now use the "
				+ "simpler IntDict, FloatDict, and StringDict classes.");
		addTextBlock("A third line.");

		System.out.println("textLines.size():" + textLines.size());
		System.out.println("getMaxLinesToDisplay():" + getMaxLinesToDisplay());
		System.out.println("getTextHeight():" + getTextHeight());

		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);

		StageManager.getInstance().getDefaultStage().registerController(this);
	}

	private void addTextBlock(String string) {
		StringBuilder sb = new StringBuilder();

		boolean isHeadAlreadyMarked = false;
		// go through all the characters in the text block splitting it by text
		// chunks which has the width equals to the textarea.width - padding - padding 
		for (int i = 0; i < string.length(); i++) {
			if (pa.textWidth(sb.toString()) > (w - 2 * padding)) {
				if (!isHeadAlreadyMarked) {
					textLines.add(new Line(sb.toString(), true)); // add last line
					isHeadAlreadyMarked = true;
				} else {
					textLines.add(new Line(sb.toString(), false)); // add last line
				}
				sb = new StringBuilder();
			}
			sb.append(string.charAt(i));
		}
		if (!isHeadAlreadyMarked) {
			textLines.add(new Line(sb.toString(), true)); // add last line
			isHeadAlreadyMarked = true;
		} else {
			textLines.add(new Line(sb.toString(), false)); // add last line
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
		pg.fill(255, 100);
		pg.stroke(100, 100, 0);
		pg.rect(0, 0, w, h, r1, r2, r3, r4);

		int consoleEndLine = PApplet.min(textLines.size() - 1, startLine + getMaxLinesToDisplay());
		for (int i = 0; i <= consoleEndLine - startLine; i++) {
			Line line = textLines.get(i + startLine);
			pg.fill(line.textColor);
			pg.textAlign(LEFT, BOTTOM);
			pg.text(line.text, padding, (int) (padding * 0.5) + (i + 1) * getTextHeight());
			if (line.isHead) {
				pg.strokeWeight(2);
				pg.point(padding - 5, (int) (padding * 0.5 + (i + 1) * getTextHeight() - getTextHeight() * 0.5));
			}
		}

		pg.popStyle();
		pg.endDraw();
	}

	private int getMaxLinesToDisplay() {
		return (int) ((h - padding - padding) / getTextHeight() + 1);
	}

	private float getTextHeight() {
		pa.textSize(textSize);
		return pa.textAscent() + pa.textDescent();
	}

	public void setStartLine(int startLine) {
		this.startLine = startLine;
	}

	private void updateScrollBarGraphics() {

	}

	/**
	 * Sets the rounding of the rectangle's border. The parameters should be entered in a clockwise order
	 * 
	 * @param r1
	 * 	Upper Left
	 * @param r2
	 * 	Upper Right
	 * @param r3
	 * 	Bottom Right
	 * @param r4
	 * 	Bottome Left
	 */
	public void setBorderRoundings(int r1, int r2, int r3, int r4) {
		this.r1 = r1;
		this.r2 = r2;
		this.r3 = r3;
		this.r4 = r4;
	}

	private class Line {
		public String	text;
		public int		textColor	= pa.color(0, 10, 30);
		public boolean	isHead;

		public Line() {
			this.text = "";
		}

		public Line(String string) {
			this.text = string;
		}

		public Line(String string, boolean isHead) {
			this.text = string;
			this.isHead = isHead;
		}

		public void setText(String text) {
			this.text = text;
		}

		public void setTextColor(int textColor) {
			this.textColor = textColor;
		}
	}
}
