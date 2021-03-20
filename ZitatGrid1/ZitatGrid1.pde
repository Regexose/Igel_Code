
ArrayList<AugmentedImage> schnipsel;
int i, xGrid, yGrid;
float s, angle, widthOffset, heightOffset;
ArrayList<PVector>  grid;
PVector pos;
PImage pic, pick;
AugmentedImage z;
Table bildTexte;
String scaleName;
int z_idx;
boolean setOff= false;
String zitatePath = "data/Einzelzitate/";


void setup() {
  size(1200, 900);
  scaleName = "PlanscheWeydemeyer_DSC05212.jpg";
  bildTexte = loadTable("Texte_im_Bild.tsv", "header");
  pic = loadImage(scaleName);
  pic.resize(width, height);
  schnipsel = new ArrayList<AugmentedImage>();
  // z_idx = 1;

  for (TableRow row : bildTexte.rows()) {
    String bildName = row.getString("BildName");
    if (bildName.equals(scaleName)== true) {
      String pngName = row.getString("png_name");
      String iStr = pngName.substring(6, 8);
      int i = int(iStr);
      // println(" png " + pngName + " i " + i + " iStr  " + iStr);
      String zitat = row.getString("Zitat");
      float angle = row.getFloat("angle_deg");
      String fileName = "st11_z" + iStr +".png";
      PImage p = loadImage(zitatePath + "st11/" + fileName);
      AugmentedImage aI = new AugmentedImage(i, p, zitat, fileName, angle);
      schnipsel.add(aI);
    }
  }
  makeGrid(5);
  for (int i=0; i< grid.size(); i++) {
    z = schnipsel.get(i%schnipsel.size());
    pick = z.img;
    PVector ppt = grid.get(i);
    z.initialPos(ppt);
  }
  pos = new PVector(0, 0);
  yGrid = 0;
  xGrid = 0;
  s = 0.25;
  i = 1;
  angle = 0;
}

void draw() {
  background(pic);

  for (int i=0; i< grid.size(); i++) {
    z = schnipsel.get(i%schnipsel.size());
    pushMatrix();
    z.update();
    z.move();
    z.display();
    popMatrix();
  }
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
    AugmentedImage aI = schnipsel.get(i%schnipsel.size());
    aI.clicked(mouseX, mouseY);
    PVector wind = new PVector(-1, 0);
    aI.applyForce(wind);
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
