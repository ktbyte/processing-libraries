import ktgui.*;
import java.util.*;

KTGUI ktgui;
Pane pane;
VerticalScrollBar vsbar;

void setup() {
  size(1200, 600);
  ktgui = new KTGUI(this);
  ktgui.setDebug(true);

  pane = new Pane(ktgui, "aPane", 600, 200, 500, 200);
  pane.setBorderRoundings(10, 10, 10, 10);
  pane.isDragable = true;

  vsbar = new VerticalScrollBar(ktgui, "sBar", 20, 200, 30, 200);
  vsbar.setBorderRoundings(0, 10, 10, 0);
}

void draw() {
  background(220);
}

