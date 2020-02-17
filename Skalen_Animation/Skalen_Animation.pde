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

boolean hasFinished = true;
boolean flicker30sec, flicker3min, flicker7min, timetoUpdate, message;

Klopfen klopfen;
Scale scale;
File folder;
File[] files;
Table zitate, bildTexte, durationMap;
int  picIndex, beatNumber, rScale, globalCounter, newglobalCounter;
String currentBeat, currentScaleName, knockMessage;
PImage pic1, noMatch, picWhite, klopf0, klopf1s, klopf1w;
PImage[] imgArray;
PGraphics audio;
String [] fileNames;
// ArrayList<ImageClass> genericScale, currentScale, imageClassArray;
HashMap<String, Scale> scaleMap = new HashMap<String, Scale>();
ArrayList<Object> scaleValues, klopfValues;
IntList weightList; 
PFont Arial;
ArrayList<ArrayList<Float>> newRythms = new ArrayList<ArrayList<Float>>();
float factor = 1.0;



void setup() {
  size(1000, 700);
  buildRythms(newRythms);
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  durationMap = loadTable("durationMappings.csv", "header");
  Arial = createFont("Arial", 16, true);
  message = false;
  scaleMap.put("singer", new Scale("PlanscheSinger", "singer", "augmented"));
  scaleMap.put("weyde", new Scale("PlanscheWeyde", "weyde", "augmented"));
  scaleMap.put("klopf", new Scale("Klopfen", "klopfen", "message"));
  picIndex = 0;
  beatNumber = 0;
  rScale = 1;
  newglobalCounter = -1;
  currentScaleName = "singer";
  scale = scaleMap.get(currentScaleName);
  noMatch = scale.noMatch;
  frameRate(20);
  klopfen = new Klopfen();
  
}

void draw() {
  if (hasFinished) {
    getRythm();
    // println("beatnumber: " + beatNumber + "   rythm size:  " + newRythms.get(rScale).size() + "   rhythm segment: " +newRythms.get(rScale).get(beatNumber) );
    float waitTime = newRythms.get(rScale).get(beatNumber);
    createScheduleTimer(waitTime);
    // println("\n\nTimer scheduled for " + nf(waitTime, 0, 2) + " msecs.\n");
    scale = scaleMap.get(currentScaleName);
    beatNumber += 1;
    beatNumber = beatNumber % newRythms.get(rScale).size(); 
    if (beatNumber % newRythms.get(rScale).size() == 0) {globalCounter += 1;}
    if (globalCounter > 0 && globalCounter%7 == 0) {
       println("Update pause because:  " + globalCounter);
       updatePause(); 
     }
     scale.display(waitTime);
  }
    klopfen.analyseInput();
    imageMode(CORNER);
    image(audio, 0, height - audio.height);
   
  //String monitoringState = klopfen.in.isMonitoring() ? "enabled" : "disabled";
  //text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
    
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

void getRythm() {
  if(minute()%2 == 0) {
    rScale = 0;
    currentScaleName = "singer";
  }  else {
    rScale = 1;
    currentScaleName = "weyde";
    // println("currentScaleName:  " + currentScaleName + "\nweigths: " + (IntList)scaleMap.get(currentScaleName).get(2));
  }
  timedEvents();
  
  if (beatNumber >= newRythms.get(rScale).size()) {
    println("beatNumber set to 0!: " + beatNumber);
    beatNumber = 0;
 }
  if (globalCounter != newglobalCounter) {
    println("globalCounter: " + globalCounter);
    newglobalCounter = globalCounter;
 }
   scale = scaleMap.get(currentScaleName);
   noMatch = scale.noMatch;
}

void timedEvents() {
  flicker30sec = (second()>=30 && second() <= 35);
  flicker3min = (minute()%3 ==0 && (second()>=15 && second() <= 18));
  flicker7min = (minute()% 7 == 0 &&  (second()>=49 && second() <= 54));
  if (flicker3min || flicker7min) {
    rScale = 2;
    scale.flicker = true;
  } else if (flicker30sec) {
    rScale = 3;
    currentScaleName = "klopf";
    message = true;
  } 
}

void updatePause() {
  ArrayList<Float> r_list = newRythms.get(rScale);
  if (minute()%3 == 0) {
  factor = 1.05;
  } else {
    factor = 0.95;
  }
  println("factor  " + factor);
  for (int i=0; i<r_list.size(); i++) {
      float pause = (float)r_list.get(i);
      float newPause = pause * factor;
      // println("new Pause  " + newPause + "for element " + i);
      r_list.set(i, newPause);
   }
   globalCounter = 0;
   printArray("r_list:   " + r_list + "\n ryhtmlist: " + newRythms.get(rScale));
}
