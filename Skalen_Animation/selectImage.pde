void selectImage (ArrayList<ImageClass> scale, int[] ryt, int beatNum) {
  beatNum = beatNum % ryt.length;
  int beatValue = ryt[beatNum];
  int maxWeight = matchList.max();
  IntList tempList = new IntList();
  if ((frameCount * 1000/ 25) % beatValue == 0) {
    println("beatNum: " + beatNum);
    for(int i=0; i< scale.size(); i++) {
      ImageClass element = scale.get(i);
      // println("element " + element.name +  "matchingBeat =  " + element.matchingBeatValue);
      if (beatNum == 0 && element.weight == maxWeight) {
         pic1 = element.image;
      } else if (element.matchingBeatValue == beatValue){
        println("element  " + element.name);
        tempList.append(element.index); //<>//
        if (tempList.size() > 1) {
          for (int t=0; t<tempList.size(); t++) {
            if (element.index == tempList.get(int(random(tempList.size())))) {
              println("element: " +element.name + "  from templist; " + tempList);
              pic1 = element.image;
              element.counter += 1;
              }
          }
        } else {
        pic1 = element.image;
        element.counter += 1;
       }
    }
   }
  }
  beatNumber += 1;
}
