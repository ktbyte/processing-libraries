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
  nextStageBtn = ktgui.createButton("NextStage", width - 120, height - 70, 100, 50);
  nextStageBtn.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Next-Stage-Button was pressed!");
      ktgui.stageManager.goToNextStage();
    }
  }
  );
  // this button will be visible in all stages
  ktgui.stageManager.defaultStage.registerController(nextStageBtn);

  s1 = ktgui.stageManager.createStage("stage_1");
  anotherButton = ktgui.createButton("Go To Stage_2", 50, height - 70, 100, 50);
  anotherButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The anotherButton (goToStage(1)) was pressed!");
      ktgui.stageManager.goToStage(1);
    }
  }
  );
  s1.registerController(anotherButton);

  // Now, the "s1" stage is "active". So, the both 'w1' and 'nextStageButton' are automatically attached to this stage. 
  // We can still use 's1.attachController(Controller) though.
  s2 = ktgui.stageManager.createStage("stage_2");
  Pane pane = ktgui.createPane((int)(width * 0.5 - 200), 240, 400, 200);  
  s2.registerController(pane);


  // Now, the "s2" stage is "active". So, the jumpButton is automatically attached to this stage.
  // We can use 's2.attachController(Controller) though.
  s3 = ktgui.stageManager.createStage("stage_3");
  jumpButton = ktgui.createButton("Jump!", 50, 50, 100, 50);
  jumpButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      println("Callback message: The Jumping Button was pressed!");
      if (jumpButton.parentWindow == w3) {
        w2.attachController(jumpButton);
      } else if (jumpButton.parentWindow == w2) {
        w3.attachController(jumpButton);
      }
    }
  }
  );

  // The "s2" stage is still "active". So, the both windows are automatically attached to this stage.
  // We can still use 's2.attachController(Controller) though.
  w2 = ktgui.createWindow("Window_2", 400, 200, 300, 200);
  s3.registerController(w2);

  w3 = ktgui.createWindow("Window_3", 10, 200, 300, 200);
  w3.attachController(jumpButton);
  //s3.registerController(jumpButton); // --------- !!!!!! --------- the controller must be automatically 
  // registered in the parentWindow.parentStage ???????
  // In that case, each newly created controller must be added to 
  // stageManager.defaultStage
  s3.registerController(w3);

  ktgui.stageManager.goToStage(s2);
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

  textSize(10);
  int YSHIFT = 12;  
  int ypos = 14;
  textAlign(LEFT, CENTER);
  text("-------------------------------------------------------------------", 10, ypos+=YSHIFT);
  for (Controller controller : ktgui.stageManager.defaultStage.controllers) {
    if (controller.title != null) { 
      text("defaultStage: " + controller.title.replaceAll("\n", ""), 10, ypos+=YSHIFT);
    }
  }
  text("-------------------------------------------------------------------", 10, ypos+=YSHIFT);
  for (Controller controller : ktgui.stageManager.activeStage.controllers) {
    if (controller.title != null) {
      text("activeStage: " + controller.title, 10, ypos+=YSHIFT);
    }
  }
  text("-------------------------------------------------------------------", 10, ypos+=YSHIFT);
  for (Stage stage : ktgui.stageManager.stages) {
    for (Controller controller : stage.controllers) {
      if (controller.title != null) { 
        text("stage." + stage.name + ": " + controller.title, 10, ypos+=YSHIFT);
      }
    }
  }

}

void keyPressed() {
  ktgui.stageManager.goToNextStage();
}
