package ktbyte.gui;

import java.util.ArrayList;

import processing.event.MouseEvent;

public class EventProcessor {
	public boolean						isActive	= true;
	public boolean						isPressed;
	public boolean						isHovered;  
	public boolean						isDragged ; // is this controller being dragged right now?
	//public boolean						isFocused;  
	public boolean						isVisible	= true;
	public boolean						isDragable; // can this controller be dragged? 
	public boolean						handleFocus;

	public ArrayList<EventAdapter>	adapters	= new ArrayList<EventAdapter>();

	public void processMouseMoved() {}

	public void processMousePressed() {}

	public void processMouseReleased() {}

	public void processMouseDragged() {}

	public void processMouseWheel(MouseEvent me) {}

	public void processKeyPressed() {}

	public void processKeyReleased() {}

	public boolean isPointInside(int x, int y) {
		return false;
	}

	public void addEventAdapter(EventAdapter adapter) {
		adapters.add(adapter);
	}
}
