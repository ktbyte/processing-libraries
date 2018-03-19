Console console;

void settings() {
  size(800,600);
}

void setup() {
  console = new Console(100, 100, 600, 400, color(0));
  console.write("Hello there!");
  console.write("I'm a bot..");
  console.write("Y u human?");
}

void draw() {
  console.drawConsole();
}

void keyTyped() {
  console.handleKeyboardInput();
}