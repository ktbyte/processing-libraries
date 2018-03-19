public class Console {

  private int x, y;
  private int w, h;
  private color c;
  private ArrayList<String> commands;
  private String currentCommand;

  public Console(int x, int y, int w, int h, color c) {
    commands = new ArrayList();
    currentCommand = "";
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
  }

  void drawConsole() {
    rectMode(CORNER);
    fill(c);
    noStroke();
    rect(x, y, w, h);
    strokeWeight(4);
    stroke(255);
    line(x, y+ h - 50, x + w, y+ h - 50);
    printCommands();
    printCurrentCommand();
  }

  void printCurrentCommand() {
    fill(255);
    textSize(20);
    textAlign(LEFT);
    text(currentCommand, x + 10, y + h - 10);
  }

  void printCommands() {
    fill(255);
    textSize(20);
    textAlign(LEFT);
    int commandsIndexLimit = commands.size() > 5 ? commands.size() - 5 : 0; 
    for (int i = commandsIndexLimit, j=0; i < commands.size(); i++, j++) {
      text(commands.get(i), x + 10, y + 20 + j * 25);
    }
  }

  void write(String command) {
    commands.add(command);
  }

  void handleKeyboardInput() {
    // temporary using the DELETE key (127) instead of backspace since the browser is using the BACKSPACE as a hotkey
    if ((int) key == 127 && currentCommand.length() > 0) {
      currentCommand = currentCommand.substring(0, currentCommand.length() - 1);
    } else if ((int) key == 10) {
      commands.add(currentCommand);
      currentCommand = "";
    } else if ((int) key != 8) {
      byte b = (byte) key;
      char ch = (char) b;
      currentCommand += ch;
    }
  }
}