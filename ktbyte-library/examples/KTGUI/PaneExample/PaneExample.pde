import ktbyte.gui.*;
import java.util.*;

KTGUI ktgui;
Pane pane1, pane2;
ScrollBar hsbar, vsbar;
Button dbgBtn;
float p1y, p2x;

void setup() {
  size(1000, 500);
  ktgui = new KTGUI(this);

  pane1 = ktgui.createPane(0, 0, 300, 300);
  pane1.setBorderRoundings(10, 10, 10, 10);
  pane1.isDragable = true;
  pane1.alignAboutCanvas(LEFT, CENTER, 60);
  p1y = pane1.getPosy();

  pane2 = ktgui.createPane(0, 0, 300, 300);
  pane2.setBorderRoundings(10, 10, 10, 10);
  pane2.isDragable = true;
  pane2.alignAboutCanvas(RIGHT, CENTER, 60);
  p2x = pane2.getPosx();

  hsbar = ktgui.createScrollBar("hsBar", 20, 200, 200, 40, 0, 100);
  hsbar.setValue(50);
  hsbar.setBorderRoundings(10, 10, 10, 10);
  hsbar.setHandleType(Slider.HANDLE_TYPE_CENTERED);
  hsbar.setIsValueVisible(true);
  hsbar.addEventAdapter(new EventAdapter(){
    public void onMouseDragged(){
      pane2.setPosx((int) (p2x + hsbar.getValue() - (hsbar.getRangeStart() + hsbar.getRangeEnd()) * 0.5f));
    }
  });
  
  vsbar = ktgui.createScrollBar("vsBar", 20, 200, 40, 200, 0, 100);
  vsbar.setValue(50);
  vsbar.setBorderRoundings(10, 10, 10, 10);
  vsbar.setIsValueVisible(true);
  vsbar.addEventAdapter(new EventAdapter(){
    public void onMouseDragged(){
      pane1.setPosy((int) (p1y + vsbar.getValue() - (vsbar.getRangeStart() + vsbar.getRangeEnd()) * 0.5f));
    }
  });

  pane1.addController(hsbar, CENTER, CENTER);
  pane2.addController(vsbar, CENTER, CENTER);

  dbgBtn = ktgui.createButton("Debug", 0, 0, 100, 40);
  dbgBtn.alignAboutCanvas(CENTER, BOTTOM);
  dbgBtn.addEventAdapter(new EventAdapter() {
    public void onMousePressed() {

    }
  });

}

void draw() {
  background(220); 
}

void keyPressed() {
  pane1.posx = 400;
}