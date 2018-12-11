import java.util.*;
import ktbyte.gui.*;

KTGUI ktgui;
Button btn;
Slider slider, otherSlider;
Pane pane;
float textPosition;

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
void setup() {
  size(600, 500);

  textSize(10);

  // instance of the KTGUI class
  ktgui = new KTGUI(this);

  // create Slider component with CENTERED handle
  slider = ktgui.createSlider(0, 0, 200, 30, 0, 1000);
  slider.alignAboutCanvas(CENTER, CENTER, 0);
  slider.setTitle("The Slider");
  slider.setHandleType(Slider.HANDLE_TYPE_CENTERED);
  slider.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      textPosition = map(slider.getValue(), slider.getRangeStart(), slider.getRangeEnd(), 0, pane.w);
    }
    public void onMouseDragged() {
      textPosition = map(slider.getValue(), slider.getRangeStart(), slider.getRangeEnd(), 0, pane.w);
    }
  });

  // create Slider component that controls the handle width
  // of the first slider
  otherSlider = ktgui.createSlider(0, 0, 200, 30, 10, 200);
  otherSlider.addEventAdapter(new KTGUIEventAdapter() {
    public void onMouseDragged() {
      slider.setHandleSize((int) otherSlider.getValue());
    }
    public void onMousePressed() {
      slider.setHandleSize((int) otherSlider.getValue());
    }
  });

  // create Pane components that will hold both sliders
  pane = ktgui.createPane("A Pane", 0, 0, 400, 400);
  pane.isDragable = true;
  pane.alignAboutCanvas(CENTER, CENTER);
  pane.addController(otherSlider, CENTER, TOP, 10);
  pane.addController(slider, CENTER, CENTER, 0);


}


/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
void draw() {
  background(100, 20, 255);
  drawDebugInfo();
  updateTextPosition();
}


void updateTextPosition() {
  PGraphics g = createGraphics(pane.w, pane.h);
  g.beginDraw();
  g.textAlign(CENTER, CENTER);
  g.textSize(26);
  g.text("Hello!", textPosition, pane.h * 0.75f);
  g.endDraw();
  pane.updateUserDefinedGraphics(g);
}

void drawDebugInfo() {
  textAlign(RIGHT, BOTTOM);
  text("slider.getHandlePos():" + slider.getHandlePos(), width - 10, height - 10);
  text("slider.getHandleSize():" + slider.getHandleSize(), width - 10, height - 20);
  text("slider.getValue():" + slider.getValue(), width - 10, height - 30);
  text("slider.isPressed:" + slider.isPressed, width - 10, height - 40);
  text("slider.isHovered:" + slider.isHovered, width - 10, height - 50);
  text("slider.isDragged:" + slider.isDragged, width - 10, height - 60);
}