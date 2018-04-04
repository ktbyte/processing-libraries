KTAudioController ktAudio;
KTSound bgMusic, clickEffect;
boolean bgMusicIsOn;

void setup() {
  size(400, 400);
  bgMusicIsOn = false;
  ktAudio = new KTAudioController(this);
  bgMusic = new KTSound(this, "http://www.noiseaddicts.com/samples_1w72b820/2553.mp3");
  clickEffect = new KTSound(this, "http://www.noiseaddicts.com/samples_1w72b820/3731.mp3");
  ktAudio.add(bgMusic);
  ktAudio.add(clickEffect);
}

void draw() {
  background(color(65, 237, 170));
  textAlign(CENTER);
  textSize(26);
  text("Click!", width/2, height/2);
  if (!bgMusicIsOn && ktAudio.getIsReady()) {
    bgMusic.loop();
    bgMusicIsOn = true;
  }
}

void mousePressed() {
  clickEffect.play();
}