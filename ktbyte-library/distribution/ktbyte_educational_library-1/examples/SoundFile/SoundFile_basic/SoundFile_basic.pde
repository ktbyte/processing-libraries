import ktbyte.sound.*;

boolean musicIsOn;

SoundFile corndogSong;
SoundFile triangle;
SoundFile yeah;
SoundFile boom;

void setup() {
    size(400, 400);
    musicIsOn = false;
    
    corndogSong = new SoundFile(this, "s3.mp3");
    corndogSong.load();
    
    triangle = new SoundFile(this, "triangle.mp3");
    triangle.load();
    
    yeah = new SoundFile(this, "yeah.mp3");
    yeah.load();
    
    boom = new SoundFile(this, "s1.mp3");
    boom.load();
    
}

void draw() {
    background(65, 237, 170);
    textSize(25);
    text("Press UP: Play fancy waltz song", 10, 50);
    text("Press RIGHT: Triangle", 10, 100);
    text("Press DOWN: YEAH!", 10, 150);
    text("Press LEFT: BOOM!", 10, 200);
    text("Press 'L': Loop Triangle", 10, 250);
    text("Press 'S': Stop Triangle", 10, 300);
    // println(corndogSong.isLoaded());
    if (!musicIsOn && corndogSong.isLoaded()) {
        println("play!");
        corndogSong.play();
        musicIsOn = true;
    }
}

void mousePressed() {
    triangle.play();
}

void keyPressed() {
    if (keyCode == 39) {
        triangle.play();
    } else if (keyCode == 40) {
        yeah.play();
    } else if (keyCode == 37) {
        boom.play();        
    } else if (keyCode == 32) {
        corndogSong.stop();
    } else if (keyCode == 76) {
        triangle.loop();
    } else if (keyCode == 38) {
        corndogSong.play();
    } else if (keyCode == 83) {
        triangle.stop();
    }
}