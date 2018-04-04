import ddf.minim.*;

Minim minim = new Minim(this);
AudioLibJS audioLibJS;

public interface AudioLibJS {
  void loadSound(String name);
  void playSound(String name);
  void stopSound(String name);
  void loopSound(String name);
  void setVolume(String name, float volume);
}

void bindJavascript(AudioLibJS jsLib) {
  audioLibJS = jsLib;
  ktAudio.loadQueuedSounds();
}

ArrayList<String> jsSoundsToLoad = new ArrayList<String>();

public class KTAudioController {
  ArrayList<KTSound> sounds;
  PApplet pap;
  boolean isReady;

  public KTAudioController(PApplet pap) {
    this.pap = pap;
    if (pap.javaVersionName != null) {
      this.isReady = true;
    } else {
      // Waiting for the javascript binding
      this.isReady = false;
    }
    this.sounds = new ArrayList();
  }

  void add(KTSound ktSound) {
    sounds.add(ktSound);
  }

  void loadQueuedSounds() {
    for (String soundName : jsSoundsToLoad) {
      audioLibJS.loadSound(soundName);
    }
    this.isReady = true;
  }

  boolean getIsReady() {
    return isReady;
  }
}

public class KTSound {
  private AudioPlayer sound;
  private PApplet pap;
  private String path;

  KTSound(PApplet pap, String path) {
    this.pap = pap;
    this.path = path;
    if (pap.javaVersionName == null) {
      jsSoundsToLoad.add(getPathName(path));
    } else {
      sound = minim.loadFile(path);
    }
  }

  void play() {
    if (pap.javaVersionName == null && audioLibJS != null) {
      audioLibJS.playSound(getPathName(path));
    } else {
      sound.rewind();
      sound.play();
    }
  };

  void stop() {
    if (pap.javaVersionName == null && audioLibJS != null) {
      audioLibJS.stopSound(getPathName(path));
    } else {
      sound.pause();
    }
  };


  void loop() {
    if (pap.javaVersionName == null && audioLibJS != null) {
      audioLibJS.loopSound(getPathName(path));
    } else {
      sound.loop();
    }
  };

  void setVolume(float volume) {
    if (pap.javaVersionName == null && audioLibJS != null) {
      // buzz.js uses a '0-100' interval for the volume parameter 
      audioLibJS.setVolume(getPathName(path), volume * 100);
    } else {
      sound.setVolume(volume);
    }
  };

  void setContext(PApplet pap) {
    this.pap = pap;
  }
}

String getPathName(String name) {
  //println(name.substring(0, getLastIndexOf(name, '.')));
  return name.substring(0, getLastIndexOf(name, '.'));
}

int getLastIndexOf(String str, char ch) {
  for (int i = str.length()-1; i > 0; i--) {
    if (str.charAt(i) == new Character(ch)) {
      return i;
    }
  }
  println((char)ch);
  return -1;
}