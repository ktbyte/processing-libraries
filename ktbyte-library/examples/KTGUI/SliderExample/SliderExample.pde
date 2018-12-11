import ktbyte.gui.*;

KTGUI ktgui;
Button btn;
Slider slider;

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
void setup() {
  size(400, 300);

  // instance of the KTGUI class
  ktgui = new KTGUI(this);

  // instance of the KTGUI 'Button' component
  btn = ktgui.createButton(0, (int)(height * 0.25f), 150, 40);
  btn.isDragable = true;
  btn.alignAboutCanvas(CENTER, 0);
  btn.setPressedColor(color(200, 150, 150));
  btn.setTitle("The Button");
  btn.addEventAdapter(new KTGUIEventAdapter() {
    // we can override only those callback methods which we really need
    public void onMousePressed() {
      btn.setTitle(btn.isPressed ? "Pressed" : "The Button");
    }
    // we can override only those callback methods which we really need
    public void onMouseReleased() {
      btn.setTitle(btn.isPressed ? "The Button" : "Released");
    }
    // we can override only those callback methods which we really need
    public void onMouseMoved() {
      btn.setTitle(btn.isHovered ? "Hovered" : "The Button");
    }
    // we can override only those callback methods which we really need
    public void onMouseDragged() {
      if (btn.isPressed) {
        btn.setTitle("Dragged");
      } else {
        btn.setTitle("The Button");
      }
    }
  }
  );

  // instance of the KTGUI 'Button' component
  slider = ktgui.createSlider(0, 0, 380, 40, 0, 1000);
  slider.alignAboutCanvas(CENTER, TOP);
  slider.setTitle("The Slider");
  slider.addEventAdapter(new KTGUIEventAdapter() {
    // we can override only those callback methods which we really need
    public void onMousePressed() {
      slider.setTitle(slider.isPressed ? "Pressed" : "The Slider");
      if (slider.isPressed) {
        int sliderValue = (int)slider.getValue();
        int mappedPos = (int)map(sliderValue, slider.getRangeStart(), slider.getRangeEnd(), 0, width - btn.w);
        btn.posx = mappedPos;
      }
    }
    // we can override only those callback methods which we really need
    public void onMouseReleased() {
      slider.setTitle(slider.isPressed ? "The Slider" : "Released");
    }
    // we can override only those callback methods which we really need
    public void onMouseMoved() {
      slider.setTitle(slider.isHovered ? "Hovered" : "The Slider");
    }
    // we can override only those callback methods which we really need
    public void onMouseDragged() {
      slider.setTitle(slider.isPressed ? "Dragged" : "The Slider");
      if (slider.isPressed) {
        int sliderValue = (int)slider.getValue();
        int mappedPos = (int)map(sliderValue, slider.getRangeStart(), slider.getRangeEnd(), 0, width - btn.w);
        btn.posx = mappedPos;
      }
    }
  }
  );
}

/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
void draw() {
  background(100, 20, 255);
  pushStyle();
  textAlign(CENTER, CENTER);
  textSize(24);
  text("Drag the button!", width * 0.5f, height * 0.5f);
  popStyle();
}
