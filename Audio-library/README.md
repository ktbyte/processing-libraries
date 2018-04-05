# Audio library

## Introduction

This library provides methods to handle and play 'mp3' sound files and is designed to work with both the Processing and [KTByte coder](https://www.ktbyte.com/coder) environments. It is a 'wrapper' which uses the 'minim' library for the Processing environment and the 'Buzz.js' library for the Processing.js/browser environment.

```java
KTAudioController ktAudio;
KTSound clickEffect;

void setup() {
  size(400, 400);
  ktAudio = new KTAudioController(this);
  clickEffect = new KTSound(this, "http://www.noiseaddicts.com/samples_1w72b820/3731.mp3");
  ktAudio.add(clickEffect);
}

void draw() {
  background(color(65, 237, 170));
}

void mousePressed() {
  clickEffect.play();
}
```

#### Methods of KTAudioController class:

**KTAudioController(PApplet pap)** - this constructs a new KTAudioController object within the current context (PApplet)


`void add(KTSound ktSound)` Registers a KTSound object in the audio controller.


`boolean getIsReady()` Returns true if the registered audio samples are ready to be used.



#### Methods of KTSound class:

**KTSound(PApplet pap, String path)** - this constructs a new KTSound object within the current context (PApplet) with the filepath/URL of the sound.


`void play()` - Starts the playback of a soundfile. Only plays once.

`void stop()` - Stops the playback of a soundfile.

`void loop()` - Starts the a looping playback of a soundfile.

`void setVolume(float volume)` - Changes the volume of the soundfile. Accepts any value between 0.0 and 1.0.


#### Note:

---
