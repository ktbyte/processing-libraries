import ktbyte.gui.*;

KTGUI ktgui;
Button button, changeStateButton;
int counter = 0;
String txt = "Try to drag the button.";

/***************************************************************************************************
 * 
 ***************************************************************************************************/
void setup() {
  size(400, 300);
  
  textFont(createFont("monospaced", 14));

  ktgui = new KTGUI(this);

  button = ktgui.createButton("A Button", 10, 10, 150, 60);
  button.alignAboutCanvas(LEFT, CENTER);
  button.setPassiveColor(color(200, 100, 150));
  button.setHoveredColor(color(100, 150, 200));
  button.setPressedColor(color(100, 100, 150));
  button.addEventAdapter(new EventAdapter() {
    public void onMousePressed() {
      println("The Button is pressed!");
      counter++;
      button.setTitle(str(counter));
      txt = "Press `isDragable` button";
    }
    public void onMouseReleased() {
      println("The Button is released!");
    }
  }
  );

  changeStateButton = ktgui.createButton("isDragable", 0, 0, 150, 60);
  changeStateButton.alignAboutCanvas(LEFT, BOTTOM);
  changeStateButton.isDragable = false;
  changeStateButton.addEventAdapter(new EventAdapter() {
    public void onMousePressed() {
      println("The changeStateButton is pressed!");
      button.isDragable = !button.isDragable;
      txt = "Try to drag again";
      button.setPassiveColor( button.isDragable ? color(50, 200, 50) : color(200, 100, 150) );
    }
  });
}

/***************************************************************************************************
 *
 ***************************************************************************************************/
void draw() {
  background(220);
  drawDebugInfo();
}

//-----------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------
void drawDebugInfo(){
  pushStyle();
  fill(0);
  textAlign(LEFT);
  textSize(14);
  text(mouseX + ", " + mouseY, 20, 20);
  text("btn.isDragable:" + str(button.isDragable), 20, 35);
  text("btn.isHovered :" + str(button.isHovered), 20, 50);
  text("btn.isPressed :" + str(button.isPressed), 20, 65);
  textSize(24);
  text(txt, 20, 90);
  popStyle();
}