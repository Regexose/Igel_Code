class Scale {
  ArrayList<AugmentedImage> siteImages;
  ArrayList<Message> messages;
  ArrayList<Object> values;
  String name, arrayType;
  PImage noMatch, pic2Show, pic4Flicker;
  IntList weightList;
  boolean flicker;
  
  Scale(String name, String folderName, String arrayType){
    this.name = name;
    this.arrayType = arrayType;
    loadImages(folderName, this.arrayType);
    this.flicker = false;
    this.pic4Flicker = createImage(width, height, RGB);
  }
  
  public void display(float pause) {
    selectImage(pause, this.arrayType);
    // println("selected image: " + this.pic2Show);
    imageMode(CENTER);
    image(this.pic2Show, width/2, height/2, width, height);
  }
  
  private void loadImages(String folderName, String arrayType) {
    String [] fileNames;
    folder = new File(sketchPath("data/"+folderName));
    files = folder.listFiles(); // need for absolut path
    fileNames = folder.list();
    if (arrayType == "augmented") {
      siteImages = new ArrayList<AugmentedImage>();
      for (int i=0; i<fileNames.length; i++) {
        if (fileNames[i].indexOf("Ort_") == -1) {
          PImage img = loadImage(files[i].toString());
          AugmentedImage aI = new AugmentedImage(fileNames[i], img, i);
          siteImages.add(aI);
          this.weightList = loadCites(aI);
          loadRythms(aI);
        } else if (fileNames[i].indexOf("Ort_Totale") != -1) {
          PImage img = loadImage(files[i].toString());
          this.noMatch = img;
          }  
        }
    } else if (arrayType == "message") {
      messages = new ArrayList<Message>();
      for (int i=0; i<fileNames.length; i++) {
         //println("36 filename " + fileNames[i] + " i " + i);
         PImage img = loadImage(files[i].toString());
         Message msg = new Message(fileNames[i], img);
         messages.add(msg);
         } 
      }
  }
  
  void selectImage(float pause, String scaleType) {
    // println("pause: " + pause + "  type:  " + scaleType);
    if (scaleType == "augmented") {
      int maxWeight = this.weightList.max();
      IntList tempList = new IntList();
      for(int i=0; i< this.siteImages.size(); i++) {
        AugmentedImage element = siteImages.get(i);
        if (beatNumber == 0  && element.weight == maxWeight) {
          this.pic2Show = element.image; 
          picIndex = i;
        } else if (beatNumber > 0 && (element.minMatch <= pause && element.maxMatch >= pause) && element.weight != maxWeight){
          tempList.append(element.index);
        } else if (this.flicker) {
            this.pic2Show = this.pic4Flicker;
            this.flicker = !this.flicker;
          } else {
            this.pic2Show = this.noMatch;
          }
        }
        if(tempList.size() >= 1) {
           tempList.shuffle();
           // printArray("tempList  " + tempList);
           for (int t=0; t<siteImages.size(); t++) {
             if(siteImages.get(t).index == tempList.get(0)) {
                // println("t- element  " + scale.get(t).name + "  element matching:   " + scale.get(t).matchingBeatValue + "  element index:   " + scale.get(t).index);
                this.pic2Show = siteImages.get(t).image;
                siteImages.get(t).counter += 1;
                picIndex = t;
             } 
           }
        }
        } else if (arrayType == "message") {
          if (this.flicker) {
            this.pic2Show = this.messages.get(1).image;
          } else {
            this.pic2Show = this.messages.get(0).image;
          }
          this.flicker = !this.flicker;
      }
    }
}

class AugmentedImage {
  String category, name;
  PImage image;
  int index, weight, minMatch, maxMatch, counter;
  ArrayList<String> cites = new ArrayList<String>();
  
  AugmentedImage(String name, PImage image, int index) {
    this.name = name;
    this.image = image;
    this.index = index;
    category = null;
    this.weight = 0;
    this.minMatch = 0;
    this.maxMatch = 100;
    this.counter = 0;
  }
  
  void updateWeight(int value) {
    this.weight += value;
    // println("updated ic: " + this.name + "  to: " + this.weight);
  }
  void textAcquire(String cite) {
      this.cites.add(cite);
  }
  void mapBeatValue(int minVal, int maxVal) {
    this.minMatch =  minVal;
    this.maxMatch =  maxVal;
    // println("matching iC " + this.name + " with " + value + " value");
  }
}

class Message {
  String name;
  PImage image;
  PGraphics surface;
  
  Message(String name, PImage image) {
    this.name = name;
    this.image = image;
  }
}

IntList loadCites(AugmentedImage augImage) {
  IntList weightList = new IntList();
  // println("checking:    " +augImage.name); 
  for (TableRow row : bildTexte.rows()) {
    String bildName = row.getString("BildName");
     if (bildName.equals(augImage.name) == true) {
      String quote = row.getString("Zitat");
      // println("bildName:   " + bildName + "   iC:image:   " + augImage.name + "\n cite: " + quote);
      augImage.textAcquire(quote);
    }
  }
  augImage.updateWeight(augImage.cites.size());
  weightList.append(augImage.cites.size());
  return weightList;
}
  
void loadRythms (AugmentedImage aI) {
  for(TableRow row : durationMap.rows()) {
    int min = row.getInt("min");
    int max = row.getInt("max");
    int duration_min = row.getInt("min_duration");
    int duration_max = row.getInt("max_duration");

    if (aI.cites.size() >= min && aI.cites.size() <= max) {
      aI.mapBeatValue(duration_min, duration_max);
    }
  }
}
