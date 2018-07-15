package ktgui;

public class Bar extends Controller {

	public Bar(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		this.isDragable = true;
	}
	
	@Override
	public void updateGraphics() {
		ktgui.drawCallStack.add(title + ".updateGraphics()");
		// draw ar and title
		pg.beginDraw();
		pg.background(200, 200);
		pg.rectMode(CORNER);
		pg.fill(bgPassiveColor);
		pg.stroke(15);
		pg.strokeWeight(1);
		pg.rect(0, 0, w, h);
		pg.fill(25);
		pg.textAlign(LEFT, CENTER);
		pg.textSize(h * 0.65f);
		pg.text(title, 10, h * 0.5f);
		pg.endDraw();
	}
}

