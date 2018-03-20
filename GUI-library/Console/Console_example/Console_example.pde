Console console;

void setup() {
  size(800, 600);
  console = new Console(100, 100, 500, 400);
  console.setInputTextColor(color(255,10,100));
  console.setOutputTextColor(color(130,90, 190));
  console.write("Hello there! What's your name?");
  console.readInput("name");
  console.setConsoleInputEvent(new ConsoleInputEvent() {
  
    public void onConsoleInput(String variable, String value) {
      if (variable.equals("name")) {
        console.write("Nice to meet you " + value + "!");
        console.write("How old are you?");
        console.readInput("age");
      } else if (variable.equals("age")) {
        console.write(value + "...  nice!");
      }
    }
    
  });
}

void draw() {
  background(144);
  console.drawConsole();
}

void keyTyped() {
  console.handleKeyboardInput();
}

void mousePressed() {
  console.handleMousePressed();
}