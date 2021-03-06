import java.util.*;

KTGUI ktgui;
Button jumpButton, anotherButton, nextStageBtn;
Pane pane;
Window w1, w2, w3;
Stage s1, s2, s3;
Stage alignStage;
boolean debug = true;
Button dbgButton;

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void setup() {
  size(800, 500);
  //noSmooth();
  
  ktgui = new KTGUI(this); // default stage is automatically created

  dbgButton = ktgui.createButton("Debug", 0, 0, 100, 50);
  dbgButton.alignAboutApplet(CENTER, BOTTOM);
  dbgButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      debug = !debug;
    }
  }
  );

  // this button will be visible always because it will be located on default stage
  nextStageBtn = ktgui.createButton("NextStage", width - 120, height - 70, 100, 50);
  nextStageBtn.alignAboutApplet(RIGHT, BOTTOM);
  nextStageBtn.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      msg("Callback message: The Next-Stage-Button was pressed!");
      ktgui.stageManager.goToNextStage();
    }
  }
  );

  s1 = ktgui.stageManager.createStage("stage_1");
  anotherButton = ktgui.createButton("Go To Stage_2", 50, height - 70, 150, 50);
  anotherButton.alignAboutApplet(LEFT, BOTTOM);
  anotherButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      msg("Callback message: The anotherButton (goToStage(1)) was pressed!");
      ktgui.stageManager.goToStage(1);
    }
  }
  );
  s1.registerController(anotherButton);

  // Now, the "s1" stage is "active". So, the both 'w1' and 'nextStageButton' are automatically attached to this stage. 
  // We can still use 's1.attachController(Controller) though.
  s2 = ktgui.stageManager.createStage("stage_2");
  pane = ktgui.createPane((int)(width * 0.5 - 200), 200, 400, 200);  
  pane.alignAboutApplet(CENTER, TOP);
  pane.isDragable = true;
  s2.registerController(pane);


  // Now, the "s2" stage is "active". So, the jumpButton is automatically attached to this stage.
  // We can use 's2.attachController(Controller) though.
  s3 = ktgui.stageManager.createStage("stage_3");
  jumpButton = ktgui.createButton("Jump!", 50, 50, 100, 50);
  jumpButton.addEventAdapter(new KTGUIEventAdapter() {
    public void onMousePressed() {
      msg("Callback message: The Jumping Button was pressed!");
      if (jumpButton.parentController == w3.pane) {
        //w2.attachController(jumpButton);
        w2.addController(jumpButton, 0, TOP);
      } else if (jumpButton.parentController == w2.pane) {
        //w3.attachController(jumpButton);
        w3.addController(jumpButton, 0, BOTTOM);
      }
    }
  }
  );

  // The "s2" stage is still "active". So, the both windows are automatically attached to this stage.
  // We can still use 's2.attachController(Controller) though.
  w2 = ktgui.createWindow("Window_2", 10, 220, 300, 200);
  w2.alignAboutApplet(LEFT, BOTTOM);
  s3.registerController(w2);

  w3 = ktgui.createWindow("Window_3", 400, 220, 300, 200);
  //w3.alignAboutApplet(RIGHT, 0);
  w3.stackAbout(w2, TOP, CENTER);
  w3.addController(jumpButton, CENTER, CENTER);
  s3.registerController(w3);

  alignStage = ktgui.stageManager.createStage("Aligning");

  Pane p1 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  p1.alignAboutApplet(LEFT, TOP);
  Button p1b1 = ktgui.createButton("Top", 10, 10, 180, 40);
  p1b1.setPassiveColor(color(200, 120, 50));
  p1.addController(p1b1, CENTER, TOP);
  Button p1b2 = ktgui.createButton("Below & Center", 10, 10, 160, 40);
  p1.attachController(p1b2);
  p1b2.stackAbout(p1b1, BOTTOM, CENTER);
  Button p1b3 = ktgui.createButton("Below & Left", 10, 10, 140, 40);
  p1.attachController(p1b3);
  p1b3.stackAbout(p1b2, BOTTOM, LEFT);
  Button p1b4 = ktgui.createButton("Below & Right", 10, 10, 120, 40);
  p1.attachController(p1b4);
  p1b4.stackAbout(p1b3, BOTTOM, RIGHT);
  alignStage.registerController(p1);

  Pane p2 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  p2.alignAboutApplet(CENTER, TOP);
  Button p2b1 = ktgui.createButton("Center", 10, 10, 180, 40);
  p2b1.setPassiveColor(color(20, 200, 150));
  p2.addController(p2b1, CENTER, CENTER);
  Button p2b2 = ktgui.createButton("Below & Center", 10, 10, 160, 40);
  p2.attachController(p2b2);
  p2b2.stackAbout(p2b1, BOTTOM, CENTER);
  Button p2b3 = ktgui.createButton("Below & Left", 10, 10, 140, 40);
  p2.attachController(p2b3);
  p2b3.stackAbout(p2b2, BOTTOM, LEFT);
  Button p2b4 = ktgui.createButton("Below & Right", 10, 10, 120, 40);
  p2.attachController(p2b4);
  p2b4.stackAbout(p2b3, BOTTOM, RIGHT);
  alignStage.registerController(p2);

  Pane p3 = ktgui.createPane("Left Pane", 110, 10, 200, 400);
  p3.alignAboutApplet(RIGHT, TOP);
  Button p3b1 = ktgui.createButton("Bottom", 10, 10, 180, 40);
  p3b1.setPassiveColor(color(250, 20, 200));
  p3.addController(p3b1, CENTER, BOTTOM);
  Button p3b2 = ktgui.createButton("Above & Center", 10, 10, 160, 40);
  p3.attachController(p3b2);
  p3b2.stackAbout(p3b1, TOP, CENTER);
  Button p3b3 = ktgui.createButton("Above & Left", 10, 10, 140, 40);
  p3.attachController(p3b3);
  p3b3.stackAbout(p3b2, TOP, LEFT);
  Button p3b4 = ktgui.createButton("Above & Right", 10, 10, 120, 40);
  p3.attachController(p3b4);
  p3b4.stackAbout(p3b3, TOP, RIGHT);
  alignStage.registerController(p3);

  ktgui.stageManager.goToStage(s2);

  msg(w2.pane.w + ":" + w2.pane.h);
}

/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
void draw() {
  background(170, 220, 170);
  //
  updateDebugInfo();
  updatePaneCanvas();
  updateSecondWindowCanvas();
}

void updatePaneCanvas() {
  PGraphics g = createGraphics(pane.w, pane.h);
  g.beginDraw();
  g.fill(200, 100, 100);
  g.textSize(36);
  g.textAlign(CENTER);
  g.text("Drag this pane!", pane.w * 0.5, 40);
  g.pushMatrix();
  g.translate(pane.w * 0.5, pane.h * 0.5);
  g.rotate(frameCount*0.01);
  g.rectMode(CENTER);
  g.fill(200);
  g.stroke(0);
  g.ellipse(0, 0, 300, 20);
  g.popMatrix();
  g.pushMatrix();
  g.translate(pane.w * 0.25, pane.h * 0.5);
  g.rotate(-frameCount*0.01);
  g.rectMode(CENTER);
  g.fill(200);
  g.stroke(0);
  g.rect(0, 0, 100, 20);
  g.popMatrix();
  g.pushMatrix();
  g.translate(pane.w * 0.75, pane.h * 0.5);
  g.rotate(-frameCount*0.01);
  g.rectMode(CENTER);
  g.fill(200);
  g.stroke(0);
  g.rect(0, 0, 100, 20);
  g.popMatrix();
  g.endDraw();
  pane.updateUserDefinedGraphics(g);
}


void updateSecondWindowCanvas() {
  PGraphics g = createGraphics(w2.pane.w, w2.pane.h);
  g.beginDraw();
  g.translate(w2.pane.w * 0.5, w2.pane.h * 0.5);
  g.rotate(frameCount*0.05);
  g.translate(w2.pane.w * 0.25, 0);
  g.rotate(-frameCount*0.2);
  g.pushMatrix();
  g.stroke(0);
  g.strokeWeight(1);
  g.line(-5, 5, 0, 45);
  g.line(0, 45, 5, 5);
  g.line(5, 5, 45, 0);
  g.line(45, 0, 5, -5);
  g.line(5, -5, 0, -45);
  g.line(0, -45, -5, -5);
  g.line(-5, -5, -45, 0);
  g.line(-45, 0, -5, 5);
  g.popMatrix();
  g.endDraw();
  w2.pane.updateUserDefinedGraphics(g);
}

void msg(String msg) {
  if (debug) {
    println(msg);
  }
}

void updateDebugInfo() {
  if (debug) {
    fill(0);
    textSize(20);
    textAlign(RIGHT, CENTER);
    textFont(createFont("monospaced", 16));
    text("activeStage.name:" + ktgui.stageManager.activeStage.name, width - 10, 10);
    text("activeStage.index:" + ktgui.stageManager.stages.indexOf(ktgui.stageManager.activeStage), width - 10, 30);
    text("size():" + ktgui.stageManager.stages.size(), width - 10, 50);

    textSize(11);
    int YSHIFT = 12;  
    int ypos = 0;
    textAlign(LEFT, CENTER);
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    for (Controller controller : ktgui.stageManager.defaultStage.controllers) {
      if (controller.title != null) { 
        text("defaultStage: " + controller.title + 
          ", posx:" + controller.posx + 
          ", posy:" + controller.posy
          , 10, ypos+=YSHIFT);
      }
    }
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    for (Controller controller : ktgui.stageManager.activeStage.controllers) {
      if (controller.title != null) {
        text("activeStage: " + controller.title + 
          ", parent:" + ((controller.parentController != null) ? controller.parentController.title : "null") + 
          ", posx:" + controller.posx + 
          ", posy:" + controller.posy, 
          10, ypos+=YSHIFT);
      }
    }
    text("----------------------------------------------------", 10, ypos+=YSHIFT);
    surface.setTitle(mouseX + ":" + mouseY);
  }
}
