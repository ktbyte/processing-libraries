KTGUI ktgui;
Button btn;
Window window;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup(){
  size(600, 400);
	ktgui = new KTGUI(this);
	btn = ktgui.createButton(50, 50, 100, 50);
	
	btn.addEventAdapters(new KTGUIEventAdapter() {
	  public void onMousePressed() {
			println("Callback message: The Button was pressed!");
		}	
    public void onMouseReleased() {
      println("Callback message: The Button was released!");
    }  
	});

  window = ktgui.createWindow(10, 10, 300, 200);
  window.attachController(btn);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw(){
  background(170, 220, 170);
  //
  surface.setTitle(mouseX + ":" + mouseY);
}
