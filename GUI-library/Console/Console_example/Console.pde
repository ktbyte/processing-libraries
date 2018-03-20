public class Console {
  private int x, y;
  private int w, h;
  private color c;
  private ArrayList<String> lines;
  private String currentCommand;
  private int inputBoxHeight;
  private HashMap<String, String> dict;
  private ConsoleEvent consoleEvent;
  private String currentVariableName;

  public Console(int x, int y, int w, int h, color c) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    this.inputBoxHeight = (int) (0.1 * h);
    this.lines = new ArrayList();
    this.dict = new HashMap<String, String>();
    this.currentCommand = "";
  }

  void drawConsole() {
    rectMode(CORNER);
    fill(c);
    noStroke();
    rect(x, y, w, h);
    strokeWeight(4);
    stroke(255);
    line(x, y + h - inputBoxHeight, x + w, y + h - inputBoxHeight);
    printCommands();
    printCurrentCommand();
  }

  void printCurrentCommand() {
    fill(255);
    textSize(18);
    textAlign(LEFT);
    text(currentCommand, x + 10, y + h - 10);
  }

  void printCommands() {
    fill(255);
    textSize(18);
    textAlign(LEFT);
    int commandsIndexLimit = lines.size() > 10 ? lines.size() - 10 : 0; 
    for (int i = commandsIndexLimit, j=0; i < lines.size(); i++, j++) {
      text(lines.get(i), x, 18 + y + j * 20);
    }
  }

  void write(String command) {
    splitCommandBasedOnConsoleWidth(command);
  }

  void splitCommandBasedOnConsoleWidth(String command) {
    String line = "";
    textSize(18);
    String[] wordsFromCommand = split(command, " ");
    for (int i=0; i < wordsFromCommand.length; i++) {
      if (textWidth(line + " ") + textWidth(wordsFromCommand[i]) < w) {
        line += wordsFromCommand[i] + " ";
      } else {
        lines.add(line);
        line = "";
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
    // temporary using the DELETE key (127) instead of backspace since the browser is using the BACKSPACE as a hotkey
    if ((int) key == 127 && currentCommand.length() > 0) {
      currentCommand = currentCommand.substring(0, currentCommand.length() - 1);
    } else if ((int) key == 10) {
      lines.add(currentCommand);
      dict.put(currentVariableName, currentCommand);
      consoleEvent.onConsoleInput(currentVariableName, currentCommand);
      currentCommand = "";
    } else if ((int) key != 8) {
      byte b = (byte) key;
      char ch = (char) b;
      currentCommand += ch;
    }
  }

  void addConsoleEvent(ConsoleEvent consoleEvent) {
    this.consoleEvent = consoleEvent;
  }
}

public interface ConsoleEvent {
  void onConsoleInput(String variable, String value);
}