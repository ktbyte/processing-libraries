package ktbyte.gui;

import processing.core.PApplet;

/**********************************************************************************************************************
 * This abstract class should be extended by the KTGUI components (controllers)
 *********************************************************************************************************************/
public abstract class EventAdapter {
	public void onMousePressed() {}

	public void onMouseReleased() {}

	public void onMouseMoved() {}

	public void onMouseDragged() {}

    public void onMouseWheel(int count) {}

    public void onAnyKeyReleased() {}

	public void onAnyKeyPressed() {}

	public void onEnterKeyPressed() {}

	public void onConsoleInput(String textInput, String lastVariableName) {}

	public void println(String string) {
		PApplet.println(string);
	}

    
}
