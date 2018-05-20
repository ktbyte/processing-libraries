package ktgui;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;

/********************************************************************************************************************** 
 * 
 *********************************************************************************************************************/
public class StageManager {

	public List<Stage>	stages;			// replace 'List' with 'Set' to prevent duplicates
	public Stage		activeStage;
	public Stage		defaultStage;
	public PApplet		pa;

	public StageManager(KTGUI ktgui) {
		stages = new ArrayList<Stage>();
		defaultStage = new Stage(ktgui, "Default");
		activeStage = defaultStage;
	}

	public Stage createStage(KTGUI ktgui, String name) {
		Stage stage = new Stage(ktgui, name);
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

}
