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
    "you--sit down\t and tell \tme all the news.\n");

  console.writeOutput("Hello there! What's your name?");
  console.readInput("name");
  console.addEventAdapter(new KTGUIEventAdapter() {
    public void onConsoleInput(String value, String variable) {
      if (variable.equals("name")) {
        console.writeOutput("Nice to meet you " + value + "!");
        console.writeOutput("How old are you?");
        console.readInput("age");
      } else if (variable.equals("age")) {
        if(!isNumber(value)){
          console.writeOutput("Please enter your age as unsigned integer.");
          console.readInput("age");
        } else {
          console.writeOutput(value + " ...  nice!!");
          console.writeOutput("Are you a Boy or girl?");
          console.readInput("gender");
        }
      } else if (variable.equals("gender")) {
        if (value.equalsIgnoreCase("boy") || value.equalsIgnoreCase("girl")) {
          console.writeOutput("Cool..");
          console.readInput("other");
        } else {
          console.writeOutput("Please answer my question! Choose from: boy or girl.");
          console.readInput("gender");
        }
      } else if (variable.equals("other")) {
        console.writeOutput(value + " you say... ok, go on...");
      }
    }
  });
}

void draw() {
  background(144);
  textSize(18);
}

boolean isNumber(String value){
  boolean isNumber;
  try {
    Integer.parseUnsignedInt(value);
    isNumber = true;
  }catch(NumberFormatException nfe){
    isNumber = false;
  }
  return isNumber;
}