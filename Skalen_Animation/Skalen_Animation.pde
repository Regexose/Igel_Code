import java.util.ArrayList;
import java.io.File;
import java.util.Arrays;
// more directory stuff: https://processing.org/examples/directorylist.html
import java.util.Timer;
import java.util.TimerTask;
// timer tutorial: https://forum.processing.org/two/discussion/1725/millis-and-timer
final Timer t = new Timer();
boolean hasFinished = true;

File sing_folder, weyd_folder;
File[] files;
Table zitate, bildTexte, durationMap;
int  picIndex, beatNumber, start, time;
String currentBeat;
PImage pic1, totaleSinger, totaleWeydemeyer;
PImage[] weydemeyer, singer;
String [] weydeList, singerList;
ArrayList<ImageClass> singerScales = new ArrayList<ImageClass>();
ArrayList<ImageClass> weydeScales = new ArrayList<ImageClass>();
IntList matchList, weightList;
PFont Arial;
ArrayList<ArrayList<Integer>> newRythms = new ArrayList<ArrayList<Integer>>();


void setup() {
  size(1900, 1100);
  newRythms.add(new ArrayList<Integer>(Arrays.asList(3000, 1000, 750, 1500, 1375, 500)));
  newRythms.add(new ArrayList<Integer>(Arrays.asList(3000, 2000, 2000, 500, 500, 1000, 1000)));
  newRythms.add(new ArrayList<Integer>(Arrays.asList(3000, 2000, 2000, 500, 500, 1000, 1000)));
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  durationMap = loadTable("durationMappings.csv", "header");
  Arial = createFont("Arial", 16, true);
  matchList = new IntList();
  weightList = new IntList();
  sing_folder = new File(sketchPath("data/singer"));
  weyd_folder = new File(sketchPath("data/weyde"));
  weydemeyer = loadImages(weyd_folder);
  singer = loadImages(sing_folder);
  weydeList = weyd_folder.list();
  singerList = sing_folder.list();
  buildClasses(singerScales, singer, singerList);
  pic1 = createImage(width, height, RGB);
  totaleSinger = loadImage("singer/Ort_Totale_DSC05176.jpg");
  totaleWeydemeyer = loadImage("weyde/Ort_Totale_DSC05018.jpg");
  // buildClasses(weydeScales, weydemeyer, weydeList);
  picIndex = 0;
  beatNumber = 0;
  start = millis();
  frameRate(25);
  
}

void draw() {
 
  if (hasFinished) {
    int waitTime = newRythms.get(0).get(beatNumber);
    createScheduleTimer(waitTime);
    println("\n\nTimer scheduled for " + nf(waitTime, 0, 2) + " msecs.\n");
    selectImage(singerScales, newRythms.get(0));
    beatNumber += 1;
    beatNumber = beatNumber % newRythms.get(0).size(); 
  }
   
    imageMode(CENTER);
    // println("second:  " + second() + "    draw beatnumber:  " + beatNumber + "   image: " + singerScales.get(picIndex).name);
    tint(255, mouseX);
    image(pic1, width/2, height/2, width, height);
    textFont(Arial, 29);
    text(beatNumber + " – " + newRythms.get(0).get(beatNumber), 20, 20);  
  //saveFrame("output/skala####.png");
}
  /*
  
} 
*/
void createScheduleTimer(final int ms) {
  hasFinished = false;
 
  t.schedule(new TimerTask() {
    public void run() {
      print("   dong   " + nf(ms, 0, 2));
      hasFinished = true;
    }
  }
  , (long) (ms));
}
