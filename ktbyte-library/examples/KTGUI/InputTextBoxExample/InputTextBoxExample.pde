import ktbyte.gui.*;

InputTextBox textBox1, textBox2;
KTGUI ktgui;

void setup() {
  size(500, 500);

  ktgui = new KTGUI(this);

  textBox1 = ktgui.createInputTextBox("Upper TextBox", 50, 50, 500, 80);
  textBox1.setTextSize(36);
  textBox1.alignAboutCanvas(CENTER, 0);
  textBox1.setWelcomeText("Enter some text in here ...");
  textBox1.setBorderRoundings(10, 10, 0, 0);
  textBox1.addEventAdapter(new EventAdapter() {
      public void onEnterKeyPressed() {
          println(textBox1.getText());
          textBox2.setText(textBox1.getText());
          textBox1.setText("");
      }
  });

  textBox2 = ktgui.createInputTextBox("Lower TextBox", 50, 150, 300, 40);
  textBox2.setTextSize(18);
  textBox2.alignAboutCanvas(CENTER, 0);
  textBox2.setWelcomeText("Or here ...");
  textBox2.setBorderRoundings(0, 0, 10, 10);
  textBox2.addEventAdapter(new EventAdapter() {
      public void onEnterKeyPressed() {
          println(textBox2.getText());
          textBox1.setText(textBox2.getText());
          textBox2.setText("");
      }
  });
}

void draw() {

}