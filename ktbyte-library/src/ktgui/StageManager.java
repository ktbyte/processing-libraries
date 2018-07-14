package ktgui;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;

/********************************************************************************************************************** 
 * 
 *********************************************************************************************************************/
public class StageManager {

	public List<Stage>			stages;			// replace 'List' with 'Set' to prevent duplicates
	public Stage				activeStage;
	public Stage				defaultStage;
	public PApplet				pa;
	private static StageManager	instance;

	static {
		instance = new StageManager();
	}

	public static StageManager getInstance() {
		return instance;
	}

	public void init(KTGUI ktgui) {
		stages = new ArrayList<Stage>();
		defaultStage = createStage("Default");
		activeStage = defaultStage;
	}

	public Stage createStage(String name) {
		System.out.println("Creating stage '" + name + "'");
		Stage stage = new Stage(name);
		stages.add(stage);
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
		activeStage = stage;
	}

	public void goToStage(int numStage) {
		if (numStage > 0 && numStage < stages.size()) {
			activeStage = stages.get(numStage);
		}
	}

	public void goToNextStage() {
		int indexOfCurrentStage = stages.indexOf(activeStage);
		if (indexOfCurrentStage < stages.size() - 1) {
			activeStage = stages.get(indexOfCurrentStage + 1);
		} else {
			activeStage = stages.get(0);
		}
	}

	public void unregisterControllerFromAllStages(Controller controller) {
		System.out.println("Unregistering " + controller.title + " from all stages ...");
		for (Stage stage : stages) {
			System.out.println("\tStage " + stage.getName() + " contains:");
			for (Controller c : stage.controllers) {
				System.out.println("\t\t" + c.title + " of type (" + c.getClass().getName() + ")");
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
