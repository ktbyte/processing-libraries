import ktbyte.midi.*;

KTSoundCipher sc;
void setup() {
    sc = new KTSoundCipher(this);
    sc.playNote(60,100,2.0);
}