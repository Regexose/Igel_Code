import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
// more directory stuff: https://processing.org/examples/directorylist.html

File sing_folder, weyd_folder;
File[] files;
Table zitate, bildTexte;
int  picIndex, counter;
PImage[] weydemeyer, singer;
int [][] rythms = { {1000, 1000, 1000, 1000, 250, 500}, 
  {500, 2000, 2000, 500, 500, 1000, 1000}, 
  {3000, 500, 500, 1000, 1000}};
ArrayList<ImageClass> singerScales = new ArrayList<ImageClass>();
ArrayList<ImageClass> weydeScales = new ArrayList<ImageClass>();
int [] weights;
PFont Arial;

void setup() {
  size(900, 600);
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  Arial = createFont("Arial", 16, true);
  sing_folder = new File(sketchPath("data/singer"));
  weyd_folder = new File(sketchPath("data/weyde"));
  files = weyd_folder.listFiles();
  for (int i=0; i<files.length; i++) { //<>//
    println("folder i: " + files[i]);}
  loadImages(weyd_folder);
  loadImages(sing_folder);
  /*buildClasses(singerScales, singer, singerList);
  buildClasses(weydeScales, weydemeyer, weydeList); */
  loadCites();
  picIndex = 0;
  counter = 0;
}

void draw() {
  selectImage(weydeScales, frameCount, rythms[2]);
  imageMode(CENTER);
  image(singerScales.get(picIndex).image, width/2, height/2, width, height);


  textFont(Arial, 29);
  text(weydeScales.get(3).cites.get(2), mouseX, mouseY);
}

void loadCites() {
  for (TableRow row : zitate.rows()) {
    String ort = row.getString("Ort");
    String quote = row.getString("Zitate");
    String ortgeber = row.getString("Ortgeber");
    if (ort.equals("Plansche Weydemeyerstrasse") == true) {
      println("quoute: " + quote);
      weydeScales.get(3).cites.add(quote);
    }
  }
}
void loadImages(File folder) {
  String[] nameList = folder.list();
  PImage[] imgArray = new PImage[nameList.length];
  for (int i=0; i<nameList.length; i++) {
    println("folder i: " + nameList[i]);
    // String path = fileList[i].getAbsolutePath();
    if(!nameList[i].startsWith(".")) {
    println("file:  " + nameList[i]); //<>//
    PImage img = loadImage(nameList[i]);
    imgArray[i] = img ;
    }
  }
  
}

void buildClasses(ArrayList<ImageClass> imageList, PImage[] images, String[] names) {
  weights = new int[images.length];
  for (int i=0; i<images.length; i++) {
    int mockLength = int(random(images.length));
    // println("image:   "+ images[i] + "   name:   " + names[i]);
    imageList.add(new ImageClass(i, images[i], names[i], mockLength));
    weights[i] = mockLength;
    println("weigths:  " + weights[i]);
  }
}
