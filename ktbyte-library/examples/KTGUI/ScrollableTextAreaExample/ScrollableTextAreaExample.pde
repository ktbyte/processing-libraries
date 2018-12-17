
import ktbyte.gui.*;

KTGUI ktgui;
ScrollableTextArea sta;

void setup() {
	size(400, 300);
	ktgui = new KTGUI(this);

	sta = new ScrollableTextArea(ktgui, "STA", 20, 20, 300, 150);
	sta.setBorderRoundings(15, 0, 15, 0);
	sta.setPadding(20);
	sta.setTextSize(14);
	sta.alignAboutCanvas(CENTER, CENTER);
	sta.appendTextBlock("A first line.", color(20, 20, 200));
	sta.appendTextBlock("A HashMap: ", color(200, 20, 20));
	sta.appendTextBlock("stores a collection of objects, each referenced by a key."
				+ " This is similar to an Array, only instead of accessing elements with "
				+ "a numeric index, a String is used. (If you are familiar with associative "
				+ "arrays from other languages, this is the same idea.) The above example "
				+ "covers basic use, but there's a more extensive example included with the "
				+ "Processing examples. In addition, for simple pairings of Strings and "
				+ "integers, Strings and floats, or Strings and Strings, you can now use the "
				+ "simpler IntDict, FloatDict, and StringDict classes.");
	sta.appendTextBlock("A third line.", color(50, 150, 0));

}

void draw() {
	background(240);
	textAlign(CENTER, BOTTOM);
	textSize(16);
	fill(0);
	text("Click on text area to make it active.", width * 0.5, 30);
	text("Use mouse wheel or '+'/'-' keys.", width * 0.5, 50);
}

void keyPressed() {
	if(key == '+') {
		sta.incrementStartLine();
	}
	if(key == '-') {
		sta.decrementStartLine();
	}
}
