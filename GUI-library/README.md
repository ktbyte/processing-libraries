# GUI library

This library consists of several easy-to-use GUI elements and is designed to work with both the Processing and [KTByte coder](https://www.ktbyte.com/coder) environments.

## Contents
  * [Elements](#elements)
     * [Button](#button)
     * [Console](#console)
     * [ListBox](#list-box)
     * [RadioInput](#radio-input)
     * [Slider](#slider)
     * [TextBox](#text-box)



The library consists of the following elements:

## <a name="#elements"></a> Elements

### <a name="#button"></a> Button

### <a name="#console"></a> Console

This element acts as a Command-line interface, accepting user input and handling custom responses. 

Example:
```
Console console;

void setup() {
 size(800, 600);
 console = new Console(this, 100, 100, 600, 400);
 console.write("Hello there! What's your name?");
 console.readInput("name");
 console.setConsoleInputListener(new ConsoleInputListener() {

    void onConsoleInput(String variable, String value) {
     if (variable.equals("name")) {
        console.write("Nice to meet you " + value + "!");
     }
    }
}
```

###### Console:

**Console(PApplet pap, int x, int y, int width, int height)** - this constructs a new Console object within the current context (PApplet), starting from the x and y coordinates, having a given width and height

void **write(String text)** - *displays some text in the console*

void **readInput(String name)** - *used to indicate that the next console's input value will be matched with the given variable name.*

void **setInputTextColor(color inputTextColor)** - *sets the display color of the input text*

void **setOutputTextColor(color outputTextColor)** - *sets the display color of the text which was registered using the **void write(String text)** method*

void **setTextSize(int textSize)** - *changes the size of the console's text to the given value*

void **setConsoleInputListener(ConsoleInputListener consoleInputListener)** - *sets a listener which will trigger a callback function when an input is entered in the console*

String **getValue(String name)** - *returns the stored input value for a given variable name*



###### ConsoleInputListener:

void **onConsoleInput(String variable, String name)** - *this method will be called after each console input*



###### Note:
- all console's inputs will be persisted as strings
- text can be entered only of the Console element is focused (a click on the Console will make it focused). 

### <a name="#list-box"></a> ListBox

### <a name="#radio-input"></a> RadioInput

This element consists of a list of options which are mutually exclusive. An option can be activated by pressing on its corresponding bullet. Only one of the radio buttons is considered active at one time.

```
RadioInput ri;

void setup() {
  size(600, 400);
  ri = new RadioInput(this, 50, 50);
  ri.addRadioButton("male", "Male", true);
  ri.addRadioButton("female", "Female");
  ri.setActiveButton("female");
  ri.setTextSize(24);
  ri.setDisplayBackground(true);
}

void draw() {
 if (ri.getActiveValue().equals("Male")) {
  println("Male!")
 }
}

```
###### RadioInput:

**RadioInput(PApplet pap, int x, int y)** - This construncts the RadioInput object within the current context (PApplet), starting from the x and y coordinates. The width and height of this GUI element are computed based on: number of items, text size, the length of the option's text.

void **addRadioButton(String option, String value)** - *Adds a new radio button. The displayed text is the **value** String, while the **option** parameters is used as an unique indentifier.*

void **addRadioButton(String option, String value, boolean isActive)** - *Adds a new radio button and makes it active/inactive. The displayed text is the **value** String, while the **option** parameters is used as an unique indentifier.*

void **setActiveButtons(String option)** - *Activates the button which have the given **option**. This method will ignore any call with an invalid option.*

void **setTextSize(int textSize)** - *Changes the size of the options' text to the given value.*

void **setDisplayBackground(boolean displayBackground)** - *Sets the flag for displaying the background of the RadioInput element.*

void **setBulletColor(color bulletColor)** - *Sets the color of the bullet point.s*

void **setTextColor(color textColor)** - *Sets the text color of the options.*

String **getActiveValue()** - *Returns the active value of the RadioInput if it exits, otherwise returns null.*

###### ConsoleInputListener:

void **onMousePressed()** - *This method will be called after each mouse press*


###### Note:

- Any activation of a button will automatically deactivate all the other buttons.

### <a name="#slider"></a> Slider

### <a name="#text-box"></a> TextBox

This element is a rectangle input in which text can be entered if the box is focused.

```
TextBox textBox;

void setup() {
  size(500, 500);
  textBox1 = new TextBox(this, 50, 50, 300, 50);
  textBox1.setText("Enter first name...");
  textBox1.setTextSize(16);
  textBox1.setKeyEventListener(new KeyEventListener() {
    void onEnterKey() {
      println(textBox1.getText());
    }
  }  
  );

}
```

###### TextBox

**TextBox(PApplet pap, int x, int y, int width, int height)** - This construncts the TextBox object within the current context (PApplet), starting from the x and y coordinates, having the spcified width and height.

void **setText(String text)**  - *Sets the (default) text inside the TextBox element*

String **getText()** - *Returns the current text from the TextBox element*

void **setTextSize(int textSize)** - *Sets the size of the text.*

void **setBorderRounding(int r1, int r2, int r3, int r4)** - *Sets the rounding of the rectangle's border. The paramters should be entered in a clockwise order*

###### KeyEventListener

void **onEnterKey()** - *This method will be called after each press of the ENTER/RETURN key*
