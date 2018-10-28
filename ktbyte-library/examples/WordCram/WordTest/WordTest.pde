import ktbyte.wordcram.*;

String inputTextFile = "Obama.txt";
WordFrequency table;
PFont tnr;	// The font to be used
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
  tnr = createFont("Times New Roman", 120);
  textFont(tnr);
  textSize(24);
  noLoop();  

  // Create the word frequency table
  table = new WordFrequency(this, tokens);
  //println("Max frequency:" + table.maxFrequency());  
  //table.arrange(N);
  //table.sort();
  //table.tabulate();
  //table.counts();
} 

void draw() {
  background(255);
  //table.display(N);
  //table.tabulate(N);
} 

// The start of building interaction ...
void mouseClicked() {
  //table.interact(mouseX, mouseY);
} 
