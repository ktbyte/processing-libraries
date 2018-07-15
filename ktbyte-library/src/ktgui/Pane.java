package ktgui;

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
public class Pane extends Controller {

	public Pane(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
	}

	@Override public void updateGraphics() {
		// change thickness depending on the user-mouse behavior
		pg.beginDraw();
		pg.background(200, 100);
		pg.stroke(0);
		pg.strokeWeight(1);
		//pg.fill(200, 220, 200, 50);
		pg.rectMode(CORNER);
		pg.rect(0, 0, w, h);
		pg.noFill();
		pg.endDraw();
	}
}
