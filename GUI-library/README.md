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
**write(text)** - used to display some text in the console
**readInput(key)** - is used to indicate that the next console's input value will be matched with the given key. It will also display the entered input in the console's textbox
**setInputTextColor**(color) - used to set the display color of the input text
**setOutputTextColor**(color) - used to set the display color of the text which was registered using the **write(text)** method

Note:
- all value entered in the console will be persisted as strings
### <a name="#button"></a> Button
