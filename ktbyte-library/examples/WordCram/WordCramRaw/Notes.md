# Notes about WordCram library clone developing process

[TOC]



## Set of classes and methods

- Word
  - weight
  - width, height (of bounding rectangle - might be needed for packing algorithm)
  - font color
  - font size
- WordCram
  - loadFromArray (load Words from String[] array)
  - loadFromFile (load Words from file on disk)
  - loadWords (directly from array of Words)
- Bounding Box Tree
- Rectangle Packing
  - Around Point
  - Inside Rectangle
  - Inside Circle
  - Inside Polyline


## WordCram



## Word



## Questions

- [x] Is KTBYTE-Coder able to use Collections.sort ?

**Yes,**

```java
ArrayList<String> al = new ArrayList<String>();
al.add("B");
al.add("!");
al.add("Z");
al.add("A");
Collections.sort(al);
print(al);
```

prints `!,A,B,Z  `





## ToDo

