import java.util.ArrayList; //<>//
import java.io.File;
import java.util.List;
import org.opencv.core.Point;
import java.awt.Rectangle;
// more directory stuff: https://processing.org/examples/directorylist.html
import java.util.Timer;
import java.util.TimerTask;
// timer tutorial: https://forum.processing.org/two/discussion/1725/millis-and-timer
import gab.opencv.*;


OpenCV opencv, linesCV, liveCV;
boolean showZ, mFollow, stopMove;
AugmentedImage aI;
ArrayList<Contour> liveContours;
Zitat currentZitat;
Table bildTexte;
String pathSingle, pathSkalen, pathSites, fileName, computer;
String[] areaNames;
int startTime, radius;
PVector center;
PFont font;
PImage img;
PGraphics layer1, layer2;
float messageX, messageY, scaleVal, moveX, moveY;
PShape s;

void setup() {
  size(1100, 750, P2D);
  computer = "iMac";
  loadData();
  layer1 = createGraphics(width, height, P2D);
  layer2 = createGraphics(width, height, P2D);
  layer2.smooth();
  font = createFont("Courier", 16, true);
  radius = 350;
  scaleVal = float(img.width) / float(width);
  center = new PVector(width/2, height *4/5);
  mFollow = false;
  stopMove = true;
  frameRate(20);
  startTime = millis();
}

void draw() {
  background(20);
  selectImage();
}



void selectImage() {
  if (! keyPressed && !stopMove) {
    aI.position.add(moveX, moveY);
    for (Zitat z : aI.zitate) {
      z.position.add(moveX, moveY);
    }
  }
  fill(255, 0, 0);
  aI.display(); 
  image(layer1, 0, 0);
  liveCV = new OpenCV(this, layer1.get());
  liveCV.gray();
  liveCV.threshold(80);
  liveContours = liveCV.findContours();
  for (int i=liveContours.size()-1; i>=0; i--) {
    Contour c = liveContours.get(i);
    if (c.numPoints() < 100) {
      liveContours.remove(i);
    }
  }
  aI.contours = liveContours;

  if (showZ) {
    for (Zitat z : aI.zitate) {
      z.display();
      // z.textDisplay();
      //image(layer2, 0, 0);
    }
  }
  if (mFollow) {
    //aI.update();
    //aI.display();
    for (Zitat z : aI.zitate) {
      z.update();
      z.display();
    }
  }
  if (mousePressed) {
    if (aI.hasZitate) {
      aI.findContour(mouseX, mouseY);
      currentZitat.display();
      image(layer2, 0, 0);
    } else {
      println("name  " + aI.name + "  has zitate?   "+ aI.hasZitate);
    }
  }
  if (keyPressed) {
    reconstruct();
  }
  image(layer2, 0, 0);
}

void reconstruct() {
  background(20);
  layer2.beginDraw();
  layer2.clear();
  layer2.endDraw();
  stroke(255, 0, 0);
  strokeWeight(1);
  PVector centerNow = PVector.mult(center, aI.scaleFactor);
  line(centerNow.x, centerNow.y, centerNow.x, 0);
  line(0, centerNow.y, width, centerNow.y);
  fill(255, 0, 0, 50);
  float newRadius = map(mouseX, 0, width, 0, width*2/3);
  arc(centerNow.x, centerNow.y, newRadius, newRadius, PI, TWO_PI);
  float zX = 0;
  float zY =0;
  for (int i=0; i < aI.zitate.size(); i++) {
    Zitat z = aI.zitate.get(i);
    stroke(255, 0, 0);
    strokeWeight(8);
    if (z.firstPos.x > img.width/2) {
      zX = centerNow.x + cos(z.angle - HALF_PI) * newRadius  ;
      zY = centerNow.y + sin(z.angle - HALF_PI) * newRadius ;
      // rotate(z.angle);
    } else {
      zX = centerNow.x + cos(z.angle + HALF_PI ) * newRadius  ;
      zY = centerNow.y  + sin(z.angle + HALF_PI ) * newRadius ;
      //rotate(z.angle);
    }
    // das ist der Punkt an dem der Streifen endet/beginnt
    point(zX, zY);
    // z.textDisplay(zX, zY); 
    pushMatrix();
    //if (z.firstPos.x < img.width/2) {
    //  translate (zX - (z.img.width * z.scale), zY - (z.img.height * z.scale) );
    //} else {
    //  translate (zX , zY - (z.img.height * z.scale) );

    //}
    //// translate (zX , zY );
    //fill(255, 120);
    //if (z.firstPos.x > img.width/2) {
    //  rotate(z.angle + HALF_PI);
    //} else {
    //  rotate(z.angle - HALF_PI);
    //}
    //text(z.zitat, 0, 0); 
    z.position = new PVector(zX, zY);
    z.display();
    popMatrix();
  }
}
void loadData() {
  if (computer.equals("iMac")) {
    pathSingle = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/SingleZitate/";
    pathSkalen = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/Skalen/";
    pathSites = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/Orte/";
  } else {
    pathSingle = "/Users/borisjoens/Documents/IchProjekte/Igel/Igel_Code/Images/SingleZitate/";
    pathSkalen = "/Users/borisjoens/Documents/IchProjekte/Igel/Igel_Code/Images/Skalen/";
    pathSites = "Images/Orte/";
  }
  bildTexte = loadTable("Skalen_detected.tsv", "header");
  fileName = "DSC00512.JPG";
  img = loadImage(pathSkalen + fileName);
  aI = new AugmentedImage(fileName, img, 0);
}

Line makeLine(PImage pic) {
  // find longest line
  linesCV = new OpenCV(this, pic); // thread?
  linesCV.findCannyEdges(20, 75);
  ArrayList<Line> lines = linesCV.findLines(100, 30, 20);
  println("found  " + lines.size() + "  lines");
  float[] lineLength = new float[lines.size()];
  int lineIndex = 0;
  for (int i=0; i<lines.size(); i++) {
    Line l = lines.get(i);
    float len = PVector.sub(l.end, l.start).mag();
    lineLength[i] = len;
    if (len > max(lineLength)) {
      lineIndex ++;
    }
  }
  return lines.get(lineIndex);
}

ArrayList<Contour> makeContours(String name, PImage img) {
  img.resize(width, height);
  opencv = new OpenCV(this, img);
  opencv.gray();
  opencv.threshold(80);
  ArrayList<Contour> contours = opencv.findContours();
  // println("name " + name + "  contours: " + contours.size());
  return contours;
}
