import ktgui.*;

KTGUI ktgui;
Button button;
int counter = 0;
/***************************************************************************************************
 * 
 ***************************************************************************************************/
void setup() {
  size(400, 300);

  ktgui = new KTGUI(this);

  button = ktgui.createButton("A new Button", 10, 10, 150, 60);
  button.alignAboutApplet(LEFT, CENTER);
  button.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("The Button is pressed!");
      button.setTitle("Pressed");
      counter++;
    }
    public void onMouseReleased() {
      println("The Button is released!");
      button.setTitle("Released");
    }
    public void onMouseMoved() {
      println("Moved:" + millis());
      if (button.isHovered) {
        button.setTitle("Hovered");
      }
    }
  }
  );

  textSize(64);
  textAlign(RIGHT, CENTER);
}

/***************************************************************************************************
 *
 ***************************************************************************************************/
void draw() {
  background(220);
  
  fill(100, 50, 150);
  text(counter, width * 0.95, height * 0.75);
  text(str(button.isHovered), width * 0.95, height * 0.25);
 
  if (!button.isHovered) {
    button.setTitle("A new Button");
  }
}
