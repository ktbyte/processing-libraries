import ktgui.*;

KTGUI ktgui;
Button jumpButton;
Window w1, w2;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(800, 500);
  
  ktgui = new KTGUI(this); // default stage is automatically created
  ktgui.setDebug(true);
  // jumpButton = ktgui.createButton("Jump!", 50, 50, 100, 50);
  // jumpButton.addEventAdapter(new KTGUIEventAdapter() {
  //   public void onMousePressed() {
  //     if (jumpButton.parentController == w2.getPane()) {
  //       w1.addController(jumpButton, 0, TOP);
  //     } else if (jumpButton.parentController == w1.getPane()) {
  //       w2.addController(jumpButton, 0, BOTTOM);
  //     }
  //   }
  // }
  // );

  w1 = ktgui.createWindow("Window_1", 10, 220, 300, 200);
  w1.alignAboutCanvas(LEFT, BOTTOM);

  w2 = ktgui.createWindow("Window_2", 400, 220, 300, 200);
  w2.stackAbout(w1, TOP, CENTER);
  //w2.addController(jumpButton, CENTER, CENTER);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw() {
  background(170, 220, 170);
}
