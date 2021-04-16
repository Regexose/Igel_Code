/* Augmented Image ist die ganze Skala mit einer Liste von Blobs, die einzeln  //<>//
 addressiert werden können */

class AugmentedImage {
  PImage img;
  ArrayList<Zitat> zitate;
  String name;
  int index;
  ArrayList<Contour> blobs;
  OpenCV ocv;
  Contour singleContour;


  AugmentedImage(int idx, PImage img, String name, OpenCV _ocv) {
    this.index = idx;
    this.img = img;
    this.name = name;
    this.ocv = _ocv;
    blobs = new ArrayList<Contour>();
    zitate = new ArrayList<Zitat>();
    makeContours();
    loadZitate();
  }

  void loadZitate() {
    for (TableRow row : bildTexte.rows()) {
      String bildName = row.getString("BildName");
      if (bildName.equals(this.name)) {
        String zitat = row.getString("Zitat");
        String blobName = row.getString("png_name");
        // println(" zitat  " + zitat + "  blobName  " + blobName);
        String iStr = blobName.substring(10, 12);
        IntList coords = new IntList();
        String ecken = row.getString("Eckpunkte_yxmin_yx_max");
        for (String c : ecken.split(",")) {
          coords.append(int(c));
        }
        float angle = row.getFloat("angle_deg");
        int numPoints = row.getInt("numPoints");
        findContour(numPoints);
        singleContour = singleContour.getPolygonApproximation();
        int i = int(iStr);
        // println("angle   " + angle + " i  " + i + "  zitat   " + zitat);
        PImage img = loadImage(pathSingle + blobName);
        Zitat z = new Zitat(i, zitat, img, angle, coords, singleContour);
        PVector ppt = grid.get(this.index % grid.size());
        z.initialPos(ppt);
        zitate.add(z);
      }
    }
  }
  void makeContours() {
    ocv.gray();
    ocv.threshold(120);
    ArrayList<Contour> allBlobs = ocv.findContours(true, true);    
    for (Contour contour : allBlobs) {
      if (contour.numPoints() > 280 && contour.numPoints() < 11000 ) {
        blobs.add(contour);
      }
    }
  }

  void relateContours() {
    for (Contour c : blobs) {
      for (Zitat z : zitate) {
        if (c.numPoints() == z.contour.numPoints()) {
          // ordne die contour zu
          // vielleicht lieber augmente contours mit positionen und namen machen
        }
      }
    }
  }

  void findContour(int nP) {
    for (Contour c : blobs) {
      if (c.numPoints() == nP) {
        singleContour = c;
      }
    }
  }
}
