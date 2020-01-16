void selectImage (ArrayList<ImageClass> scale, int[] ryt, int beatNum) {
  beatNum = beatNum % ryt.length;
  int beatValue = ryt[beatNum];
  int maxWeight = matchList.max();
  println("beatValue " + beatValue);
  if ((frameCount * 1000/ 25) % beatValue == 0) {
    for(int i=0; i< scale.size(); i++) {
      // println("element " + scale.get(i).name +  "matchingBeat =  " + scale.get(i).matchingBeatValue);
      if (beatNum == 0 && scale.get(i).weight == maxWeight) {
         pic1 = scale.get(i).image;
      } else if (scale.get(i).matchingBeatValue == beatValue){
        pic1 = scale.get(i).image;
      }
     }
    beatNumber += 1;
 
  }
}

void updateWeights(ArrayList<ImageClass> scale) {
  for(int i=0; i< scale.size(); i ++) {
    // println("weights not updated: " + scale.get(i).weight);
    println("weightlist element: " + matchList.get(i)); //<>//
    if (scale.get(i).weight == matchList.min()) {
      scale.get(i).updateWeight(2);
    }
    matchList.set(i, scale.get(i).weight);
    
    // weightList.get(i).set(scale.get(i).weight);
    
  }
}
