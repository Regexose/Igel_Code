class AugmentedImage { //<>//
  PImage img;
  String name, zitat;
  int index;
  float angle, scale, w, h;
  PVector position, center;
  color col;
  boolean clicked = false;

  AugmentedImage(int idx, PImage img, String z, String name, float angle) {
    this.index = idx;
    this.img = img;
    this.zitat = z;
    this.angle = angle;
    this.name = name;
    this.scale = 0.25;
    this.w = img.width * this.scale;
    this.h = img.height * this.scale;
    this.col = color(0, 255, 0, 200);
  }

  void initialPos (PVector vec) {
    this.position = vec;
  }


  void move() {
    this.position.add(random(-1, 1), random(-1, 1));
  }

  void display() {
    translate(this.position.x, this.position.y);
    if (this.clicked) {
      tint(this.col);
    } else {
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
