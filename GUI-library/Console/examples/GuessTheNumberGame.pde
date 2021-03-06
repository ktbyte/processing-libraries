Console console;
int number = 3;

void setup() {
  size(800, 600);
  console = new Console(this, 50, 50, 600, 400);
  console.setInputTextColor(color(255, 10, 100));
  console.setOutputTextColor(color(130, 90, 190));
  console.setTextSize(14);
  console.write("I'm thinking of a number between 0 and 9. Try to guess!");
  console.readInput("number");

  console.setConsoleInputListener(new ConsoleInputListener() {

    // use the "public" modifier for the onConsoleInput method in order to work in Processing
    void onConsoleInput(String variable, String value) {
      if (variable.equals("number")) {
        try {
          if (Integer.parseInt(value) < number) {
            console.write("Too small. Try again!");
            console.readInput("number");
          } else if (Integer.parseInt(value) > number) {
            console.write("Too big. Try again!");
            console.readInput("number");
          } else {
            console.write("Exactly!");
          }
        } catch (Exception e) {
          println("The input was not a number..");
        }
      }
    }
  }
  );
}

void draw() {
  background(144);
}

public class Console {
  private final static int BACKSPACE_ASCII_CODE = 8;
  private final static int ENTER_ASCII_CODE = 10;
  private final static int BASIC_ASCII_LOWER_LIMIT = 32;
  private final static int BASIC_ASCII_UPPER_LIMIT = 126;
  private final static int BOX_RONDING = 7;
  private final static int SCROLL_BAR_WIDTH = 20;
  private final static float INPUT_BOX_HEIGHT_PERCENTAGE = 0.1;

  private int x, y;
  private int w, h;
  private color inputTextColor;
  private color outputTextColor;
  private ArrayList<Line> lines;
  private String textInput;
  private int inputBoxHeight;
  private HashMap<String, String> dict;
  private ConsoleInputListener consoleInputListener;
  private String lastVariableName;
  private int globalPadding;
  private int lineScrollOffset;
  private boolean isFocused;
  private int textSize;
  private int maxLinesToDisplay;
  private float textHeight;
  private ArrowButton upBtn;
  private ArrowButton downBtn;
  private float scrollBarMaxHeight;
  private PApplet pap;

  public Console(PApplet pap, int x, int y, int width, int height) {
    this.pap = pap;
    this.pap.registerMethod("draw", this);
    this.pap.registerMethod("mouseEvent", this);
    this.pap.registerMethod("keyEvent", this);
    this.inputTextColor = color(255);
    this.outputTextColor = color(170);
    this.x = x;
    this.y = y;
    this.w = width;
    this.h = height;
    this.globalPadding = 10;
    this.inputBoxHeight = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);
    this.lines = new ArrayList();
    this.dict = new HashMap<String, String>();
    this.textInput = "";
    computeDefaultAttributes();
  }

  void computeDefaultAttributes() {
    if (h < 400) {
      this.textSize = 18;
    } else if (h < 900) {
      this.textSize = 22;
    } else {
      this.textSize = 24;
    }
    textSize(this.textSize);
    this.textHeight = textAscent() + textDescent();
    this.maxLinesToDisplay = computeMaxLinesToDisplay();
    this.scrollBarMaxHeight = h - inputBoxHeight - SCROLL_BAR_WIDTH * 2;
  }

  int computeMaxLinesToDisplay() {
    return (int) ((0.9 * h - globalPadding * 2) / (textHeight + 2));
  }

  void draw() {
    pushStyle();
    drawConsoleTextBox();
    drawInputBox();
    drawScrollBar();
    popStyle();
  }

  void drawConsoleTextBox() {
    rectMode(CORNER);
    fill(0);
    noStroke();
    rect(x, y, w - SCROLL_BAR_WIDTH, h - inputBoxHeight, BOX_RONDING, 0, 0, 0);
    textSize(textSize);
    textAlign(LEFT, TOP);    
    int consoleStartLine = max(0, lines.size() - maxLinesToDisplay + lineScrollOffset);
    int consoleEndLine = min(lines.size(), consoleStartLine + maxLinesToDisplay);

    for (int i = consoleStartLine, j=0; i < consoleEndLine; i++, j++) {
      stroke(lines.get(i).textColor);
      fill(lines.get(i).textColor);
      text(lines.get(i).text, x + globalPadding, y + j * (textHeight + 2) + globalPadding);
    }
  }

  void drawScrollBar() {
    noStroke();
    fill(50);
    rect(x + w - SCROLL_BAR_WIDTH, y, SCROLL_BAR_WIDTH, h - inputBoxHeight, 0, BOX_RONDING, 0, 0);
    upBtn = new ArrowButton(x + w - SCROLL_BAR_WIDTH, y, SCROLL_BAR_WIDTH, 0, 0, BOX_RONDING, 0, 0);
    downBtn = new ArrowButton(x + w - SCROLL_BAR_WIDTH, y + h - inputBoxHeight - 20, SCROLL_BAR_WIDTH, 2);
    fill(120);

    float scrollBarHeight = scrollBarMaxHeight;
    if (lines.size() > maxLinesToDisplay) {
      scrollBarHeight = max(25, ((float) maxLinesToDisplay/lines.size()) * scrollBarMaxHeight);
    }
    int consoleScrollableLines = lines.size() - maxLinesToDisplay;
    float trackScrollArea = h - inputBoxHeight - SCROLL_BAR_WIDTH * 2 - scrollBarHeight;
    float scrollBarYCoordinate = y + SCROLL_BAR_WIDTH + trackScrollArea;
    if (lines.size() > maxLinesToDisplay) {
      scrollBarYCoordinate = y + SCROLL_BAR_WIDTH + trackScrollArea - (-lineScrollOffset * ((float) trackScrollArea/consoleScrollableLines));
    }
    rectMode(CORNER);
    rect(x + w - SCROLL_BAR_WIDTH, scrollBarYCoordinate, SCROLL_BAR_WIDTH, scrollBarHeight);

    upBtn.drawButton();
    downBtn.drawButton();
  }

  void drawInputBox() {
    fill(255);
    noStroke();
    rect(x, y + h - inputBoxHeight, w, inputBoxHeight, 0, 0, BOX_RONDING, BOX_RONDING);
    fill(0);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getTrimmedInputText(textInput), x + globalPadding, y + 0.9 * h + inputBoxHeight/2);
    drawBlinkingInputCursor();
  }

  String getTrimmedInputText(String textInput) {
    String trimmedTextInput = "";
    char[] textInputCharArray = textInput.toCharArray();
    for (int i = textInputCharArray.length - 1; i >= 0; i--) {
      if (textWidth(trimmedTextInput) + textWidth(textInputCharArray[i]) < w - globalPadding * 2) {
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
      float cursorX = min(x + w - globalPadding, x + textWidth(textInput) + globalPadding);
      line(cursorX, y + h - inputBoxHeight + 10, cursorX, y + h - 10);
    }
  }

  void write(String text) {
    splitCommandBasedOnConsoleWidth(new Command(text, false));
    lastVariableName = "";
  }

  void splitCommandBasedOnConsoleWidth(Command command) {
    Line line = new Line();
    textSize(textSize);
    String[] wordsFromCommand = split(command.text, " ");
    int i = 0;
    while (i < wordsFromCommand.length) {
      if (textWidth(line.text + " ") + textWidth(wordsFromCommand[i]) < w - SCROLL_BAR_WIDTH) {
        line.text += wordsFromCommand[i] + " ";
        line.textColor = (command.isInput ? inputTextColor : outputTextColor);
        i++;
      } else {
        lines.add(line);
        line = new Line();
      }
    }
    lines.add(line);
  }

  String getValue(String name) {
    return dict.get(name);
  }

  void readInput(String name) {
    this.lastVariableName = name;
  }

  void mouseEvent(MouseEvent e) {
    if (e.getAction() == MouseEvent.PRESS) {
      mousePressed();
    } else if (e.getAction() == MouseEvent.WHEEL) {
      mouseWheel(e);
    }
  }
  
    // used by processing.js
  void mouseScrolled(int mouseWheelDelta) {
    if (!this.isFocused) {
        return;
    }
    if (mouseWheelDelta < 0) {
      if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
        lineScrollOffset--;
      }
    } else if (mouseWheelDelta > 0) {
      if (lineScrollOffset < 0) {
        lineScrollOffset++;
      }
    }
  }
  
  void mouseWheel(MouseEvent e) {
    mouseScrolled(e.getCount());
  }

  void keyEvent(KeyEvent e) {
    if (e.getAction() == KeyEvent.PRESS) {
      keyPressed();
    }
  }

  void keyPressed() {
    if (!isFocused) {
      return;
    }
    if ((int) key == BACKSPACE_ASCII_CODE && textInput.length() > 0) {
      textInput = textInput.substring(0, textInput.length() - 1);
    } else if ((int) key == ENTER_ASCII_CODE) {
      handleConsoleInput();
    } else if ((int) key >= BASIC_ASCII_LOWER_LIMIT && (int) key <= BASIC_ASCII_UPPER_LIMIT) {
      byte b = (byte) key;
      char ch = (char) b;
      textInput += ch;
    }
  }

  void mousePressed() {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      isFocused = true;
    } else {
      isFocused = false;
    }
    if (upBtn.isPressed(mouseX, mouseY)) {
      if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
        lineScrollOffset--;
      }
    } else if (downBtn.isPressed(mouseX, mouseY)) {
      if (lineScrollOffset < 0) {
        lineScrollOffset++;
      }
    }
  }

  void handleConsoleInput() {
    splitCommandBasedOnConsoleWidth(new Command(textInput, true));
    dict.put(lastVariableName, textInput);
    consoleInputListener.onConsoleInput(lastVariableName, textInput);
    textInput = "";
  }

  void setConsoleInputListener(ConsoleInputListener consoleInputListener) {
    this.consoleInputListener = consoleInputListener;
  }

  void setInputTextColor(color inputTextColor) {
    this.inputTextColor = inputTextColor;
  }

  void setOutputTextColor(color outputTextColor) {
    this.outputTextColor = outputTextColor;
  }

  void setTextSize(int textSize) {
    this.textSize = textSize;
    this.textHeight = textAscent() + textDescent();
    this.maxLinesToDisplay = computeMaxLinesToDisplay();
  }

  private class ArrowButton {
    private int x, y, s;
    private int r1, r2, r3, r4; // box-roundings
    private Point p1, p2, p3;

    // TODO - try to use an enum insted of ints
    public int orientation; // int from 0-3, clockwise

    ArrowButton(int x, int y, int s, int o) {
      this.x = x;
      this.y = y;
      this.s = s;
      this.orientation = o;
      computeArrowEndPoints();
    }

    ArrowButton(int x, int y, int s, int o, int r1, int r2, int r3, int r4) {
      this.x = x;
      this.y = y;
      this.s = s;
      this.orientation = o;
      this.r1 = r1;
      this.r2 = r2;
      this.r3 = r3;
      this.r4 = r4;
      computeArrowEndPoints();
    }

    void computeArrowEndPoints() {
      switch (orientation) {
      case 0: // UP
        this.p1 = new Point(x + 0.2 * s, y + 0.8 * s);
        this.p2 = new Point(x + 0.8 * s, y + 0.8 * s);
        this.p3 = new Point(x + 0.5 * s, y + 0.2 * s);
        break;
      case 1: // RIGHT
        this.p1 = new Point(x + 0.2 * s, y + 0.2 * s);
        this.p2 = new Point(x + 0.2 * s, y + 0.8 * s);
        this.p3 = new Point(x + 0.8 * s, y + 0.5 * s);
        break;
      case 2: // DOWN
        this.p1 = new Point(x + 0.2 * s, y + 0.2 * s);
        this.p2 = new Point(x + 0.8 * s, y + 0.2 * s);
        this.p3 = new Point(x + 0.5 * s, y + 0.8 * s);
        break;
      case 3: // LEFT
        this.p1 = new Point(x + 0.8 * s, y + 0.2 * s);
        this.p2 = new Point(x + 0.8 * s, y + 0.8 * s);
        this.p3 = new Point(x + 0.2 * s, y + 0.5 * s);
        break;
      default:
      }
    }

    void drawButton() {
      rectMode(CORNER);
      noStroke();
      fill(80);
      rect(this.x, this.y, s, s, r1, r2, r3, r4);
      stroke(200);
      line(p1.x, p1.y, p3.x, p3.y);
      line(p2.x, p2.y, p3.x, p3.y);
    }

    boolean isPressed(float mx, float my) {
      return (mx > this.x && mx < this.x + s && my > this.y && my < this.y + s);
    }
  }

  private class Point {
    public float x, y;

    Point(float x, float y) {
      this.x = x;
      this.y = y;
    }
  }

  private class Command {
    public String text;
    public boolean isInput;

    Command(String text, boolean isInput) {
      this.text = text;
      this.isInput = isInput;
    }
  }

  private class Line {
    public String text;
    public color textColor;

    Line() {
      this.text = "";
    }
  }
}

abstract class ConsoleInputListener {

  abstract void onConsoleInput(String variable, String value);

  /* 
   * Method used as a workaround, so that the println statements from the onConsoleInput() method 
   * will work in the KYByte coder
   */
  void println(String text) {
    PApplet.println(text);
  };
}