public class TextBox {
  private final static int ENTER_ASCII_CODE = 10;
  private final static int BASIC_ASCII_LOWER_LIMIT = 32;
  private final static int BASIC_ASCII_UPPER_LIMIT = 126;

  private int x, y, w, h;
  private int r1, r2, r3, r4;
  private boolean isFocused;
  private String textInput;
  private int textSize;
  private float textHeight;
  private KeyEventListener keyEventListener;
  private float padding;
  private PApplet pap;

  public TextBox(PApplet pap, int x, int y, int w, int h) {
    this.pap = pap;
    this.pap.registerMethod("draw", this);
    this.pap.registerMethod("mouseEvent", this);
    this.pap.registerMethod("keyEvent", this);
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.textSize = 18;
    computeDefaultAttributes();
  }
  
  void setBorderRoundings(int r1, int r2, int r3, int r4) {
    this.r1 = r1;
    this.r2 = r2;
    this.r3 = r3;
    this.r4 = r4;
  }

  void computeDefaultAttributes() {
    this.padding = 0.08 * h;
    textSize(this.textSize);
    this.textHeight = textAscent() + textDescent();
    computeTextSize();
  }

  void computeTextSize() {
    while (textHeight > h - padding * 2) {
      this.textSize--;
      textSize(this.textSize);
      this.textHeight = textAscent() + textDescent();
    }
  }

  void draw() {
    pushStyle();
    fill(255);
    noStroke();
    rect(x, y, w, h, r1, r2, r3, r4);
    fill(0);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getTrimmedInputText(textInput), x + padding, y + h/2);
    drawBlinkingInputCursor();
    popStyle();
  }

  void mouseEvent(MouseEvent e) {
    if (e.getAction() == MouseEvent.PRESS) {
      this.mousePressed();
    }
  }

  void keyEvent(KeyEvent e) {
    if (e.getAction() == KeyEvent.PRESS) {
      this.keyPressed();
    }
  }

  void keyPressed() {
    if (!isFocused) {
      return;
    }

    if (key == CODED) {
      // temporary using the LEFT key instead of backspace since the browser(Chrome) is using the BACKSPACE as a hotkey
      if (keyCode == LEFT && textInput.length() > 0) {
        textInput = textInput.substring(0, textInput.length() - 1);
      }
    } else {
      if ((int) key == ENTER_ASCII_CODE) {
        keyEventListener.onEnterKey();
        this.isFocused = false;
      } else if ((int) key >= BASIC_ASCII_LOWER_LIMIT && (int) key <= BASIC_ASCII_UPPER_LIMIT) {
        byte b = (byte) key;
        char ch = (char) b;
        textInput += ch;
      }
    }
  }

  void mousePressed() {
    if (this.isInside()) {
      this.isFocused = true;
    } else {
      this.isFocused = false;
    }
  }

  boolean isInside() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }

  void setText(String text) {
    this.textInput = text;
  }

  void setTextSize(int textSize) {
    this.textSize = textSize;
    computeDefaultAttributes();
  }

  String getText() {
    return this.textInput;
  }

  boolean isFocused() {
    return isFocused;
  }

  void setIsFocused(boolean isFocused) {
    this.isFocused = isFocused;
  }

  void setKeyEventListener(KeyEventListener keyEventListener) {
    this.keyEventListener = keyEventListener;
  }

  String getTrimmedInputText(String textInput) {
    String trimmedTextInput = "";
    char[] textInputCharArray = textInput.toCharArray();
    for (int i = textInputCharArray.length - 1; i >= 0; i--) {
      if (textWidth(trimmedTextInput) + textWidth(textInputCharArray[i]) < w - padding * 2) {
        trimmedTextInput = textInputCharArray[i] + trimmedTextInput;
      } else {
        break;
      }
    }
    return trimmedTextInput;
  };

  void drawBlinkingInputCursor() {
    if (!isFocused) {
      return;
    }
    stroke(0);
    if (frameCount % 60 < 30) {
      float cursorX = min(x + w - padding, x + textWidth(textInput) + padding);
      line(cursorX, y + h/2 - textHeight/2, cursorX, y+ h/2 + textHeight/2);
    }
  }
}

abstract class KeyEventListener {

  abstract void onEnterKey();

  /* 
   * Method used as a workaround, so that the println statements from the onEnterKey() method 
   * will work in the KYByte coder
   */
  void println(String text) {
    PApplet.println(text);
  };
}