RadioInput ri;

void setup() {
  size(600, 400);
  ri = new RadioInput(this, 50, 50);
  ri.addRadioButton("male", "Male", true);
  ri.addRadioButton("female", "Female");
  ri.addRadioButton("other1", "Other1");
  ri.addRadioButton("other2", "Other2");
  ri.addRadioButton("other3", "Other3");

  ri.setActiveButton("female");
  ri.setActiveButton("unknown");
  ri.setTextSize(24);
  ri.setDisplayBackground(true);
  ri.setBulletColor(color(0, 100, 200));
  ri.setTextColor(color(10, 10, 100));
  ri.setMouseEventListener(new MouseEventListener() {
    // use the "public" modifier for the onMousePressed method in order to work in Processing
    void onMousePressed() {
      println(ri.getActiveValue());
    }
  }  
  );
}

void draw() {
  background(200);
}

public class RadioInput {
  private int x, y;
  private float w, h;
  private ArrayList<RadioButton> radioButtons;
  private boolean displayBackground;
  private MouseEventListener mouseEventListener;
  private int textSize;
  private float textHeight;
  private float circleRadius;
  private color textColor;
  private color bulletColor;
  private color backgroundColor;
  private boolean recalculationFlag;
  private PApplet pap;

  public RadioInput(PApplet pap, int x, int y) {
    this.pap = pap;
    this.pap.registerMethod("draw", this);
    this.pap.registerMethod("mouseEvent", this);
    radioButtons = new ArrayList();
    this.x = x;
    this.y = y;
    textSize(14);
    this.textHeight = textAscent() + textDescent();
    this.circleRadius = textHeight/3;
    this.w = this.circleRadius * 4;
    this.textColor = color(0);
    this.bulletColor = color(0);
    this.backgroundColor = color(255);
  }

  void calculateBackgroundDimensions() {
    this.h = circleRadius * 2; 
    this.w = 0;
    for (RadioButton rBtn : radioButtons) {
      h += textHeight;
      if (textWidth(rBtn.value) > w - this.circleRadius * 5) {
        w = this.circleRadius * 5 + textWidth(rBtn.value);
      }
    }
    recalculationFlag = false;
  }

  void addRadioButton(String option, String value) {
    if (this.getButtonWithOption(option) != null) {
      println("(!) Warning: can't have two buttons with the same option name. This will not be added");
    } else {
      radioButtons.add(new RadioButton(option, value));
    }
    recalculationFlag = true;
  }

  void addRadioButton(String option, String value, boolean isActive) {
    if (this.getButtonWithOption(option) != null) {
      println("(!) Warning: can't have two buttons with the same option name. This will not be added");
    } else {
      RadioButton rBtn = new RadioButton(option, value);
      radioButtons.add(rBtn);
    }
    if (isActive) {
      setActiveButton(option);
    }
    recalculationFlag = true;
  }

  RadioButton getButtonWithOption(String option) {
    for (RadioButton rBtn : radioButtons) {
      if (rBtn.option.equals(option)) {
        return rBtn;
      }
    }
    return null;
  }

  void setDisplayBackground(boolean displayBackground) {
    this.displayBackground = displayBackground;
  }

  void setTextColor(color textColor) {
    this.textColor = textColor;
  }

  void setBulletColor(color bulletColor) {
    this.bulletColor = bulletColor;
  }

  void setBackgroundColor(color backgroundColor) {
    this.backgroundColor = backgroundColor;
  }

  void setTextSize(int textSize) {
    this.textSize = textSize;
    textSize(this.textSize);
    this.textHeight = textAscent() + textDescent();
    this.circleRadius = textHeight/3;
    this.w = this.circleRadius * 4;
  }

  void draw() {
    pushStyle();
    fill(0);
    if (displayBackground) {
      drawBackground();
    }
    for (int i = 0; i < radioButtons.size(); i++) {
      noFill();
      if (radioButtons.get(i).isActive) {
        fill(bulletColor);
      }
      ellipse(x + circleRadius*2, y + i * 1.1 * textHeight + circleRadius*2, ((float) circleRadius*2), ((float) circleRadius*2));
      fill(textColor);
      textAlign(LEFT, CENTER);
      text(radioButtons.get(i).value, x + circleRadius * 4, y + i * 1.1 * textHeight + circleRadius * 2 - 2);
    }
    popStyle();
  }

  void drawBackground() {
    pushStyle();
    if (recalculationFlag) {
      calculateBackgroundDimensions();
    }
    fill(backgroundColor);
    rect(x, y, w, h, 6, 6, 6, 6);
    popStyle();
  }

  void setActiveButton(String option) {
    RadioButton activeRadioBtn = getActiveButton();
    RadioButton radioBtnToActivate = getButtonWithOption(option);
    if (radioBtnToActivate != null && !radioBtnToActivate.equals(activeRadioBtn)) {
      getButtonWithOption(option).isActive = true;
      if (activeRadioBtn != null) {
        activeRadioBtn.isActive = false;
      }
    }
  }

  String getActiveValue() {
    RadioButton activeRadioBtn = getActiveButton();

    if (activeRadioBtn != null) {
      return getActiveButton().value;
    }
    return null;
  }

  String getActiveOption() {
    return getActiveButton().option;
  }

  RadioButton getActiveButton() {
    for (RadioButton rBtn : radioButtons) {
      if (rBtn.isActive) {
        return rBtn;
      }
    }
    return null;
  }

  void setMouseEventListener(MouseEventListener mouseEventListener) {
    this.mouseEventListener = mouseEventListener;
  }

  void mouseEvent(MouseEvent e) {
    if (e.getAction() == MouseEvent.PRESS) {
      this.mousePressed();
    }
  }

  void mousePressed() {
    for (int i = 0; i < radioButtons.size(); i++) {
      if (dist(x + circleRadius*2, y + i * 1.1 * textHeight + circleRadius*2, mouseX, mouseY) < ((float) circleRadius)) {
        setActiveButton(radioButtons.get(i).option);
      }
    }
    mouseEventListener.onMousePressed();
  }

  private class RadioButton {
    boolean isActive;
    String option;
    String value;

    RadioButton(String option, String value) {
      this.option = option;
      this.value = value;
    }
  }
}

abstract class MouseEventListener {

  abstract void onMousePressed();

  /* 
   * Method used as a workaround, so that the println statements from the onEnterKey() method 
   * will work in the KYByte coder
   */
  void println(String text) {
    PApplet.println(text);
  };
}
