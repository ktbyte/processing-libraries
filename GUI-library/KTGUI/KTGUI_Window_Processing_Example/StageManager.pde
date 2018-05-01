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
    activeStage = defaultStage;
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
  }

  void goToNextStage() {
    int indexOfCurrentStage = stages.indexOf(activeStage);
    if (indexOfCurrentStage < stages.size() - 1) {
      activeStage = stages.get(indexOfCurrentStage + 1);
    } else {
      activeStage = stages.get(0);
    }
  }


}
