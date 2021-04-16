class Zitat {
  PImage img;
  IntList coords;
  List<Point> contourCoords;
  float angle, evenAngle, scale, gridX, gridY;
  int index, w, h;
  PGraphics surface;
  String zitat, fileName;
  Contour contour;
  PVector firstPos, position, velocity, acceleration, center;
  boolean clicked = false;
  color col;

  Zitat(int index, String _z, PImage _img, float _angle, IntList _c, Contour _contour) {
    this.index = index; 
    this.zitat = _z;
    this.img = _img;
    this.angle = _angle;
    this.coords = _c;
    this.contour = _contour;
    this.contourCoords = this.contour.pointMat.toList();
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector (0, 0);
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
    PVector mouse = new PVector(mouseX, mouseY);
    mouse.sub(this.position);
    mouse.setMag(1);
    this.acceleration = mouse;
    this.velocity.add(this.acceleration);
    this.velocity.limit(10);
    // this.position.add(this.velocity);
    this.acceleration.mult(0);
  }

  void display() {
    layer1.beginDraw();
    layer1.pushMatrix();
    if (this.clicked) {
      this.position = this.firstPos.copy();
      layer1.translate(this.firstPos.x, this.firstPos.y);
      layer1.tint(0, 255, 0, 125);
    } else {
      layer1.noTint();
      gridX = grid.get(this.index % grid.size()).x;
      gridY = grid.get(this.index % grid.size()).y;
      this.position = new PVector(gridX, gridY);
      layer1.translate(gridX, gridY);
      layer1.imageMode(CORNER);
      layer1.rotate(radians(this.angle));
      //println("name   " + this.zitat + " pos  " + grid.get(0).x + "  ,  " + grid.get(0).y);
    }
    layer1.scale(this.scale);
    layer1.image(this.img, 0, 0);
    layer1.popMatrix();
    layer1.endDraw();
  }

  void displayContour() {  
    printArray("coords   " + this.contourCoords);
    layer2.beginDraw();
    for (Point p : this.contourCoords) {
      float cX = (float) p.x;
      float cY = (float) p.y;
      cX = map(cX, 0, pic.width, 0, width);
      cY = map(cY, 0, pic.height, 0, height);
      println("cx  " + cX + "   cy  " + cY);
      layer2.beginShape();
      layer2.fill(100, 200, 0, 100);
      layer2.vertex(cX, cY);
      layer2.endShape(CLOSE);
    }
    layer2.endDraw();
    
    //pushMatrix();
    ////translate(gridX, gridY);
    //scale(this.scale);
    
    //fill(100, 255, 0, 122);
    //this.contour.draw();
    ////rotate(radians(this.angle));
    //popMatrix();
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
