package ktbyte.gui;

/*****************************************************************************************************
 * 
 ****************************************************************************************************/
class CloseButton extends Button {

	public CloseButton(KTGUI ktgui, String title, int posx, int posy, int w, int h) {
		super(ktgui, title, posx, posy, w, h);
		this.isDragable = false; // just to make sure
	}
	
	@Override
	public void updateGraphics() {
        super.updateGraphics();
		pg.beginDraw();
		pg.rectMode(CORNER);
		if (isHovered && !isPressed) {
			pg.fill(KTGUI.COLOR_FG_HOVERED);
		} else if (isHovered && isPressed) {
			pg.fill(KTGUI.COLOR_FG_PRESSED);
		} else {
			//pg.fill(ktgui.COLOR_FG_PASSIVE);
			pg.fill(200, 200);
		}
		pg.stroke(0);
		pg.strokeWeight(1);
		pg.rectMode(CORNER);
		pg.rect(0, 0, w, h);
		pg.line(w * 0.2f, h * 0.2f, w * 0.8f, h * 0.8f);
		pg.line(w * 0.2f, h * 0.8f, w * 0.8f, h * 0.2f);
		pg.endDraw();
	}

	/**
	 * TODO : replace 'closeControllerRecursively' method with 'closeParentWindow' in 
	 * order to prevent closing ALL controllers up to the 'root'. That behaviour is not
	 * right - the CloseButton of the Window.TitleBar should close only the parent Window
	 * and all it's childs (and their childs).
	 */
	@Override
	public void processMousePressed() {
		super.processMousePressed();
		if (isPressed) {
			closeParent();
		}
	}
	
	/**
	 * This method closes all the controllers recursively up to the parent Window
	 * and then closes all its childs recursively down. 
	 */
	@Override
	public void closeParent() {
		if (parentController != null) {
			if(!parentController.getClass().getName().contains("Window")) {
				parentController.closeParent();
			}
			parentController.close();
		}
		closeAllChildsRecursively();
	}
}