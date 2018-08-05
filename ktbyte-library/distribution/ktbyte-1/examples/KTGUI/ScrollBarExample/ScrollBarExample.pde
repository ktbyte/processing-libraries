import ktgui.*;
import java.util.*;

KTGUI ktgui;
Pane pane;
ScrollBar hsbar, vsbar;
Button dbgBtn;

void setup() {
  size(1000, 600);
  ktgui = new KTGUI(this);
  ktgui.setDebug(true);

  pane = new Pane(ktgui, "aPane", 0, 0, 500, 300);
  pane.setBorderRoundings(10, 10, 10, 10);
  pane.isDragable = false;
  pane.alignAboutCanvas(CENTER, CENTER);

  hsbar = new ScrollBar(ktgui, "hsBar", 20, 200, 200, 40);
  hsbar.setBorderRoundings(10, 10, 10, 10);
  
  vsbar = new ScrollBar(ktgui, "vsBar", 20, 200, 40, 200);
  vsbar.setBorderRoundings(10, 10, 10, 10);

  pane.addController(hsbar, LEFT, TOP, 10);
  pane.addController(vsbar, RIGHT, BOTTOM, 10);

  dbgBtn = new Button(ktgui, "Debug", 0, 0, 100, 40);
  dbgBtn.alignAboutCanvas(CENTER, BOTTOM);
  dbgBtn.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      ktgui.setDebug(!ktgui.getDebug());
    }
  });

}

void draw() {
  background(220); 
}

