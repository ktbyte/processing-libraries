import ktbyte.midi.*;

KTByteSoundCipher sc;
void setup() {
    sc = new KTByteSoundCipher(this);
    sc.playNote(60,100,2.0);
}