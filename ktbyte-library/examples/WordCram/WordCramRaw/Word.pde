class Word {
  String text;
  float weight = 0f;
  float width, height;
  float fontHeight = 10f;
  float x, y, angle;

  public Word(String text) {
    this.text = text;
  }

  public Word(String text, float weight) {
    this.text = text;
    this.weight = weight;
  }


}