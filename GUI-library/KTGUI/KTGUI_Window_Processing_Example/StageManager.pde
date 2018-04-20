/**********************************************************************************************************************
 * 
 *********************************************************************************************************************/
class StageManager {

  List<Stage> stages; // replace 'List' with 'Set' to prevent duplicates
  Stage activeStage;
  Stage defaultStage;

  StageManager() {
    stages = new ArrayList<Stage>();
    defaultStage = new Stage("Default");
  }

  Stage createStage(String name) {
    Stage stage = new Stage(name);
    stages.add(stage);
    activeStage = stage;
    return stage;
  }

  void goToStage(Stage stage) {
    activeStage = stage;
  }

  void goToStage(int numStage) {
    if (numStage > 0 && numStage < stages.size()) {
      activeStage = stages.get(numStage);
    }
    println("numStage:" + numStage);
    println("numStage < Stages.size():" + (numStage < stages.size()));
    println("Stages.indexOf(activeStage):" + stages.indexOf(activeStage));
    println();
  }

  void goToNextStage() {
    int indexOfCurrentStage = stages.indexOf(activeStage);
    println("Before...");
    println("indexOfCurrentStage:" + indexOfCurrentStage);

    if (indexOfCurrentStage < stages.size() - 1) {
      activeStage = stages.get(indexOfCurrentStage + 1);
    } else {
      activeStage = stages.get(0);
    }

    println("After...");
    indexOfCurrentStage = stages.indexOf(activeStage);
    println("indexOfCurrentStage:" + indexOfCurrentStage);
    println();
  }

  void closeWindow(Window window) {
    // first, destroy all the child components
    for (Controller controller : window.controllers) {
      controller.isActive = false;
      for (Stage stage : stages) {
        stage.controllers.remove(controller);
      }
      activeStage.unregisterController(controller);
      defaultStage.unregisterController(controller);
    }
    // now, destroy the window itself
    window.isActive = false;
    for (Stage stage : stages) {
      stage.controllers.remove(window);
    }
    activeStage.unregisterController(window);
    defaultStage.unregisterController(window);
  }
}
