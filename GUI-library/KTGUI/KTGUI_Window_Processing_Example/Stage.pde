/**********************************************************************************************************************
 * A Stage can have multple controllers.
 * The KTGUI class should handle the transition from one Stage to another.
 * Only one Stage can be active at a time. 
 * Only the GUI elements from the active Stage will be displayed
 * This allows the sharing of variables between different Stages, by storing/retriving data from the 'context' object
 *********************************************************************************************************************/
public class Stage {
  ArrayList<Controller> controllers;
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
    msg("Trying to register '" + controller.title + "' " + controllerClassName + " in '" + name + "' stage.");

    // try to remove controller from default stage then
    if (ktgui.stageManager.defaultStage.controllers.contains(controller)) {
      msg("\tdefaultStage already contains this controller: --> removing from default stage.");
      ktgui.stageManager.defaultStage.unregisterController(controller);
    }

    // try to remove controller from active stage then
    if (ktgui.stageManager.activeStage != null) {
      if (ktgui.stageManager.activeStage.controllers.contains(controller)) {
        msg("\tactiveStage already contains this controller: --> removing from active stage.");
        ktgui.stageManager.activeStage.unregisterController(controller);
      }
    }

    // add controller to this stage
    String[] tokens = splitTokens(controllerClassName, ".$");
    if (tokens.length > 1) controllerClassName = tokens[1];
    if (!controllers.contains(controller)) {
      msg("controllers.size() of controller '" + controller.title + "':" + controllers.size());
      controllers.add(controller);
      controller.parentStage = this;
      msg("\tAdded to controllers list successfully, new parentStage is (" + name + ")");
      if (tokens.length > 1) {
        // try to add all child components of controller, if it is of type Window
        if (tokens[1].equalsIgnoreCase("Window")) {
          Window window = (Window) controller;
          window.registerChildControllers();
        }
        // try to add all child components of controller, if it is of type Pane
        if (tokens[1].equalsIgnoreCase("Pane")) {
          Pane pane = (Pane) controller;
          pane.registerChildControllers();
        }
        if (tokens[1].equalsIgnoreCase("WindowPane")) {
          WindowPane windowPane = (WindowPane) controller;
          windowPane.registerChildControllers();
        }
      } else {
        msg("....Cannot register child controllers of '" + name + "'");
      }
    } else {
      msg("\talready exist.");
    }
    msg("------------------------------------------------------------------------------------");
  }

  void unregisterController(Controller controller) {
    if (controllers.contains(controller)) {
      msg("\t" + name + " already contains controller '" + controller.title + "': --> removing from '" + name + "' stage.");
      controllers.remove(controller);
      controller.parentStage = null;
    }
  }
}
