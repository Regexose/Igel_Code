class AugmentedImage {
  String type, name;
  PImage image, dst;
  int index, weight, minMatch, maxMatch, counter;
  ArrayList<String> cites = new ArrayList<String>();
  ArrayList<Contour> contours;
  ArrayList<PShape> shapes;

  AugmentedImage(String name, PImage image, int index) {
    this.name = name;
    this.image = image;
    this.index = index;
    this.weight = 0;
    this.minMatch = 0;
    this.maxMatch = 100;
    this.counter = 0;
    this.contours = makeContours(name, image);
    this.dst = dstMaker(image);
    makeShapes();
  }

  void makeShapes() {
    this.shapes = new ArrayList<PShape>();
    int i = 0;
    // exclude fotos
    if (name.indexOf("Ort_DSC") == -1) {
        for (Contour contour : this.contours) {
          PShape z_shape = createShape();
          
          //println("31 name  " + this.name + "   points: " + points.size());
          // ZitatShape z = new ZitatShape(str(i) + "_" + this.name, contour);
          z_shape.beginShape();
          noStroke();
          contour.setPolygonApproximationFactor(1.0);
          for (PVector p : contour.getPolygonApproximation().getPoints()) 
            z_shape.vertex(p.x, p.y);
          z_shape.endShape(CLOSE);
          z_shape.setFill(color(random(255), random(255), random(255)));
          z_shape.setName(str(i) + "_" + this.name);
          if (z_shape.getVertexCount() > 6) {
            this.shapes.add(z_shape);
          }
          i++;
        }
      }
  printArray("38 name: " + this.name + "\nshapes: " + this.shapes.size());
}

void updateWeight(int value) {
  this.weight += value;
  // println("updated aI: " + this.name + "  to: " + this.weight);
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
  String name, message;
  PImage image, dst;

  Message(String name, PImage image) {
    this.name = name;
    this.image = image;
    this.dst = dstMaker(image);
  }
}


void selectKlopf(float pause) {
  getScaleName();
  scale = scaleMap.get(currentScaleName);
  // println("   scalename  " + currentScaleName + "  array size: " + scale.imageArray);
  int index = int(pause % scale.imageArray.size());
  index = int(random(index, scale.imageArray.size()));
  println("image name: " + scale.imageArray.get(index).name);
  scale.pic2Show = scale.imageArray.get(index).image;
  scale.pic2ShowName = scale.imageArray.get(index).name;
}

void loadCites(AugmentedImage augImage) {
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
}

void loadDurations (AugmentedImage aI) {
  for (TableRow row : durationMap.rows()) {
    int min = row.getInt("min");
    int max = row.getInt("max");
    int duration_min = row.getInt("min_duration");
    int duration_max = row.getInt("max_duration");

    if (aI.cites.size() >= min && aI.cites.size() <= max) {
      aI.mapBeatValue(duration_min, duration_max);
    }
  }
}
