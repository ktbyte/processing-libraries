package ktgui;

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
public class Pane extends Controller {

    Pane(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
        super(ktgui, title, posx, posy, w, h);
    }

    @Override
    public void updateGraphics() {
        super.updateGraphics();
        pg.beginDraw();
        pg.background(200, 100);
        if (isFocused) {
            pg.strokeWeight(2f);
        } else if (!isFocused) {
            pg.strokeWeight(1f);
        }
        pg.rectMode(CORNER);
        pg.rect(0, 0, w, h, r1, r2, r3, r4);
        pg.noFill();
        pg.endDraw();
    }
}
