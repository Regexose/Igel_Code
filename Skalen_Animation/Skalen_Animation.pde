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
boolean hasFinished, loading;
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
PGraphics loadScreen, layer1;
float loadStatus, messageX, messageY, messageSize, moveX, moveY;
PShape s;

void setup() {
  size(1000, 700);
  computer = "iMac";
  thread("loadData");
  loadScreen = createGraphics(width, height/8);
  layer1 = createGraphics(width, height);
  font = createFont("Courier", 16, true);
  // loading = true;
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
    image(loadScreen, 0, height *7/8);
  }
  // rect(mouseX, mouseY, 40, 40);
}

void loadData() {
  println("loading Data");
  loading = true;
  if (computer.equals("iMac")) {
    pathSingle = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/SingleZitate/";
    pathSkalen = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/Skalen2/";
    pathSites = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/Orte/";
  } else {
    pathSingle = "/Users/borisjoens/Documents/IchProjekte/Igel/Igel_Code/Images/SingleZitate/";
    pathSkalen = "/Users/borisjoens/Documents/IchProjekte/Igel/Igel_Code/Images/Skalen/";
    pathSites = "Images/Orte/";
  }
  // bildTexte = loadTable("Texte_im_Bild.tsv", "header");
  bildTexte = loadTable("SkalenTexte.tsv", "header");
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
  // println("beatNumber: " + beatNumber + "   rythm size:  " + newRythms.get(rScale).size() + "   rhythm segment: " +newRythms.get(rScale).get(beatNumber) );
  //createScheduleTimer(1);
  aI = scales.scaleArray.get(picIndex % scales.scaleArray.size());

  if (! keyPressed) {
    aI.position.add(moveX, moveY);
  }
  fill(255, 0, 0);
  aI.display(); 
  image(layer1, 0, 0, width, height);
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      moveX = 2;
      moveY = 0;
    } else if (keyCode == RIGHT) {
      moveX = -2;
      moveY = 0;
    } else if (keyCode == UP) {
      moveX = 0;
      moveY = 2;
    } else if (keyCode == DOWN) {
      moveX = 0;
      moveY = -2;
    }
    println("tvec?   " + aI.position);
  } else {
    if (key == 'n') {
      picIndex ++;
    }  else if (key == ' ') {
      moveX = 0;
      moveY = 0;
    }
    if (key == 's') {
      aI.scaleFactor += 0.2;
      
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
