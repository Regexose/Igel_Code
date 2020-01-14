class ImageClass {
  PImage image;
  String name, category;
  int index,  weight;
  ArrayList<String> cites = new ArrayList<String>();
  
  ImageClass(int index, PImage image, String name, int tempWeight) {
    this.index = index;
    this.image = image;
    this.name = name;
    category = null;
    this.weight = tempWeight;
    this.cites = cites;
  }
  void updateWeight(int value) {
    this.weight += value;
    // println("updated ic: " + this.index + "  to: " + this.weight);
  }
  void textAcquire(String cite) {
    this.cites.add(cite);
  }
}
