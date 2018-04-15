import java.util.*;

KTGUI ktgui;
Button jumpButton, anotherButton, nextStateBtn;
Window w1, w2, w3;
State s1, s2, s3;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(600, 500);
  ktgui = new KTGUI(this); // default state is automatically created

  s1 = ktgui.stateManager.createState("state_1");
  anotherButton = ktgui.createButton(50, 50, 100, 50);
  anotherButton.setTitle("Go To\nState_2");
  anotherButton.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The anotherButton (goToState(1)) was pressed!");
      ktgui.stateManager.goToState(2);
    }  
  }
  );
  s1.attachController(anotherButton);
  
  // Now, the "s1" state is "active". So, the both 'w1' and 'nextStateButton' are automatically attached to this state. 
  // We can still use 's1.attachController(Controller) though.
  s2 = ktgui.stateManager.createState("state_2");
  w1 = ktgui.createWindow(10, 10, 300, 200);
  w1.setTitle("Window_1");
  nextStateBtn = ktgui.createButton(width - 120, height - 70, 100, 50);
  nextStateBtn.setTitle("NextState");
  nextStateBtn.addEventAdapters(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Next-State-Button was pressed!");
      ktgui.stateManager.goToNextState();
    }
  }
  );
  s2.attachController(w1);


  // Now, the "s2" state is "active". So, the jumpButton is automatically attached to this state.
  // We can use 's2.attachController(Controller) though.
  s3 = ktgui.stateManager.createState("state_3");
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
  s3.attachController(jumpButton);
  
  // The "s2" state is still "active". So, the both windows are automatically attached to this state.
  // We can still use 's2.attachController(Controller) though.
  w2 = ktgui.createWindow(10, 10, 300, 200);
  w2.setTitle("Window_2");
  s3.attachController(w2);
  
  w3 = ktgui.createWindow(10, 230, 300, 200);
  w3.setTitle("Window_3");
  w3.attachController(jumpButton);
  s3.attachController(w3);
  
  s1.attachController(nextStateBtn);
  s2.attachController(nextStateBtn);
  s3.attachController(nextStateBtn);

  ktgui.stateManager.goToState(s3);
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
  text("activeState.name:" + ktgui.stateManager.activeState.name, width - 10, 10);
  text("activeState.index:" + ktgui.stateManager.states.indexOf(ktgui.stateManager.activeState), width - 10, 30);
  text("size():" + ktgui.stateManager.states.size(), width - 10, 50);
}

void keyPressed(){
  ktgui.stateManager.goToNextState();
}
