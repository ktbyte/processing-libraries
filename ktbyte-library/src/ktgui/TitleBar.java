package ktgui;

class TitleBar extends Bar {

	CloseButton closeButton;

	TitleBar(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		closeButton = new CloseButton(ktgui, "cb:" + this.title, w - KTGUI.TITLE_BAR_HEIGHT + 2, 2,
				KTGUI.TITLE_BAR_HEIGHT - 4, KTGUI.TITLE_BAR_HEIGHT - 4);
		attachController(closeButton);
		registerChildController(closeButton);
	}

}
