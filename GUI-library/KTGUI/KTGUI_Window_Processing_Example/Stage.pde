/**********************************************************************************************************************
 * A Stage can have multple controllers.
 * The KTGUI class should handle the transition from one Stage to another.
 * Only one Stage can be active at a time. 
 * Only the GUI elements from the active Stage will be displayed
 * This allows the sharing of variables between different Stages, by storing/retriving data from the 'context' object
 *********************************************************************************************************************/
public class Stage {
  List<Controller> controllers;
  String name;

  Stage(String name) {
    this.name = name;
    this.controllers = new ArrayList<Controller>();
  }

  void draw() {
    for (Controller controller : controllers) {
      controller.updateGraphics();
      controller.draw();
    }
  }

  void registerController(Controller controller) {
    println("Trying to register " + controller.title + " in " + name);
    if (ktgui.stageManager.defaultStage.controllers.contains(controller)) {
      println("\tktgui.stageManager.defaultStage.controllers.contains(controller):" + ktgui.stageManager.defaultStage.controllers.contains(controller) + " -- removing");
      ktgui.stageManager.defaultStage.controllers.remove(controller);
    }
    if (ktgui.stageManager.activeStage != null) {
      if (ktgui.stageManager.activeStage.controllers.contains(controller)) {
        println("\tktgui.stageManager.activeStage.controllers.contains(controller):" + ktgui.stageManager.activeStage.controllers.contains(controller) + " -- removing");
        ktgui.stageManager.activeStage.controllers.remove(controller);
      }
    }
    for (Stage stage : ktgui.stageManager.stages) {
      if (stage.controllers.contains(controller)) {
        println("\t" + stage.name + ".controllers.contains(controller):" + stage.controllers.contains(controller) + " -- removing");
        stage.controllers.remove(controller);
      }
    }
    if (!controllers.contains(controller)) {
      controllers.add(controller);
      controller.parentStage = this;
      println("\tsuccessfull.");
    } else {
      println("\talready exist.");
    }
  }

  void unregisterController(Controller controller) {
    if (controllers.contains(controller)) {
      controllers.remove(controller);
      controller.parentStage = null;
    }
  }
}
