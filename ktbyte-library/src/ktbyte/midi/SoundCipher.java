package ktbyte.midi;


import processing.core.*;
import arb.soundcipher.*;

/**
 * 
 * This element can be used to create music. It is just a wrapper library over the SoundCipher library.
 */
public class SoundCipher implements Instruments {
	
	private PApplet parent;
	private arb.soundcipher.SoundCipher soundCipher;

	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the Library.
	 * 
	 * @param parent
	 *   The main PApplet instance
	 */
	public SoundCipher(PApplet parent) {
		this.parent = parent;
		this.soundCipher = new arb.soundcipher.SoundCipher(parent);
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
	
	/**
	 * Schedules a note cluster (chord) for immediate playback. 
	 * 
	 * @param pitch
	 *          The MIDI pitches (frequencies) for each note [0-127]
	 * @param dynamic
	 *          The loudness, MIDI velocity, of the note [0-127]
	 * @param duration
	 * 			The length that the note will sound, in beats          
	 */
	public void playChord(float[] pitches, double dynamic, double duration) {
		this.soundCipher.playChord(pitches, dynamic, duration);
	}
	
	/**
	 * 
	 * Specifies the default instrument
	 * 
	 * @param instrumentCode
	 *          The instrument code number [0-127].       
	 */
	public void changeInstrument(double instrumentCode) {
		this.soundCipher.instrument(instrumentCode);
	}
	
	/**
	 * 
	 * Loads the instrument soundfont in the current environment
	 * 
	 * @param instrumentCode
	 *          The instrument code number [0-127].       
	 */
	public void loadInstrument(double instrumentCode) {
		// does nothing since the sound of the instruments are already loaded in the Java environment,
		// this method may be useful in the browser environment 
	}
}

