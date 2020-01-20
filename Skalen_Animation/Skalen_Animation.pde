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

File folder;
File[] files;
Table zitate, bildTexte, durationMap;
int  picIndex, beatNumber, minute;
String currentBeat, currentScaleName;
PImage pic1, noMatch;
PImage[] imgArray;
String [] fileNames;
ArrayList<ImageClass> genericScale, currentScale;
ArrayList<ImageClass> imageClassArray;
HashMap<String,IntList> counterLists = new HashMap<String,IntList>();
HashMap<String, ArrayList> scaleMap = new HashMap<String, ArrayList>();
ArrayList<Object> scaleValues;
IntList matchList, weightList; 
PFont Arial;
ArrayList<ArrayList<Integer>> newRythms = new ArrayList<ArrayList<Integer>>();


void setup() {
  size(1000, 666);
  newRythms.add(new ArrayList<Integer>(Arrays.asList(3000, 1000, 750, 1500, 1375, 500)));
  newRythms.add(new ArrayList<Integer>(Arrays.asList(4500, 750, 500, 750, 500, 750, 500, 2000, 250)));
  newRythms.add(new ArrayList<Integer>(Arrays.asList(3000, 2000, 2000, 500, 500, 1000, 1000)));
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  durationMap = loadTable("durationMappings.csv", "header");
  Arial = createFont("Arial", 16, true);
  loadScales("singer");
  loadScales("weyde");
  pic1 = createImage(width, height, RGB);
  picIndex = 0;
  beatNumber = 0;
  minute = 1;
  currentScaleName = "singer";
  currentScale = (ArrayList)scaleMap.get(currentScaleName).get(0);
  noMatch = (PImage)scaleMap.get(currentScaleName).get(1);
  frameRate(25);
  
}

void draw() {
  getRythm(); 
  if (hasFinished) {
    int waitTime = newRythms.get(minute).get(beatNumber);
    createScheduleTimer(waitTime);
    // println("\n\nTimer scheduled for " + nf(waitTime, 0, 2) + " msecs.\n");
    selectImage(currentScaleName, currentScale, newRythms.get(minute), noMatch);
    textFont(Arial, 29);
    text(beatNumber + " – " + newRythms.get(minute).get(beatNumber), 20, 20);  
    beatNumber += 1;
    beatNumber = beatNumber % newRythms.get(minute).size(); 
    // println("new Minute with:  " + currentScaleName);
  }
   
    imageMode(CENTER);
    // println("second:  " + second() + "    draw beatnumber:  " + beatNumber + "   image: " + singerScales.get(picIndex).name);
    tint(255, mouseX);
    image(pic1, width/2, height/2, width, height);
   
  //saveFrame("output/skala####.png");
}
  /*
  
} 
*/
void createScheduleTimer(final int ms) {
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
  if(minute()%2 ==0) {
    minute = 0;
    currentScaleName = "singer";
  }
  else {
    minute = 1;
    currentScaleName = "weyde";
    // println("currentScaleName:  " + currentScaleName + "\nweigths: " + (IntList)scaleMap.get(currentScaleName).get(2));
  }
   if (beatNumber > newRythms.get(minute).size()) {
   println("beatNumber set to 0!: " + beatNumber);
   beatNumber = 0;
 }
   currentScale = (ArrayList)scaleMap.get(currentScaleName).get(0);
   noMatch = (PImage)scaleMap.get(currentScaleName).get(1);
}
