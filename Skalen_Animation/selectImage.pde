void selectImage (ArrayList<ImageClass> scale, ArrayList<Integer> rytArray, PImage noMatch) {
  int beatValue = rytArray.get(beatNumber);
  int maxWeight = weightList.max();
  IntList tempList = new IntList();

  println("beatNum: " + beatNumber + " beatValue: " + beatValue + " weightlist:  " + weightList + " max weight " + maxWeight);
  for(int i=0; i< scale.size(); i++) {
    
    ImageClass element = scale.get(i);
    println("element " + element.name  + "  I: " + i + "  element.weight   " + element.weight);
    if (beatNumber == 0  && element.weight == maxWeight) {
      pic1 = element.image; 
      picIndex = i;
      println("element " + element.name  + "  I: " + i + "  element.weight   " + (pic1 == element.image)); //<>//
    } else if (beatNumber > 0 && element.matchingBeatValue == beatValue && element.weight != maxWeight){
      tempList.append(element.index); //<>//
    } else if (beatNumber > 0 && !rytArray.contains(element.matchingBeatValue)) {
        pic1 = noMatch;
      } 
    }
   
    if(tempList.size() >= 1) {
       tempList.shuffle();
       // printArray("tempList  " + tempList);
       for (int t=0; t<scale.size(); t++) {
         if(scale.get(t).index == tempList.get(0)) {
            println("t- element  " + scale.get(t).name + "  element matching:   " + scale.get(t).matchingBeatValue + "  element index:   " + scale.get(t).index);
            pic1 = scale.get(t).image;
            scale.get(t).counter += 1;
            picIndex = t;
         } 
       }
    }
 
}
