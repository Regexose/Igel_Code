class AugmentedImage {
  String type, name;
  PImage image;
  PVector position, velocity, acceleration;
  int index, w, h, weight, counter;
  ArrayList<Contour> contours;
  ArrayList<Zitat> zitate;
  OpenCV ocv;
  Contour singleContour;
  float scaleFactor;
  boolean hasZitate;

  AugmentedImage(String name, PImage image, int index) {
    this.name = name;
    this.image = image;
    w = width;
    h = height;
    //println(" image width " + this.image.width + "  width   " + width + "  ratio width/image.w)   " + float(width)/float(this.image.width));
    this.index = index;
    this.position = new PVector (-width/3, -height/2);
    scaleFactor = 1.75;
    this.weight = 20;
    this.counter = 0;
    this.contours = makeContours(name, image);
    this.hasZitate = false;
    this.zitate = new ArrayList<Zitat>();
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector (0, 0);
    // println("countours leng " + this.contours.size());
    loadZitate();
  }

  void loadZitate() {
    String iStr = "";
    String blobName = "";
    int i = 0;
    PImage img = createImage(30, 30, RGB);
    String angle = "0";

    for (TableRow row : bildTexte.rows()) {
      String bildName = row.getString("BildName");
      if (bildName.equals(this.name)) {
        IntList coords = new IntList();
        String zitat = row.getString("Zitat");
        if (row.getString("png_name").length() != 0) {
          this.hasZitate = true;
          blobName = row.getString("png_name");
          img = loadImage(pathSingle + blobName);
          if (blobName.length() > 3) {
            iStr = blobName.substring(10, 12);
          } else {
            iStr = blobName; // bei Zitaten, die schon freigestellt wurden
          }
          String ecken = row.getString("Eckpunkte_yxmin_yx_max");
          // println("ecken   " + ecken);
          for (String c : ecken.split(", ")) {
            coords.append(int(c));
          }
          angle = row.getString("angle_deg");


          int numPoints = row.getInt("numPoints");
          findContour(numPoints);
          // singleContour = singleContour.getPolygonApproximation();
          i = int(iStr);
        } else {
          this.hasZitate = false;
          // println("Zitat  " + zitat + "has zitate? " + this.hasZitate);
          // make fake Zitate
          i ++;
          for (int x=0; x< 50; x+=5) {
            coords.append(x);
          }
        }
        // println("zitat   " + zitat + "  angle   " + angle);

        Zitat z = new Zitat(i, zitat, img, angle, coords, this.image.width, this.image.height);
        zitate.add(z);
      }
    }
  }

  void update() {
    PVector mouse = new PVector(mouseX, mouseY);
    mouse.sub(this.position);
    mouse.setMag(1);
    this.acceleration = mouse;
    this.velocity.add(this.acceleration);
    this.velocity.limit(10);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }

  void rePosition(PVector newPos) {
    this.position = newPos;
  }

  void display() {
    layer1.beginDraw();
    // layer1.background(220, 0, 200);
    layer1.translate(this.position.x, this.position.y);
    // layer1.scale(scaleFactor, scaleFactor);
    layer1.image(this.image, 0, 0, layer1.width *scaleFactor, layer1.height*scaleFactor);

    layer1.endDraw();
  }

  void findContour(int nP) {
    for (Contour c : contours) {
      if (c.numPoints() == nP) {
        singleContour = c;
      }
    }
  }
}
