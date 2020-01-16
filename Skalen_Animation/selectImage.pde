void selectImage (ArrayList<ImageClass> scale, int fr, int[] ryt) {
   if (counter >= ryt.length) {counter  = 0; }
   float element = ryt[counter];
   // printArray("weightlist: " + weightList);
   int max_weight = weightList.max();
   if ((fr*100) % element == 0) {
     println("max:  " + max_weight + "  weightlist: " + weightList);
      for(int i=0; i< scale.size(); i++) {
        println("element " + scale.get(i).name +  " =  " + scale.get(i).weight);
        if (scale.get(i).weight == max_weight) {
             picIndex = scale.get(i).index;
             scale.get(i).weight = 0;
             println("new weight of:  " + scale.get(i).name + "  is: " + scale.get(i).weight);
             updateWeights(scale);
        counter += 1;
        // updateWeights(scale);
        }
      }
    }
}

void updateWeights(ArrayList<ImageClass> scale) {
  for(int i=0; i< scale.size(); i ++) {
    // println("weights not updated: " + scale.get(i).weight);
    println("weightlist element: " + weightList.get(i)); //<>//
    if (scale.get(i).weight == weightList.min()) {
      scale.get(i).updateWeight(2);
    }
    weightList.set(i, scale.get(i).weight);
    
    // weightList.get(i).set(scale.get(i).weight);
    
  }
}
