class ImageClass {
  PImage image;
  String name, category;
  int index,  weight, matchingBeatValue, counter;
  ArrayList<String> cites = new ArrayList<String>();
  
  ImageClass(int index, PImage image, String name) {
    this.index = index;
    this.image = image;
    this.name = name;
    category = null;
    this.weight = 0;
    this.matchingBeatValue = 0;
    this.counter = 1;
  }
  
  void updateWeight(int value) {
    this.weight += value;
    // println("updated ic: " + this.index + "  to: " + this.weight);
  }
  void textAcquire(String cite) {
      this.cites.add(cite);
  }
  void mapBeatValue(int value) {
    this.matchingBeatValue =  value;
    println("matching iC " + this.name + " with " + value + " value");
  }
  
}

void loadCitesAndRythms(ImageClass iC) {
  // println("checking:    " +iC.name); 
  for (TableRow row : bildTexte.rows()) {
    String bildName = row.getString("BildName");
     if (bildName.equals(iC.name) == true) {
      String quote = row.getString("Zitat");
      // println("bildName:   " + bildName + "   iC:image:   " + iC.name + "\n cite: " + quote);
      iC.textAcquire(quote);
    }
  }
  iC.updateWeight(iC.cites.size());
  weightList.append(iC.cites.size());
  
  for(TableRow row : durationMap.rows()) {
    int min = row.getInt("min");
    int max = row.getInt("max");
    int duration = row.getInt("duration");
    if (iC.cites.size() >= min && iC.cites.size() <= max) {
      iC.mapBeatValue(duration);
    }
  }
  matchList.append(iC.matchingBeatValue);
  // println("matchlist: " + matchList);

}

PImage[] loadImages(File folder) {
  File[] fileList = folder.listFiles();
  PImage[] imgArray = new PImage[fileList.length];
  for (int i=0; i<fileList.length; i++) {
    // String path = fileList[i].getAbsolutePath();
    String fileName = fileList[i].toString();
    if(!fileName.endsWith(".DS_Store")) {
    PImage img = loadImage(fileList[i].toString());
    imgArray[i] = img ;
    }
  }
  return imgArray;
}

void buildClasses(ArrayList<ImageClass> imageList, PImage[] images, String[] names) {
  for (int i=0; i<images.length; i++) {
    ImageClass iC = new ImageClass(i, images[i], names[i]);
    imageList.add(iC);
    loadCitesAndRythms(iC);
  }
}
