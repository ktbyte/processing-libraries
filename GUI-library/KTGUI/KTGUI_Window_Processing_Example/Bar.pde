class Bar extends Controller {
  
  CloseButton closeButton;
  
  Bar(int x, int y, int w, int h) {
    this.posx = x;
    this.posy = y;
    this.w  = w;
    this.h = h;
  }
  
  void draw() {
    // drawBar and title
    pg.beginDraw();
    pg.background(200, 200);
    pg.rectMode(CORNER);
    pg.fill(180);
    pg.stroke(15);
    pg.strokeWeight(1);
    pg.rect(0, 0, w, ktgui.TITLE_BAR_HEIGHT);
    pg.fill(25);
    pg.textAlign(LEFT, CENTER);
    pg.textSize(ktgui.TITLE_BAR_HEIGHT*0.65);
    pg.text(title, 10, ktgui.TITLE_BAR_HEIGHT*0.5);
    pg.endDraw();  
  }
}

class TitleBar extends Bar {
  TitleBar(int x, int y, int w, int h) {
    super(x, y, w, h);
  }
}
