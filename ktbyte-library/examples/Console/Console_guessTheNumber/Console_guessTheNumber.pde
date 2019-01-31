import ktbyte.old.gui.*;

Console console;
int number;

void setup() {
  size(800, 600);
  number = (int) random(0,10);
  console = new Console(this, 50, 50, 600, 400);
  console.setInputTextColor(color(225, 100, 245));
  console.setOutputTextColor(color(120, 120, 225));
  console.setTextSize(14);
  console.write("I'm thinking of a number between 0 and 9. Try to guess!");
  console.readInput("number");

  console.setConsoleInputListener(new ConsoleInputListener() {

    public void onConsoleInput(String variable, String value) {
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
        } catch (NumberFormatException e) {
          console.write("The input was not a number..");
          console.readInput("number");
        }
      }
    }
  }
  );
}

void draw() {
  background(144);
}