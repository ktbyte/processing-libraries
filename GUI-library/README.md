# GUI library

## Table of contents

- [GUI library](#gui-library)
  * [Table of contents](#table-of-contents)
  * [Introduction](#introduction)
    + [Button](#button)
      - [Example 1](#example-1)
      - [Example 2](#example-2)
      - [Example 3](#example-3)
    + [Console](#console)
      - [Methods of Console class](#methods-of-console-class)
      - [Methods of ConsoleInputListener class](#methods-of-consoleinputlistener-class)
      - [Note](#note)
    + [ListBox](#listbox)
    + [RadioInput](#radioinput)
    + [Methods of RadioInput class](#methods-of-radioinput-class)
      - [Methods of ConsoleInputListener class](#methods-of-consoleinputlistener-class)
      - [Note](#note)
    + [Slider](#slider)
    + [TextBox](#textbox)
      - [Methods of TextBox class](#methods-of-textbox-class)
      - [Methods of KeyEventListener class](#methods-of-keyeventlistener-class)
    + [KTGUI Library](#ktgui-library)

## Introduction

This library consists of several easy-to-use GUI elements and is designed to work with both the Processing and [KTByte coder](https://www.ktbyte.com/coder) environments.

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
Making this check inside the 'draw()' method ensures that no state change would be missed. The advantage of this approach is simplicity of the design. The drawback of this approach is the redundancy - if there are a lot of GUI elements present in the code then it will put the extensive load on the processor. Moreover, in case there are lot of GUI components in the code the logic that handles the checking of all these components became very complex and hard to manage. The better approach is to use the [callback methods](#example-2) - these are the methods that will be executed automatically when the GUI component event is triggered.

#### Example 2

The [second example](https://github.com/ktbyte/processing-libraries/blob/master/GUI-library/Button/Button_Callback_Example.pde) shows the use of the callback method. The callback method is executed when the particular event has happened (in our case, the Button object triggers the `onPressed()`event when the user presses the button with the mouse. 

The code of this example has the following differences with the previous example:

- The Button class now has an additional field of type `ArrayList`. This field stores all the instances of the objects that implements the `ButtonListener` interface:
```java
ArrayList<ButtonListener> btnListeners;
```
- The 'main' code now has an additional `public interface ButtonListener`: 
```java
public interface ButtonListener {
  void onPressed();
}
```
- The Button class now has additional `void addListener(ButtonListener listener)` method that is intended to register and store all the object that must be notified when the particular event has happened:
```java
  void addListener(ButtonListener listener) {
    btnListeners.add(listener);
  }
```
- `The void processMousePressed()` method now has additional code that traverses through all the instances of the objects stored in `ArrayList<ButtonListener> btnListeners` and fire the `void onPressed()` method for each of these objects. This way we can 'notify' any amount of objects that 'listen' the given event (the user has pressed the Button with the mouse) and awaits when this event would happen.
```java
  void processMousePressed() {
    if (isPointInside(mouseX, mouseY)) {
      ...
      // notify listeners
      for(ButtonListener listener: btnListeners){
        listener.onPressed();
      }
    }
  }
```

The most convenient feature of this approach is that it is not necessary to create a variable somewhere to store the object that 'reacts' to the given event. Instead, we can create (instantiate) an anonymous object that implements the `interface ButtonListener`. We can still add the wanted 'behavior/reaction' on the event inside the implemented method. Here is an example how to do the described above:

```java
  btn = new Button(100, 100, 200, 100);  // instantiate the Button object
  
  btn.addListener(new ButtonListener() { // instantiate the anonymous object that implements the ButtonListener interface
    void onPressed() {                   // implement the method that reacts to the given event
      bg = color(random(0, 255),random(0, 255),random(0, 255));
      doTickle = doTickle ? false : true;
    }
  });
```

#### Example 3

The [third example](https://github.com/ktbyte/processing-libraries/blob/master/GUI-library/KTGUI/KTGUI_Button_KTByte_Example.pde) shows the use of the Button class as a part of library. The main drawback of the two previous examples is that in order to make them 'live' (draw the shape of each GUI component on the canvas, react on the mouse and keyboard events) we must write the code inside the native Processing's methods - `setup()`, `draw()`, `mousePressed()`, `mouseRelease()` etc. This makes us to mix the 'main' logic of our application with the 'GUI' logic, which is not the best approach. Instead, in order to separate the two types of the said codes, we can use the ability of the Processing library to 'register' some of its 'specific' methods in the external class. After that, these methods will be executed at a particular moments of the 'main' code execution allowing to 'synchronize' the execution of the 'main' code with the execution of the particular methods of the external class. (More detailed information is [here](https://github.com/processing/processing/wiki/Library-Basics#library-methods)).

One can find the full list of these methods [here](https://github.com/processing/processing/wiki/Library-Basics#library-methods). We will register' in the external class and use for separating the code only the following three methods:

- `public void draw()` Method that's called at the end of draw().

- `public void mouseEvent(MouseEvent e)` Called when a mouse event occurs in the parent applet. Drawing is allowed because mouse events are queued, unless the sketch has called noLoop().

- `public void keyEvent(KeyEvent e)` Called when a key event occurs in the parent applet. Drawing is allowed because key events are queued, unless the sketch has called noLoop().




[Back to the table of contents](#contents)

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



[Back to the table of contents](#contents)

---

### ListBox



[Back to the table of contents](#contents)

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
### Methods of RadioInput class:
`RadioInput(PApplet pap, int x, int y)`  This construncts the RadioInput object within the current context (PApplet), starting from the x and y coordinates. The width and height of this GUI element are computed based on: number of items, text size, the length of the option's text. 



`void addRadioButton(String option, String value)` Adds a new radio button. The displayed text is the **value** String, while the **option** parameters is used as an unique identifier.



`void addRadioButton(String option, String value, boolean isActive)` Adds a new radio button and makes it active/inactive. The displayed text is the **value** String, while the **option** parameters is used as an unique identifier.



`void setActiveButtons(String option)` Activates the button which have the given **option**. This method will ignore any call with an invalid option.



`void setTextSize(int textSize)` Changes the size of the options' text to the given value.



`void setDisplayBackground(boolean displayBackground)`  Sets the flag for displaying the background of the RadioInput element.



`void setBulletColor(color bulletColor)` Sets the color of the bullet points.



`void setTextColor(color textColor)` Sets the text color of the options.



`String getActiveValue()` Returns the active value of the RadioInput object if it exits, otherwise returns null.



#### Methods of ConsoleInputListener class:

`void onMousePressed()` - This method will be called after each mouse press.


#### Note:

- Any activation of a button will automatically deactivate all the other buttons.



[Back to the table of contents](#contents)

---

### Slider



[Back to the table of contents](#contents)

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



[Back to the table of contents](#contents)

---

### KTGUI Library

As was already mentioned in the [Example of the Button that uses the callback method and is part of the 'library'](#example-3), the KTGUI Library is a class that is specifically designed to provide the ability to separate the 'main' code of the application from the 'GUI' related code. And, by 'GUI' related code we understand the:

1. Calls to the methods which drawing the shape of each GUI component inside the Processing's `draw()` method.
2. Calls to the methods which reacts to the `mouse` and `keyboard` events and calculate if the particular GUI component should changed its state.
3. Calls to the methods which notify all the objects that must react to the GUI components state change.

[Back to the table of contents](#contents)

---
