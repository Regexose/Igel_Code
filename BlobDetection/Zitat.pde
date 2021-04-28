class Zitat { //<>//
  PImage pic_crop, contourPic;
  float angle, lineAngle, centerAngle;
  int index;
  ArrayList<PVector> outLine, points;
  ArrayList<Edge> edges;
  ArrayList<Line> lines;
  java.awt.Rectangle box;
  Contour contour;
  PGraphics surface, contourSurf;
  String content, sIndex, pngName;
  PVector firstPos, zitatPos, secondPos, baseLine, horizontal;

  Zitat(int index, Contour contour) {
    this.index = index; 
    this.contour = contour;
    this.box = contour.getBoundingBox();
    this.surface = createGraphics(box.width, box.height);
    this.contourSurf = createGraphics(box.width, box.height);
    makeEdges();
    horizontal = new PVector(1, 0);
    //fillSurf();
  }

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
    String sIndex = str(this.index);
    if (this.index <10) {
      sIndex = "0" + this.index;
    }
    String pngName = fileName + "_Blob" + sIndex + ".png";
    pic_crop.save(pathSingle + pngName); 
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
    // make contourPic to find lines
    this.contourSurf.beginDraw();
    // this.contourSurf.background(100);
    this.contourSurf.fill(0, 0, 255);
    this.contourSurf.beginShape();
    for (Edge e : edges) {
      float eX = e.point.x - this.box.x;
      float eY = e.point.y- this.box.y;
      //println("surf w   " + this.contourSurf.width + " eX  " + eX);
      //println("surf h   " + this.contourSurf.height + " eY  " + eY);
      this.contourSurf.vertex(eX, eY);
    }
    this.contourSurf.endShape(CLOSE);
    this.contourSurf.endDraw();
    this.contourPic = this.contourSurf.get();
    // contourPics.add(this.contourPic);
    // image(this.contourPic, width/2, height/2);

    if (edges.get(1).point.x < pic.width/2) {
      this.firstPos = edges.get(1).point.copy();
    } else { 
      this.firstPos = edges.get(0).point.copy();
    }
  }

  void makeZitatPosition() {
    float posX = 0;
    float posY = 0;
    if (this.firstPos.x > pic.width/2) {
      posX = center.x + cos(this.lineAngle - HALF_PI) * scaleRadius/2 ;
      posY = center.y +  sin(this.lineAngle - HALF_PI) * scaleRadius/2;
    } else {
      posX = center.x + cos(this.lineAngle + HALF_PI) * scaleRadius/2 ;
      posY = center.y +  sin(this.lineAngle + HALF_PI) * scaleRadius/2;
    }
    this.zitatPos = new PVector(posX, posY);
  }

  void calcAngles() {
    this.lineAngle = (float)lines.get(0).angle;
    println("Lineangle of  " + this.index + " =   " + this.lineAngle);

    if (this.firstPos.x < pic.width/2) {
      // y_max is second point
      secondPos = edges.get(2).point; 
      // lower line of zitat
      baseLine = PVector.sub(secondPos, this.firstPos); 
      this.angle = - PVector.angleBetween(horizontal, baseLine);
    } else {
      //y_min is second Point
      secondPos = edges.get(0).point; 
      // upper line of zitat
      baseLine = PVector.sub(secondPos, this.firstPos); 
      this.angle = PVector.angleBetween(baseLine, horizontal); 
      ;
    }
    println(" index  "  + index + "   angle   " + degrees(this.angle));
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
