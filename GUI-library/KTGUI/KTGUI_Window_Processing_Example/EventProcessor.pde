class EventProcessor {
  boolean isPressed, isHovered;
  boolean isActive = true;
  boolean isDragable = true;

  ArrayList<KTGUIEventAdapter> adapters = new ArrayList<KTGUIEventAdapter>();

  void processMouseMoved() {
  }
  void processMousePressed() {
  }
  void processMouseReleased() {
  }
  void processMouseDragged() {
  }
  void processKeyPressed() {
  }
  void processKeyReleased() {
  }
  void addEventAdapter(KTGUIEventAdapter adapter) {
    adapters.add(adapter);
  }
}
