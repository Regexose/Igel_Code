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
PImage pic, pic_crop, pic1, pic2;
ArrayList<Contour> blobs;
ArrayList<Contour> bigContours;
ArrayList<Zitat> zitatList;
Zitat zitatNow;
int i = 0;
float noiseT = 0;
float xOff, yOff;
PGraphics surface;

void setup() {
  size(1200, 900);
  pic1 = loadImage("DSC05212.JPG");
  pic2 = loadImage("FabianAileen_DSC05217.jpg");
  pic = pic2;
  opencv = new OpenCV(this, pic);
  opencv.gray();
  opencv.threshold(120);
  blobs = opencv.findContours(true, true);
  bigContours = new ArrayList<Contour>();
  zitatList = new ArrayList<Zitat>();
  for (Contour contour : blobs) {
    if (contour.numPoints() > 300) {
      Zitat zitat = new Zitat(i+1, contour, "vorläufiger Text des Zitats");
      // crop pic to zitat.box
      PImage pic_crop = pic.get(zitat.box.x, zitat.box.y, zitat.box.width, zitat.box.height);
      zitat.fillSurface(pic_crop);
      // new openCV with cropped Pic to find its lines
      OpenCV picCrop = new OpenCV(this, pic_crop);
      picCrop.findCannyEdges(20,75);
      ArrayList<Line> lines = picCrop.findLines(100, 30, 20);
      zitat.lines = lines;
      // show lines
      zitat.calcAngles(lines);
      
      zitatList.add(zitat);
      bigContours.add(contour);
      i ++;
      }
  }
   i = 0;
}

void draw() {
  
  background(222);
  // scale(0.15);
  image(pic, 0, 0);
  for (Zitat zitat : zitatList) {
    fill(255, 0, 0, 100);
    noStroke();
    // zitat.contour.draw();
    pushMatrix();
   // translate(xOff, yOff);
   // fill(255, 0, 0, 100);
   //stroke(0, 255,0);
   //strokeWeight(1);
   rotate(zitat.evenAngle);
   xOff = noise(noiseT);
   yOff = noise(noiseT);
   //xOff = map(xOff, 0, 1, zitat.position.x -20, zitat.position.x +20 );
   //yOff = map(yOff, 0, 1, zitat.position.y-20, zitat.position.y+20);
   xOff = random(zitat.position.x -10, zitat.position.x +10 );
   yOff = random(zitat.position.y-10, zitat.position.y+10);
   image(zitat.surface, xOff, yOff);
   popMatrix();
  }
   noiseT += 0.02;
   if (keyPressed) {
   i ++; 
   }
}
