package ktgui;

/*****************************************************************************************************
 * 
 ****************************************************************************************************/
public class CloseButton extends Button {

	public CloseButton(KTGUI ktgui, int posx, int posy, int w, int h) {
		super(ktgui, posx, posy, w, h);
	}

	public CloseButton(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
	}

	public void updateGraphics() {
		pg.beginDraw();
		pg.rectMode(CORNER);
		if (isHovered && !isPressed) {
			pg.fill(ktgui.COLOR_FG_HOVERED);
		} else if (isHovered && isPressed) {
			pg.fill(ktgui.COLOR_FG_PRESSED);
		} else {
			//pg.fill(ktgui.COLOR_FG_PASSIVE);
			pg.fill(200, 200);
		}
		pg.stroke(0);
		pg.strokeWeight(1);
		pg.rectMode(CORNER);
		pg.rect(0, 0, w, h);
		pg.line((int)(w * 0.2), (int)(h * 0.2), (int)(w * 0.8), (int)(h * 0.8));
		pg.line((int)(w * 0.2), (int)(h * 0.8), (int)(w * 0.8), (int)(h * 0.2));
		pg.endDraw();
	}

	public void processMousePressed() {
		super.processMousePressed();
		if (isPressed) {
			//closeControllerRecursivelyUpward(parentController); // closeButton --> TitleBar --> Window --> Pane, Button, Button, Window --> TitleBar
			closeControllerRecursively(this); // closeButton --> TitleBar --> Window --> Pane, Button, Button, Window --> TitleBar
		}
	}
}
