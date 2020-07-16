class Scale {
  ArrayList<AugmentedImage> imageArray;
  ArrayList<Message> messageImages;
  PGraphics surface;
  ArrayList<Object> values;
  AugmentedImage aI;
  PShape z_shape;
  String name, arrayType, pic2ShowName;
  PImage noMatch, pic2Show, pic4Flicker, messagePic;
  IntList imageWeights;
  boolean flicker, loaded, augmented;

  Scale(String name, String folderName, String arrayType) {
    this.name = name;
    this.surface = createGraphics(width, height);
    this.arrayType = arrayType;
    this.imageWeights = new IntList();
    loadImages(folderName, this.arrayType);
    this.pic2Show = this.noMatch;
    this.loaded = false;
    this.flicker = false;
    this.augmented = false;
    this.z_shape = createShape(RECT, 0, 0, 50, 50);
    this.pic4Flicker = createImage(width, height, RGB);
  }

  public void display() {
    imageMode(CENTER);
    image(this.pic2Show, width/2, height/2, width, height);
    if (this.augmented) {
      //for (PShape ps : this.aI.shapes) {
      //  shape(ps, 0, 0);
      shape(this.z_shape, 0, 0);
      }
    }  
    //image(this.surface, 0, 0);


  void loadImages(String folderName, String arrayType) {
    loadStatus = 0.0;
    loading = true;
    hasFinished = false;
    currentScaleName = folderName;
    String[] fileNames;
    folder = new File(sketchPath("data/" + folderName));
    files = folder.listFiles(); // need for absolut path
    fileNames = folder.list();
    restFiles = new StringList();
    restFileNames = new StringList();
    if (arrayType == "augmented") {
      imageArray = new ArrayList<AugmentedImage>();
      this.augmented = true;
      // i muss bei 1 anfangen, sonst liest der loop nur das .DS_Store, warum auch immer...
      for (int i=1; i<fileNames.length; i++) {
        if (fileNames[i].toLowerCase().endsWith(".jpg")) {  
          if (fileNames[i].indexOf("Ort_") == -1 ) {
            PImage img = loadImage(files[i].toString());
            AugmentedImage aI = new AugmentedImage(fileNames[i], img, i);
            imageArray.add(aI);
            loadCites(aI);
            this.imageWeights.append(aI.weight);
            loadDurations(aI);
          } else if (fileNames[i].indexOf("Ort_Totale") != -1) {
            PImage img = loadImage(files[i].toString());
            this.noMatch = img;
          }
           else if (fileNames[i].indexOf("Ort_DSC") != -1) {
          //bilder der Orte
            PImage img = loadImage(files[i].toString());
            AugmentedImage aI = new AugmentedImage(fileNames[i], img, i);
            imageArray.add(aI);
           }
 
          loadStatus += width/(fileNames.length +1);
        } else {
          println("else: " +  "i: " + i + "  fileNames[i]:  " + fileNames[i]);
        }
      }
    } else if (arrayType == "simple") {
      messageImages = new ArrayList<Message>();
      for (int i=0; i<fileNames.length; i++) {
        PImage img = loadImage(files[i].toString());
        Message msg = new Message(fileNames[i], img);
        messageImages.add(msg);
      } 
      this.noMatch = createImage(width, height, RGB);
    }
    currentScaleName = this.name;
    println("finished loading  " + folderName);
    this.loaded = true;
  }

  void selectImage(float pause, String tempScaleType) {
    // println(" pause: " + pause + "  type:  " + tempScaleType + "  beatNumber: " + beatNumber);
    if (tempScaleType == "augmented") {
      this.augmented = true;
      IntList tempList = new IntList();
      for (int i=0; i< this.imageArray.size(); i++) {
        AugmentedImage aI = this.imageArray.get(i);
        boolean pauseMatch = (aI.minMatch <= pause && aI.maxMatch >= pause);
        // println("  element weight: " + element.weight + "  weightlist" + this.imageWeights);
        int maxWeight = this.imageWeights.max();
        if (beatNumber == 0  && aI.weight == maxWeight) {
          this.pic2Show = aI.image; 
          this.pic2ShowName = aI.name;
          this.aI = aI;
        } else if (beatNumber > 0 && pauseMatch && aI.weight != maxWeight) {
          tempList.append(aI.index);
        } else if (this.flicker) {
          this.pic2Show = this.pic4Flicker;
          this.flicker = !this.flicker;
        } else if (beatNumber != 0 && !pauseMatch) {
          // println(" else image: " + element.name + "  weight: " + element.weight);
          this.pic2ShowName = aI.name;
          this.pic2Show = this.noMatch;
          this.aI = aI;
        }
      }
      
      if (tempList.size() >= 1) {
        tempList.shuffle();
        for (int t=0; t<this.imageArray.size(); t++) {
          if (this.imageArray.get(t).index == tempList.get(0)) {
            // println("t- element  " + scale.get(t).name + "  element matching:   " + scale.get(t).matchingBeatValue + "  element index:   " + scale.get(t).index);
            this.pic2Show = this.imageArray.get(t).image;
            this.aI = this.imageArray.get(t);
            this.pic2ShowName = this.imageArray.get(t).name;
            this.imageArray.get(t).counter += 1;
          }
        }
        
      }
      // showBiggestShapes(this.aI);
      
    } else if (tempScaleType == "message") {
      this.augmented = false;
      // printArray("messages: " + this.messages + " current Scalename: " + currentScaleName);
      if (this.flicker) {
        this.pic2Show = this.messageImages.get(0).image;
        messageX = width /8;
        this.pic2ShowName = this.messageImages.get(0).name;
      } else {
        this.pic2Show = this.messageImages.get(2).image;
        messageX = width *3/7;
        this.pic2ShowName = this.messageImages.get(2).name;
      }
      // updateSurface(message, messageTime);
      this.flicker = !this.flicker;
    } else {
      selectKlopf(pause);
    }
    // updateSurface(str(knock) + "  " + this.pic2ShowName, false);
    
  }
  
  void selectShape() {
    // jede Shape sollte eine Position abspeichern, wenn möglich auch eine Breite und Höhe
    // so können gezielt shapes wieder abgefragt bzw herausgefiltert werden.
  if (this.augmented && (this.aI.name.indexOf("Ort_DSC") == -1)) {
    // println("158 image name: " + this.aI.name); 
    // printArray("\nshapes: " + scale.aI.shapes);
    int index = int(random(this.aI.shapes.size()));
    this.z_shape = this.aI.shapes.get(index);
    // println("162 vertexCount: " + this.z_shape.getVertexCount()); 

    } else {return;}
}

  
  void updateSurface(String text, boolean msgTime) {

    if (msgTime) {

      String[] words = text.split(" ");
      // println("  x: " + messageX + "  y: " + messageY);
      int index = int(random(words.length));
      String word = words[index];
      messageSize = int(random(50, 100));
      textSize(messageSize);
      float textHeight = textAscent() * 0.8;
      PGraphics wordSurf = createGraphics(int(textWidth(word) * 2), int(textHeight) * 2);
      wordSurf.smooth();
      messageY = this.surface.height/2;

      wordSurf.beginDraw();
      wordSurf.textAlign(CENTER);
      wordSurf.textFont(Arial, messageSize);
      wordSurf.background(200);
      wordSurf.fill(10);
      wordSurf.text(word, wordSurf.width/2, wordSurf.height/2 + 10);
      wordSurf.endDraw();
      this.surface.beginDraw();
      this.surface.clear();
      this.surface.image(wordSurf, messageX, messageY);
      this.surface.endDraw();
    } else {
      this.surface.beginDraw();
      this.surface.textAlign(CENTER);
      this.surface.background(color(245, 66, 233));
      this.surface.textFont(Arial, 20);
      this.surface.text(text, this.surface.width/2, this.surface.height/2);
      this.surface.endDraw();
    }
  }
}
