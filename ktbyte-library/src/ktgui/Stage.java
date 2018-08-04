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
		System.out.println("Creating stage '" + name + "' started.");
		this.pa = KTGUI.getParentPApplet();
		this.name = name;
		this.controllers = new ArrayList<Controller>();
		StageManager.getInstance().getStages().add(this);
		System.out.println("Creating stage '" + name + "' completed.");
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
		System.out.println("Registering controller (" + controller.title + ") in stage (" + name + ").");

		// check if controller already exist in 'this' stage
		if (controllers.contains(controller)) {
			System.out.println(
					"\tController (" + controller.title + ") already exist in stage (" + name + "). Interrupting.");
			return;
		}

		// try to remove controller from default stage before adding it to 'this' stage
		if (StageManager.getInstance().getDefaultStage().controllers.contains(controller)) {
			StageManager.getInstance().getDefaultStage().unregisterController(controller);
		}

		// try to remove controller from active stage before adding it to 'this' stage
		if (StageManager.getInstance().getActiveStage() != null) {
			if (StageManager.getInstance().getActiveStage().controllers.contains(controller)) {
				StageManager.getInstance().getActiveStage().unregisterController(controller);
			}
		}

		// add controller to this stage
		controllers.add(controller);
		controller.parentStage = this;

		// debug info
		System.out.println("\tDone. Now, stage (" + name + ") contains " + controllers.size() + " controllers.");
		for (Controller c : controllers) {
			System.out.println("\t\t" + controllers.indexOf(c) + ": " + c.title + " (" + c.controllers.size()
					+ " child controllers)");
			for (Controller child : c.controllers) {
				System.out.println("\t\t\t" + c.controllers.indexOf(child) + ": " + child.title);
			}
		}

		//		String controllerClassName = controller.getClass().getName();
		//		String[] tokens = PApplet.splitTokens(controllerClassName, ".$");
		//		//if (tokens.length > 1) controllerClassName = tokens[1];
		//		if (tokens.length > 1) {
		//			// try to add all child components of controller, if it is of type Window
		//			if (tokens[1].equalsIgnoreCase("Window")) {
		//				Window window = (Window) controller;
		//				window.registerChildControllers();
		//			}
		//			// try to add all child components of controller, if it is of type Pane
		//			if (tokens[1].equalsIgnoreCase("Pane")) {
		//				Pane pane = (Pane) controller;
		//				pane.registerChildControllers();
		//			}
		//			if (tokens[1].equalsIgnoreCase("WindowPane")) {
		//				WindowPane windowPane = (WindowPane) controller;
		//				windowPane.registerChildControllers();
		//			}
		//		} else {
		//			System.out.println("....Cannot register child controllers of '" + name + "'");
		//		}
		//		System.out.println("------------------------------------------------------------------------------------");
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
