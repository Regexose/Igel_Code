class AugmentedImage {
  String type, name;
  PImage image;
  int index, weight, counter;
  ArrayList<Contour> contours;
  ArrayList<Zitat> zitate;
  OpenCV ocv;
  Contour singleContour;

  AugmentedImage(String name, PImage image, int index) {
    this.name = name;
    this.image = image;
    this.index = index;
    this.weight = 20;
    this.counter = 0;
    this.contours = makeContours(name, image);
    this.zitate = new ArrayList<Zitat>();
    // println("countours leng " + this.contours.size());
    loadZitate();
  }
  void loadZitate() {
    for (TableRow row : bildTexte.rows()) {
      String bildName = row.getString("BildName");
      IntList coords = new IntList();
      if (bildName.equals(this.name)) {
        String zitat = row.getString("Zitat");
        if (row.getString("png_name").length() != 0) {
          String blobName = row.getString("png_name");
          println("blabname   " + blobName);
          String iStr = blobName.substring(10, 12);
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
        PImage img = createImage(200, 200, RGB);
        Zitat z = new Zitat(1000, zitat, img, 0, coords);
        // z.initialPos(ppt);
        zitate.add(z);
      }
    }
  }

  void findContour(int nP) {
    for (Contour c : contours) {
      if (c.numPoints() == nP) {
        singleContour = c;
      }
    }
  }
}
