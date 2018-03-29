# GUI library

This library consists of several easy-to-use GUI elements and is designed to work with both the Processing and [KTByte coder](https://www.ktbyte.com/coder) environments.

## Contents
  * [Elements](#elements)
     * [Console](#console)
     * [Button](#button)

The library consists of the following elements:

## <a name="#elements"></a> Elements

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

void **write(String text)** - *displays some text in the console*

void **readInput(String name)** - *used to indicate that the next console's input value will be matched with the given variable name.*

void **setInputTextColor(color inputTextColor)** - *sets the display color of the input text*

void **setOutputTextColor(color outputTextColor)** - *sets the display color of the text which was registered using the **void write(String text)** method*

void **setTextSize(float textSize)** - *changes the text size of the console's text to the given value*

void **setConsoleInputListener(ConsoleInputListener consoleInputListener)** - *sets a listener which will trigger a callback function when an input is entered in the console*

String **getValue(String name)** - *returns the stored input value for a given variable name*



###### ConsoleInputListener:

void **onConsoleInput(String variable, String name)** - *this method will be called after each console input*



###### Note:
- all value entered in the console will be persisted as strings
### <a name="#button"></a> Button
