/*
Idee einer automatischen Zitaterkennung, die 
 png files werden nicht mehr stacheln, sondern jpg zugeordnet. Ist sonst zu viel fuss
 blob detection mit besser winkeln, die das spätere rekonstruieren erleichtern
 
 */
import gab.opencv.*;
import java.awt.Rectangle;
import java.awt.Point;
import java.util.Map;

OpenCV opencv;
PImage pic, pic_crop, pic1, pic2, pic3;
ArrayList<Contour> allBlobs, bigBlobs;
ArrayList<Zitat> zitatList;
ArrayList<PImage> schnipsel;
Table bildTexte;
Zitat zitatNow;
float noiseT = 0;
float xOff, yOff, scaleVal;
String pathSingle, pathSkalen, pathSites, computer, fileName;
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
  tableOps();
}

void draw() {
  image(pic, 0, 0, width, height);
  for (Zitat z : zitatList) {
    xOff = map(z.firstPos.x, 0, pic.width, 0, width);
    yOff = map(z.firstPos.y, 0, pic.height, 0, height);
    //pushMatrix();
    fill(0, 255, 0, 100);
    //scale(scaleVal);
    //for (Edge e : z.edges) {
    //  stroke(e.col);
    //  strokeWeight(30);
    //  point(e.point.x, e.point.y);
    //}
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
    //translate(z.firstPos.x, z.firstPos.y);
    //   rotate(z.angle);
    //stroke(0, 0, 255);
    //strokeWeight(15);
    //PVector newBaseline = PVector.add(new PVector(0,0), z.baseLine);

    //// rotated baseLine
    //line(0, 0, newBaseline.x, newBaseline.y);
    //// text(z.angle, z.firstPos.x, z.firstPos.y);
    //popMatrix();
    //stroke(255, 0, 0, 100);
    //strokeWeight(1);
    //line(pic.width/2 * scaleVal, 0, pic.width/2* scaleVal, pic.height);
    rect(xOff, yOff, 20, 20);
    fill(255);
    textSize(12);
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
  fileName = "DSC00512.JPG";
  bildTexte = loadTable("SkalenTexte.tsv", "header");
  pic3 = loadImage(pathSkalen + fileName);
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
      zitatList.add(zitat);
      bigBlobs.add(contour);
      i ++;
    }
  }
}

void tableOps() {


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
      } else if(row.getString("png_name").equals(pngName))  {

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
      }


      saveTable(bildTexte, "data/" + fileName + "_detected.tsv");
    }
  }
}
