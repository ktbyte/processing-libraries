/**********************************************************************************************************************
 * A state can have multple controllers.
 * The KTGUI class should handle the transition from one state to another.
 * Only one state can be active at a time. 
 * Only the GUI elements from the active state will be displayed
 * This allows the sharing of variables between different states, by storing/retriving data from the 'context' object
 *********************************************************************************************************************/
public class State {
  List<Controller> controllers;
  HashMap<String, Object> context;
  String name;

  State(String name) {
    this.name = name;
    this.controllers = new ArrayList<Controller>();
    this.context = new HashMap<String, Object>();
  }

  void draw() {
    for (Controller controller : controllers) {
      controller.updateGraphics();
      controller.draw();
    }
  }

  void attachController(Controller controller) {
    if (!controllers.contains(controller)) {
      controllers.add(controller);
    }
  }
}
