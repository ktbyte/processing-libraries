package ktbyte.gui;

/**********************************************************************************************************************
 * This is a KTGUI component (controller).
 * This class extends the 'Controller' class.
 * The object of this class can be 'Pressed', 'Hovered', 'Released' and 'Dragged'.
 *********************************************************************************************************************/
public class Button extends Controller {
	/**
	 * FIX : all button emitting the 'mouseRelease' event ??? 
	 * 
	 */
    public Button(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
        super(ktgui, title, posx, posy, w, h);
    }

    @Override
    public void updateGraphics() {
        super.updateGraphics();
        pg.beginDraw();
        pg.rectMode(CORNER);
        if (isHovered && !isPressed) {
            pg.fill(fgHoveredColor);
        } else if (isHovered && isPressed) {
            pg.fill(fgPressedColor);
        } else {
            pg.fill(fgPassiveColor);
        }
        // indicate whether the controller is currently selected
        if (isFocused) {
            pg.strokeWeight(2f);
        } else if (!isFocused) {
            pg.strokeWeight(1f);
        }
        pg.rect(0, 0, w, h, r1, r2, r3, r4);
        pg.fill(255);
        pg.textAlign(CENTER, CENTER);
        pg.textSize(14);
        pg.text(title, (int) (w * 0.5), (int) (h * 0.5));
        pg.endDraw();
    }

}
