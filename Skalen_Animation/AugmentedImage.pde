class AugmentedImage {
  String type, name;
  PImage image;
  int index, weight, minMatch, maxMatch, counter;
  ArrayList<String> cites = new ArrayList<String>();
  ArrayList<Contour> contours;
  ArrayList<ZitatShape> shapes;

  AugmentedImage(String name, PImage image, int index) {
    this.name = name;
    this.image = image;
    this.index = index;
    this.weight = 0;
    this.minMatch = 0;
    this.maxMatch = 100;
    this.counter = 0;
    this.contours = makeContours(this.name, this.image);
    makeShape();
  }

  void makeShape() {
    this.shapes = new ArrayList<ZitatShape>();
    int i = 0;
    for (Contour contour : this.contours) {
      ArrayList<PVector> points = contour.getPolygonApproximation().getPoints();
      if (points.size() > 20) {
        ZitatShape z = new ZitatShape(str(i), contour);
        // println("z vertices: " + z.z_shape.getVertexCount());
        this.shapes.add(z);
        i++;
     }
    }
    println("name: " + this.name + "\ncontours: " + this.contours.size() + "\nshapes: " + this.shapes.size());
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

class ZitatShape {
  PShape z_shape;
  String name;
 
  ZitatShape(String name, Contour contour) {
    this.name = name;
    this.z_shape = makeShape(contour);
  }

  PShape makeShape(Contour contour) {
    color fill_color = color(random(250), random(250), random(250));
    PShape z_shape = createShape();
    contour.setPolygonApproximationFactor(3.0);
    z_shape.beginShape();
    for (PVector p : contour.getPolygonApproximation().getPoints()) {
       // z_shape.fill(fill_color);
       z_shape.noStroke();
       z_shape.vertex(p.x, p.y);
        // println("p.x " + p.x + "  p.y: " + p.y);
      }
    z_shape.endShape(CLOSE);
    z_shape.setFill(fill_color);
    // println("z_Shape vertex Count: " + z_shape.getVertexCount());
    return z_shape;
  }
}

class Message {
  String name, message;
  PImage image;

  Message(String name, PImage image) {
    this.name = name;
    this.image = image;
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
