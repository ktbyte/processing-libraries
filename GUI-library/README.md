# GUI library

This library consists of several easy-to-use GUI elements and is designed to work with both the Processing and [KTByte coder](https://www.ktbyte.com/coder) environments.

## Contents
  * [Elements](#elements)
     * [Button](#button)
     * [Console](#console)
     * [ListBox](#listbox)
     * [RadioInput](#radioinput)
     * [Slider](#slider)
     * [TextBox](#textbox)


## Elements

### Button

This GUI element acts as a button. The Button reacts if the user clicks on it with the mouse or if the user hovers the cursor over the Button. One could set the initial location (of the upper left corner) of the button and its size (width and height) during the creation. To do that, one should just put the appropriate values as arguments of the constructor method:

```java
  // create the button
  // upper left corner at the (100, 100)
  // width = 200, height = 100 
  btn = new Button(100, 100, 200, 100);
```
There are three examples available:

 - [Example of the Button that does not use the callback method](#example-1)
 - [Example of the Button that uses the callback method](#example-2) 
 - [Example of the Button that uses the callback method and is part of the 'library'](#example-3)

#### Example 1 

The [first example](https://github.com/ktbyte/processing-libraries/blob/master/GUI-library/Button/Button_Without_Callback.pde) shows how to use the _Button_ directly, without the callback function. This means that at any given moment the user should check the state (if it is 'pressed' or 'released' at that moment) of the _Button_ himself. In this example, the state of the _Button_ is checked inside the 'tickle()' method. In its turn, this method is called inside the 'draw()' method. 

```java
void draw() {
  background(220);
  btn.draw();
  ...
  tickle();          // <-- call the method that 'does' something
                     // in dependance of the Button state
}

void tickle(){
  if(btn.isPressed){ // <-- checking the state of the Button
    ...
    text("TICKLE", 0, 0);
    ...
  }
}
```
Making this check inside the 'draw()' method ensures that no state change would be missed. The advantage of this approach is simplicity of the design. The drawback of this approach is the redundancy - if there are a lot of GUI elements present in the code then it will put the extensive load on the processor.

#### Example 2

The [second example](https://github.com/ktbyte/processing-libraries/blob/master/GUI-library/Button/Button_Callback_Example.pde) shows the use of the callback method.

#### Example 3

The [third example](https://github.com/ktbyte/processing-libraries/blob/master/GUI-library/KTGUI/KTGUI_Button_KTByte_Example.pde) shows the use of the Button class as a part of library.

---



### Console

This element acts as a Command-line interface, accepting user input and handling custom responses. 

Example:
```java
Console console;

void setup() {
  size(800, 600);
  console = new Console(this, 100, 100, 600, 400);
  console.setConsoleInputListener(new ConsoleInputListener() {
    void onConsoleInput(String variable, String value) {
      if (variable.equals("name")) {
        console.write("Nice to meet you " + value + "!");
      }
    }
  console.write("Hello there! What's your name?");
  console.readInput("name");
}
```

#### Methods of Console class:

**Console(PApplet pap, int x, int y, int width, int height)** - this constructs a new Console object within the current context (PApplet), starting from the x and y coordinates, having a given width and height

void **write(String text)** - *displays some text in the console*

void **readInput(String name)** - *used to indicate that the next console's input value will be matched with the given variable name.*

void **setInputTextColor(color inputTextColor)** - *sets the display color of the input text*

void **setOutputTextColor(color outputTextColor)** - *sets the display color of the text which was registered using the **void write(String text)** method*

void **setTextSize(int textSize)** - *changes the size of the console's text to the given value*

void **setConsoleInputListener(ConsoleInputListener consoleInputListener)** - *sets a listener which will trigger a callback function when an input is entered in the console*

String **getValue(String name)** - *returns the stored input value for a given variable name*



#### Methods of ConsoleInputListener class:

void **onConsoleInput(String variable, String name)** - *this method will be called after each console input*


#### Note:
- all console's inputs will be persisted as strings
- text can be entered only of the Console element is focused (a click on the Console will make it focused). 

---

### ListBox

---

### RadioInput

This element consists of a list of options which are mutually exclusive. An option can be activated by pressing on its corresponding bullet. Only one of the radio buttons is considered active at one time.

```java
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
### RadioInput:

**RadioInput(PApplet pap, int x, int y)** - This construncts the RadioInput object within the current context (PApplet), starting from the x and y coordinates. The width and height of this GUI element are computed based on: number of items, text size, the length of the option's text.

void **addRadioButton(String option, String value)** - *Adds a new radio button. The displayed text is the **value** String, while the **option** parameters is used as an unique indentifier.*

void **addRadioButton(String option, String value, boolean isActive)** - *Adds a new radio button and makes it active/inactive. The displayed text is the **value** String, while the **option** parameters is used as an unique indentifier.*

void **setActiveButtons(String option)** - *Activates the button which have the given **option**. This method will ignore any call with an invalid option.*

void **setTextSize(int textSize)** - *Changes the size of the options' text to the given value.*

void **setDisplayBackground(boolean displayBackground)** - *Sets the flag for displaying the background of the RadioInput element.*

void **setBulletColor(color bulletColor)** - *Sets the color of the bullet point.s*

void **setTextColor(color textColor)** - *Sets the text color of the options.*

String **getActiveValue()** - *Returns the active value of the RadioInput if it exits, otherwise returns null.*

#### ConsoleInputListener:

void **onMousePressed()** - *This method will be called after each mouse press*


#### Note:

- Any activation of a button will automatically deactivate all the other buttons.

---

### Slider

---

### TextBox

This element is a rectangle input in which text can be entered if the box is focused.

```java
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

#### Methods of TextBox class

**TextBox(PApplet pap, int x, int y, int width, int height)** - This construncts the TextBox object within the current context (PApplet), starting from the x and y coordinates, having the spcified width and height.

void **setText(String text)**  - *Sets the (default) text inside the TextBox element*

String **getText()** - *Returns the current text from the TextBox element*

void **setTextSize(int textSize)** - *Sets the size of the text.*

void **setBorderRounding(int r1, int r2, int r3, int r4)** - *Sets the rounding of the rectangle's border. The paramters should be entered in a clockwise order*

#### Methods of KeyEventListener class

void **onEnterKey()** - *This method will be called after each press of the ENTER/RETURN key*
