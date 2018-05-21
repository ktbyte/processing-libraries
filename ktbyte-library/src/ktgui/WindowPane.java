package ktgui;


class WindowPane extends Pane {
  Window parentWindow;
  
  WindowPane(KTGUI ktgui, Window window, int posx, int posy, int w, int h) {
    super(ktgui, posx, posy, w, h);
    this.parentWindow = window;
  }

  WindowPane(KTGUI ktgui, String title, Window window, int posx, int posy, int w, int h) {
    super(ktgui, title, posx, posy, w, h);
    this.parentWindow = window;
  }
}
