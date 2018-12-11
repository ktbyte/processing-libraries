package ktbyte.old.gui;

import processing.core.PApplet;

public abstract class ConsoleInputListener {

	public abstract void onConsoleInput(String variable, String value);

	/*
	 * Method used as a workaround, so that the println statements from the
	 * onConsoleInput() method will work in the KYByte coder
	 */
	void println(String text) {
		PApplet.println(text);
	};
}