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
PImage pic, pic_crop, pic1, pic2;
ArrayList<Contour> blobs;
ArrayList<Contour> bigContours;
ArrayList<Zitat> zitatList;
ArrayList<PImage> schnipsel;
Table bildTexte;
Zitat zitatNow;
int i = 0;
float noiseT = 0;
float xOff, yOff, s, angle;

PGraphics surface;
boolean drawGrid = false;

void setup() {
  size(1200, 900);
  pic1 = loadImage("DSC05212.JPG");
  pic2 = loadImage("FabianAileen_DSC05217.jpg");
  bildTexte = loadTable("Texte_im_Bild.csv", "header");
  pic = pic1;
  opencv = new OpenCV(this, pic);
  opencv.gray();
  opencv.threshold(120);
  blobs = opencv.findContours(true, true);
  bigContours = new ArrayList<Contour>();
  zitatList = new ArrayList<Zitat>();
  for (Contour contour : blobs) {
    schnipsel = new ArrayList<PImage>();
    if (contour.numPoints() > 250 && contour.numPoints() < 11000 ) {
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
