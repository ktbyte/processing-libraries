package ktbyte.gui;

import java.util.ArrayList;

import processing.event.MouseEvent;

public class EventProcessor {
    // defines if we can interact with this controller at this moment
    public boolean                 isActive  = true;
    // defines if this controller being pressed right now
    public boolean                 isPressed;
    // defines if this controller being hovered right now
    public boolean                 isHovered;
    // defines if this controller being dragged right now
    public boolean                 isDragged;
    // defines if we should display this controller at this moment
    public boolean                 isVisible = true;
    // defines if this controller can be dragged at this moment
    public boolean                 isDragable;                               
    // public boolean isFocused;
    public boolean                 handleFocus;

    public ArrayList<EventAdapter> adapters  = new ArrayList<EventAdapter>();

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
