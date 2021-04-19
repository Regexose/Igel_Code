class AugmentedImage {
  String type, name;
  PImage image;
  PVector position;
  int index, w, h, weight, counter;
  ArrayList<Contour> contours;
  ArrayList<Zitat> zitate;
  OpenCV ocv;
  Contour singleContour;
  float scaleFactor;

  AugmentedImage(String name, PImage image, int index) {
    this.name = name;
    this.image = image;
    w = width;
    h = height;
    this.index = index;
    position = new PVector (0, 0);
    scaleFactor = 1.0;
    this.weight = 20;
    this.counter = 0;
    this.contours = makeContours(name, image);
    this.zitate = new ArrayList<Zitat>();
    // println("countours leng " + this.contours.size());
    loadZitate();
  }
  void loadZitate() {
    String iStr = "";
    for (TableRow row : bildTexte.rows()) {
      String bildName = row.getString("BildName");
      IntList coords = new IntList();
      if (bildName.equals(this.name)) {
        String zitat = row.getString("Zitat");
        if (row.getString("png_name").length() != 0) {
          String blobName = row.getString("png_name");
          // println("blabname   " + blobName);
          if (blobName.length() > 3) {
            iStr = blobName.substring(10, 12);
          } else {
            iStr = blobName; // bei Zitaten, die schon freigestellt wurden
          }
          String ecken = row.getString("Eckpunkte_yxmin_yx_max");
          for (String c : ecken.split(",")) {
            coords.append(int(c));
          }
          float angle = row.getFloat("angle_deg");
          int numPoints = row.getInt("numPoints");
          findContour(numPoints);
          // singleContour = singleContour.getPolygonApproximation();
          int i = int(iStr);
        }
        println("zitat   " + zitat + "  coords   " + coords);
        PImage img = createImage(200, 200, RGB);
        Zitat z = new Zitat(1000, zitat, img, 0, coords);
        // z.initialPos(ppt);
        zitate.add(z);
      }
    }
  }

  void resizeImage(float factor) {
    // check hier https://forum.processing.org/two/discussion/1364/constraining-an-image-while-panning-and-zooming
    //float newWidth = map(w, 0, this.image.width, position.x, this.image.width/factor); 
    //float newHeight = map(h, 0, this.image.height, position.y, this.image.height/factor); 
    //this.image = this.image.get(int(position.x), int(position.y), int(newWidth), int(newHeight));
    // this.image.resize(int(factor), int(factor));
    println("image resized " + this.image.width + " ,"  + this.image.height);
  }

  void display() {
    layer1.beginDraw();
    layer1.background(220, 0, 200);
    layer1.translate(position.x, position.y);
    layer1.scale(scaleFactor, scaleFactor);
    layer1.image(this.image, 0, 0, layer1.width, layer1.height);
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
