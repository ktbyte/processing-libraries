package ktgui;

public class TitleBar extends Bar {

	CloseButton closeButton;

	public TitleBar(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		closeButton = new CloseButton(ktgui, "cb:" + this.title, w - h + 2, 2,
				h - 4, h - 4);
		attachController(closeButton);
		registerChildController(closeButton);
	}

}
