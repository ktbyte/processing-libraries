package ktbyte.ktgui;

public class Bar extends Controller {

	public Bar(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
	}
	
	@Override
	public void updateGraphics() {
        super.updateGraphics();
		// draw ar and title
		pg.beginDraw();
		pg.background(200, 200);
		pg.rectMode(CORNER);
		pg.fill(bgPassiveColor);
        pg.stroke(0);
        pg.rectMode(CORNER);
        if(isFocused) {
            pg.strokeWeight(3f);
        } else {
            pg.strokeWeight(1f);
        }
        pg.rect(0, 0, w, h, r1, r2, r3, r4);
		pg.fill(25);
		pg.textAlign(LEFT, CENTER);
		pg.textSize(h * 0.65f);
		pg.text(title, 10, h * 0.5f);
		pg.endDraw();
	}
}

