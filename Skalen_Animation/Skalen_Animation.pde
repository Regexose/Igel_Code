import java.util.ArrayList; //<>//
import java.io.File;
import java.util.List;
import org.opencv.core.Point;
import java.awt.Rectangle;
import java.util.Random;
// more directory stuff: https://processing.org/examples/directorylist.html
import java.util.Timer;
import java.util.TimerTask;
// timer tutorial: https://forum.processing.org/two/discussion/1725/millis-and-timer
import gab.opencv.*;


OpenCV opencv, linesCV, liveCV;
boolean hasFinished, loading, showZ, mFollow, stopMove;
final Timer t = new Timer();
ScaleArray scales;
AugmentedImage aI;
ArrayList<Contour> liveContours;
Zitat currentZitat;
File folder;
File[] files;
Table bildTexte;
String pathSingle, pathSkalen, pathSites, computer, currentScaleName;
String[] areaNames, fileNames;
int startTime, picIndex;
PFont font;
PImage dst;
PGraphics loadScreen, layer1, layer2;
float loadStatus, messageX, messageY, messageSize, moveX, moveY;
PShape s;

void setup() {
  size(1100, 750, P2D);
  computer = "MacBook";
  thread("loadData");
  loadScreen = createGraphics(width, height/12 );
  layer1 = createGraphics(width, height, P2D);
  layer2 = createGraphics(width, height, P2D);
  layer2.smooth();
  font = createFont("Courier", 16, true);
  mFollow = false;
  stopMove = true;
  loadStatus = 0.0;
  currentScaleName = "";
  picIndex = 0;
  frameRate(20);
  startTime = millis();
  dst = createImage(20, 29, RGB);
}

void draw() {
  if (!loading) {
    selectImage();
  } else {
    showLoadScreen();
    image(loadScreen, 0, height *11/12);
  }
}

void loadData() {
  println("loading Data");
  loading = true;
  if (computer.equals("iMac")) {
    pathSingle = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/SingleZitate/";
    pathSkalen = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/Skalen/";
    pathSites = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/Orte/";
  } else {
    pathSingle = "/Volumes/OhneTitel/Igel/Code/Images/SingleZitate/";
    pathSkalen = "/Volumes/OhneTitel/Igel/Code/Images/Skalen/";
    pathSites = "/Volumes/OhneTitel/Igel/Code/Images/Orte/";
  }
  // bildTexte = loadTable("Texte_im_Bild.tsv", "header");
  bildTexte = loadTable("Skalen_detected.tsv", "header");
  scales = new ScaleArray("first", pathSkalen);
}



void selectImage() {
  // println("picIndex  " + picIndex);
  aI = scales.scaleArray.get(picIndex % scales.scaleArray.size());
  // AugmentedImage bg = scales.scaleArray.get(5);


  if (! keyPressed && !stopMove) {
    aI.position.add(moveX, moveY);
    for (Zitat z : aI.zitate) {
      z.position.add(moveX, moveY);
    }
  }
  fill(255, 0, 0);
  // bg.display();
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
      z.textDisplay();
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
}



void createScheduleTimer(final float ms) {
  hasFinished = false;
  t.schedule(new TimerTask() {
    public void run() {
      // print("   dong   " + nf(ms, 0, 2));
      hasFinished = true;
    }
  }
  , (long) (ms));
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

void showLoadScreen() {
  loadScreen.beginDraw();
  loadScreen.background(100);
  loadScreen.textFont(font);
  loadScreen.textAlign(CENTER);
  loadScreen.text("loading images..  " + currentScaleName, loadScreen.width/2, loadScreen.height/2);
  loadScreen.strokeWeight(5);
  loadScreen.stroke(250);
  loadScreen.line(10, loadScreen.height - 50, 10 + loadStatus, loadScreen.height-50);
  loadScreen.endDraw();
}
