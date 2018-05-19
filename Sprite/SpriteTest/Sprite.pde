// The Sprite class represents a Sprite (Image) on the canvas with
// which you can move and rotate. The Sprite class should be used
// with imageMode CENTER. In general, the fields/instance variables
// for the Sprite class should not be used outside of the class.

/* CONSTRUCTORS:
 
 All constructors create Sprites at (x, y) with size (w, h)
 Different constructors are available depending on image source,
 as well as a copy constructor.
 
 Sprite(String url, float x, float y, float w, float h)
 create a Sprite and load its image
 DON'T use this too many times - it will load a new image each time!
 
 Sprite(PImage img, float x, float y, float w, float h)
 create a Sprite with pre-loaded image
 
 Sprite(float x, float y, float w, float h)
 create a solid black Sprite
 color can change by useing the setColor() method
 
 Sprite(Sprite s)
 create a copy of Sprite s
 
 */

/* METHODS/FUNCTIONS:
 
 BASIC FUNCTIONS
 
 void display()
 draw the Sprite with its current information
 
 void setSize(float w, float h)
 
 void setCoor(float x, float y)
 set both position coordinates at once
 
 void setX(float x)
 
 void setY(float y)
 
 void setImage(PImage img)
 
 float getX()
 
 float getY()
 
 float getW()
 get the width of the sprite
 
 float getH()
 get the height of the sprite
 
 PImage getImage()
 
 IMAGE ADJUSTMENT FUNCTIONS
 
 void frontAngle(float degrees)
 sets the "front" of the Sprite to be something other than 0 (right).
 for example images facing upward should set frontAngle(-90).
 
 TURNING/DIRECTION FUNCTIONS
 
 void turn(float degrees)
 turn the specified number of degrees
 
 void turnToPoint(float x, float y)
 turn to face the specified (x, y) location
 
 void turnToDir(float angle)
 turn to the specified angle
 
 void turnToSprite(Sprite s)
 turn to the specified Sprite s
 
 float getDir()
 get the direction (in degrees) the Sprite is facing
 
 MOVEMENT FUNCTIONS
 
 void moveToPoint(float x, float y)
 move sprite to location (x, y)
 
 void moveToSprite(Sprite s)
 move sprite to location of Sprite s
 
 void forward(float steps)
 move forward in the direction the sprite is facing
 by the specified number of steps (pixels)
 
 void sideStep(float steps)
 move "sideways" relative to the sprite's current facing
 negative steps goes "left", positive goes "right"
 
 // DISTANCE, LOCATION, AND TOUCHING FUNCTIONS
 
 float distTo(Sprite s)
 calculate the distance from this Sprite to Sprite s
 
 float distTo(float x, float y)
 calculate the distance from this Sprite to (x,y)
 
 boolean touchingSprite(Sprite s)
 
 boolean touchingPoint(float x, float y)
 
 boolean isInsideScreen()
 
 */

public class Sprite {
  // do not modify these except through the provided methods
  private PImage img;
  private float w;
  private float h;
  private float x;
  private float y;
  private PVector rotVector; // for movement
  private float front = 0;   // angle of front relative to right of image

  // constructor to create a Sprite at (x, y) with size (w, h)
  // using the image provided by the url
  Sprite(String url, float x, float y, float w, float h) {
    img = loadImage(url);
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    rotVector = new PVector(1, 0, 0);
  }

  // constructor to create a Sprite at (x, y) with size (w, h)
  // with a solid black color. The color of this Sprite can
  // change using the setColor() function
  Sprite(float x, float y, float w, float h) {
    img = createImage(1, 1, RGB);
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    rotVector = new PVector(1, 0, 0);
  }

  // consturctor to create a copy of Sprite s
  Sprite(Sprite s) {
    img = s.img;
    x = s.x;
    y = s.y;
    w = s.w;
    h = s.h;
    rotVector = new PVector(s.rotVector.x, s.rotVector.y, 0);
  }

  // adjust the direction of the PImage of the Sprite
  // without changing the orientation of the Sprite
  void frontAngle(float degrees) {
    front = radians(degrees);
    // movement done from this direction from now on
    rotVector.rotate(front);
  }

  // change the color of a Sprite created without an image
  void setColor(float r, float g, float b) {
    int c = color(r, g, b);
    for (int x = 0; x < img.width; x++) {
      for (int y = 0; y < img.height; y++) {
        img.set(x, y, c);
      }
    }
  }

  // turn the specified number of degrees
  void turn(float degrees) {
    rotVector.rotate(radians(degrees));
  }

  // turn to the specified (x, y) location
  void turnToPoint(float x, float y) {
    rotVector.set(x - this.x, y - this.y, 0);
    rotVector.setMag(1);
  }

  // turn to the specified angle
  void turnToDir(float angle) {
    float radian = radians(angle);
    rotVector.set(cos(radian), sin(radian));
    rotVector.setMag(1);
  }

  // turn to the specified Sprite s
  void turnToSprite(Sprite s) {
    turnToPoint(s.x, s.y);
  }

  // move sprite to location (x, y)
  void moveToPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // move sprite to location of Sprite s
  void moveToSprite(Sprite s) {
    x = s.x;
    y = s.y;
  }

  // move in the X direction by the specified amount 
  void moveX(float x) {
    this.x += x;
  }

  // move in the Y direction by the specified amount 
  void moveY(float y) {
    this.y += y;
  }

  // move forward in the direction the sprite is facing
  // by the specified number of steps (pixels)
  void forward(float steps) {
    x += rotVector.x * steps;
    y += rotVector.y * steps;
  }

  // move 90 degree clockwise from the direction
  // the sprite is facing by the specified number of steps (pixels)
  void sideStep(float steps) {
    rotVector.rotate(PI / 2);
    x += rotVector.x * steps;
    y += rotVector.y * steps;
    rotVector.rotate(-PI / 2);
  }

  // draw the Sprite. This function
  // should be called in the void draw() function
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(rotVector.heading() - front);
    image(img, -w * 0.5, -h * 0.5, w, h);
    popMatrix();
  }

  // change the direction of the Sprite by flipping
  // the x component of its direction
  void flipX() {
    rotVector.x *= -1;
  }

  // change the direction of the Sprite by flipping
  // the y component of its direction
  void flipY() {
    rotVector.y *= -1;
  }

  // set the size of the Sprite
  void setSize(float w, float h) {
    this.w = w;
    this.h = h;
  }

  void setCoor(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // set the x coordinate
  void setX(float x) {
    this.x = x;
  }

  // set the y coordinate
  void setY(float y) {
    this.y = y;
  }

  // change the image of the Sprite
  void setImage(PImage img) {
    this.img = img;
  }

  // get the x coordinate of the sprite 
  float getX() {
    return x;
  }

  // get the y coordinate of the sprite
  float getY() {
    return y;
  }

  // get the width of the sprite
  float getW() {
    return w;
  }

  // get the height of the sprite
  float getH() {
    return h;
  }

  // get the image of the sprite
  PImage getImage() {
    return img;
  }

  // get the direction (in degrees) the Sprite is facing
  float getDir() {
    return degrees(rotVector.heading());
  }

  // calculate the distance from this Sprite to Sprite s
  float distTo(Sprite s) {
    return dist(x, y, s.x, s.y);
  }

  float distToPoint(float x, float y) {
    return dist(this.x, this.y, x, y);
  }

  PVector[] getPoints() {
    float[] dx = {-w/2, w/2, w/2, -w/2};
    float[] dy = {-h/2, -h/2, h/2, h/2};
    PVector[] points = new PVector[4];
    float angle = rotVector.heading() - front;
    float cosA = cos(angle);
    float sinA = sin(angle);
    for (int i = 0; i < 4; i++) {
      float newX = cosA * dx[i] + sinA * dy[i];
      float newY = sinA * dx[i] - cosA * dy[i];
      points[i] = new PVector(newX + x, newY + y);
    }
    return points;
  }

  // checks whether this Sprite is touching Sprite s
  boolean touchingSprite(Sprite s) {
    PVector[] s1Points = s.getPoints();
    PVector[] s2Points = this.getPoints();
    
    for (int i = 0; i < 4; i++) {
      PVector a = s1Points[i], b = s1Points[(i+1)%4];
      for (int j = 0; j < 4; j++) {
        PVector c = s2Points[j], d = s2Points[(j+1)%4];
        if (isCCW(a, c, d) != isCCW(b, c, d) && isCCW(a, b, c) != isCCW(a, b, d)) {
          return true;
        }
      }
    }
    
    return false;
  }

  // checks whether this Sprite is touching the specified point
  boolean touchingPoint(float x, float y) {
    PVector c = new PVector(x, y);
    PVector d = new PVector(-1, -1);
    // count how many edge of this Sprint the line p-q crosses
    int count = 0;
    PVector[] s1Points = this.getPoints();
    for (int i = 0; i < 4; i++) {
      PVector a = s1Points[i], b = s1Points[(i+1)%4];
      if (isCCW(a, c, d) != isCCW(b, c, d) && isCCW(a, b, c) != isCCW(a, b, d)) {
        count++;
      }
    }

    return count % 2 == 1;
  }

  // checks whether this Sprite is inside the canvas
  boolean isInsideScreen() {
    PVector[] points = this.getPoints();
    for (PVector p : points) {
      if (0 <= p.x && p.x < width && 0 <= p.y && p.y < height) {
        return true;
      }
    }
    return false;
  }

  private boolean isCCW(PVector A, PVector B, PVector C) {
    return (C.y - A.y) * (B.x - A.x) > (B.y - A.y) * (C.x - A.x);
  }
}
