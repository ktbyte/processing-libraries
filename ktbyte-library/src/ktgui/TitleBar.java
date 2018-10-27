package ktgui;

class TitleBar extends Bar {

	CloseButton	closeButton;
	Window		parentWindow;

	TitleBar(KTGUI ktgui, Window window, int x, int y, int w, int h) {
		super(ktgui, x, y, w, h);
		this.parentWindow = window;
		closeButton = new CloseButton(ktgui, w - KTGUI.TITLE_BAR_HEIGHT + 2, 2,
				KTGUI.TITLE_BAR_HEIGHT - 4, KTGUI.TITLE_BAR_HEIGHT - 4);
		attachController(closeButton);
		registerChildController(closeButton);
	}

	TitleBar(KTGUI ktgui, String title, Window window, int x, int y, int w, int h) {
		super(ktgui, title, x, y, w, h);
		this.parentWindow = window;
		closeButton = new CloseButton(ktgui, "cb:" + this.title, w - KTGUI.TITLE_BAR_HEIGHT + 2, 2,
				KTGUI.TITLE_BAR_HEIGHT - 4, KTGUI.TITLE_BAR_HEIGHT - 4);
		attachController(closeButton);
		registerChildController(closeButton);
	}

}
