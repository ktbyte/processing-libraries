import ktgui.*;

KTGUI ktgui;
KTGUIConsole console;

void setup() {
  size(800, 600);
  ktgui = new KTGUI(this);

  console = new KTGUIConsole(ktgui, "A Console", 100, 100, 600, 400);
  // console.enableLineStartMarks(true);
//   console.setInputTextColor(color(255, 10, 100));
//   console.setOutputTextColor(color(130, 90, 190));
//   console.write("Hello there! What's your name?");
//   console.readInput("name");
//   console.setConsoleInputListener(new ConsoleInputListener() {

//     public void onConsoleInput(String variable, String value) {
//       if (variable.equals("name")) {
//         console.write("Nice to meet you " + value + "!");
//         console.write("How old are you?");
//         console.readInput("age");
//       } else if (variable.equals("age")) {
//         console.write(value + "...  nice! !");
//         console.write("Boy or girl?");
//         console.readInput("gender");
//       } else if (variable.equals("gender")) {
//         if (value.equals("boy") || value.equals("girl")) {
//           console.write("Cool..");
//         } else {
//           console.write("Please answer my question! Choose from: boy or girl.");
//           console.readInput("gender");
//         }
//       }
//     }
//   }
//   );
}

void draw() {
  background(144);
}