package ktgui;

import java.util.ArrayList;
import java.util.List;

/********************************************************************************************************************** 
 * 
 *********************************************************************************************************************/
public class StageManager {

	public static List<Stage>	stages;			// replace 'List' with 'Set' to prevent duplicates
	private static Stage		activeStage;	// this is just a pointer to the currently active stage
	private static Stage		defaultStage;	// this stage is always present regardless of the number of other stages
	private static StageManager	instance;

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

	public static Stage createStage(String name) {
		Stage stage = new Stage(name);
		activeStage = stage;
		return stage;
	}

	public static Stage getDefaultStage() {
		return defaultStage;
	}

	public static Stage getActiveStage() {
		return activeStage;
	}

	public static void goToStage(Stage stage) {
		activeStage = stage;
	}

	public static void goToStage(int numStage) {
		if (numStage > 0 && numStage < stages.size()) {
			activeStage = stages.get(numStage);
		}
	}

	public static void goToNextStage() {
		int indexOfCurrentStage = stages.indexOf(activeStage);
		if (indexOfCurrentStage < stages.size() - 1) {
			activeStage = stages.get(indexOfCurrentStage + 1);
		} else {
			activeStage = stages.get(0);
		}
	}

	public static void unregisterControllerFromAllStages(Controller controller) {
		System.out.println("Unregistering " + controller.title + " from all stages ...");
		for (Stage stage : stages) {
			System.out.println("\tStage " + stage.getName() + " contains:");
			for (Controller c : stage.controllers) {
				System.out.println("\t\t" + c.title + " of type (" +
						c.getClass().getName() + ")");
			}
			if (stage.controllers.contains(controller)) {
				System.out.println("\t\t\t>>> Found (" + controller.title + ") in stage (" +
						stage.getName() + "), removing ...");
				stage.controllers.remove(stage.controllers.indexOf(controller));
				System.out.println("\t\t\tNow, " + stage.getName() +
						".controllers.contains(" + controller.title + ") == " + stage.controllers.contains(controller));
			}
		}
		controller.parentStage = null;
		System.out.println("Done.");
	}
}
