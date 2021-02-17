 //<>//
ArrayList<AugmentedImage> schnipsel;
int i, xGrid, yGrid;
float s, angle, widthOffset, heightOffset;
PImage pic, pick;
AugmentedImage z;
Table bildTexte;
String scaleName;
int z_idx;


void setup() {
  size(1200, 900);
  scaleName = "PlanscheWeydemeyer_DSC05212.jpg";
  bildTexte = loadTable("Texte_im_Bild.tsv", "header");
  pic = loadImage(scaleName);
  pic.resize(width, height);
  schnipsel = new ArrayList<AugmentedImage>();
  // z_idx = 1;
  for (TableRow row : bildTexte.rows()) {
    String pngName = row.getString("png_name");
    String iStr = pngName.substring(6, 8);
    int i = int(iStr);
    println(" png " + pngName + " i " + i + " iStr  " + iStr);
    String zitat = row.getString("Zitat");
    float angle = row.getFloat("angle_deg");
    String fileName = "st11_z" + iStr +".png";
    PImage p = loadImage("zitate/" + fileName);
    AugmentedImage aI = new AugmentedImage(i, p, zitat, fileName, angle);
    schnipsel.add(aI);
  }
  yGrid = 0;
  xGrid = 0;
  s = 1.0;
  i = 1;
  angle = 0;
}

void draw() {
  background(pic);
  z = schnipsel.get(i%schnipsel.size());
  pick = z.img;
  grid(pick);
}

void grid(PImage p) {
  yGrid = 0;
  xGrid = 0;
  widthOffset = p.width -50;
  heightOffset = p.height -50;

  while (yGrid < height) {

    if (xGrid>= width) {
      xGrid = 0;
      yGrid += heightOffset;
    }
    pushMatrix();
    translate(xGrid, yGrid);
    imageMode(CENTER);
    rotate(radians(z.angle));
    scale(s);
    image(z.img, 0, 0);
    popMatrix();
    xGrid += widthOffset;
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
    angle += 0.01;
  }
  if (key == 'b') {
    angle -= 0.01;
  }
  if (key == 'w') {
    widthOffset -= 10;
  }
  if (key == 'h') {
    heightOffset -= 10;
  }

  println("schnipsel " + z.index + " scale " + s);
}
