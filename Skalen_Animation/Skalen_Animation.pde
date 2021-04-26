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


OpenCV opencv;
boolean hasFinished, loading, showZ, mFollow, stopMove;
final Timer t = new Timer();
ScaleArray scales;
AugmentedImage aI;
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
  size(1800, 1200, P2D);
  computer = "iMac";
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
    pathSingle = "/Users/borisjoens/Documents/IchProjekte/Igel/Igel_Code/Images/SingleZitate/";
    pathSkalen = "/Users/borisjoens/Documents/IchProjekte/Igel/Igel_Code/Images/Skalen/";
    pathSites = "Images/Orte/";
  }
  // bildTexte = loadTable("Texte_im_Bild.tsv", "header");
  bildTexte = loadTable("newBildTexte.tsv", "header");
  scales = new ScaleArray("first", pathSkalen);
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

void selectImage() {
  // println("picIndex  " + picIndex);
  aI = scales.scaleArray.get(picIndex % scales.scaleArray.size());
  AugmentedImage bg = scales.scaleArray.get(5);

  if (! keyPressed && !stopMove) {
    aI.position.add(moveX, moveY);
    for (Zitat z : aI.zitate) {
      z.position.add(moveX, moveY);
    }
  }
  fill(255, 0, 0);
  bg.display();
  aI.display(); 
  image(layer1, 0, 0);

  if (showZ) {
    for (Zitat z : aI.zitate) {
      z.display();
      z.textDisplay();
      image(layer2, 0, 0);
    }
  }
  if (mFollow) {
    aI.update();
    aI.display();
    for (Zitat z : aI.zitate) {
      z.update();
      z.textDisplay();
    }
  }

  if (mousePressed) {
    for (Zitat z : aI.zitate) {
      z.move();
      // z.display();
      z.textDisplay();
    }
  }
  image(layer2, 0, 0);
}


void keyReleased() {
  int xStep = 10;
  int yStep = 10;
  if (key == CODED) {
    stopMove = false;
    if (keyCode == LEFT) {
      moveX = xStep;
      moveY = 0;
    } else if (keyCode == RIGHT) {
      moveX = -xStep;
      moveY = 0;
    } else if (keyCode == UP) {
      moveX = 0;
      moveY = yStep;
    } else if (keyCode == DOWN) {
      moveX = 0;
      moveY = -yStep;
    }
  } else {
    if (key == 'n') {
      picIndex ++;
      moveX = 0;
      moveY = 0;
    }
    if (key == 'p') {
      if (picIndex > 0) {
        picIndex --;
      } else {
        picIndex = scales.scaleArray.size();
      }
      moveX = 0;
      moveY = 0;
    }

    if (key == ' ') {
      stopMove = true;
      moveX = 0;
      moveY = 0;
    } 
    if (key == 's') {
      stopMove = false;
      aI.scaleFactor += 0.04;
      for (Zitat z : aI.zitate) {
        z.scale += 0.06;
      }
    }

    if (key == 'a') {
      stopMove = false;
      aI.scaleFactor -= 0.1 ;
      for (Zitat z : aI.zitate) {
        z.scale -= 0.06;
      }
    }
    if (key == 'r') {
      stopMove = false;
      aI.scaleFactor = 1.0 ;
      aI.position = new PVector(0, 0);
    }

    if (key == 'o') {
      aI.rePosition(new PVector(-mouseX, -mouseY));
    }
    if (key == 'i') {
      aI.rePosition(new PVector(-width/3, -height));
    }
    if (key == 'z') {
      showZ = !showZ;
    }
    if (key == 'm') {
      mFollow = !mFollow;
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

ArrayList<Contour> makeContours(String name, PImage img) {
  img.resize(width, height);
  opencv = new OpenCV(this, img);
  opencv.gray();
  opencv.threshold(80);
  ArrayList<Contour> contours = opencv.findContours();
  // println("name " + name + "  contours: " + contours.size());
  return contours;
}
