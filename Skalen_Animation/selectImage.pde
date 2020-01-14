void selectImage (ArrayList<ImageClass> scale, int fr, int[] ryt) {
  /* 1. an welcher position im Rhythmus bin ich? find r_pos
  2. index = BildObj.r_pos
  3.  bild[index] = */ 
   if (counter >= ryt.length) {counter  = 0; }
   float element = ryt[counter];
   if ((fr*100) % element == 0) {
      int max_weight = max(weights);
      for(int i=0; i< scale.size(); i++) {
        if (scale.get(i).weight == max_weight) {
             picIndex = scale.get(i).index;
             scale.get(i).weight = 0;
        scale.get(int(random(scale.size()))).updateWeight(2);
        counter += 1;
        updateWeights(scale);
        }
      }
    }
}

void updateWeights(ArrayList<ImageClass> scale) {
  for(int i=0; i< weights.length; i ++) {
    weights[i] = scale.get(i).weight;
    // println("weights updated: " + weights);
  }
}
