/* //<>//
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
ArrayList<Contour> blobs;
ArrayList<Contour> bigContours;
ArrayList<Zitat> zitatList;
ArrayList<PImage> schnipsel;
Table bildTexte;
Zitat zitatNow;
int i = 0;
float noiseT = 0;
float xOff, yOff, s, angle;
String pathSingle, pathSkalen, pathSites;
PFont font;
PGraphics surface;
boolean drawGrid = false;

void setup() {
  size(1200, 800);
  bildTexte = loadTable("newBildTexte.tsv", "header");
  pic1 = loadImage("PlanscheWeydemeyer_DSC05212.jpg");
  pic2 = loadImage("FabianAileen_DSC05217.jpg");
  pic3 = loadImage("DSC00513.JPG");

  pic = pic3;
  println("image w " +pic.width + "   image h   " + pic.height);
  font = createFont("Helvetica", 15, true);
  textFont(font);
  textAlign(LEFT,CENTER);
  opencv = new OpenCV(this, pic);
  opencv.gray();
  opencv.threshold(120);
  blobs = opencv.findContours(true, true);
  bigContours = new ArrayList<Contour>();
  zitatList = new ArrayList<Zitat>();
  for (Contour contour : blobs) {
    schnipsel = new ArrayList<PImage>();
    if (contour.numPoints() > 280 && contour.numPoints() < 11000 ) {
      println("numpoits " + contour.numPoints());
      Zitat zitat = new Zitat(i+1, contour);
      // crop pic to zitat.box
      Rectangle box = contour.getBoundingBox();
      pic_crop = pic.get(box.x, box.y, box.width, box.height);

      // new openCV with cropped Pic to find its lines
      // OpenCV picCrop = new OpenCV(this, pic_crop);
      zitat.calcAngles();
      // zitat.fillSurface(pic_crop);
      zitatList.add(zitat);
      bigContours.add(contour);
      i ++;
    }
  }
  i = 0;
  s = 1;
  angle = 0;
}

void draw() {
  image(pic, 0, 0, width, height);
  for (Zitat z : zitatList) {
    xOff = map(z.firstPos.x, 0, pic.width, 0, width);
    yOff = map(z.firstPos.y, 0, pic.height, 0, height);
    pushMatrix();
    fill(0, 255, 0, 100);
    scale(0.2);
    //translate(-z.box.width, -z.box.height);
    z.contour.draw();
    popMatrix();
    fill(255);
    text(z.index, xOff, yOff);
  }
}
