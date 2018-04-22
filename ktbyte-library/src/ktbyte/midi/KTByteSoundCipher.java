package ktbyte.midi;


import processing.core.*;
import arb.soundcipher.SoundCipher;

/**
 * 
 * @example Hello 
 */

public class KTByteSoundCipher {
	PApplet parent;
	SoundCipher sc;

	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the Library.
	 * 
	 * @example Hello
	 * @param parent
	 */
	public KTByteSoundCipher(PApplet parent) {
		this.parent = parent;
		this.sc = new SoundCipher(parent);
	}
	
	/**
	 * 
	 * @param pitch
	 *          The MIDI pitch at which the note will play [0-127]
	 * @param dynamic
	 *          The loudness, MIDI velocity, of the note [0-127]
	 * @param duration
	 * 			The length that the note will sound, in beats          
	 */
	public void playNote(double pitch, double dynamic, double duration) {
		this.sc.playNote(pitch, dynamic, duration);
	}
	
	/**
	 * return the version of the Library.
	 * 
	 * @return String
	 */
	public static String version() {
		return "";
	}

	/**
	 * 
	 * @param theA
	 *          the width of test
	 * @param theB
	 *          the height of test
	 */
	public void setVariable(int theA, int theB) {
//		myVariable = theA + theB;
	}
}

