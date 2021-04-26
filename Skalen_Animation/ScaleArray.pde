class ScaleArray {
  ArrayList<AugmentedImage> scaleArray;
  PGraphics surface;
  AugmentedImage aI;
  PShape z_shape;
  Rectangle shapeBox;
  String name;
  PImage pic2Show;
  boolean flicker, loaded;

  ScaleArray(String name, String path) {
    this.name = name;
    this.surface = createGraphics(width, height);
    this.loaded = false;
    this.flicker = false;
    this.z_shape = createShape(RECT, 0, 0, 50, 50);
    loadImages(path);
  }

  public void display() {
    imageMode(CENTER);
    image(this.pic2Show, width/2, height/2, width, height);
    shape(this.z_shape, 0, 0);
    strokeWeight(1);
    stroke(0, 255, 0);
    noFill();
    rect(this.shapeBox.x, this.shapeBox.y, this.shapeBox.width, this.shapeBox.height);
  }

  void loadImages(String folderName) {
    // print("arrayType: " + arrayType);
    loadStatus = 0.0;
    currentScaleName = folderName;
    folder = new File(folderName);
    files = folder.listFiles(); // need for absolut path
    fileNames = folder.list();
    scaleArray = new ArrayList<AugmentedImage>();
    // i muss bei 1 anfangen, sonst liest der loop nur das .DS_Store, warum auch immer...
    for (int i=0; i<fileNames.length; i++) {
      if (fileNames[i].toLowerCase().endsWith(".jpg")) {  
        PImage img = loadImage(files[i].toString());
       // println("filename " + fileNames[i]);
        AugmentedImage aI = new AugmentedImage(fileNames[i], img, i);
        this.scaleArray.add(aI);
        currentScaleName = fileNames[i];
        loadStatus += width/(fileNames.length +1);
      }
    }
    println("finished loading  " + folderName);
    loading = false;
    // println("loading? " + loading);
    // this.loaded = true;
  }

  void selectImage(float pause, String tempScaleType) {
    // println(" pause: " + pause + "  scalename: " + tempScaleType);
    if (tempScaleType == "augmented") {
      for (int i=0; i< this.scaleArray.size(); i++) {
        AugmentedImage element = this.scaleArray.get(i);
        this.pic2Show = element.image;
      }
    }
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
      wordSurf.textFont(font, messageSize);
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
      this.surface.textFont(font, 20);
      this.surface.text(text, this.surface.width/2, this.surface.height/2);
      this.surface.endDraw();
    }
  }
}
