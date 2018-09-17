import ktgui.*;
import java.util.*;

KTGUI ktgui;
TitleBar titleBar;
Pane pane;
Window window;
PGraphics ug;
ScrollableTextArea sta;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(1200, 600);
  KTGUI.setDebugControllersFlag(true);
  ktgui = new KTGUI(this);

  window = new Window(ktgui, "aWindow", 10, 50, 500, 400);
  window.alignAboutCanvas(CENTER, BOTTOM, 20);

  Button debugButton = new Button(ktgui, "Debug On/Off", 200, 200, 120, 30);
  debugButton.setBorderRoundings(5, 5, 5, 5);
  debugButton.addEventAdapter(new KTGUIEventAdapter(){
    public void onMousePressed(){
      println("Button has been pressed!");
      ktgui.setDebugControllersFlag(ktgui.getDebugControllersFlag() ? false : true);
    }
  });

  Window otherWindow = new Window(ktgui, "otherWindow", 10, 50, 400, 300);
  window.addController(otherWindow, CENTER, TOP, 20);
  otherWindow.addController(debugButton, LEFT, TOP, 10);

	sta = new ScrollableTextArea(ktgui, "STA", 20, 20, 300, 150);
	sta.setBorderRoundings(15, 0, 0, 0);
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

  otherWindow.addController(sta, RIGHT, BOTTOM, 0);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw() {
  background(220);
}

