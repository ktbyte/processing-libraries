package ktgui;

import java.util.ArrayList;
import java.util.List;

/********************************************************************************************************************** 
 * 
 *********************************************************************************************************************/
public class StageManager {

    public static List<Stage>   stages;       // replace 'List' with 'Set' to prevent duplicates
    private static Stage        activeStage;  // this is just a pointer to the currently active stage
    private static Stage        defaultStage; // this stage is always present regardless of the number of other stages
    private static StageManager instance;

    static {
        instance = new StageManager();
        instance.init();
    }

    public static StageManager getInstance() {
        return instance;
    }

    private void init() {
        stages = new ArrayList<Stage>();
        defaultStage = createStage("Default");
        activeStage = defaultStage;
    }

    public Stage createStage(String name) {
        Stage stage = new Stage(name);
        activeStage = stage;
        return stage;
    }

    public Stage getDefaultStage() {
        return defaultStage;
    }

    public Stage getActiveStage() {
        return activeStage;
    }

    public void goToStage(Stage stage) {
        if (stage != defaultStage) {
            activeStage = stage;
        }
    }

    public void goToStage(int numStage) {
        if (numStage > 0 && numStage < stages.size()) {
            activeStage = stages.get(numStage);
        }
    }

    public void goToNextStage() {
        if (userStagesExist()) {
            int indexOfCurrentStage = stages.indexOf(activeStage);
            if (indexOfCurrentStage > 0 && indexOfCurrentStage < stages.size() - 1) {
                activeStage = stages.get(indexOfCurrentStage + 1);
            } else {
                activeStage = stages.get(1); // go to first stage (default stage has 0 index)
            }
        }
    }

    public void unregisterControllerFromAllStages(Controller controller) {
        System.out.println("Unregistering [" + controller.title + "] from all stages ...");
        for (Stage stage : stages) {
            System.out.println("\tStage {" + stage.getName() + "} contains:");
            for (Controller c : stage.controllers) {
                System.out.println("\t\t[" + c.title + "] of type <" +
                        c.getClass().getName() + ">");
            }
            if (stage.controllers.contains(controller)) {
                System.out.println("\t\t\t>>> Found [" + controller.title + "] of type <" +
                        controller.getClass().getName() + "> in stage {" +
                        stage.getName() + "}, removing ...");
                stage.controllers.remove(stage.controllers.indexOf(controller));
                System.out.println("\t\t\tNow, {" + stage.getName() +
                        "}.controllers.contains(" + controller.title + ") = " + stage.controllers.contains(controller));
            }
        }
        controller.parentStage = null;
        System.out.println("Done.");
    }

    public boolean userStagesExist() {
        return StageManager.getInstance().getDefaultStage() != StageManager.getInstance().getActiveStage();
    }

    public List<Stage> getStages() {
        return stages;
    }
}
