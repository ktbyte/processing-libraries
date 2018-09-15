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
    "you--sit down\t and tell \tme all the news...\n");
  console.writeOutput("");
  console.writeOutput("One of them was a sallow, clean-shaven civilian with a thin and wrinkled" +
    "face, already growing old, though he was dressed like a most fashionable " +
    "young man. He sat with his legs up on the sofa as if quite at home and " +
    "having stuck an amber mouthpiece far into his mouth, was inhaling the " +
    "smoke spasmodically and screwing up his eyes. This was an old bachelor " +
    "Shinshín, a cousin of the countess’, a man with “a sharp tongue " +
    "as they said in Moscow society. He seemed to be condescending " +
    "this companion. The latter, a fresh, rosy officer of the Guards " +
    "irreproachably washed, brushed, and buttoned, held his pipe in the" +
    "middle of his mouth and with red lips gently inhaled the smoke, letting " +
    "it escape from his handsome mouth in rings. This was Lieutenant Berg, a" +
    "officer in the Semënov regiment with whom Borís was to travel to joi" +
    "the army, and about whom Natásha had teased her elder sister Véra" +
    "speaking of Berg as her “intended.” The count sat between them an" +
    "listened attentively. His favorite occupation when not playing boston, " +
    "card game he was very fond of, was that of listener, especially when he" +
    "succeeded in setting two loquacious talkers at one another " +
    "Well, then, old chap, mon très honorable Alphonse Kárlovich, " +
    "said Shinshín, laughing ironically and mixing the most ordinary Russia " +
    "expressions with the choicest French phrases—which was a peculiarit " +
    "of his speech. “Vous comptez vous faire des rentes sur l’état; " +
    "you want to make something out of your company?");
  console.writeOutput("");
  console.writeOutput("Ohhh... Hello there! What's your name?");
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