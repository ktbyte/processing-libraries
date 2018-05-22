package ktgui;

import java.util.ArrayList;

import processing.core.PApplet;

/**********************************************************************************************************************
 * A Stage can have multple controllers.
 * The KTGUI class should handle the transition from one Stage to another.
 * Only one Stage can be active at a time. 
 * Only the GUI elements from the active Stage will be displayed
 * This allows the sharing of variables between different Stages, by storing/retriving data from the 'context' object
 *********************************************************************************************************************/
public class Stage {
	ArrayList<Controller>	controllers;
	String					name;
	PApplet					pa;

	public Stage(String name) {
		this.pa = KTGUI.getParentPApplet();
		this.name = name;
		this.controllers = new ArrayList<Controller>();
	}

	public String getName() {
		return name;
	}

	public void draw() {
		for (Controller controller : controllers) {
			if (controller.isActive) {
				controller.updateGraphics();
				controller.draw();
			}
		}
	}

	public void registerController(Controller controller) {
		String controllerClassName = controller.getClass().getName();

		// try to remove controller from default stage then
		if (StageManager.getInstance().getDefaultStage().controllers.contains(controller)) {
			StageManager.getInstance().defaultStage.unregisterController(controller);
		}

		// try to remove controller from active stage then
		if (StageManager.getInstance().getActiveStage() != null) {
			if (StageManager.getInstance().activeStage.controllers.contains(controller)) {
				StageManager.getInstance().activeStage.unregisterController(controller);
			}
		}

		// add controller to this stage
		String[] tokens = PApplet.splitTokens(controllerClassName, ".$");
		if (tokens.length > 1)
			controllerClassName = tokens[1];
		if (!controllers.contains(controller)) {
			controllers.add(controller);
			controller.parentStage = this;
			if (tokens.length > 1) {
				//				// try to add all child components of controller, if it is of type Window
				//				if (tokens[1].equalsIgnoreCase("Window")) {
				//				}
				//					Window window = (Window) controller;
				//					window.registerChildControllers();
				//				}
				//				// try to add all child components of controller, if it is of type Pane
				//				if (tokens[1].equalsIgnoreCase("Pane")) {
				//					Pane pane = (Pane) controller;
				//					pane.registerChildControllers();
				//				if (tokens[1].equalsIgnoreCase("WindowPane")) {
				//					WindowPane windowPane = (WindowPane) controller;
				//					windowPane.registerChildControllers();
				//				}
			} else {
			}
		} else {
		}
	}

	public void unregisterController(Controller controller) {
		if (controllers.contains(controller)) {
			controllers.remove(controller);
			controller.parentStage = null;
		}
	}

	public ArrayList<Controller> getControllers() {
		return controllers;
	}
}
