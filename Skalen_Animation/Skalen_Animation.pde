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

Minim minim;

boolean hasFinished = true;
boolean flicker30sec, flicker3min, flicker7min, timetoUpdate, message, knock;

Klopfen klopfen;
Scale scale;
File folder;
File[] files;
Table zitate, bildTexte, durationMap;
int  picIndex, beatNumber, rScale, globalCounter, newglobalCounter, startTime, elapsedTime;
String currentBeat, currentScaleName, knockMessage, scaleType;
PImage noMatch;
PGraphics audio;
String [] fileNames;
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
  scaleType = "augmented";
  knock = false;
  frameRate(20);
  minim = new Minim(this);
  klopfen = new Klopfen(minim);
  startTime = millis();  
}

void draw() {
    klopfen.analyseInput();
    if (hasFinished && !knock) {
    getRythm();
    println("beatnumber: " + beatNumber + "   rythm size:  " + newRythms.get(rScale).size() + "   rhythm segment: " +newRythms.get(rScale).get(beatNumber) );
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
     scale.selectImage(waitTime, scaleType);
  }
   
   scale.display();
   imageMode(CORNER);
   image(audio, 0, height - audio.height);
   elapsedTime = millis() - startTime;
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
