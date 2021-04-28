class Zitat {
  PImage img;
  IntList coords;
  List<Point> contourCoords;
  float angle, evenAngle, scale, gridX, gridY;
  int index, parentW, parentH;
  PGraphics surface;
  String zitat;
  Contour contour;
  PVector firstPos, position, velocity, acceleration, center;
  Line line;
  boolean clic = false;
  color col;

  Zitat(int index, String _z, PImage _img, String _angle, IntList _c, int _w, int _h) {
    this.index = index; 
    this.zitat = _z;
    this.img = _img;
    this.angle = float(_angle.replace(',', '.'));
    this.coords = _c;
    makePositions();
    // this.contour = _contour;  // contours später definieren
    // this.contourCoords = this.contour.pointMat.toList();
    this.line = makeLine(this.img);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector (0, 0);
   
    this.parentW = _w;
    this.parentH = _h;
     this.scale = float(width)/ float(parentW);
    this.col = color(0, 255, 0, 200);
    //println("Zitat index   " + this.index + "  zitat  " + this.zitat  + "  angle   "  +this.angle  + "   position  " + this.position);
  }

  void makePositions() {
    float x1 = this.coords.get(2);
    float y1 = this.coords.get(3);
    float x2 = this.coords.get(0);
    float y2 = this.coords.get(1);
    this.firstPos = new PVector (x1, y1 );
    if (x1 < this.parentW) {
      this.firstPos = new PVector (x1, y1 );
    } else {
      this.firstPos = new PVector (x2, y2 );
    }
    this.position = PVector.mult(this.firstPos, 0.1);
  }

  void applyForce(PVector force) {
    this.acceleration.add(force);
  }

  void move() {
    this.position.add(this.acceleration);
  }

  void update() {
    PVector mouse = new PVector(mouseX, mouseY);
    mouse.sub(this.position);
    mouse.setMag(1);
    this.acceleration = mouse;
    this.velocity.add(this.acceleration);
    this.velocity.limit(10);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }

  void display() {
    // println("displaying zitat   " + this.zitat + "  at pos   " + this.position);
    layer2.beginDraw();
    // layer2.background(130, 100);
    layer2.pushMatrix();
    //layer2.noTint();
    layer2.translate(this.position.x, this.position.y);
    layer2.imageMode(CORNER);
    // layer2.rotate(this.angle);
    layer2.scale(this.scale, this.scale);
    layer2.image(this.img, 0, 0);
    layer2.popMatrix();
    layer2.endDraw();
  }

  void textDisplay() {
    layer2.beginDraw();
    layer2.clear();
    layer2.pushMatrix();
    layer2.translate(this.position.x, this.position.y);
    if (this.position.x < this.parentW/2) {
      layer2.rotate(-radians(this.angle));
    } else {
      layer2.rotate(radians(this.angle));
    }
    layer2.scale(this.scale);
    layer2.fill(200);
    layer2.textFont(font, 12);
    layer2.rect(0, -textAscent(), textWidth(this.zitat), textAscent() +5);
    layer2.fill(10);

    layer2.text(this.zitat, 0, 0);
    layer2.popMatrix();
    layer2.endDraw();
  }


  //void contourDisplay() {  
  //  // printArray("coords   " + this.contourCoords);

  //  this.contourCoords = this.contour.pointMat.toList();
  //  layer2.beginDraw();
  //  for (Point p : this.contourCoords) {
  //    float cX = (float) p.x;
  //    float cY = (float) p.y;
  //    cX = map(cX, 0, pic.width, 0, width);
  //    cY = map(cY, 0, pic.height, 0, height);
  //    println("cx  " + cX + "   cy  " + cY);
  //    layer2.beginShape();
  //    layer2.fill(100, 200, 0, 100);
  //    layer2.vertex(cX, cY);
  //    layer2.endShape(CLOSE);
  //  }
  //  layer2.endDraw();
  //}

  void clicked(float x, float y) {
    boolean inW = x >= this.position.x && x <=  this.position.x + this.parentW;
    boolean inH = y >= this.position.y && y <=  this.position.y+ this.parentH;
    // println(this.clicked);
    if (inW && inH) {
      // println("name   "  + name + "  zitat   " + zitat + "   pos   " + this.position);
      // println(" width   "  + this.w + "   height   " + this.h);
      //println("  width  " + (this.position.x+ this.w) + "  height  " + (this.position.y+ this.h) +"   x  " + x + "   y  " + y);
      this.clic = !this.clic;
      if (this.clic) {
        this.scale = 0.5;
      } else {
        this.scale = 0.25;
      }
    }
  }
}
