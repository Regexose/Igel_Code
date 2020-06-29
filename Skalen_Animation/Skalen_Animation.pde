import java.util.ArrayList;
import java.io.File;
import java.util.Arrays;
import java.util.HashMap;
// more directory stuff: https://processing.org/examples/directorylist.html
import java.util.Timer;
import java.util.TimerTask;
// timer tutorial: https://forum.processing.org/two/discussion/1725/millis-and-timer
final Timer t = new Timer();
import ddf.minim.*;
import ddf.minim.analysis.*;
import gab.opencv.*;

Minim minim;
OpenCV opencv;

boolean hasFinished = true;
boolean knocklock = false;
boolean pleaseKnock, timetoUpdate, messageTime, knock, globalStop, loading;

Klopfen klopfen;
Scale scale;
File folder;
File[] files;
Table zitate, bildTexte, durationMap;
int  beatNumber, rScale, globalCounter, newglobalCounter, startTime, elapsedTime;
String currentBeat, currentScaleName, scaleType, audioPath, message;
String[] areaNames;
StringList restFiles, restFileNames;
HashMap<String, Scale> scaleMap = new HashMap<String, Scale>();
PFont Arial;
PImage dst;
PGraphics surface;
ArrayList<ArrayList<Float>> newRythms = new ArrayList<ArrayList<Float>>();
float factor, loadStatus, messageX, messageY, messageSize;
PShape s;

void setup() {
  size(1000, 700);
  surface = createGraphics(width,height);
  buildRythms(newRythms);
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  durationMap = loadTable("durationMappings.csv", "header");
  Arial = createFont("Courier", 16, true);
  audioPath = sketchPath("data/rec/");
  message = "Klopf mal an !";
  thread("loadScales");
  loadStatus = 0.0;
  messageTime = false;
  beatNumber = 0;
  rScale = 1;
  newglobalCounter = -1;
  currentScaleName = "Klopf";
  knock = false;
  globalStop = false;
  frameRate(20);
  minim = new Minim(this);
  klopfen = new Klopfen(minim);
  startTime = millis();  
}

void draw() {
    if (!loading) {
      if (hasFinished && !knock) {
        getRythm();
        selectImage();
       } 
       klopfen.analyseInput();
       scale.display();
      } else {
      loadDisplay();
      }
}

void selectImage() {
  // println("beatNumber: " + beatNumber + "   rythm size:  " + newRythms.get(rScale).size() + "   rhythm segment: " +newRythms.get(rScale).get(beatNumber) );
  float waitTime = newRythms.get(rScale).get(beatNumber);
  createScheduleTimer(waitTime);
  // println("\n\nTimer scheduled for " + nf(waitTime, 0, 2) + " msecs.\n");
  scale.selectImage(waitTime, scaleType);
  scale.selectShape();
  beatNumber += 1;
  beatNumber = beatNumber % newRythms.get(rScale).size(); 
  if (beatNumber % newRythms.get(rScale).size() == 0) {globalCounter += 1;}
  if (globalCounter > 0 && globalCounter%7 == 0) {
     println("Update pause because:  " + globalCounter + " but suspended im moment");
     // updatePause(); 
  }
}

void showBiggestShapes(AugmentedImage aI) {
  println("91 aIname: " + aI.name); 
  println("\nshapes size: " + aI.shapes.size());
  scale.surface.beginDraw();
  for (PShape s : aI.shapes) {
    if(s.getVertexCount() > 10) {
      println("s.numPoints: " + s.getVertexCount());
      scale.surface.shape(s, 100, 100);
    }
  } 
  scale.surface.endDraw();
  
}

//void selectShape() {
//  if (scale.augmented && (scale.aI.name.indexOf("Ort_DSC") == -1)) {
//    println("107 image name: " + scale.aI.name); 
//    // printArray("\nshapes: " + scale.aI.shapes);
//    int index = int(random(scale.aI.shapes.size()));
//    PShape s = scale.aI.shapes.get(index).z_shape;
//    println("shape name?:  " + s.getName()); //<>//
//    println("shape position?:  " + s.getVertex(1).x + "   " +  s.getVertex(1).y);
//    // println("scale:  " + scale.name + " surface: " + scale.surface);
    
//    scale.surface.beginDraw();
//      // scale.surface.text("es ist ein brunnengeschäft", 100, 100);
//      scale.surface.shape(s, s.getVertex(1).x, s.getVertex(1).y);
//      // scale.surface.shape(s, 100, 100);
    
//  } else {return;}
//  scale.surface.endDraw();
//}

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

void stop() {
  globalStop = true;
}

void loadScales() {
  loading = true;
  scaleMap.put("Klopf", new Scale("Klopfen", "klopfen", "simple"));
  scaleMap.put("PlanscheSinger", new Scale("PlanscheSinger", "PlanscheSinger", "augmented"));
  scaleMap.put("PlanscheWeyde", new Scale("PlanscheWeyde", "PlanscheWeyde", "augmented"));
  getRythm();
  loading = false;
  hasFinished = true;
}

void loadDisplay() {
  background(100);
  textFont(Arial, 25);
  textAlign(CENTER);
  text("loading images..  " + currentScaleName, width/2, height/2);
  strokeWeight(5);
  stroke(250);
  line(10, height - 50, 10 + loadStatus, height-50);
  
}

ArrayList<Contour> makeContours(String name, PImage img) {
     opencv = new OpenCV(this, img);
     opencv.gray();
     opencv.threshold(50);
     ArrayList<Contour> contours = opencv.findContours();
     // println("name" + name + "  contours: " + contours.size());
     return contours; //<>//
}
 
PImage dstMaker(PImage img) {
   opencv = new OpenCV(this, img);
   opencv.gray();
   opencv.threshold(90);
   dst = opencv.getOutput();
   return dst;
}
