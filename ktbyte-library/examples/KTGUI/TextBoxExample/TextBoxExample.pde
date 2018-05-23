import ktgui.*;

KTGUITextBox textBox1, textBox2;
KTGUI ktgui;

void setup() {
  size(500, 500);

  ktgui = new KTGUI(this);

  textBox1 = new KTGUITextBox(ktgui, "A TextBox", 50, 50, 300, 50);

  textBox1.setText("Enter first name...");
  textBox1.setTextSize(16);
//   textBox1.setKeyEventListener(new KeyEventListener() {
//     public void onEnterKey() {
//       println(textBox1.getText());
//     }
//   }  
//   );

//   textBox2 = new TextBox(this, 50, 150, 150, 40);
//   textBox2.setBorderRoundings(12, 12, 12, 12);
//   textBox2.setText("Enter last name...");
//   textBox2.setTextSize(16);
//   textBox2.setKeyEventListener(new KeyEventListener() {
//     public void onEnterKey() {
//       println(textBox2.getText());
//     }
//   }
//   );
}

void draw() {

}