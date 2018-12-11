package ktbyte.gui;

public class ArrowButton extends Controller {

	private int direction;

	ArrowButton(KTGUI ktgui, String title, int posx, int posy, int w, int h, int dir) {
		super(ktgui, title, posx, posy, w, h);
		direction = dir;
	}

	@Override
	public void updateGraphics() {
        super.updateGraphics();
		pg.beginDraw();
		pg.pushStyle();
		pg.stroke(0);
		// changing the fill color depending on the state
		if (isHovered && !isPressed) {
			pg.fill(fgHoveredColor);
		} else if (isHovered && isPressed) {
			pg.fill(fgPressedColor);
		} else {
			pg.fill(fgPassiveColor);
		}
		// indicate whether the controller is currently selected
		if(isSelected(this)) {
		    pg.strokeWeight(2f);
		} else {
		    pg.strokeWeight(1f);
		}
		pg.rectMode(CORNER);
		pg.rect(0, 0, w, h, r1, r2, r3, r4);
		///////////////////////////////////////////////////
		// start drawing the 'arrow'
		///////////////////////////////////////////////////
		pg.pushMatrix();
		pg.translate(w * 0.5f, h * 0.5f);
		if (direction == UP) {
			pg.rotate(PI);
		} else if (direction == DOWN) {
			pg.rotate(0);
		} else if (direction == LEFT) {
			pg.rotate(HALF_PI);
		} else if (direction == RIGHT) {
			pg.rotate(HALF_PI + PI);
		}
		pg.strokeWeight(1f);
		pg.line(-w * 0.4f, -h * 0.4f, 0, h * 0.4f);
		pg.line(0, h * 0.4f, w * 0.4f, -h * 0.4f);
		pg.popMatrix();
        ///////////////////////////////////////////////////
		// stop drawing the 'arrow'
        ///////////////////////////////////////////////////
		pg.popStyle();
		pg.endDraw();
	}

	public void setDirection(int dir) {
		direction = dir;
	}

}
