class AugmentedImage {
  String type, name;
  PImage image, dst;
  int index, weight, minMatch, maxMatch, counter;
  ArrayList<String> cites = new ArrayList<String>();
  ArrayList<Contour> contours;
  HashMap<String, PShape> shapeMap;
  HashMap<String, Rectangle> shapeBox;
  boolean hasText, hasShapes;

  AugmentedImage(String name, PImage image, int index, boolean hasShapes) {
    this.name = name;
    this.image = image;
    this.index = index;
    this.hasShapes = hasShapes;
    this.weight = 20;
    this.minMatch = 100;
    this.maxMatch = 4000;
    this.counter = 0;
    this.contours = makeContours(name, image);
    this.dst = dstMaker(image);
    makeShapes();
  }

  void makeShapes() {
    // jede Shape sollte eine Position abspeichern, wenn möglich auch eine Breite und Höhe
    // so können gezielt shapes wieder abgefragt bzw herausgefiltert werden.
    // am besten eine HashMap leicht zu adressierenden shapes
    // this.shapes = new ArrayList<PShape>();
    int i = 0;
    // exclude fotos
    if (this.name.indexOf("Ort_") == -1) {
      this.shapeMap = new HashMap<String, PShape>(this.contours.size());
      this.shapeBox = new HashMap<String, Rectangle>(this.contours.size());
        for (Contour contour : this.contours) {
          PShape z_shape = createShape();
          z_shape.beginShape();
          noStroke();
          contour.setPolygonApproximationFactor(0.5);
          Rectangle box = contour.getBoundingBox();
          //if ( box.getWidth() > 4) {
          this.shapeBox.put(str(i) + "_" + this.name, box);
          //}
          for (PVector p : contour.getPolygonApproximation().getPoints())
            z_shape.vertex(p.x, p.y);
          z_shape.endShape(CLOSE);
          z_shape.setFill(color(random(255), random(255), random(255)));
          z_shape.setName(str(i) + "_" + this.name);
          // add only shapes with more than 6 vertices
          // println("vertCount: " + z_shape.getVertexCount());
          if (z_shape.getVertexCount() > 6) {
            this.shapeMap.put(str(i) + "_" + this.name, z_shape);
          }
          i++;
          
        }
      }
      println("name: " + this.name + "    contours: " + this.contours.size());
  }

void setHasText(boolean has) {
  this.hasText = has;
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
  // println("matching iC " + this.name + " with " + maxVal + " maxVal");
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
