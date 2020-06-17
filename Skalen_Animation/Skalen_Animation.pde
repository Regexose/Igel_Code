import java.util.ArrayList;
import java.io.File;
import java.util.Arrays;
import java.util.HashMap;
// more directory stuff: https://processing.org/examples/directorylist.html
import java.util.Timer;
import java.util.TimerTask;
// timer tutorial: https://forum.processing.org/two/discussion/1725/millis-and-timer
final Timer t = new Timer();
import ddf.minim.analysis.FFT;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;

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
PGraphics surface;
ArrayList<ArrayList<Float>> newRythms = new ArrayList<ArrayList<Float>>();
float factor, loadStatus, messageX, messageY, messageSize;

void setup() {
  size(1000, 700);
  surface = createGraphics(width,height);
  buildRythms(newRythms);
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  durationMap = loadTable("durationMappings.csv", "header");
  Arial = createFont("Courier", 16, true);
  audioPath = sketchPath("data/rec/");
  // audioPath = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code/Skalen_Animation/data/rec";
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
      background(100);
      textFont(Arial, 25);
      textAlign(CENTER);
      text("loading images..  " + currentScaleName, width/2, height/2);
      strokeWeight(5);
      stroke(250);
      line(10, height - 50, 10 + loadStatus, height-50);
      }
}

void selectImage() {
  // println("beatNumber: " + beatNumber + "   rythm size:  " + newRythms.get(rScale).size() + "   rhythm segment: " +newRythms.get(rScale).get(beatNumber) );
  float waitTime = newRythms.get(rScale).get(beatNumber);
  createScheduleTimer(waitTime);
  // println("\n\nTimer scheduled for " + nf(waitTime, 0, 2) + " msecs.\n");
  scale.selectImage(waitTime, scaleType);
  beatNumber += 1;
  beatNumber = beatNumber % newRythms.get(rScale).size(); 
  if (beatNumber % newRythms.get(rScale).size() == 0) {globalCounter += 1;}
  if (globalCounter > 0 && globalCounter%7 == 0) {
     println("Update pause because:  " + globalCounter + " but suspended im moment");
     // updatePause(); 
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

void loadRest() {
    println("loadRest for scale: " + currentScaleName);
    for (int i=0; i<restFileNames.size(); i++) {
      PImage img = loadImage(restFiles.get(i));
      AugmentedImage aI = new AugmentedImage(restFileNames.get(i), img, i);
      scale = scaleMap.get(currentScaleName);
      scale.imageArray.add(aI);
      println("scale.imageArray Size: " + scale.imageArray.size());
    }
    
  }
