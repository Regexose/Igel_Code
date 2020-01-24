void selectImage (String scaleName, ArrayList<ImageClass> scale, ArrayList<Float> rytArray, PImage noMatch) {
  // println("hashmap weightlist:   " + counterLists + "   scaleName:  " + scaleName);
  float beatValue = rytArray.get(beatNumber);
  IntList wL = (IntList)scaleMap.get(scaleName).get(2);
  int maxWeight = wL.max();
  IntList tempList = new IntList();

  // println("beatNum: " + beatNumber + " beatValue: " + beatValue + "\nweightlist:  " + wL + " max weight " + maxWeight + "\nscaleName:   " + scaleName);
  for(int i=0; i< scale.size(); i++) {
    ImageClass element = scale.get(i);
    if (beatNumber == 0  && element.weight == maxWeight) {
      pic1 = element.image; 
      picIndex = i;
      // println("element " + element.name  + "  I: " + i + "  element.weight   " + (pic1 == element.image)); //<>// //<>//
    } else if (beatNumber > 0 && (element.minMatch <= beatValue && element.maxMatch >= beatValue) && element.weight != maxWeight){ //<>//
      tempList.append(element.index); //<>// //<>//
    } else if (beatNumber > 0 && !rytArray.contains(element.minMatch)) { //<>//
        pic1 = noMatch;
      } else if (beatValue <= 0.0 && beatValue <= 25.0) {
        picWhite = createImage(width, height, RGB);
        pic1 = picWhite;
      }
        
    }
   
    if(tempList.size() >= 1) {
       tempList.shuffle();
       // printArray("tempList  " + tempList);
       for (int t=0; t<scale.size(); t++) {
         if(scale.get(t).index == tempList.get(0)) {
            // println("t- element  " + scale.get(t).name + "  element matching:   " + scale.get(t).matchingBeatValue + "  element index:   " + scale.get(t).index);
            pic1 = scale.get(t).image;
            scale.get(t).counter += 1;
            picIndex = t;
         } 
       }
    }
 
}
