package ktgui;

import java.util.ArrayList;
import java.util.List;

import processing.core.PApplet;

/********************************************************************************************************************** 
 * 
 *********************************************************************************************************************/
class StageManager {

	List<Stage>	stages;			// replace 'List' with 'Set' to prevent duplicates
	Stage		activeStage;
	Stage		defaultStage;
	PApplet		pa;

	StageManager(KTGUI ktgui) {
		stages = new ArrayList<Stage>();
		defaultStage = new Stage(ktgui, "Default");
		activeStage = defaultStage;
	}

	Stage createStage(KTGUI ktgui, String name) {
		Stage stage = new Stage(ktgui, name);
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
