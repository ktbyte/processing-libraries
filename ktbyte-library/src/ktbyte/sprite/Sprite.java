package ktbyte.sprite;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PImage;
import processing.core.PVector;

public class Sprite {
	public PApplet	pa;
	// do not modify these except through the provided methods
	private PImage			_img;
	private float			_w;
	private float			_h;
	private float			_x;
	private float			_y;
	private PVector			_rotVector;										// for movement
	private float			_front			= 0;							// angle of front relative to right of image

	private PVector			_hitboxCenter	= new PVector();
	private PVector[]		_hitbox;

	private boolean			_flipped		= false;
	private PVector			out				= new PVector(-10000, -10000);	// any outside point


	// method to initialize the Sprite at (x, y) with size (w, h)
	// using the image provided in the url
	public Sprite(PApplet pa, String url, float x, float y, float w, float h) {
		this.pa = pa;
		_img = pa.loadImage(url);
		_x = x;
		_y = y;
		_w = w;
		_h = h;
		_rotVector = new PVector(1, 0, 0);
		resetRectHitbox();
	}

	// method to initialize the Sprite at (x, y) with size (w, h)
	// with a solid black color. The color of this Sprite can
	// change using the setColor() function
	public Sprite(PApplet pa, float x, float y, float w, float h) {
		this.pa = pa;
		_img = pa.createImage(1, 1, PConstants.RGB);
		_x = x;
		_y = y;
		_w = w;
		_h = h;
		_rotVector = new PVector(1, 0, 0);
		resetRectHitbox();
	}

	// method to initialize the Sprite from a copy of another 
	// Sprite instance
	public Sprite(PApplet pa, Sprite s) {
		this.pa = pa;
		_img = s._img;
		_x = s._x;
		_y = s._y;
		_w = s._w;
		_h = s._h;
		_rotVector = new PVector(s._rotVector.x, s._rotVector.y, 0);
		_front = s._front;
		_hitboxCenter = new PVector(s._hitboxCenter.x, s._hitboxCenter.y);
		_hitbox = new PVector[s._hitbox.length];
		for (int i = 0; i < _hitbox.length; i++) {
			_hitbox[i] = new PVector(s._hitbox[i].x, s._hitbox[i].y);
		}
		_flipped = s._flipped;
	}

	// adjust the direction of the PImage of the Sprite
	// without changing the orientation of the Sprite
	public void frontAngle(float degrees) {
		float newFront = PApplet.radians(degrees);

		// movement done from this direction from now on
		_rotVector.rotate(newFront - _front);

		_front = newFront;
	}

	// set rectangular hitbox of given size
	// h is along the front-back axis
	// w is along the perpendicular axis
	public void setRectHitbox(float w, float h) {
		_hitbox = new PVector[] {
				new PVector(-w / 2, h / 2),
				new PVector(-w / 2, -h / 2),
				new PVector(w / 2, -h / 2),
				new PVector(w / 2, h / 2)
		};
	}

	// set rectangular hitbox of size based on image
	public void resetRectHitbox() {
		setRectHitbox(_w, _h);
	}

	// set circular hitbox of given size
	public void setRoundHitbox(float r) {
		_hitbox = new PVector[] {
				new PVector(r, r * 2)
		};
	}

	// set circular hitbox based on image size
	public void resetRoundHitbox() {
		setRoundHitbox((_w + _h) / 4);
	}

	// recenter hitbox relative to center of image
	public void setHitboxCenter(float x, float y) {
		_hitboxCenter = new PVector(x, y);
	}

	// recenter hitbox to exactly center of image
	public void resetHitboxCenter() {
		_hitboxCenter = new PVector(0, 0);
	}

	public void setHitboxPoints(PVector[] array) {
		if (array.length > 0) {
			boolean valid = true;
			for (PVector pv : array)
				if (pv == null)
					valid = false;

			if (valid)
				_hitbox = array;
			else
				PApplet.println("invalid hitbox: " + java.util.Arrays.toString(array));
		} else {
			PApplet.println("hitbox must have 3+ points: " + java.util.Arrays.toString(array));
		}
	}

	// change the color of a Sprite created without an image
	public void setColor(float r, float g, float b) {
		int c = pa.color(r, g, b);
		for (int x = 0; x < _img.width; x++) {
			for (int y = 0; y < _img.height; y++) {
				_img.set(x, y, c);
			}
		}
	}

	// flips Sprite image across its X axis
	public void flip() {
		_flipped = !_flipped;
	}

	// turn the specified number of degrees
	public void turn(float degrees) {
		_rotVector.rotate(PApplet.radians(degrees));
	}

	// turn to the specified (x, y) location
	public void turnToPoint(float x, float y) {
		_rotVector.set(x - _x, y - _y, 0);
		_rotVector.setMag(1);
	}

	// turn to the specified angle
	public void turnToDir(float angle) {
		float radian = PApplet.radians(angle);
		_rotVector.set(PApplet.cos(radian), PApplet.sin(radian));
		_rotVector.setMag(1);
	}

	// turn to the specified Sprite s
	public void turnToSprite(Sprite s) {
		turnToPoint(s._x, s._y);
	}

	// move sprite to location (x, y)
	public void moveToPoint(float x, float y) {
		_x = x;
		_y = y;
	}

	// move sprite to location of Sprite s
	public void moveToSprite(Sprite s) {
		_x = s._x;
		_y = s._y;
	}

	// move in the X direction by the specified amount 
	public void moveX(float x) {
		_x += x;
	}

	// move in the Y direction by the specified amount 
	public void moveY(float y) {
		_y += y;
	}

	public void moveXY(float dx, float dy) {
		_x += dx;
		_y += dy;
	}

	// move forward in the direction the sprite is facing
	// by the specified number of steps (pixels)
	public void forward(float steps) {
		_x += _rotVector.x * steps;
		_y += _rotVector.y * steps;
	}

	// move 90 degree clockwise from the direction
	// the sprite is facing by the specified number of steps (pixels)
	public void sideStep(float steps) {
		_rotVector.rotate(PApplet.PI / 2);
		_x += _rotVector.x * steps;
		_y += _rotVector.y * steps;
		_rotVector.rotate(-PApplet.PI / 2);
	}

	// draw the Sprite. This function
	// should be called in the void draw() function
	public void display() {
		pa.pushMatrix();
		pa.pushStyle();

		pa.translate(_x, _y);
		pa.rotate(_rotVector.heading() - _front);
		if (_flipped)
			pa.scale(-1, 1);
		pa.imageMode(PApplet.CENTER);
		pa.image(_img, 0, 0, _w, _h);

		pa.popStyle();
		pa.popMatrix();
	}

	public void displayHitbox() {
		PVector cen = _getCenter();

		pa.pushStyle();
		pa.stroke(255, 0, 0);
		pa.strokeWeight(5);
		pa.noFill();

		if (_hitbox.length == 1) {
			pa.ellipseMode(PApplet.CENTER);
			pa.ellipse(cen.x, cen.y, _hitbox[0].y, _hitbox[0].y);
		} else {
			PVector[] corners = _getPoints();
			for (int i = 0; i < corners.length; i++) {
				PVector a = corners[i];
				PVector b = corners[(i + 1) % corners.length];
				pa.line(a.x, a.y, b.x, b.y);
			}
		}

		pa.line(cen.x, cen.y, cen.x + _rotVector.x * 20, cen.y + _rotVector.y * 20);

		pa.fill(255, 0, 0);
		pa.noStroke();
		pa.ellipse(cen.x, cen.y, 15, 15);

		pa.popStyle();
	}

	// change the direction of the Sprite by flipping
	// the x component of its direction
	public void flipX() {
		_rotVector.x *= -1;
	}

	// change the direction of the Sprite by flipping
	// the y component of its direction
	public void flipY() {
		_rotVector.y *= -1;
	}

	// set the size of the Sprite
	public void setSize(float w, float h) {
		_w = w;
		_h = h;
	}

	public void setCoor(float x, float y) {
		_x = x;
		_y = y;
	}

	// set the x coordinate
	public void setX(float x) {
		_x = x;
	}

	// set the y coordinate
	public void setY(float y) {
		_y = y;
	}

	// change the image of the Sprite
	public void setImage(PImage img) {
		_img = img;
	}

	// get the x coordinate of the sprite 
	public float getX() {
		return _x;
	}

	// get the y coordinate of the sprite
	public float getY() {
		return _y;
	}

	// get the width of the sprite
	public float getW() {
		return _w;
	}

	// get the height of the sprite
	public float getH() {
		return _h;
	}

	// get the image of the sprite
	public PImage getImage() {
		return _img;
	}

	// get the direction (in degrees) the Sprite is facing
	public float getDir() {
		return PApplet.degrees(_rotVector.heading());
	}

	// calculate the distance from this Sprite to Sprite s
	public float distTo(Sprite s) {
		return PApplet.dist(_x, _y, s._x, s._y);
	}

	public float distToPoint(float x, float y) {
		return PApplet.dist(_x, _y, x, y);
	}

	// checks whether this Sprite is touching Sprite s
	public boolean touchingSprite(Sprite s) {
		if (s._hitbox.length == 1) {
			if (_hitbox.length == 1) {
				return PVector.dist(this._getCenter(), s._getCenter()) <= this._hitbox[0].x + s._hitbox[0].x;
			}
			return _circPoly(s._getCenter(), s._hitbox[0].x, this._getPoints());
		}
		if (_hitbox.length == 1) {
			return _circPoly(this._getCenter(), this._hitbox[0].x, s._getPoints());
		}

		PVector[] s1Points = s._getPoints();
		PVector[] s2Points = this._getPoints();

		for (int i = 0; i < s1Points.length; i++) {
			PVector a = s1Points[i], b = s1Points[(i + 1) % s1Points.length];
			for (int j = 0; j < s2Points.length; j++) {
				PVector c = s2Points[j], d = s2Points[(j + 1) % s2Points.length];

				// sprites touch if ab crosses cd
				if (_clockwise(a, c, d) != _clockwise(b, c, d) && // a & b on different sides of cd, and
						_clockwise(a, b, c) != _clockwise(a, b, d)) { // c & d on different sides of ab
					return true;
				}
			}
		}

		return _insidePts(s1Points, s2Points) || _insidePts(s2Points, s1Points);
	}

	//checks to see if this Sprite is fully inside another sprite
	public boolean insideSprite(Sprite s) {
		if (s._hitbox.length == 1) {
			if (_hitbox.length == 1) {
				return PVector.dist(s._getCenter(), this._getCenter()) < s._hitbox[0].x - this._hitbox[0].x;
			}
			return _insideCirc(_getPoints(), s._getCenter(), s._hitbox[0].x);
		}
		if (s._hitbox.length == 1) {
			// TODO: check if center is in middle but NOT touching any side
			//   (will want to adapt existing _circPoly to separate side-touching
			//    code into individual method)
			return false;
		}
		return _insidePts(this._getPoints(), s._getPoints());
	}

	// checks whether this Sprite is touching the specified point
	public boolean touchingPoint(float x, float y) {
		if (_hitbox.length == 1)
			return PApplet.dist(x, y, _hitboxCenter.x, _hitboxCenter.y) < _hitbox[0].x;
		return _ptPoly(new PVector(x, y), _getPoints());
	}

	// checks whether this Sprite's hitbox is at least partially inside the canvas
	// TODO: technically this returns true even if circular Sprite is just outside
	//   at the corners, and false if a tilted rectangular Sprite's edge crosses
	//   a corner with endpoints outside
	public boolean isInsideScreen() {
		if (_hitbox.length == 1) {
			float r = _hitbox[0].x;
			PVector c = _getCenter();
			return 0 <= c.x + r && c.x - r < pa.width && 0 <= c.y + r && c.y - r < pa.height;
		}

		PVector[] points = this._getPoints();
		for (PVector p : points) {
			if (0 <= p.x && p.x < pa.width && 0 <= p.y && p.y < pa.height) {
				return true;
			}
		}
		return false;
	}

	// (pseudo-static) checks whether pt touches polygon
	private boolean _ptPoly(PVector pt, PVector[] poly) {
		// count edges crossed by the line connecting the target point to "the outside"
		int count = 0;

		for (int i = 0; i < poly.length; i++) {
			PVector a = poly[i], b = poly[(i + 1) % poly.length]; // edge points
			if (_clockwise(a, pt, out) != _clockwise(b, pt, out) && // a & b on different sides of line
					_clockwise(a, b, pt) != _clockwise(a, b, out)) { // tgt & out on diff sides of edge
				count++;
			}
		}

		return count % 2 == 1;
		// a convex poly would be crossed on one edge;
		//   concave could be crossed on any odd # of edges
	}

	// (pseudo-static) checks whether circle is touching polygon
	//   (including one inside the other)
	private boolean _circPoly(PVector center, float r, PVector[] poly) {
		// center is in polygon
		if (_ptPoly(center, poly))
			return true;
		if (_insideCirc(poly, center, r))
			return true;

		// circle encloses any corner
		for (PVector corner : poly) {
			if (PApplet.dist(center.x, center.y, corner.x, corner.y) < r)
				return true;
		}

		// circle is adjacent and close enough to any side
		for (int i = 0; i < poly.length; i++) {
			if (_circSeg(center, r, poly[i], poly[(i + 1) % poly.length]))
				return true;
		}

		return false;
	}

	// (pseudo-static) 
	// checks if circle touches segment AB from a perpendicular direction,
	//   but NOT from "beyond the ends"
	//   (this should be checked separately if desired)
	// aka, checks if center forms a perpendicular to any point on segment
	//   with length <= r 
	private boolean _circSeg(PVector center, float r, PVector a, PVector b) {
		PVector ab = PVector.sub(b, a);
		PVector abPerp = (new PVector(-ab.y, ab.x)).normalize().mult(r);

		PVector[] limits = new PVector[] {
				PVector.add(a, abPerp), // move perpendicular to the segment by
				PVector.sub(a, abPerp), // distance r from each of the endpoints,
				PVector.sub(b, abPerp), // forming a bounding rectangle
				PVector.add(b, abPerp)
		};

		return _ptPoly(center, limits);
	}

	// (pseudo-static) checks whether all inPts are completely within the outPts
	//   TODO: does not check whether edges between inPts are within outPts!
	private boolean _insidePts(PVector[] inPts, PVector[] outPts) {

		for (int i = 0; i < inPts.length; i++) {
			// direction of angular relationship to any side must match
			//   direction of relationship to opposite side
			if (!_ptPoly(inPts[i], outPts))
				return false;
		}
		return true;
	}

	// (pseudo-static) checks whether all inPts are completely within circle
	private boolean _insideCirc(PVector[] inPts, PVector center, float r) {

		for (int i = 0; i < inPts.length; i++) {
			// direction of angular relationship to any side must match
			//   direction of relationship to opposite side
			if (PVector.dist(inPts[i], center) > r)
				return false;
		}
		return true;
	}

	// get hitbox absolute center based on image center, relative offset, rotation, and front
	private PVector _getCenter() {
		PVector cen = new PVector(_hitboxCenter.x, _hitboxCenter.y);
		cen.rotate(_rotVector.heading() - _front);
		cen.x += _x;
		cen.y += _y;
		return cen;
	}

	// get points representing rectangular hitbox
	private PVector[] _getPoints() {
		PVector cen = _getCenter();

		PVector[] points = new PVector[_hitbox.length];
		float angle = _rotVector.heading();
		for (int i = 0; i < _hitbox.length; i++) {
			points[i] = new PVector(_hitbox[i].x, _hitbox[i].y);
			points[i].rotate(angle);
			points[i].x += cen.x;
			points[i].y += cen.y;
		}
		return points;
	}

	// checks whether motion in AB turns clockwise to follow BC
	// i.e. which way is angle ABC concave?
	private boolean _clockwise(PVector A, PVector B, PVector C) {
		return (C.y - A.y) * (B.x - A.x) > (B.y - A.y) * (C.x - A.x);
	}
}
