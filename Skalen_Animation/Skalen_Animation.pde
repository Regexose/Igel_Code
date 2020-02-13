import java.util.ArrayList;
import java.io.File;
import java.util.Arrays;
import java.util.HashMap;
// more directory stuff: https://processing.org/examples/directorylist.html
import java.util.Timer;
import java.util.TimerTask;
// timer tutorial: https://forum.processing.org/two/discussion/1725/millis-and-timer
final Timer t = new Timer();

boolean hasFinished = true;
boolean flicker30sec, flicker3min, flicker7min, timetoUpdate;

File folder;
File[] files;
Table zitate, bildTexte, durationMap;
int  picIndex, beatNumber, rScale, globalCounter, newglobalCounter;
String currentBeat, currentScaleName;
PImage pic1, noMatch, picWhite;
PImage[] imgArray;
String [] fileNames;
ArrayList<ImageClass> genericScale, currentScale, imageClassArray;
HashMap<String, ArrayList> scaleMap = new HashMap<String, ArrayList>();
ArrayList<Object> scaleValues;
IntList weightList; 
PFont Arial;
ArrayList<ArrayList<Float>> newRythms = new ArrayList<ArrayList<Float>>();
float factor = 1.0;


void setup() {
  size(1706, 960);
  buildRythms(newRythms);
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  durationMap = loadTable("durationMappings.csv", "header");
  Arial = createFont("Arial", 16, true);
  loadScales("singer");
  loadScales("weyde");
  pic1 = createImage(width, height, RGB);
  picIndex = 0;
  beatNumber = 0;
  rScale = 1;
  newglobalCounter = -1;
  currentScaleName = "singer";
  currentScale = (ArrayList)scaleMap.get(currentScaleName).get(0);
  noMatch = (PImage)scaleMap.get(currentScaleName).get(1);
  frameRate(20);
  
}

void draw() {
   
  if (hasFinished) {
    getRythm();
    println("beatnumber: " + beatNumber + "   rythm size:  " + newRythms.get(rScale).size() + "   rhythm segment: " +newRythms.get(rScale).get(beatNumber) );
    float waitTime = newRythms.get(rScale).get(beatNumber);
    createScheduleTimer(waitTime);
    // println("\n\nTimer scheduled for " + nf(waitTime, 0, 2) + " msecs.\n");
    selectImage(currentScaleName, currentScale, newRythms.get(rScale), noMatch);
    beatNumber += 1;
    beatNumber = beatNumber % newRythms.get(rScale).size(); 
    if (beatNumber % newRythms.get(rScale).size() == 0) {globalCounter += 1;}
    if (globalCounter > 0 && globalCounter%7 == 0) {
       println("Update pause because:  " + globalCounter);
       updatePause(); }
    // println("new Minute with:  " + currentScaleName);
  }
    imageMode(CENTER);
    image(pic1, width/2, height/2, width*7/5, height*7/5);
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
  checkFlicker();
  
  if (beatNumber >= newRythms.get(rScale).size()) {
    println("beatNumber set to 0!: " + beatNumber);
    beatNumber = 0;
 }
  if (globalCounter != newglobalCounter) {
    println("globalCounter: " + globalCounter);
    newglobalCounter = globalCounter;
 }
   currentScale = (ArrayList)scaleMap.get(currentScaleName).get(0);
   noMatch = (PImage)scaleMap.get(currentScaleName).get(1);
}

void checkFlicker() {
  flicker30sec = (second()>=30 && second() <= 35);
  flicker3min = (minute()%3 ==0 && (second()>=15 && second() <= 18));
  flicker7min = (minute()% 7 == 0 &&  (second()>=49 && second() <= 54));
  if (flicker3min || flicker7min) {
    println( "flicker?  " + (flicker3min || flicker7min) + "   at beat:  " + beatNumber);
    rScale = 2;
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
