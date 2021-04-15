import gab.opencv.*;

OpenCV opencv;
int i, xGrid, yGrid;
AugmentedImage aI;
float s, angle, widthOffset, heightOffset;
ArrayList<PVector>  grid;
PVector pos;
PImage pic;
AugmentedImage z;
Table bildTexte;
String scaleName;
int z_idx;
boolean setOff= false;
String pathSingle, pathSkalen, pathSites, computer, blobName;

void setup() {
  size(1200, 900);
  computer = "iMac";
  makeGrid(5);
  loadData();
  opencv = new OpenCV(this, pic);
  scaleName = "DSC05213.jpg";
  bildTexte = loadTable("Texte_im_Bild.tsv", "header");
  pos = new PVector(0, 0);
  yGrid = 0;
  xGrid = 0;
  s = 0.25;
  i = 1;
  angle = 0;
}

void draw() {
  background(pic);

  for (Zitat z : aI.zitate) {
    pushMatrix();
    z.update();
    z.move();
    z.display();
    popMatrix();
  }
  for (PVector p : grid){
    stroke(255);
    strokeWeight(5);
    point(p.x, p.y);
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
  bildTexte = loadTable("Texte_im_Bild.tsv", "header");
  scaleName = "DSC00513.JPG";
  pic = loadImage(pathSkalen + scaleName);
  pic.resize(width, height);
  aI = new AugmentedImage(i, pic, scaleName);
  }


void makeGrid(int resolution) {
  grid = new ArrayList<PVector>();
  float x = 0;
  float y = 0;
  while (y < height) {
    PVector position = new PVector(x, y);
    grid.add(position);
    if (x >= width) {
      x = 0;
      y += height/resolution;
    } else {
      x += width/resolution;
    }
  }
}

void mousePressed() {
  for (int i=0; i< grid.size(); i++) {
    Zitat z = aI.zitate.get(i);
    z.clicked(mouseX, mouseY);
    PVector wind = new PVector(-1, 0);
    //z.applyForce(wind);
  }
}

void keyPressed() {
  if (key == 'i') { 
    i++;
  }
  if (key == 's') {
    s *= 1.1;
  }
  if (key == 'n') {
    s *= 0.9;
  }
  if (key == 'j') {
    i --;
  }
  if (key == 'a') {
    setOff = true;
    angle += 0.1;
  }
  if (key == 'b') {
    setOff = true;
    angle -= 0.1;
  }
  if (key == 'w') {
    setOff = true;
    widthOffset -= 10;
  }
  if (key == 'h') {
    setOff = true;
    heightOffset -= 10;
  }

  // println("schnipsel " + z.index + " scale " + s);
}
