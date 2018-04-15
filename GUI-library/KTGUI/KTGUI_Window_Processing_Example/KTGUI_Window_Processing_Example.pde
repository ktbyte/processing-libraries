KTGUI ktgui;
Button jumpButton, anotherButton, nextStateBtn;
Window w1, w2, w3;
State s1, s2;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(600, 500);
  ktgui = new KTGUI(this); // default state is automatically created

  anotherButton = ktgui.createButton(50, 50, 100, 50);
  anotherButton.setTitle("Go To\nState1");
  anotherButton.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The DefaultButton was pressed!");
      ktgui.stateManager.goToState(1);
    }  
  }
  );
  
  // Now, the "s1" state is "active". So, the both 'w1' and 'nextStateButton' are automatically attached to this state. 
  // We can still use 's1.attachController(Controller) though.
  s1 = ktgui.stateManager.createState("state_1");
  w1 = ktgui.createWindow(10, 10, 300, 200);
  nextStateBtn = ktgui.createButton(width - 120, height - 70, 100, 50);
  nextStateBtn.setTitle("NextState");
  nextStateBtn.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Nex-State-Button was pressed!");
      ktgui.stateManager.goToNextState();
      ktgui.stateManager.activeState.attachController(nextStateBtn);
    }
  }
  );


  // Now, the "s2" state is "active". So, the jumpButton is automatically attached to this state.
  // We can use 's2.attachController(Controller) though.
  s2 = ktgui.stateManager.createState("state_2");
  jumpButton = ktgui.createButton(50, 50, 100, 50);
  jumpButton.setTitle("Jump!");
  jumpButton.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Jumping Button was pressed!");
      if(jumpButton.parentWindow == w3){
        w2.attachController(jumpButton);
      }else if(jumpButton.parentWindow == w2){
        w3.attachController(jumpButton);
      }
    }  
  }
  );
  
  // The "s2" state is still "active". So, the both windows are automatically attached to this state.
  // We can still use 's2.attachController(Controller) though.
  w2 = ktgui.createWindow(10, 10, 300, 200);
  w3 = ktgui.createWindow(50, 50, 300, 200);
  w3.attachController(jumpButton);

  ktgui.stateManager.goToState(s1);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw() {
  background(170, 220, 170);
  //
  fill(0);
  textSize(20);
  textAlign(RIGHT, CENTER);
  text(ktgui.stateManager.activeState.name, width - 10, 10);
}

void keyPressed(){
  ktgui.stateManager.goToNextState();
}
