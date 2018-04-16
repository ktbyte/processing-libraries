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
    if(ktgui.stageManager.defaultStage.controllers.contains(controller)){
      ktgui.stageManager.defaultStage.controllers.remove(controller);      
    }
    if (!controllers.contains(controller)) {
      controllers.add(controller);
      controller.parentStage = this;
    }
  }

  void unregisterController(Controller controller) {
    if (controllers.contains(controller)) {
      controllers.remove(controller);
      controller.parentStage = null;
    }
  }
}
