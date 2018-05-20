import ktgui.*;

KTGUI ktgui;
Button button, changeStateButton;
int counter = 0;

/***************************************************************************************************
 * 
 ***************************************************************************************************/
void setup() {
  size(400, 300);
  
  textFont(createFont("monospaced", 14));

  ktgui = new KTGUI(this);

  button = ktgui.createButton("A Button", 10, 10, 150, 60);
  button.alignAboutApplet(LEFT, CENTER);
  button.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("The Button is pressed!");
      counter++;
      button.setTitle(str(counter));
    }
    public void onMouseReleased() {
      println("The Button is released!");
    }
  }
  );

  changeStateButton = ktgui.createButton("isDragable", 0, 0, 150, 60);
  changeStateButton.alignAboutApplet(LEFT, BOTTOM);
  changeStateButton.isDragable = false;
  changeStateButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      button.isDragable = !button.isDragable;
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
  text("Try to drag the button.", 20, 90);
  popStyle();
}