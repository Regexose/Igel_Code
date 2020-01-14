void selectImage (ArrayList<ImageClass> scale, int fr, int[] ryt) {
   if (counter >= ryt.length) {counter  = 0; }
   float element = ryt[counter];
   printArray("weightlist: " + weightList);
   int max_weight = weightList.max();
   if ((fr*100) % element == 0) {
      for(int i=0; i< scale.size(); i++) {
        if (scale.get(i).weight == max_weight) {
             picIndex = scale.get(i).index;
             scale.get(i).weight = 0;
        scale.get(weightList.min()).updateWeight(2);
        counter += 1;
        // updateWeights(scale);
        }
      }
    }
}

void updateWeights(ArrayList<ImageClass> scale) {
  for(int i=0; i< weightList.size(); i ++) {
    // weightList.get(i).set(scale.get(i).weight);
    // println("weights updated: " + weights);
  }
}
