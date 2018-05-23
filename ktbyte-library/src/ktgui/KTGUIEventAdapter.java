package ktgui;

import processing.core.PApplet;

/**********************************************************************************************************************
 * This abstract class should be extended by the KTGUI components (controllers)
 *********************************************************************************************************************/
public abstract class KTGUIEventAdapter {
	public void onMousePressed() {}

	public void onMouseReleased() {}

	public void onMouseMoved() {}

	public void onMouseDragged() {}

	public void onAnyKeyReleased() {}

	public void onAnyKeyPressed() {}

	public void onEnterKeyPressed() {}

	public void println(String string) {
		PApplet.println(string);
	}

}
