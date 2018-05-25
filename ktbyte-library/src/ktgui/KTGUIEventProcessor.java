package ktgui;

import java.util.ArrayList;

import processing.event.MouseEvent;

public class KTGUIEventProcessor {
	public boolean						isPressed, isHovered;
	public boolean						isActive	= true;
	public boolean						isDragable	= true;
	public boolean						isFocused;
	
	public ArrayList<KTGUIEventAdapter>	adapters	= new ArrayList<KTGUIEventAdapter>();

	public void processMouseMoved() {}

	public void processMousePressed() {}

	public void processMouseReleased() {}

	public void processMouseDragged() {}
	
	public void processMouseWheel(MouseEvent me) {}

	public void processKeyPressed() {}

	public void processKeyReleased() {}

	public void addEventAdapter(KTGUIEventAdapter adapter) {
		adapters.add(adapter);
	}
}
