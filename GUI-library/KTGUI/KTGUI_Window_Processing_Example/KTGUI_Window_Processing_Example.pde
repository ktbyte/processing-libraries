KTGUI ktgui;
Button btn, nextStateBtn;
Window w1, w2, w3;
State s1, s2;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(600, 400);
  ktgui = new KTGUI(this);
  s1 = ktgui.createState("state_1");
  s2 = ktgui.createState("state_2");

  btn = ktgui.createButton(s1, 50, 50, 100, 50);
  btn.setTitle("Click counter");

  btn.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      Integer clickCount = (Integer) s1.getFromContext("click_count");
      s1.addToContext("click_count", ++clickCount);
      println("Callback message: The Button was pressed!");
    }	
    public void onMouseReleased() {
      println("Callback message: The Button was released!");
    }
  }
  );

  nextStateBtn = ktgui.createButton(s1, 110, 110, 100, 50);
  nextStateBtn.setTitle("Next state");
  nextStateBtn.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Next state button was pressed: number of clicks: " + s1.getFromContext("click_count"));
      ktgui.makeStateActive(s2);
    }
  }
  );

  s1.addToContext("click_count", 0);
  w1 = ktgui.createWindow(s1, 10, 10, 300, 200);
  w1.attachController(btn);
  w1.attachController(nextStateBtn);
  s1.attachController(w1);

  w2 = ktgui.createWindow(s2, 10, 10, 300, 200);
  w3 = ktgui.createWindow(s2, 50, 50, 300, 200);
  s2.attachController(w2);
  s2.attachController(w3);

  ktgui.makeStateActive(s1);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw() {
  background(170, 220, 170);
  //
  surface.setTitle(ktgui.activeState.name + ": " + mouseX + ":" + mouseY);
}