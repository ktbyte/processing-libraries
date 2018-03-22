public class RadioInput {
  private int x, y;
  private float w, h;
  private ArrayList<RadioButton> radioButtons;
  private boolean displayBorder;
  private MouseEventListener mouseEventListener;
  private int textSize;
  private float textHeight;
  private float circleRadius;

  public RadioInput(int x, int y) {
    radioButtons = new ArrayList();
    this.x = x;
    this.y = y;
    textSize(14);
    this.textHeight = textAscent() + textDescent();
    this.circleRadius = textHeight;
    this.w = this.circleRadius * 3;
  }

  void addRadioButton(String option, String value) {
    if (this.getButtonWithOption(option) != null) {
      println("(!) Warning: can't have two buttons with the same option name. This will not be added");
    } else {
      radioButtons.add(new RadioButton(option, value));
      h += textHeight;
      println(textWidth(value));
      if (textWidth(value) > w - this.circleRadius * 3) {
        w = this.circleRadius * 3 + textWidth(value);
      }
    }
  }

  void addRadioButton(String option, String value, boolean isActive) {
    if (this.getButtonWithOption(option) != null) {
      println("(!) Warning: can't have two buttons with the same option name. This will not be added");
    } else {
      radioButtons.add(new RadioButton(option, value));
    }
    setActiveButton(option);
  }

  RadioButton getButtonWithOption(String option) {
    for (RadioButton btn : radioButtons) {
      if (btn.option.equals(option)) {
        return btn;
      }
    }
    return null;
  }

  void setDisplayBorder(boolean displayBorder) {
    this.displayBorder = displayBorder;
  }

  void setTextSize(int textSize) {
    this.textSize = textSize;
    textSize(this.textSize);
    this.textHeight = textAscent() + textDescent();
    this.circleRadius = textHeight;
  }

  void drawRadioInput() {
    pushStyle();
    fill(0);
    if (displayBorder) {
      pushStyle();
      noFill();
      rect(x, y, w, radioButtons.size() * 1.1 * textHeight, 6, 6, 6, 6);
      popStyle();
    }
    for (int i = 0; i < radioButtons.size(); i++) {
      noFill();
      if (radioButtons.get(i).isActive) {
        fill(0);
      }
      ellipse(x + circleRadius, y + i * 1.1 * textHeight + circleRadius, ((float) circleRadius)/2, ((float) circleRadius)/2);
      textAlign(LEFT, CENTER);
      text(radioButtons.get(i).value, x + circleRadius * 2, y + i * 1.1 * textHeight + circleRadius - 2);
    }
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
    for (RadioButton rb : radioButtons) {
      if (rb.isActive) {
        return rb;
      }
    }
    return null;
  }

  void setMouseEventListener(MouseEventListener mouseEventListener) {
    this.mouseEventListener = mouseEventListener;
  }

  void handleMousePressed() {
    for (int i = 0; i < radioButtons.size(); i++) {
      if (dist(x + circleRadius, y + i * 1.1 * textHeight + circleRadius, mouseX, mouseY) < ((float) circleRadius)/4) {
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