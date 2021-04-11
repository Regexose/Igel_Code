class Zitat { //<>//
  PImage pic_crop;
  float angle, evenAngle;
  int index;
  ArrayList<PVector> outLine, points;
  ArrayList<Edge> edges;
  // ArrayList<Line> lines;
  java.awt.Rectangle box;
  Contour contour, hull;
  PGraphics surface;
  String content, sIndex, fileName;
  PVector firstPos, baseLine, vertLine;

  Zitat(int index, Contour contour) {
    this.index = index; 
    this.contour = contour;
    this.box = contour.getBoundingBox();
    makeEdges();
    this.surface = createGraphics(box.width, box.height);
    this.hull = this.contour.getConvexHull();
    calcAngles();
    tableOps();
    // fillSurf();
    // pointsTest();
  }

  void tableOps() {
    sIndex = str(this.index);
    if (this.index <10) {
      sIndex = "0" + this.index;
    }
    fileName =  "st007_Blob" + sIndex + ".png";
    String[] ecken = new String[4];
    for (TableRow row : bildTexte.rows()) {
      if (row.getString("png_name").equals(fileName)) {
        for (int a=0; a<edges.size(); a++) {
          int x = int(edges.get(a).point.x);
          int y = int(edges.get(a).point.y);
          String ecke = str(x) + ", " + str(y);
          ecken[a] = ecke;
        }
        // print("ecken" + ecken); 
        String tableEdges = join(ecken, ", ");
        row.setString("Eckpunkte_yxmin_yx_max", tableEdges);
        row.setString("angle_deg", str(degrees(this.angle)));
        //println("row " + row.getString("Eckpunkte_yxmin_yx_max"));
        //println("angle " + degrees(this.angle));
      }
    }
    saveTable(bildTexte, "data/newBildTexte.tsv");
  }

  //void fillSurface(PImage pic) {

  //  this.pic_crop = pic; 
  //  this.pic_crop.loadPixels(); 
  //  this.surface.beginDraw(); 
  //  // this.surface.background(120,150);
  //  this.surface.loadPixels(); 
  //  // all pixels in the box are checked if they are inside the contour
  //  for (int x= this.box.x; x < this.box.x + this.box.width; x++) {
  //    println("rendered   " + (x -this.box.x)  + "   remaining " + ((this.box.x + this.box.width) -x) + " spalten"); 
  //    for  (int y= this.box.y; y< this.box.y + this.box.height; y++) {
  //      int loc = (x - this.box.x) + (y - this.box.y) * this.box.width; 
  //      if (this.contour.containsPoint(x, y)) {
  //        points.add(new PVector(x, y));
  //        // println("x   " + x  + "   y   " + y + "  color  " +  pic.get((x - this.box.x),(y - this.box.y)));
  //        //println("points: " + contour.getPoints().get((y - this.box.y)) + " y  " + (y - this.box.y));
  //        // this.surface.background(100, 100, 0);
  //        // arraycopy() schneller?

  //        this.surface.pixels[loc] = this.pic_crop.pixels[loc];
  //      }
  //      this.surface.updatePixels();
  //    }
  //  }

  //  this.surface.endDraw(); 
  //  pic_crop = this.surface.get(); 
  //  pic_crop.save(pathSingle + fileName); 
  //  schnipsel.add(pic_crop);
  //}
  //void makePoints() {
  //}

  void fillSurf() {
    points = new ArrayList<PVector>();
    for (int x= this.box.x; x < this.box.x + this.box.width; x++) {
      println("rendered   " + (x -this.box.x)  + "   remaining " + ((this.box.x + this.box.width) -x) + " spalten"); 
      for  (int y= this.box.y; y< this.box.y + this.box.height; y++) {
        if (this.contour.containsPoint(x, y)) {
          points.add(new PVector(x, y));
        }
      }
    }
      pic.loadPixels();
      this.surface.beginDraw();
      this.surface.loadPixels();
      for (PVector p : points) {
        //println("point x  " + p.x + ", point y  " + p.y);
        // println("copying  " + i + " from  " +  points.size());
        int loc = int(p.x) + (int(p.y) * pic.width);
        int surfX = int(p.x) - this.box.x;
        int surfY = int(p.y) - this.box.y;
        // println("surfx " + surfX + ", surf y  " + surfY);

        int locSurf = surfX + (surfY * this.surface.width);
        this.surface.pixels[locSurf] = pic.pixels[loc];
      }
      this.surface.updatePixels();
      this.surface.endDraw();
      pic_crop = this.surface.get(); 
      pic_crop.save(pathSingle + fileName); 
      schnipsel.add(pic_crop);
  }

  void makeEdges() {
    outLine = this.contour.getPoints(); 
    edges = new ArrayList(); 
    StringList edgeNames = new StringList(); // only one point can be edge
    for (PVector point : outLine) {
      if (point.y == this.box.y) {
        if (!edgeNames.hasValue("y_min")) {
          Edge edge = new Edge(point, 1, "y_min", color(255, 0, 0)); 
          //println("index " + edge.index + "   name   " + edge.name + "   point   " + point); 
          edgeNames.append(edge.name); 
          edges.add(edge);
        }
      } else if (point.x == this.box.x) {
        if (!edgeNames.hasValue("x_min")) {
          Edge edge = new Edge(point, 2, "x_min", color(0, 255, 0)); 
          // println("index " + edge.index + "   name   " + edge.name + "   point   " + point); 
          edgeNames.append(edge.name); 
          edges.add(edge);
        }
      } else if (dist(point.x, point.y, point.x, this.box.y + this.box.height) < 2) {
        if (!edgeNames.hasValue("y_max")) {
          Edge edge = new Edge(point, 3, "y_max", color(0, 0, 255)); 
          //println("index " + edge.index + "   name   " + edge.name + "   point   " + point); 

          edgeNames.append(edge.name); 
          edges.add(edge);
        }
      } else if (dist(point.x, point.y, this.box.x +this.box.width, point.y) < 2) {
        if (!edgeNames.hasValue("x_max")) {
          Edge edge = new Edge(point, 4, "x_max", color(100, 100, 200)); 
          // println("index " + edge.index + "   name   " + edge.name + "   point   " + point); 
          edgeNames.append(edge.name); 
          edges.add(edge);
        }
      }
    }

    this.firstPos = edges.get(1).point.copy();
    // versuch, eine Surface in Form der Contour zu machen
    //int w = int(dist(edges.get(0).point.x, edges.get(0).point.y, edges.get(2).point.x, edges.get(2).point.y));
    //int h = int(dist(edges.get(0).point.x, edges.get(0).point.y, edges.get(1).point.x, edges.get(1).point.y));
    //this.surface = createGraphics(w,h);
  }
  void calcAngles() {
    PVector straight = new PVector(10, 0); 
    if (this.firstPos.x < width/2) {
      // y_max is second point
      PVector secondPoint = edges.get(2).point; 
      // lower line of zitat
      // was passiert hier mit der ersten und zweiten Edge?
      baseLine = PVector.sub(secondPoint, this.firstPos); 
      PVector thirdPoint = edges.get(0).point; 
      vertLine = PVector.sub(thirdPoint, this.firstPos); 
      this.angle = PVector.angleBetween(straight, baseLine); 
      this.evenAngle = - this.angle;
    } else {

      //y_min is second Point
      PVector secondPoint = edges.get(3).point; 
      // upper line of zitat
      baseLine = PVector.sub(secondPoint, this.firstPos); 
      this.angle = PVector.angleBetween(baseLine, straight); 
      this.evenAngle = this.angle; 
      PVector thirdPoint = edges.get(2).point; 
      vertLine = PVector.sub(thirdPoint, this.firstPos); 
      // zitat ist gedreht, daher mus firstPos höher liegen, ergo mit der box höhe subtrahiert werden
    }
    // println("angle   "+ degrees(this.angle) + "   " + fileName + index + ".png");
  }
}

class Edge {
  PVector point; 
  int index; 
  String name; 
  color col; 

  Edge(PVector point, int index, String name, color col) {
    this.point = point; 
    this.index = index; 
    this.name = name; 
    this.col = col;
  }
}
