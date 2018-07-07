import ktgui.*;

KTGUI ktgui;
KTGUIConsole console;

void setup() {
  size(800, 600);
  ktgui = new KTGUI(this);

  console = new KTGUIConsole(ktgui, "A Console", 100, 100, 600, 400);
  // console.alignAboutCanvas(LEFT, TOP);
  console.setBorderRoundings(10, 10, 5, 5);
  console.setInputTextColor(color(255, 10, 100));
  console.setOutputTextColor(color(130, 90, 190));
  
  console.writeOutput("Hello there! What's your name?");
  console.readInput("name");
  console.addEventAdapter(new KTGUIEventAdapter() {
    public void onConsoleInput(String value, String variable) {
      if (variable.equals("name")) {
        console.writeOutput("Nice to meet you " + value + "!");
        console.writeOutput("How old are you?");
        console.readInput("age");
      } else if (variable.equals("age")) {
        console.writeOutput(value + "...  nice! !");
        console.writeOutput("Boy or girl?");
        console.readInput("gender");
      } else if (variable.equals("gender")) {
        if (value.equals("boy") || value.equals("girl")) {
          console.writeOutput("Cool..");
        } else {
          console.writeOutput("Please answer my question! Choose from: boy or girl.");
          console.readInput("gender");
        }
      }
    }
  });
}

void draw() {
  background(144);
  text("Previous input (line):" + console.getLastLine(), 10, 20);
  text("Previous input (block):" + console.getLastBlock(), 10, 40);
}