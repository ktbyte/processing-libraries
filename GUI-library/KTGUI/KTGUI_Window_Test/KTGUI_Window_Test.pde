KTGUI ktgui;
Button btn;
Window window;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup(){
  size(600, 400);
	ktgui = new KTGUI(this);
	btn = ktgui.createButton(width/2 - 75, 50, 150, 40);
	
	btn.addEventAdapters(new KTGUIEventAdapter() {
	  public void onMousePressed() {
			println("Callback message: The Button was pressed!");
		}	
	});

  window = new Window(0, 0, 300, 200);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw(){
  background(220);
}
