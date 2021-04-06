/*
Idee einer automatischen Zitaterkennung, die 
 1. aus einem grossen Bild allen Zitaten Koordinaten zuweist
 2. alle Zitate freistellt und als png sichert
 3. in einem Raster anordnet
 4. per mouseKlick vergrößert
 
 */
import gab.opencv.*;
import java.awt.Rectangle;
import java.awt.Point;
import java.util.Map;

OpenCV opencv;
PImage pic, pic_crop, pic1, pic2, pic3;
ArrayList<Contour> allBlobs;
ArrayList<Contour> bigBlobs;
ArrayList<Zitat> zitatList;
ArrayList<PImage> schnipsel;
Table bildTexte;
Zitat zitatNow;
float noiseT = 0;
float xOff, yOff, scaleVal;
String pathSingle, pathSkalen, pathSites, computer;
PFont font;
PGraphics surface;
boolean drawGrid = false;

void setup() {
  size(1500, 1000);
  computer = "iMac";
  loadData();
  opencv = new OpenCV(this, pic);
  makeBlobs();
  font = createFont("Helvetica", 15, true);
  textFont(font);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  scaleVal = float(width) / float(pic.width);
}

void draw() {
  image(pic, 0, 0, width, height);
  for (Zitat z : zitatList) {
    xOff = map(z.firstPos.x, 0, pic.width, 0, width);
    yOff = map(z.firstPos.y, 0, pic.height, 0, height);
    pushMatrix();
    fill(0, 255, 0, 100);
    scale(scaleVal);
    // translate(-z.box.width, -z.box.height);
    z.contour.draw();
    popMatrix();
    fill(255, 0, 0, 100);
    rect(xOff, yOff, 20, 20);
    fill(255);
    text(z.index, xOff, yOff);
  }
}

void loadData() {
  if (computer.equals("iMac")) {
    pathSingle = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/SingleZitate/";
    pathSkalen = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/Skalen/";
    pathSites = "/Volumes/Macintosh HD 2/projekte/Igel_der_Begegnung/Igel_Code_fork/Images/Orte/";
  } else {
    pathSingle = "/Users/borisjoens/Documents/IchProjekte/Igel/Igel_Code/Images/SingleZitate/";
    pathSkalen = "/Users/borisjoens/Documents/IchProjekte/Igel/Igel_Code/Images/Skalen/";
    pathSites = "Images/Orte/";
  }
  bildTexte = loadTable("BildTexte_0321.tsv", "header");
  pic3 = loadImage(pathSkalen + "DSC00513.JPG");
  pic = pic3;
}

void makeBlobs() {
  int i = 0;
  opencv.gray();
  opencv.threshold(120);
  allBlobs = opencv.findContours(true, true);
  bigBlobs = new ArrayList<Contour>();
  zitatList = new ArrayList<Zitat>();
  for (Contour contour : allBlobs) {
    schnipsel = new ArrayList<PImage>();
    if (contour.numPoints() > 280 && contour.numPoints() < 11000 ) {
      //println("numpoits " + contour.numPoints());
      Zitat zitat = new Zitat(i+1, contour);
      // crop pic to zitat.box
      Rectangle box = contour.getBoundingBox();
      pic_crop = pic.get(box.x, box.y, box.width, box.height);

      // new openCV with cropped Pic to find its lines
      // OpenCV picCrop = new OpenCV(this, pic_crop);
      // zitat.calcAngles();
      // zitat.fillSurface(pic_crop);
      zitatList.add(zitat);
      bigBlobs.add(contour);
      i ++;
    }
  }
}
