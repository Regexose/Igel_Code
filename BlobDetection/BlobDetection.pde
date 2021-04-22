/*
Idee einer automatischen Zitaterkennung, die 
 png files werden nicht mehr stacheln, sondern jpg zugeordnet. Ist sonst zu viel fuss
 blob detection mit besser winkeln, die das spätere rekonstruieren erleichtern
 
 */
import gab.opencv.*;
import java.awt.Rectangle;
import java.awt.Point;
import java.util.Map;

OpenCV opencv, linesCV;
PImage pic, pic_crop, pic1, pic2, pic3;
ArrayList<PImage> contourPics = new ArrayList<PImage>();
ArrayList<Contour> allBlobs, bigBlobs;
ArrayList<Zitat> zitatList;
ArrayList<PImage> schnipsel;
PVector center;
Table bildTexte;
int scaleRadius;
Zitat zitatNow;
float noiseT = 0;
float xOff, yOff, scaleVal;
String pathSingle, pathSkalen, pathSites, computer, fileName;
PFont font;
PGraphics surface;
boolean drawGrid = false;

void setup() {
  size(1500, 1000, P2D);
  computer = "iMac";
  loadData();
  opencv = new OpenCV(this, pic);
  pic3 = createImage(30, 30, RGB);
  center = new PVector(width/2, height *4/5);
  scaleRadius = 495;
  makeBlobs();
  font = createFont("Helvetica", 15, true);
  textFont(font);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  scaleVal = float(width) / float(pic.width);

  tableOps();
}

void draw() {
  image(pic, 0, 0, width, height);
  for (Zitat z : zitatList) {
    xOff = map(z.firstPos.x, 0, pic.width, 0, width);
    yOff = map(z.firstPos.y, 0, pic.height, 0, height);
    pushMatrix();
    //scale(scaleVal);
    //beginShape();
    //fill(0, 255, 255, 100);
    //for (Edge e : z.edges) {
    //  float eX = map(e.point.x, 0, pic.width, 0, width);
    //  float eY = map(e.point.y, 0, pic.height, 0, height);
    //  vertex(eX, eY);
    //  //strokeWeight(30);
    //  //point(e.point.x, e.point.y);
    //}
    //endShape();
    fill(0, 255, 0, 100);
    //z.contour.draw();
    //stroke(0, 255, 255);
    //strokeWeight(10);
    //point(z.firstPos.x, z.firstPos.y);

    //point(z.secondPos.x, z.secondPos.y);
    //PVector lineCoord = PVector.add(z.firstPos, z.baseLine);
    //PVector straightCoord = PVector.add(z.firstPos, z.straight);
    //line(z.firstPos.x, z.firstPos.y, lineCoord.x, lineCoord.y);

    //stroke(255, 255, 0);
    //strokeWeight(10);
    ////straight Line
    //line(z.firstPos.x, z.firstPos.y, straightCoord.x, straightCoord.y);
    translate(xOff, yOff);
    //   rotate(z.angle);
    //stroke(0, 0, 255);
    //strokeWeight(15);
    //PVector newBaseline = PVector.add(new PVector(0,0), z.baseLine);

    //// rotated baseLine
    //line(0, 0, newBaseline.x, newBaseline.y);
    //// text(z.angle, z.firstPos.x, z.firstPos.y);
    // scale(scaleVal);


    popMatrix();
    rectMode(CENTER);
    rect(xOff, yOff, 20, 20);
    fill(255);
    textSize(12);
    text(z.index, xOff, yOff);
  }

  reconstruct();
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
  fileName = "DSC00513.JPG";
  bildTexte = loadTable("SkalenTexte.tsv", "header");
  pic = loadImage(pathSkalen + fileName);
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
      // contour = contour.getPolygonApproximation();
      Zitat zitat = new Zitat(i+1, contour);
      // crop pic to zitat.box
      Rectangle box = contour.getBoundingBox();
      pic_crop = pic.get(box.x, box.y, box.width, box.height);
      // find lines
      linesCV = new OpenCV(this, zitat.contourPic);
      linesCV.findCannyEdges(20, 75);
      zitat.lines = linesCV.findLines(100, 30, 20);
      println("zitat ind  " + zitat.index + "  lines   " + zitat.lines.size());
      zitat.calcAngles();
      zitat.makeZitatPosition();
      zitatList.add(zitat);
      bigBlobs.add(contour);
      i ++;
    }
  }
}

void reconstruct() {

  stroke(255, 0, 0);
  strokeWeight(1);
  line(center.x, center.y, width/2, 0);
  line(0, height *4/5, width, height *4/5);
  fill(255, 0, 0, 50);
  arc(center.x, center.y, scaleRadius, scaleRadius, PI, TWO_PI);

  for (int i=0; i < zitatList.size(); i++) {
    Zitat z = zitatList.get(i);
    stroke(20);
    strokeWeight(8);
    point(z.zitatPos.x, z.zitatPos.y);
    fill(255, 120);
    text(z.index, z.zitatPos.x, z.zitatPos.y +15); 
    pushMatrix();
    translate (z.zitatPos.x, z.zitatPos.y);
    stroke(0);
    strokeWeight(1);
    if (z.firstPos.x > pic.width/2) {
      rotate(z.lineAngle - HALF_PI);
    } else {
      rotate(z.lineAngle + HALF_PI);
    }
    rectMode(CORNER);
    rect(0, 0, 100, 15);
    popMatrix();
  }
}

void tableOps() {
  bildTexte.addColumn("lineAngle");
  for (Zitat z : zitatList) {
    String sIndex = str(z.index);
    if (z.index <10) {
      sIndex = "0" + z.index;
    }
    String pngName =  fileName + "_Blob" + sIndex + ".png";
    println("pngname   " + pngName);
    // pngName = sIndex; // für den Fall, dass es schon pngs gibt und man tableops braucht
    String[] ecken = new String[4];
    for (int i= bildTexte.getRowCount()-1; i >= 0; i--) {
      TableRow row =  bildTexte.getRow(i);
      if (!row.getString("png_name").equals(pngName) && !row.getString("BildName").equals(fileName)) {
        println("i  " + i + " removing ort   " + row.getString("Ort")); 
        bildTexte.removeRow(i);
      } else if (row.getString("png_name").equals(pngName)) {

        println("i  " + i + " keeping blob   " + row.getString("png_name")); 
        for (int a=0; a< z.edges.size(); a++) {
          int x = int(z.edges.get(a).point.x);
          int y = int(z.edges.get(a).point.y);
          String ecke = str(x) + ", " + str(y);
          ecken[a] = ecke;
        }
        // print("ecken" + ecken); 
        String tableEdges = join(ecken, ", ");
        row.setString("Eckpunkte_yxmin_yx_max", tableEdges);
        row.setString("angle_deg", str(degrees(z.angle)));
        row.setInt("numPoints", z.contour.numPoints());
        row.setString("lineAngle", str(z.lineAngle));
      }

      saveTable(bildTexte, "data/" + fileName + "_detected.tsv");
    }
  }
}
