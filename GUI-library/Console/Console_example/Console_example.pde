Console console;

void setup() {
  size(800, 600);
  console = new Console(100, 100, 600, 400, color(0));
  console.write("Hello there! What's your name?");
  console.readInput("name");
  console.addConsoleEvent(new ConsoleEvent() {
    public void onConsoleInput(String variable, String value) {
      if (variable.equals("name")) {
        console.write("Nice to meet you " + value + "!");
        console.write("How old are you?");
        console.readInput("age");
      } else if (variable.equals("age")) {
        console.write("So it seems I am older!");
      }
    }
  }
  );
}

void draw() {
  console.drawConsole();
}

void keyTyped() {
  console.handleKeyboardInput();
}