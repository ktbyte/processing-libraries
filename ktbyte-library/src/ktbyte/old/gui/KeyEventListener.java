package ktbyte.old.gui;

import processing.core.PApplet;

public abstract class KeyEventListener {

	public abstract void onEnterKey();

	/*
	 * Method used as a workaround, so that the println statements from the
	 * onEnterKey() method will work in the KYByte coder
	 */
	void println(String text) {
		PApplet.println(text);
	};
}
