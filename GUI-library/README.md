# GUI library

This library consists of several easy-to-use GUI elements and is designed to work with both the Processing and [KTByte coder](https://www.ktbyte.com/coder) environments.

## Contents
  * [Elements](#elements)
     * [Console](#console)
     * [Button](#button)

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

### <a name="#list-box"></a> ListBox

### <a name="#radio-input"></a> RadioInput

This element consists of a list of options which are mutually exclusive. Only one of the radio buttons is considered active at one time.

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

void **setDisplayBackground(boolean displayBackground)** - *Sets the flag for displaying the background of the RadioInput element*

void **setBulletColor(color bulletColor)** - *Sets the color of the bullet points*

void **setTextColor(color textColor)** - *Sets the text color of the options*

String **getActiveValue()** - *Returns the active value of the RadioInput if it exits, otherwise returns null*

###### ConsoleInputListener:

void **onMousePressed()** - *this method will be called after each mouse press*


Note:

Any activation of a button will automatically deactivate all the other buttons

### <a name="#slider"></a> Slider

### <a name="#text-box"></a> TextBox

