package ktgui;

public class ScrollableTextArea extends Controller {

	public ScrollableTextArea(KTGUI ktgui, String title, int x, int y, int w, int h) {
		super(ktgui);
		
		this.title = title;
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;
		
		pg = pa.createGraphics(w + 1, h + 1);
		userpg = pa.createGraphics(w + 1, h + 1);
		
		StageManager.getInstance().getDefaultStage().registerController(this);
	}

}
