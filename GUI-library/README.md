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
  // instantiate the Button object
  btn = new Button(100, 100, 200, 100);  
  
  // instantiate the anonymous object that implements the ButtonListener interface
  btn.addListener(new ButtonListener() { 
    // implement the method that reacts on the given event
    void onPressed() {                   
      bg = color(random(0, 255),random(0, 255),random(0, 255));
      doTickle = doTickle ? false : true;
    }
  });
```

#### Example 3

The [third example](https://github.com/ktbyte/processing-libraries/blob/master/GUI-library/KTGUI/KTGUI_Button_KTByte_Example.pde) shows the use of the Button class as a part of library. The main drawback of the two previous examples is that in order to make them 'live' (draw the shape of each GUI component on the canvas, react on the mouse and keyboard events) we must write the code inside the native Processing's methods - `setup()`, `draw()`, `mousePressed()`, `mouseRelease()` etc. This makes us to mix the 'main' logic of our application with the 'GUI' logic, which is not the best approach. Instead, we can use the 'library' [approach](#ktgui-library). Using this approach, the single 'library' object is created. And then, each GUI component is created by calling the particular factory method of the 'library' class. 

Here is an example:



[Back to the table of contents](#table-of-contents)

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



[Back to the table of contents](#table-of-contents)

---

### ListBox



[Back to the table of contents](#table-of-contents)

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



[Back to the table of contents](#table-of-contents)

---

### Slider



[Back to the table of contents](#table-of-contents)

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



[Back to the table of contents](#table-of-contents)

---

### KTGUI Library

As was already mentioned in the [Example of the Button that uses the callback method and is part of the 'library'](#example-3), the KTGUI Library is a class that is specifically designed to provide the ability to separate the 'main' code of the application from the 'GUI' related code. 

#### The concept of 'main' and 'GUI' related code separation 

In order to separate the two types of the said codes, we can use the ability of the Processing library to 'register' some of its 'specific' methods in the external class. To register the 'specific' methods in the external class, the *PApplet* uses the `registerMethod(String methodName, PApplet parentPApplet)` method. After these methods were being registered, they will be executed at a particular moments of the 'main' code execution allowing to 'synchronize' the execution of the 'main' code with the execution of the particular methods of the external class. (More detailed information can be found in the Processing's documentation [here](https://github.com/processing/processing/wiki/Library-Basics#library-methods)).

The full list of these 'specific' methods can be found [here](https://github.com/processing/processing/wiki/Library-Basics#library-methods). We will register in the external class and use for separating the code __*only the following three methods*__:

- `public void draw()` Method that's called at the end of  the *PApplet's* `draw()` method.
- `public void mouseEvent(MouseEvent e)` Method that's called when a mouse event occurs in the parent *PApplet*. Drawing inside this method is allowed because mouse events are queued, unless the sketch has called `noLoop()`.
- `public void keyEvent(KeyEvent e)` Method that's called when a key event occurs in the parent *PApplet.* Drawing is allowed because key events are queued, unless the sketch has called `noLoop()`.


#### The implementation of 'main' and 'GUI' related code separation 

The 'separation' is achieved by the following:

1. KTGUI has the reference to the parent *PApplet* object called `pa`. 

   ```java
   public class KTGUI {
     PApplet pa;
     ...
   }
   ```

   During the creation of the *KTGUI* object, one must insert the reference to the parent _PApplet_ object as argument of the *KTGUI* constructor, like shown below:
   ```java
   // The 'main' Processing's code

   KTGUI ktgui;

   void setup() {
     size(600, 600);
     // instance of the KTGUI class
     ktgui = new KTGUI(this);  // 'this' is a reference to the parent PApplet object
   }

   void draw() {
     ...
   }
   ```


2. In order to be able to be managed (stored and processed) uniformly (as objects of the same type), all of the GUI components must extend the `abstract class Controller`. Therefore, for convenience, we will call the 'library' GUI components as ___Controllers___. 

3. KTGUI stores the references to all the _controllers_ in a special field called `controllers`. The type of this field is `List<Controller>`. 

   ```java
   public class KTGUI {
     ...
     List<Controller> controllers;
     ...
   }
   ```

   ​

4. KTGUI class uses the [_factory_](https://en.wikipedia.org/wiki/Factory_method_pattern) methods to create the instances of all the 'library' GUI components. During the _controller_ creation, the factory method automatically adds the reference to the newly created GUI component to the `controllers` list. 

   ```java
   // an example of factory method that returns the instance of the Button GUI component
   Button createButton(int x, int y, int w, int h) {
     Button btn = new Button(x, y, w, h);
     registerController(btn);
     return btn;
   }
   ```

   For this, the `registerController(Controller controller)` method is used:

   ```java
   void registerController(Controller controller) {
     controllers.add(controller);
   }
   ```

   ​


5. An `abstract class KTGUIEventAdapter` is used for that each particular Object can have it's own set of 'event-related' behaviors for each type of event and each type of `Controller`. 

   ```java
   abstract class KTGUIEventAdapter {
     void onMousePressed() {
     }
     void onMouseReleased() {
     }
     void onMouseMoved() {
     }
     void onMouseDragged() {
     }
     void onKeyReleased() {
     }
     void onKeyPressed() {
     }
   }
   ```

   Each `Controller` has a field of type `ArrayList<KTGUIEventAdapter>` to store the list of the objects that wants to react on the events of this particular `Controller`. To add the particular object to the list of the list of the objects that wants to react on the events this particular `Controller` one should use the `void addEventAdapters(KTGUIEventAdapter adapter)` method:

   ```java
   public abstract class Controller {
     ...
     ArrayList<KTGUIEventAdapter> adapters;
     ...
     void addEventAdapters(KTGUIEventAdapter adapter) {
       adapters.add(adapter);
     }
     ...
   }
   ```

   The `KTGUIEventAdapter` can be anonymous or concrete.

   Here is an example of the anonymous adapter registered to the Button. This adapter will react for the particular event when this particular *Button* will have the `pressed` state. As a reaction, this adapter will set the *Title* of this particular Button to have the text "Pressed":

   ```java
   KTGUI ktgui;
   Button btn;

   void setup() {
     size(600, 600);

     // instance of the KTGUI class
     ktgui = new KTGUI(this);

     // instance of the KTGUI 'Button' component
     btn = ktgui.createButton(width/2 - 100, 50, 100*2, 40);
     btn.addEventAdapters(new KTGUIEventAdapter() {
       // we can override only those callback methods which we really need
       void onMousePressed() {
         btn.setTitle(btn.isPressed ? "Pressed" : "The Button");
       }
     }
     );
   }
   ```

   ​

6. The constructor of the *KTGUI* class uses the *PApplet's* method `registerMethod(String methodName, PApplet parentPApplet)` to register the three (mentioned above) methods of the *PApplet* as a dedicated *KTGUI* methods which are intended to be called when the `mouse`, `keyboard` and `draw` related events of the parent *PApplet's* object are happened. 

   ```java
   public class KTGUI {
     ...
     public KTGUI(PApplet pa) {
       this.pa = pa;                               // store the reference to the parent PApplet
       this.pa.registerMethod("draw", this);       // register special 'draw' method
       this.pa.registerMethod("mouseEvent", this); // register special 'mouse' method
       this.pa.registerMethod("keyEvent", this);   // register special 'keyboard' method
     }
     ...
   }
   ```

   ​

7. The calls to the methods which draw the shape of each GUI component are done automatically and outside the Processing's `draw()` method.

   ```java
   public class KTGUI {
     ...
     // this method has been registered in the KTGUI constructor and is called each time 
     // the parent PApplet's object 'draw()' method execution is finished  
     void draw() {                                
       // iterate through all the controllers
       for (Controller controller : controllers) { 
         // draw each controller
         controller.draw();                        
       }
     }
     ...
   }
   ```

   ​

8. Calls to the methods which react to the `mouse` and `keyboard` events of the parent *PApplet* object are done outside the Processing's `mouseClicked()`, `mouseReleased()`, `keyPressed()`, `keyReleased()` and other `mouse` and `keyboard` related methods.

   ```java
   public class KTGUI {
     
     ...
       
     // this method has been registered in the KTGUI constructor and is called each time 
     // the parent PApplet's object 'mouse' related event has happened
     void mouseEvent(MouseEvent e) {
       switch (e.getAction()) {
       case MouseEvent.PRESS:
         this.mousePressed();
         break;
       case MouseEvent.RELEASE:
         this.mouseReleased();
         break;
       case MouseEvent.DRAG:
         this.mouseDragged();  ///--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>---------
         break;
       case MouseEvent.MOVE:
         this.mouseMoved();
         break;
     }

     // this method has been registered in the KTGUI constructor and is called each time 
     // the parent PApplet's object 'keyboard' related event has happened
     void keyEvent(KeyEvent e) {
       switch (e.getAction()) {
       case KeyEvent.PRESS:
         this.keyPressed();
         break;
       case KeyEvent.RELEASE:
         this.keyReleased();
         break;
     }
       
     ...
     
     // This is an example of one of the KTGUI methods that are called to force all
     // the controllers to call the methods that must be executed when the particular 
     // event has happened in the parent PApplet. 
     // This particular method is called when the 'mouseDragged' event has happened in the 
     // parent PApplet. As seen, this method iterates through all the controllers stored
     // in the list and calls the 'processMouseDragged()' method. 
     void mouseDragged() {  ///---------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<---------
       //println("Dragged!");
       for (Controller controller : controllers) {
         controller.processMouseDragged();
       }
     }
   }
   ```

   ​

9. Calls to the methods which notify all the objects that must react on the GUI component events are executed automatically and outside the Processing's native (`draw()` ,`mouseClicked()`, `mouseReleased()`, `keyPressed()`, `keyReleased()` and other) methods. This is done using the `KTGUIEventAdapter`  class (see p.5 above). For this, when the event is happened in the parent _PApplet_, and when this event is 'redirected' to all the _controllers_ using _registered_ methods, each controller iterates through all the available _adapters_ he has and calls the particular _adapter's_ callback method. I.e. if the input event was `mouseDragged` then the _adapter's_ `onMouseDragged()` callback method will be called.

   ​






[Back to the table of contents](#table-of-contents)

---
