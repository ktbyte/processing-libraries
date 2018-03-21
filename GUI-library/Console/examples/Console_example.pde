Console console;
int number = 3;
// ### Classic example ###
//void setup() {
//  size(800, 600);
//  console = new Console(100, 100, 600, 400);
//  console.setInputTextColor(color(255, 10, 100));
//  console.setOutputTextColor(color(130, 90, 190));
//  console.write("Hello there! What's your name?");
//  console.readInput("name");
//  console.setConsoleInputEvent(new ConsoleInputEvent() {

//    public void onConsoleInput(String variable, String value) {
//      if (variable.equals("name")) {
//        console.write("Nice to meet you " + value + "!");
//        console.write("How old are you?");
//        console.readInput("age");
//      } else if (variable.equals("age")) {
//        console.write(value + "...  nice! !");
//        console.write("Boy or girl?");
//        console.readInput("gender");
//      } else if (variable.equals("gender")) {
//        console.write("Cool..");
//      }
//    }
//  }
//  );
//}

// ### Number-Game Example ###
void setup() {
  size(800, 600);
  console = new Console(50, 50, 600, 400);
  console.setInputTextColor(color(255, 10, 100));
  console.setOutputTextColor(color(130, 90, 190));
  console.write("I'm thinking of a number between 0 and 9. Try to guess!");
  console.readInput("number");

  console.setConsoleInputEvent(new ConsoleInputEvent() {

    public void onConsoleInput(String variable, String value) {
      if (variable.equals("number")) {
        // using custom getInteger() method since using Processing's "int(...)" fails when Java code is compiling
        if (getInteger(value) < number) {
          console.write("Too small. Try again!");
          console.readInput("number");
        } else if (getInteger(value) > number) {
          console.write("Too big. Try again!");
          console.readInput("number");
        } else {
          console.write("Exactly!");
        }
      }
    }
  }
  );
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

int getInteger(String value) {
  // TODO - make this method also work with negative numbers
  int number = 0;
  for (char ch : value.toCharArray()) {
    if ((byte) ch >= 48 && (byte) ch <= 57) {
      number = number*10 + (byte) ch - 48;
    } else {
      break;
    }
  }
  return number;
}