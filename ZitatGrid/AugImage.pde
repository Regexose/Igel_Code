class AugmentedImage {
  PImage img;
  String name, zitat;
  int index;
  float angle;

  AugmentedImage(int idx, PImage img, String z, String name, float angle) {
    this.index = idx;
    this.img = img;
    this.zitat = z;
    this.angle = angle;
    this.name = name;
  }
}
