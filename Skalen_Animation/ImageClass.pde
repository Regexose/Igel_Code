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
    this.counter = 0;
  }
  
  void updateWeight(int value) {
    this.weight += value;
    // println("updated ic: " + this.name + "  to: " + this.weight);
  }
  void textAcquire(String cite) {
      this.cites.add(cite);
  }
  void mapBeatValue(int value) {
    this.matchingBeatValue =  value;
    // println("matching iC " + this.name + " with " + value + " value");
  }
  
}

IntList loadCites(ImageClass iC, IntList weightList) {
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
  return weightList;
}
  
IntList loadRythms (ImageClass iC, IntList matchList) {
  for(TableRow row : durationMap.rows()) {
    int min = row.getInt("min");
    int max = row.getInt("max");
    int duration = row.getInt("duration");
    if (iC.cites.size() >= min && iC.cites.size() <= max) {
      iC.mapBeatValue(duration);
    }
  }
  matchList.append(iC.matchingBeatValue);
  // printArray("matchlist :   " + matchList);

  return matchList;
}

PImage[] loadImages(File folder) {
  File[] fileList = folder.listFiles();
  PImage[] imgArray = new PImage[fileList.length];
  // IntList ortBilder = new IntList();
  // PImage[] ortArray= new PImage[ortBilder.size()];
  for (int i=0; i<fileList.length; i++) {
    // String path = fileList[i].getAbsolutePath();
    String fileName = fileList[i].toString();
    if(!fileName.endsWith(".DS_Store") && fileName.indexOf("Ort_") == -1) {
      // println( fileName + "  indexOf??   " + (fileName.indexOf("Ort_") == -1));
      PImage img = loadImage(fileList[i].toString());
      imgArray[i] = img ;
    } else if (fileName.indexOf("Ort_Totale") != -1) {
      PImage img = loadImage(fileList[i].toString());
      noMatch = img;
    }
  }
  return imgArray;
}

ArrayList<ImageClass> buildClass(String listName, ArrayList<ImageClass> iC_Array, PImage[] images, String[] names) {
  for (int i=0; i<images.length; i++) {
    if (names[i].indexOf("Ort_") == -1) {
      ImageClass iC = new ImageClass(i, images[i], names[i]);
      iC_Array.add(iC);
    }
  }
  return iC_Array;
}
