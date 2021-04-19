import gab.opencv.*;

OpenCV opencv;
int i, xGrid, yGrid;
AugmentedImage aI;
float s, angle, widthOffset, heightOffset;
ArrayList<PVector>  grid;
ArrayList<Contour> currentContours;
PVector pos;
PImage pic;
PGraphics layer1;
Table bildTexte;
String scaleName;
int z_idx;
boolean setOff= false;
String pathSingle, pathSkalen, pathSites, computer, blobName;

void setup() {
  size(1500, 1000);
  layer1 = createGraphics(width, height);
  computer = "iMac";
  makeGrid(5);
  loadData();
  scaleName = "DSC05213.jpg";
  pos = new PVector(0, 0);
  yGrid = 0;
  xGrid = 0;
  s = 0.25;
  i = 1;
  angle = 0;
  frameRate(25);
}

void draw() {
  background(pic);

  for (int i=0; i< aI.zitate.size(); i++) {
    Zitat z = aI.zitate.get(i);
    z.update();
    z.move();
    z.display();
  }
  if (frameCount%50 ==0) {
    opencv = new OpenCV(this, layer1.get());
    opencv.threshold(100);
    currentContours = opencv.findContours();
    aI.blobs = opencv.findContours();
  }
  image(layer1, 0, 0);

  for (PVector p : grid) {
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
  // bildTexte = loadTable("Texte_im_Bild.tsv", "header");
  bildTexte = loadTable("newBildTexte.tsv", "header");
  scaleName = "DSC00513.JPG";
  pic = loadImage(pathSkalen + scaleName);
  opencv = new OpenCV(this, pic);
  pic.resize(width, height);
  aI = new AugmentedImage(i, pic, scaleName, opencv);
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

void newOpenCV() {
  for (Contour contour : currentContours) {
    // println("c num   " + contour.numPoints());
    contour = contour.getPolygonApproximation();
    layer1.beginDraw();
    layer1.fill(255, 0, 200);
    layer1.beginShape();
    for (PVector p : contour.getPoints()) {
      layer1.vertex(p.x, p.y);
    }
    layer1.endShape(CLOSE);
    layer1.endDraw();
  }
}

void mousePressed() {
  for (Contour c : currentContours) {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector cPos = new PVector();
    if (c.containsPoint(int(mouse.x), int(mouse.y))) {
      
    }
  }
  for (int i=0; i< grid.size(); i++) {
    Zitat z = aI.zitate.get(i);
    z.clicked(mouseX, mouseY);
    //PVector wind = new PVector(-1, 0);
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
