import ktgui.*;

InputTextBox textBox1, textBox2;
KTGUI ktgui;

void setup() {
  size(500, 500);

  ktgui = new KTGUI(this);

  textBox1 = new InputTextBox(ktgui, "Upper TextBox", 50, 50, 300, 40);

  textBox1.setText("Enter some text in here ...");
  textBox1.alignAboutCanvas(CENTER, 0);
  textBox1.setTextSize(16);
  textBox1.setBorderRoundings(10, 10, 0, 0);
  textBox1.addEventAdapter(new KTGUIEventAdapter() {
      public void onEnterKeyPressed() {
          println(textBox1.getText());
          textBox2.setText(textBox1.getText());
          textBox1.setText("");
      }
  });

  textBox2 = new InputTextBox(ktgui, "Lower TextBox", 50, 150, 300, 40);
  textBox2.setBorderRoundings(0, 0, 10, 10);
  textBox2.alignAboutCanvas(CENTER, 0);
  textBox2.setText("Or here ...");
  textBox2.setTextSize(16);
  textBox2.addEventAdapter(new KTGUIEventAdapter() {
      public void onEnterKeyPressed() {
          println(textBox2.getText());
          textBox1.setText(textBox2.getText());
          textBox2.setText("");
      }
  });
}

void draw() {

}