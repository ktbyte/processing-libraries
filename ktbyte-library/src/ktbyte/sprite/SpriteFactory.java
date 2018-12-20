package ktbyte.sprite;

import processing.core.PApplet;

public class SpriteFactory {
	private static PApplet	pa;
	
	public SpriteFactory(PApplet pa) {
		SpriteFactory.pa = pa;
	}
	
	public Sprite createSprite(String url, float x, float y, float w, float h) {
		return new Sprite(pa, url, x, y, w, h);
	}
	
	public Sprite createSprite(float x, float y, float w, float h) {
		return new Sprite(pa, x, y, w, h);
	}

	// method to initialize the Sprite from a copy of another 
	// Sprite instance
	public Sprite createSprite(Sprite s) {
		return new Sprite(pa, s);
	}
}
