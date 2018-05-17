package ktgui;

import java.util.ArrayList;

class EventProcessor {
	boolean							isPressed, isHovered;
	boolean							isActive	= true;
	boolean							isDragable	= true;

	ArrayList<KTGUIEventAdapter>	adapters	= new ArrayList<KTGUIEventAdapter>();

	public void processMouseMoved() {}

	public void processMousePressed() {}

	public void processMouseReleased() {}

	public void processMouseDragged() {}

	public void processKeyPressed() {}

	public void processKeyReleased() {}

	public void addEventAdapter(KTGUIEventAdapter adapter) {
		adapters.add(adapter);
	}
}
