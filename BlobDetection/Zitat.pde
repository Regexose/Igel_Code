class Zitat {
  PVector position;
  float angle, evenAngle;
  int index;
  ArrayList<PVector> coords;
  ArrayList<Line> lines;
  java.awt.Rectangle box;
  Contour contour, hull;
  PGraphics surface;
  String content;
  ArrayList<PVector> points;
  HashMap<String, PVector> boxEdges;
  ArrayList<PVector> edges;
 
  Zitat(int index, Contour contour, String content) {
    this.index = index;
    this.contour = contour;
    this.content = content;
    this.box = contour.getBoundingBox();
    this.boxEdges = makeBoxEdges();
    this.position = new PVector(this.box.x, this.box.y);
    this.surface = createGraphics(box.width, box.height);
    this.hull = this.contour.getConvexHull();
  }
  
  void fillSurface(PImage pic){
    pic.loadPixels();
    this.surface.beginDraw();
    this.surface.loadPixels();
    for (int x= this.box.x; x < this.box.x + this.box.width; x++) {
      println("Noch " + ((this.box.x + this.box.width) -x) + " spalten");
      for  (int y= this.box.y; y< this.box.y + this.box.height; y++){
        int loc = (x - this.box.x) + (y - this.box.y) * this.box.width;
        if (this.contour.containsPoint(x, y)) {
          // println("x   " + x  + "   y   " + y + "  color  " +  pic.get((x - this.box.x),(y - this.box.y)));
          //println("points: " + contour.getPoints().get((y - this.box.y)) + " y  " + (y - this.box.y));
          // this.surface.background(100, 100, 0);
          
          this.surface.pixels[loc] = pic.pixels[loc];
        }
        this.surface.updatePixels();
      }
    }
    this.surface.endDraw();
    }
    
    void calcAngles(ArrayList<Line> lines) {
      this.lines = lines;
      // find longest line for angle_calc
      FloatList lengths = new FloatList();
      for (Line line : this.lines){
        float lineLength = dist(line.start.x, line.start.y,line.end.x, line.end.y);
        lengths.append(lineLength);
      }
      float longest = lengths.max();
      for (Line line : this.lines){
        float lineLength = dist(line.start.x, line.start.y,line.end.x, line.end.y);
        if (lineLength == longest) {
          this.angle = (float) line.angle ;
          this.evenAngle = - this.angle + HALF_PI;
        }
    }
    }
    
    HashMap<String, PVector> makeBoxEdges() {
      HashMap<String, PVector> edges = new HashMap<String, PVector>();
      edges.put("1", new PVector(this.box.x, this.box.y));
      edges.put("2", new PVector(this.box.x , this.box.y + this.box.height));
      edges.put("3", new PVector(this.box.x + this.box.width, this.box.y + this.box.height));
      edges.put("4", new PVector(this.box.x +this.box.width, this.box.y));
      print("\nprocessing shape  " + this.index + "  with box   " + edges);
      return edges;
    }
  
}
