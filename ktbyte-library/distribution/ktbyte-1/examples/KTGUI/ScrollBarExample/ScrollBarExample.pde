import ktgui.*;
import java.util.*;

KTGUI ktgui;
Pane pane;

void setup() {
  size(1200, 600);
  ktgui = new KTGUI(this);
  ktgui.setDebug(true);

  pane = new Pane(ktgui, "aPane", 600, 200, 500, 200);
  pane.setBorderRoundings(5, 5, 5, 5);
  pane.isDragable = true;

}

void draw() {
  background(220);
}

