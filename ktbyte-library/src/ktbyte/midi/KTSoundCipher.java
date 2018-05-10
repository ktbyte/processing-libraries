package ktbyte.midi;


import arb.soundcipher.SoundCipher;
import processing.core.PApplet;

/**
 * 
 * This element can be used to create music. It is just a wrapper library over the SoundCipher library.
 */
public class KTSoundCipher {
	
	private SoundCipher soundCipher;
	private PApplet papplet;

	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the Library.
	 * 
	 * @param parent
	 *   The main PApplet instance
	 */
	public KTSoundCipher(PApplet parent) {
		this.papplet = parent;
		this.soundCipher = new SoundCipher(parent);
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
		this.soundCipher.playNote(pitch, dynamic, duration);
	}
}

