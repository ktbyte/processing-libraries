import ktbyte.midi.*;

// Try pressing the keys q through p in the keyboard
// The sharps also work

KTByteSoundCipher sc;
void setup() {
  sc = new KTByteSoundCipher(this);
}

void draw() {
}

char[]    keys = {'q', '2', 'w', 'e', '4', 'r', '5', 't', 'y', '7', 'u', '8', 'i', '9', 'o', 'p'};
String[] notes = {"A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C"};
void keyPressed() {
  int index = -1;
  for (int i = 0; i < keys.length; i++) {
    if (keys[i] == key) {
      index = i;
    }
  }
  if (index >= 0) {
    println("Pressed key "+key+", corresponding to array index "+index);
    int note = index + 57;
    println("Playing note "+note+", which corresponds to "+notes[index]);
    sc.playNote(note, 100, 0.2);
  }
}