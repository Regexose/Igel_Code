/* Augmented Image ist die ganze Skala mit einer Liste von Blobs, die einzeln  //<>//
 addressiert werden können */

class AugmentedImage {
  PImage img;
  ArrayList<Zitat> zitate;
  String name;
  int index;


  AugmentedImage(int idx, PImage img, String name) {
    this.index = idx;
    this.img = img;
    this.name = name;
    zitate = new ArrayList<Zitat>();
    loadZitate();
  }

  void loadZitate() {
    for (TableRow row : bildTexte.rows()) {
      String bildName = row.getString("BildName");
      if (bildName.equals(this.name)) {
        String zitat = row.getString("Zitat");
        String blobName = row.getString("png_name");
        String iStr = blobName.substring(10, 12);
        IntList coords = new IntList();
        String ecken = row.getString("Eckpunkte_yxmin_yx_max");
        for (String c : ecken.split(",")){
          coords.append(int(c));
        }
        
        float angle = row.getFloat("angle_deg");
        int i = int(iStr);
        PImage img = loadImage(pathSingle + blobName);
        Zitat z = new Zitat(i, zitat, img, angle, coords);
        PVector ppt = grid.get(this.index % grid.size());
        z.initialPos(ppt);
        zitate.add(z);
      }
    }
  }
}
