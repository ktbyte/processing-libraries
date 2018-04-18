import java.util.*;

KTGUI ktgui;
Button jumpButton, anotherButton, nextStageBtn;
Window w1, w2, w3;
Stage s1, s2, s3;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(800, 500);
  ktgui = new KTGUI(this); // default stage is automatically created

  // this button will be visible always because it will be located on default stage
  nextStageBtn = ktgui.createButton(width - 120, height - 70, 100, 50);
  nextStageBtn.setTitle("NextStage");
  nextStageBtn.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Next-Stage-Button was pressed!");
      ktgui.stageManager.goToNextStage();
    }
  }
  );

  s1 = ktgui.stageManager.createStage("stage_1");
  anotherButton = ktgui.createButton(50, 50, 100, 50);
  anotherButton.setTitle("Go To\nStage_2");
  anotherButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The anotherButton (goToStage(1)) was pressed!");
      ktgui.stageManager.goToStage(2);
    }  
  }
  );
  s1.registerController(anotherButton);
  
  // Now, the "s1" stage is "active". So, the both 'w1' and 'nextStageButton' are automatically attached to this stage. 
  // We can still use 's1.attachController(Controller) though.
  s2 = ktgui.stageManager.createStage("stage_2");
  Panel panel = ktgui.createPanel((int)(width * 0.5 - 200), 20, 400, 100);  
  s2.registerController(panel);


  // Now, the "s2" stage is "active". So, the jumpButton is automatically attached to this stage.
  // We can use 's2.attachController(Controller) though.
  s3 = ktgui.stageManager.createStage("stage_3");
  jumpButton = ktgui.createButton(50, 50, 100, 50);
  jumpButton.setTitle("Jump!");
  jumpButton.addEventAdapter(new KTGUIEventAdapter() {
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
  s3.registerController(jumpButton);
  
  // The "s2" stage is still "active". So, the both windows are automatically attached to this stage.
  // We can still use 's2.attachController(Controller) though.
  w2 = ktgui.createWindow(110, 110, 300, 200);
  w2.setTitle("Window_2");
  s3.registerController(w2);
  
  w3 = ktgui.createWindow(10, 230, 300, 200);
  w3.setTitle("Window_3");
  w3.attachController(jumpButton);
  s3.registerController(w3);
  
  // this button will be visible in all stages
  ktgui.stageManager.defaultStage.registerController(nextStageBtn);

  ktgui.stageManager.goToStage(s3);
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
  textFont(createFont("monospaced", 16));
  text("activeStage.name:" + ktgui.stageManager.activeStage.name, width - 10, 10);
  text("activeStage.index:" + ktgui.stageManager.stages.indexOf(ktgui.stageManager.activeStage), width - 10, 30);
  text("size():" + ktgui.stageManager.stages.size(), width - 10, 50);
}

void keyPressed(){
  ktgui.stageManager.goToNextStage();
}
