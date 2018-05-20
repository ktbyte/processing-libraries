package ktgui;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PGraphics;

public class Test extends KTGUIEventProcessor implements PConstants {
	public PApplet					pa;
	public KTGUI					ktgui;
	public String					title;
	public int						posx, posy, w, h;

	public ArrayList<Controller>	controllers	= new ArrayList<Controller>();
	public Controller				parentController = null;
	public Stage					parentStage	= null;

	public PGraphics				pg;
	public PGraphics				userpg;

	public int						hoveredColor;
	public int						pressedColor;
	public int						passiveColor;

	public void setParents(KTGUI ktgui) {
		this.ktgui = ktgui;
		this.pa = ktgui.getPa();

		init();
	}

	private void init() {
		hoveredColor = ktgui.COLOR_FG_HOVERED;
		pressedColor = ktgui.COLOR_FG_PRESSED;
		passiveColor = ktgui.COLOR_FG_PASSIVE;
	}
}
