import gab.opencv.*;
import java.awt.Rectangle;
import java.awt.Point;

OpenCV opencv;
PImage pic, pic_crop, pic2;
ArrayList<Contour> blobs;
ArrayList<Contour> bigContours;
ArrayList<PVector> points;
int i = 0;
FloatList xs, ys;
PGraphics surface;

void setup() {
  size(900, 600);
  pic = loadImage("DSC05212.JPG");
  pic2 = loadImage("FabianAileen_DSC05217.jpg");
  opencv = new OpenCV(this, pic2);
  opencv.gray();
  opencv.threshold(110);
  blobs = opencv.findContours(true, true);
  bigContours = new ArrayList<Contour>();
  for (Contour contour : blobs) {
  if (contour.numPoints() > 400) {
    bigContours.add(contour);
    }
  }
  fillSurface(0);

}

void draw() {
background(222);
// scale(0.15);
  image(pic2, 0, 0);
  Contour contour = bigContours.get(i % bigContours.size());
  // contour.getBoundingBox();
   fill(255, 0, 0, 100);
   noStroke();
   contour.draw();
   points = contour.getPoints();
   xs = new FloatList();
   ys = new FloatList();
   ArrayList<PVector> outline = new ArrayList<PVector>();
   for (PVector point : points) {
     xs.append(point.x);
     ys.append(point.y);
     }
     for (PVector point : points) {
       if (point.x == xs.min() || point.x == xs.max() || point.y == ys.min() || point.y == ys.max()) {
         outline.add(point);
       }
     }
     
     pushMatrix();
     // scale(1.0);
     // translate(width/3, height/3);
     image(surface, mouseX, mouseY);
     
     image(pic_crop, mouseX + 200, mouseY);
     popMatrix();
     
     if (keyPressed) {
     i ++; 
     fillSurface(i%bigContours.size());
     }
}

void fillSurface(int j) {
  Contour contour = bigContours.get(j);
  java.awt.Rectangle box = contour.getBoundingBox();
  println("box: " + box);
  for (int i=0; i<10; i++) {println("contour points:   " + contour.getPoints().get(i));}
  surface = createGraphics(box.width, box.height);
  pic_crop = pic2.get(box.x, box.y, box.width, box.height);
  pic_crop.loadPixels();
  surface.beginDraw();
  surface.background(150);
  surface.loadPixels();
  for (int x= box.x; x < box.x + box.width; x++) {
    for  (int y= box.y; y< box.y + box.height; y++){
      // println("x   " + x  + "   y   " + y);
      int loc = (x - box.x) + (y - box.y) * box.width;
      if (contour.containsPoint(x, y)) {
        println("x   " + x  + "   y   " + y + "  color  " +  pic_crop.get((x - box.x),(y - box.y)));
        println("points: " + contour.getPoints().get((y - box.y)) + " y  " + (y - box.y));
        surface.background(100, 100, 0);
        surface.pixels[loc] = pic_crop.pixels[loc];
      }
      surface.updatePixels();
    }
  }
  surface.endDraw();
  
  // draw a vertex with contour Points
  //stroke(20);
  //strokeWeight(15);
  //contour.setPolygonApproximationFactor(95);
  //ArrayList<PVector> zPoints = contour.getPolygonApproximation().getPoints();
  //beginShape();
  //for (PVector point : contour.getPolygonApproximation().getPoints()) {
  //    vertex(point.x, point.y);
  //    zPoints.add(point);
  //  }
  //endShape(CLOSE);
}
