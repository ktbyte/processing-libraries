public class Console {
  private final static int BOX_RONDING = 7;
  private final static int DELETE_KEY_CODE = 127;
  private final static int ENTER_KEY_CODE = 10;
  private final static float INPUT_BOX_HEIGHT_PERCENTAGE = 0.1;

  private int x, y;
  private int w, h;
  private color inputTextColor;
  private color outputTextColor;
  private ArrayList<Line> lines;
  private String textInput;
  private int inputBoxHeight;
  private HashMap<String, String> dict;
  private ConsoleInputEvent consoleInputEvent;
  private String currentVariableName;
  private int globalPadding;

  public Console(int x, int y, int w, int h) {
    this.inputTextColor = color(255);
    this.outputTextColor = color(170);
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.globalPadding = 10;
    this.inputBoxHeight = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);
    this.lines = new ArrayList();
    this.dict = new HashMap<String, String>();
    this.textInput = "";
  }

  void drawConsole() {
    drawConsoleTextBox();
    drawInputBox();
  }

  void drawConsoleTextBox() {
    rectMode(CORNER);
    fill(0);
    noStroke();
    rect(x, y, w, h - inputBoxHeight, BOX_RONDING, BOX_RONDING, 0, 0);
    textSize(18);
    textAlign(LEFT);
    int commandsIndexLimit = lines.size() > 10 ? lines.size() - 10 : 0; 
    for (int i = commandsIndexLimit, j=0; i < lines.size(); i++, j++) {
      stroke(lines.get(i).textColor);
      fill(lines.get(i).textColor);
      text(lines.get(i).text, x + globalPadding, 18 + y + j * 20 + globalPadding);
    }
  }

  void drawInputBox() {
    fill(255);
    noStroke();
    rect(x, y + h - inputBoxHeight, w, inputBoxHeight, 0, 0, BOX_RONDING, BOX_RONDING);
    fill(0);
    textSize(18);
    textAlign(LEFT);
    text(textInput, x + globalPadding, y + h - globalPadding);
    drawBlinkingInputCursor();
  }

  void drawBlinkingInputCursor() {
    stroke(0);
    if (frameCount % 60 < 30) {
      float cursorX = x + textWidth(textInput) + globalPadding;
      line(cursorX, y + h - 30, cursorX, y + h - 10);
    }
  }

  void write(String text) {
    splitCommandBasedOnConsoleWidth(new Command(text, false));
  }

  void splitCommandBasedOnConsoleWidth(Command command) {
    println(command.text);
    Line line = new Line();
    textSize(18);
    String[] wordsFromCommand = split(command.text, " ");
    for (int i=0; i < wordsFromCommand.length; i++) {
      if (textWidth(line.text + " ") + textWidth(wordsFromCommand[i]) < w) {
        line.text += wordsFromCommand[i] + " ";
        line.textColor = (command.isInput ? inputTextColor : outputTextColor);
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
    this.currentVariableName = name;
  }

  void handleKeyboardInput() {
    // temporary using the DELETE key (127) instead of backspace since the browser(Chrome) is using the BACKSPACE as a hotkey
    if ((int) key == DELETE_KEY_CODE && textInput.length() > 0) {
      textInput = textInput.substring(0, textInput.length() - 1);
    } else if ((int) key == ENTER_KEY_CODE) {
      handleConsoleInput();
    } else if ((int) key != DELETE_KEY_CODE) {
      byte b = (byte) key;
      char ch = (char) b;
      textInput += ch;
    }
  }

  void handleConsoleInput() {
    splitCommandBasedOnConsoleWidth(new Command(textInput, true));
    dict.put(currentVariableName, textInput);
    consoleInputEvent.onConsoleInput(currentVariableName, textInput);
    textInput = "";
  }

  void setConsoleInputEvent(ConsoleInputEvent consoleInputEvent) {
    this.consoleInputEvent = consoleInputEvent;
  }

  void setInputTextColor(color inputTextColor) {
    this.inputTextColor = inputTextColor;
  }

  void setOutputTextColor(color outputTextColor) {
    this.outputTextColor = outputTextColor;
  }

  private class Command {

    Command(String text, boolean isInput) {
      this.text = text;
      this.isInput = isInput;
    }

    public String text;
    public boolean isInput;
  }

  private class Line {
    public String text;
    public color textColor;

    Line() {
      this.text = "";
    }
  }
}

public interface ConsoleInputEvent {
  void onConsoleInput(String variable, String value);
}