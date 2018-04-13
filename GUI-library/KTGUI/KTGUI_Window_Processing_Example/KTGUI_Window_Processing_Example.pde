KTGUI ktgui;
Button btn, defaultStateBtn, nextStateBtn;
Window w1, w2, w3;
State s1, s2;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(600, 400);
  ktgui = new KTGUI(this); // default state is automatically created

  defaultStateBtn = ktgui.createButton(50, 50, 100, 50);
  defaultStateBtn.setTitle("DefaultState");

  defaultStateBtn.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The DefaultButton was pressed!");
      ktgui.stateManager.goToState(1);
    }  
    public void onMouseReleased() {
      println("Callback message: The DefaultButton was released!");
    }
  }
  );
  
  // Now, the "s1" state is "active"
  s1 = ktgui.stateManager.createState("state_1");


  nextStateBtn = ktgui.createButton(110, 110, 100, 50);
  nextStateBtn.setTitle("Next state");
  nextStateBtn.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      ktgui.stateManager.goToState(s2);
    }
  }
  );

  w1 = ktgui.createWindow(10, 10, 300, 200);
  w1.attachController(nextStateBtn);
  s1.attachController(w1);

  // Now, the "s2" state is "active"
  s2 = ktgui.stateManager.createState("state_2");


  btn = ktgui.createButton(50, 50, 100, 50);
  btn.setTitle("A button");

  btn.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Button was pressed!");
      ktgui.stateManager.goToNextState();
    }  
    public void onMouseReleased() {
      println("Callback message: The Button was released!");
    }
  }
  );
  
  w2 = ktgui.createWindow(10, 10, 300, 200);
  w3 = ktgui.createWindow(50, 50, 300, 200);
  w3.attachController(btn);
  s2.attachController(w2);
  s2.attachController(w3);

  ktgui.stateManager.goToState(s1);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw() {
  background(170, 220, 170);
  //
  surface.setTitle(ktgui.stateManager.activeState.name + ": " + mouseX + ":" + mouseY);
}

void keyPressed(){
  ktgui.stateManager.goToNextState();
}
