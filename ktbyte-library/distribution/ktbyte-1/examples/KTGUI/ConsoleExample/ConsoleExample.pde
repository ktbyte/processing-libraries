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
  console.setOutputTextSize(22);


  console.writeOutput("Well, Prince, so Genoa and Lucca are now just family estates of the " +
    "Buonapartes. But I warn you, if you don't tell me that this means war, " +
    "if you still try to defend the infamies and horrors perpetrated by that " +
    "Antichrist--I really believe he is Antichrist--I will have nothing more " +
    "to do with you and you are no longer my friend, no longer my 'faithful " +
    "slave,' as you call yourself! But how do you do? I see I have frightened " +
    "you--sit down and tell me all the news.");

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
  textSize(18);
}