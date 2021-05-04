class AugmentedImage {
  String type, name;
  PImage image, fakeImage;
  PVector position, velocity, acceleration;
  int index, w, h, weight, counter;
  ArrayList<Contour> contours;
  ArrayList<Zitat> zitate;
  ArrayList<Line> lines;
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
    //this.contours = makeContours(name, image);
    this.hasZitate = false;
    this.zitate = new ArrayList<Zitat>();
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector (0, 0);
    // println("countours leng " + this.contours.size());
    makeFakeImage();
    loadZitate();
  }
  
  void makeFakeImage(){
    PGraphics fake = createGraphics(500, 100);
    fake.beginDraw();
    fake.background(0);
    fake.fill(200);
    fake.rect(20, 10, fake.width - 20, fake.height-20);
    fake.endDraw();
    fakeImage = fake.get();
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
          println("blob   " + blobName);
          img = loadImage(pathSingle + blobName);
          // img = fakeImage;
     
          if (blobName.length() > 3) {
            iStr = blobName.substring(17, 19);
          } else {
            iStr = blobName; // bei Zitaten, die schon freigestellt wurden
          }
          String ecken = row.getString("Eckpunkte_yxmin_yx_max");
          // println("ecken   " + ecken);
          for (String c : ecken.split(", ")) {
            coords.append(int(c));
          }
          angle = row.getString("lineAngle");
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
        // println("zitat   " + zitat + "  index   " + i + " name  " + this.name);
        Zitat z = new Zitat(i, zitat, img, angle, coords, this.image.width, this.image.height);
        this.zitate.add(z);
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

  void findContour(int x, int y) {
    println("findContour  " + " name " + this.name + "  has Z  " + this.hasZitate);
    for (Contour c : this.contours) {
      if (c.containsPoint(x, y)) {
        // make contourPic to find lines
        PImage pic = makeContourPic(c);
        Line line = makeLine(pic);
        float[] angles = new float[this.zitate.size()];
        for (int i=0; i<this.zitate.size(); i++) {
          Zitat z = this.zitate.get(i);
          float between = (float)line.angleFrom(z.line);
          angles[i] = abs(between);
        }
        printArray(angles);
        Rectangle box = c.getBoundingBox();
        for (int i=0; i<this.zitate.size(); i++) {
          if (angles[i]== min(angles)) {
            currentZitat = this.zitate.get(i);
            currentZitat.position = new PVector(box.x, box.y); 
            println(" i " + i + "   Zitat found " + currentZitat.zitat + " angle "  + currentZitat.angle);
          }
        }
      }
    }
  }

  PImage makeContourPic(Contour c) {
    Rectangle box = c.getBoundingBox();
    PGraphics contourSurf = createGraphics(box.width, box.height);
    c = c.getPolygonApproximation();
    contourSurf.beginDraw();
    // this.contourSurf.background(100);

    contourSurf.beginShape();
    contourSurf.fill(0, 0, 255);
    for (PVector p : c.getPoints()) {
      float pX = p.x - box.x;
      float pY = p.y - box.y;
      //println("surf w   " + contourSurf.width + " pX  " + pX);
      //println("surf h   " + contourSurf.height + " pY  " + pY);
      contourSurf.vertex(pX, pY);
    }
    contourSurf.endShape(CLOSE);
    contourSurf.endDraw();
    println("box  " + box);
    PImage contourPic = contourSurf.get();
    // dst = contourSurf.get();
    return contourPic;
  }
}
