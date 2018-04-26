import ktbyte.midi.*;

KTByteSoundCipher sc;
void setup() {
    sc = new KTByteSoundCipher(this);
}
 
int note = 60;
void draw() {
    if(frameCount % 10 == 0) {
        println("Playing note: "+note);
        sc.playNote(note,100,0.5);
       
        if(note >= 100) {
            noLoop();
        }else {
            note++;
        }
    }
}