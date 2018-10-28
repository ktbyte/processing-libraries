import ktbyte.wordcram.*;

String inputTextFile = "Obama.txt";
WordStorage storage;
PFont font;	// The font to be used
int N = 150;	// The number of words to be displayed

void setup() {
  // Input and parse text file
  String [] fileContents = loadStrings(inputTextFile);
  
  String rawText = join(fileContents, " ");
  rawText = rawText.toLowerCase();
  
  String [] tokens;
  String delimiters = " ,./?<>;:'\"[{]}\\|=+-_()*&^%$#@!~";

  tokens = splitTokens(rawText, delimiters);
  println(tokens.length + " tokens found in file: " + inputTextFile);
  
  // display stuff
  size(800, 800);
  font = createFont("Times New Roman", 120);
  textFont(font);
  textSize(24);
  noLoop();  

  // Create the word frequency storage
  storage = new WordStorage(this, tokens);
  //println("Max frequency:" + storage.maxFrequency());  
  //storage.arrange(N);
  //storage.sort();
  //storage.counts();
  
} 

void draw() {
  background(255);
  //storage.display(N);
  //storage.tabulate(N);
} 

// The start of building interaction ...
void mouseClicked() {
  //storage.interact(mouseX, mouseY);
} 
