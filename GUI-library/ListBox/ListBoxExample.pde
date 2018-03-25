ListBox listBox;
Button btn;

PFont font;

/***************************************************************************************************
*
***************************************************************************************************/
void setup(){
  size(600, 400);

  font = createFont("monospace", ListBoxItem.vSize - 3);
  textFont(font);
  
  listBox = new ListBox(100, 100); 
  listBox.addItems(Arrays.asList("A", "B", "C", "D", "E"));
  
  btn = new Button(width - 150, 100, 100, 40);
  btn.addListener(new ButtonListener() {
    void onPressed(){
      listBox.addItem("Z" + listBox.items.size() - 5);
    }
  });
  btn.setTitle("Add Z");
}

void draw(){
  background(220);
  listBox.display();
  btn.draw();
}


void mousePressed(){
  listBox.processMousePressed();
  btn.processMousePressed(mouseX, mouseY);
}


void mouseMoved(){
  listBox.processMouseMoved();
  btn.processMouseHovered(mouseX, mouseY);
}

void mouseReleased(){
  btn.processMouseReleased();
}

//**********************************************************************************************
//
//**********************************************************************************************
public interface ButtonListener {
  void onPressed();
}

//**********************************************************************************************
//
//**********************************************************************************************
public class Button {
  private boolean isPressed, isHovered;
  private int x, y, width, height;
  private ArrayList<ButtonListener> btnListeners;
  private color HOVERED = color(100, 100, 200, 250);
  private color PRESSED = color(250, 50, 50);
  private color PASSIVE = color(180);
  private String title;

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  Button(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    btnListeners = new ArrayList<ButtonListener>();
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void draw() {
    pushMatrix();
    translate(x, y);
    pushStyle();
    if (isHovered) {
      strokeWeight(5);
      stroke(50, 200, 50);
      fill(HOVERED);
    } else {
      strokeWeight(2);
      stroke(50, 50, 200);
      fill(PASSIVE);
    }
    if (isPressed) {
      fill(PRESSED);
    }
    rectMode(CORNER);
    rect(0, 0, this.width, this.height, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    text(title, this.width/2, this.height/2);
    popMatrix();
    popStyle();
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  boolean isPointInside(int ptx, int pty) {
    boolean isInside = false;
    if (ptx > x && ptx < x + width) {
      if (pty > y && pty < y + height) {
        isInside = true;
      }
    }
    return isInside;
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void processMouseHovered(int x, int y) {
    if (isPointInside(x, y)) {
      isHovered = true;
    } else {
      isHovered = false;
    }
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void processMousePressed(int x, int y) {
    if (isPointInside(x, y)) {
      isPressed = true;
      
      // notify listeners
      for(ButtonListener listener: btnListeners){
        listener.onPressed();
      }
    }
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void processMouseReleased() {
    isPressed = false;
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void addListener(ButtonListener listener) {
    btnListeners.add(listener);
  }

  //---------------------------------------------------------------------------------------
  //
  //---------------------------------------------------------------------------------------
  void setTitle(String title){
    this.title = title;
  }
}

/***************************************************************************************************
 *
 ***************************************************************************************************/
abstract class EventListener {
  abstract void onListItemEvent(ListBoxItem item);
}

/***************************************************************************************************
 *
 ***************************************************************************************************/
class ListBox extends EventListener {

  int x, y;
  int boxWidth = 100;
  int boxHeight = 400;
  final static int itemSpace = 1;

  ListBoxItem selectedItem;
  ListBoxItem hoveredItem; 

  List<ListBoxItem> items;

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  ListBox(int x, int y) {
    this.x = x;
    this.y = y;
    items = new ArrayList<ListBoxItem>();
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void addItems(List<String> values) {
    for (int i = 0; i<values.size(); i++) {
      ListBoxItem item = new ListBoxItem(values.get(i), x, y + ListBox.itemSpace + i * ListBoxItem.vSize);
      item.addEventListener(this);
      items.add(item);
    }
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void addItem(String value) {
    int indexOfNewItem = items.size();
    ListBoxItem item = new ListBoxItem(value, x, y + ListBox.itemSpace + indexOfNewItem * ListBoxItem.vSize);
    item.addEventListener(this);
    items.add(item);
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void display() {
    for (int i=0; i<items.size(); i++) {
      items.get(i).display();
    }
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void processMousePressed() {
    for (ListBoxItem item : items) {
      item.processMousePressed();
    }
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void processMouseMoved() {
    for (ListBoxItem item : items) {
      item.processMouseMoved();
    }
  }

  void onListItemEvent(ListBoxItem item) {
    selectedItem = item;
    println("Selected item is - " + item.getValue());
  }
}

/***************************************************************************************************
 *
 ***************************************************************************************************/
private class ListBoxItem {
  final static int hSize = 200;
  final static int vSize = 20;

  int BG_HOVERED = color(50, 50, 220);
  int BG_PASSIVE = color(50, 50, 120);

  ArrayList<EventListener> listeners = new ArrayList<EventListener>();
  boolean isHovered;
  int posx, posy;

  String value;

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  ListBoxItem(String value, int posx, int posy) {
    this.value = value;
    this.posx = posx;
    this.posy = posy;
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void display() {
    pushMatrix();
    translate(posx, posy);
    pushStyle();
    rectMode(CORNER);
    strokeWeight(1);
    if (isHovered) {
      fill(BG_HOVERED);
    } else {
      fill(BG_PASSIVE);
    }
    rect(0, 0, hSize, vSize);
    textFont(font);
    textAlign(LEFT, CENTER);
    fill(255);
    text(value, 3, 8); 
    popStyle();
    popMatrix();
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  boolean isPointInside(int x, int y) {
    boolean isInside = false;
    if (x > posx && x < posx + hSize) {
      if (y > posy && y < posy + vSize) {
        isInside = true;
      }
    }
    return isInside;
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void processMouseMoved() {
    if (isPointInside(mouseX, mouseY)) {
      isHovered = true;
    } else {
      isHovered = false;
    }
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void processMousePressed() {
    if (isHovered) {
      println(value + " has been picked.");
      for (EventListener listener : listeners) {
        listener.onListItemEvent(this);
      }
    }
  }

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  void addEventListener(EventListener listener){
    listeners.add(listener);
  }
  
  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------
  String getValue(){
    return value;
  }
}
