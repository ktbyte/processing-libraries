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
      if (controller.isActive) {
        controller.updateGraphics();
        controller.draw();
      }
    }
  }

  void registerController(Controller controller) {
    String controllerClassName = controller.getClass().getName();
    String[] tokens = splitTokens(controllerClassName, ".$");
    if (tokens.length > 1) controllerClassName = tokens[1];
    println("Trying to register '" + controller.title + "' " + controllerClassName + " in '" + name + "' stage.");
    
    // try to remove controller from default stage first
    if (ktgui.stageManager.defaultStage.controllers.contains(controller)) {
      println("\tdefaultStage already contains this controller: --> removing from default stage.");
      ktgui.stageManager.defaultStage.controllers.remove(controller);
    }

    // try to remove controller from active stage first
    if (ktgui.stageManager.activeStage != null) {
      if (ktgui.stageManager.activeStage.controllers.contains(controller)) {
      println("\tactiveStage already contains this controller: --> removing from active stage.");
        ktgui.stageManager.activeStage.controllers.remove(controller);
      }
    }

    // try to remove controller from parent stage first
    if (controller.parentStage != null) {
      println("\tparentStage(" + controller.parentStage.name + ") != null: true");
    }

    // add controller to this stage
    if (!controllers.contains(controller)) {
      controllers.add(controller);
      controller.parentStage = this;
      println("\tAdded to controllers list successfully, new parentStage is (" + name + ")");
      if (tokens.length > 1) {
        // try to add all child components of controller, if it is of type Window
        if (tokens[1].contains("Window")) {
          Window window = (Window) controller;
          window.registerChildControllers();
        }
        // try to add all child components of controller, if it is of type Pane
        if (tokens[1].contains("Pane")) {
          Pane pane = (Pane) controller;
          pane.registerChildControllers();
        }
      } else {
        println("....Cannot register child controllers of '" + name + "'");
      }
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
