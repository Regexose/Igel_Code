import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
// more directory stuff: https://processing.org/examples/directorylist.html

File sing_folder, weyd_folder;
File[] files;
Table zitate, bildTexte, durationMap;
int  picIndex, beatNumber;
PImage pic1, pic2;
PImage[] weydemeyer, singer;
String [] weydeList, singerList;
ArrayList<ImageClass> singerScales = new ArrayList<ImageClass>();
ArrayList<ImageClass> weydeScales = new ArrayList<ImageClass>();
IntList matchList;
PFont Arial;
int[][] rythms = { {3000, 1000, 1000, 1000, 250, 500}, 
  {3000, 2000, 2000, 500, 500, 1000, 1000}, 
  {3000, 500, 500, 1000, 1000}};


void setup() {
  size(900, 600);
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  durationMap = loadTable("durationMappings.csv", "header");
  Arial = createFont("Arial", 16, true);
  matchList = new IntList();
  sing_folder = new File(sketchPath("data/singer"));
  weyd_folder = new File(sketchPath("data/weyde"));
  weydemeyer = loadImages(weyd_folder);
  singer = loadImages(sing_folder);
  weydeList = weyd_folder.list();
  singerList = sing_folder.list();
  buildClasses(singerScales, singer, singerList);
  pic1 = createImage(width, height, ARGB);
  // buildClasses(weydeScales, weydemeyer, weydeList);
  picIndex = 0;
  beatNumber = 0;
  
}

void draw() {
  selectImage(singerScales, rythms[0], beatNumber);
  imageMode(CENTER);
  image(pic1, width/2, height/2, width, height);
  textFont(Arial, 29);
  text(singerScales.get(3).cites.get(0), mouseX, mouseY);
}
