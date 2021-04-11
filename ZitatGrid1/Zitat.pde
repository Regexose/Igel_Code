class Zitat {
  PImage img;
  IntList coords;
  float angle, evenAngle, mass, scale;
  int index, w, h;
  PGraphics surface;
  String zitat, fileName;
  PVector firstPos, position, velocity, acceleration, center;
  boolean clicked = false;
  color col;

  Zitat(int index, String _z, PImage _img, float _angle, IntList _c) {
    this.index = index; 
    this.zitat = _z;
    this.img = _img;
    this.angle = _angle;
    this.coords = _c;
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector (0, 0);
    this.mass = 30;
    this.scale = 0.25;
    this.w = int(img.width * this.scale);
    this.h = int(img.height * this.scale);
    this.col = color(0, 255, 0, 200);
  }

  void initialPos (PVector vec) {
    this.position = vec;
    int xMin = this.coords.get(0);
    int yMin = this.coords.get(1);
    this.firstPos = new PVector(xMin, yMin);
  }

  void applyForce(PVector force) {
    this.acceleration.add(force);
  }


  void move() {
    this.position.add(random(-1, 1), random(-1, 1));
  }

  void update() {
    float gridX = grid.get(this.index % grid.size()).x;
    float gridY = grid.get(this.index % grid.size()).y;

    PVector mouse = new PVector(gridX, gridY);
    mouse.sub(this.position);
    mouse.setMag(1);
    this.acceleration = mouse;
    this.velocity.add(this.acceleration);
    this.velocity.limit(10);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }

  void display() {
    if (this.clicked) {
      translate(20, 20);
      rotate(- radians(this.angle));
      // println("name   " + this.zitat + " pos  " + grid.get(0).x + "  ,  " + grid.get(0).y);
    } else {
      translate(this.position.x, this.position.y);
      noTint();
    }
    scale(this.scale);
    image(this.img, 0, 0);
  }

  void clicked(float x, float y) {
    boolean inW = x >= this.position.x && x <=  this.position.x + this.w;
    boolean inH = y >= this.position.y && y <=  this.position.y+ this.h;
    // println(this.clicked);
    if (inW && inH) {
      // println("name   "  + name + "  zitat   " + zitat + "   pos   " + this.position);
      // println(" width   "  + this.w + "   height   " + this.h);
      //println("  width  " + (this.position.x+ this.w) + "  height  " + (this.position.y+ this.h) +"   x  " + x + "   y  " + y);
      this.clicked = !this.clicked;
      if (this.clicked) {
        this.scale = 0.5;
      } else {
        this.scale = 0.25;
      }
    }
  }
}
