The folder `./Sprite/SpriteTest` contains the modified version of the "Sprite" class `Sprite.pde` and the example of its usage `SpriteTest.pde`.

The usage example `SpriteTest.pde` can be opened and executed directly inside the Processing IDE, as a usual Processing project.

The Sprite class was written by [Chi Bong Ho](https://jira.ktbyte.com/secure/ViewProfile.jspa?name=chibong) and modified by [Ivan Shuba](https://jira.ktbyte.com/secure/ViewProfile.jspa?name=Samuil9999).
The modifications were added in order to change the way how the PImage is rotated and positioned on the canvas. After modification, the PImage is rotated and positioned about its __CENTER__ instead of its __ORIGIN__ (upper-left corner).

Later, the "Sprite" class will become a part of the [ktbyte](https://github.com/ktbyte/processing-libraries/tree/master/ktbyte-library) library. The file `Sprite.pde` will be renamed to `Sprite.java` and moved to `./ktbyte-library/src/ktbyte/sprite` folder. And, the example of its usage `SpriteTest.pde` will be moved to the `./ktbyte-library/examples/Sprite` folder in order to comply with the [ktbyte](https://github.com/ktbyte/processing-libraries/tree/master/ktbyte-library) library folder structure.