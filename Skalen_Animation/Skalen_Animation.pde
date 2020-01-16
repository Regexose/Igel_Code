import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
// more directory stuff: https://processing.org/examples/directorylist.html

File sing_folder, weyd_folder;
File[] files;
Table zitate, bildTexte;
int  picIndex, counter;
PImage[] weydemeyer, singer;
String [] weydeList, singerList;
ArrayList<ImageClass> singerScales = new ArrayList<ImageClass>();
ArrayList<ImageClass> weydeScales = new ArrayList<ImageClass>();
IntList weightList;
PFont Arial;
int [][] rythms = { {1000, 1000, 1000, 1000, 250, 500}, 
  {500, 2000, 2000, 500, 500, 1000, 1000}, 
  {3000, 500, 500, 1000, 1000}};

void setup() {
  size(900, 600);
  zitate = loadTable("Igel_Zitate.csv", "header");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  Arial = createFont("Arial", 16, true);
  weightList = new IntList();
  sing_folder = new File(sketchPath("data/singer"));
  weyd_folder = new File(sketchPath("data/weyde"));
  weydemeyer = loadImages(weyd_folder);
  singer = loadImages(sing_folder);
  weydeList = weyd_folder.list();
  singerList = sing_folder.list();
  buildClasses(singerScales, singer, singerList);
  // buildClasses(weydeScales, weydemeyer, weydeList);
  picIndex = 0;
  counter = 0;
}

void draw() {
  selectImage(singerScales, frameCount, rythms[2]);
  imageMode(CENTER);
  image(singerScales.get(picIndex).image, width/2, height/2, width, height);
  textFont(Arial, 29);
  text(singerScales.get(3).cites.get(0), mouseX, mouseY);
}

void loadCites(ImageClass iC) {
  // println("checking:    " +iC.name); 
  for (TableRow row : bildTexte.rows()) {
    String bildName = row.getString("BildName");
     if (bildName.equals(iC.name) == true) {
      String quote = row.getString("Zitat");
      // println("bildName:   " + bildName + "   iC:image:   " + iC.name + "\n cite: " + quote);
      iC.textAcquire(quote);
    }
  }
  iC.updateWeight(iC.cites.size());
  weightList.append(iC.cites.size());
  
}

PImage[] loadImages(File folder) {
  File[] fileList = folder.listFiles();
  PImage[] imgArray = new PImage[fileList.length];
  for (int i=0; i<fileList.length; i++) {
    // String path = fileList[i].getAbsolutePath();
    String fileName = fileList[i].toString();
    if(!fileName.endsWith(".DS_Store")) {
    PImage img = loadImage(fileList[i].toString());
    imgArray[i] = img ;
    }
  }
  return imgArray;
}

void buildClasses(ArrayList<ImageClass> imageList, PImage[] images, String[] names) {
  for (int i=0; i<images.length; i++) {
    ImageClass iC = new ImageClass(i, images[i], names[i]);
    imageList.add(iC);
    loadCites(iC);
  }
}
