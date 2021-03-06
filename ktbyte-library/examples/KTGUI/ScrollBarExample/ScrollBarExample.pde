import ktbyte.gui.*;
import java.util.*;

KTGUI ktgui;
Pane pane;
ScrollBar hsbar, vsbar;
Button dbgBtn;

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
void setup() {
  size(1000, 600);
  ktgui = new KTGUI(this);

  pane = ktgui.createPane(0, 0, 500, 300);
  pane.setBorderRoundings(10, 10, 10, 10);
  pane.isDragable = true;
  pane.alignAboutCanvas(CENTER, CENTER);

  hsbar = ktgui.createScrollBar("hsBar", 20, 200, 200, 40, 0, 200);
  hsbar.setBorderRoundings(10, 10, 10, 10);
  hsbar.setHandleType(Slider.HANDLE_TYPE_CENTERED);
  hsbar.setIsValueVisible(true);
  
  vsbar = ktgui.createScrollBar("vsBar", 20, 200, 40, 200, 0, 10);
  vsbar.setBorderRoundings(10, 10, 10, 10);
  vsbar.setIsValueVisible(true);
  vsbar.addEventAdapter(new EventAdapter(){
    public void onMousePressed(){
      hsbar.setHandleStep(vsbar.getValue());
      println(str(hsbar.getHandleStep()));
    }
    public void onMouseDragged(){
      hsbar.setHandleStep(vsbar.getValue());
      println(str(hsbar.getHandleStep()));
    }
  });

  pane.addController(hsbar, LEFT, TOP, 10);
  pane.addController(vsbar, RIGHT, BOTTOM, 10);

  dbgBtn = ktgui.createButton("Debug", 0, 0, 100, 40);
  dbgBtn.alignAboutCanvas(CENTER, BOTTOM);
  dbgBtn.addEventAdapter(new EventAdapter() {
    public void onMousePressed() {
    }
  });

}

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
void draw() {
  background(220); 
}

