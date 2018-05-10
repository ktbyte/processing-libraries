package ktbyte.sound;

import ddf.minim.AudioPlayer;
import ddf.minim.Minim;
import processing.core.PApplet;

/**
 * 
 * This element can be used to play mp3 files. It is just a wrapper library over the minim library.
 */
public class SoundFile {

	private String path;
	private Minim minim;
	private AudioPlayer sound;
	private PApplet papplet;

	/**
	 * This constructs a SoundFile object within the current context (PApplet),
	 * 
	 * @param parent
	 *   The main PApplet instance
	 * @param path
	 *   Path can be either a file path or and URL in the browser environment. In PDE environment, it only accepts a file path
	 */
	public SoundFile(PApplet parent, String path) {
		this.papplet = parent;
		this.path = path;
		this.minim = new Minim(parent);
	}

	/**
	 * Starts the playback of a sound
	 */
	public void play() {
		sound.rewind();
		sound.play();
	}

	/**
	 * Loads the sound file
	 */
	public void load() {
		sound = minim.loadFile(path);
	}

	/**
	 * Stops the playback of the sound
	 */
	public void stop() {
		sound.pause();
	}

	/**
	 * Loops the playback of a sound
	 */
	public void loop() {
		sound.loop();
	}
	
	/**
	 * In the KTByte environment: Returns true if the sound is loaded and ready to use
	 * In PDE environment: Always returns true
	 * @return
	 *   True of the sound is loaded and can be used.
	 */
	public boolean isLoaded() {
		return true;
	}
}
