BasicLibrary bl;

void setup() {
  bl = new BasicLibrary(this);
  size(300,300);
}

void draw() {
  background(100,20,255);
}

public class BasicLibrary {
  PApplet pa;

  public BasicLibrary(PApplet pa) {
    this.pa = pa;
    this.pa.registerMethod("draw", this);
    this.pa.registerMethod("mouseEvent", this);
    this.pa.registerMethod("keyEvent", this);
  }

  void draw() {
    fill(200, 100, 60);
    ellipse(100, 100, 40, 40);
  }
  
  void mouseEvent(MouseEvent e) {
    switch (e.getAction()) {
      case MouseEvent.PRESS:
        this.mousePressed();
        break;
      case MouseEvent.RELEASE:
        this.mouseReleased();
        break;
      case MouseEvent.CLICK:
        this.mouseClicked();
        break;
      case MouseEvent.DRAG:
        this.mouseDragged();
        break;
      case MouseEvent.MOVE:
        this.mouseMoved();
        break;    
    }
  }
  
    void keyEvent(KeyEvent e) {
      switch (e.getAction()) {
        case KeyEvent.PRESS:
          this.keyPressed();
          break;
        case KeyEvent.RELEASE:
          this.keyReleased();
          break;
        case KeyEvent.TYPE:
          this.keyTyped();
          break;
      }
  }
  
  void mouseClicked() {
    println("Click at: " + mouseX + " " + mouseY);
  }
  
  void mouseDragged() {
    println("Dragged!");
  }
  
  void mousePressed() {
    println("Press at: " + mouseX + " " + mouseY);
  }
  
  void mouseReleased() {
    println("Release at: " + mouseX + " " + mouseY);
  }
  
  void mouseMoved() {
    println("Moved!");
  }
  
  void keyTyped() {
    println("key Typed!");
  }
  
  void keyPressed() {
    println("Pressed key: " + keyCode);
  }
  
  void keyReleased() {
      println("Released key: " + keyCode);
  }
}
