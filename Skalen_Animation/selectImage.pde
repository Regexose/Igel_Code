void selectImage (ArrayList<ImageClass> scale, int[] ryt) {
  
  int beatValue = ryt[beatNumber];
  int maxWeight = weightList.max();
  IntList tempList = new IntList();
  if ((frameCount * 2000/ 25) % beatValue == 0) {
    println("beatNum: " + beatNumber + " beatValue: " + beatValue + "  picindex:  " + picIndex);
    for(int i=0; i< scale.size(); i++) {
      ImageClass element = scale.get(i);
      // boolean contains = IntStream.of(ryt).anyMatch(x -> x == beatValue);
      if (beatNumber == 0 && element.weight == maxWeight) {
        pic1 = element.image; 
        picIndex = i;
        println("element " + element.name +  ", pic1 =  " + pic1 + "  i:   " + i);
      } else if (element.matchingBeatValue == beatValue){
        println("element  " + element.name + "  element weight:   " + element.weight);
        tempList.append(element.index); //<>//
        if (tempList.size() > 1) {
          for (int t=0; t<tempList.size(); t++) {
            if (element.index == tempList.get(int(random(tempList.size())))) {
              // println("element: " +element.name + "  from templist; " + tempList);
              pic1 = element.image;
              picIndex = i;
              element.counter += 1;
              }
          }
        } else if (contains(ryt, element.matchingBeatValue) == false) {
          pic1 = pic2;
        } else {
        pic1 = element.image;
        element.counter += 1;
       }
    }
   }
   beatNumber += 1;
   beatNumber = beatNumber % ryt.length;
  }
  
}

boolean contains(int[] arr, int item) {
      int index = Arrays.binarySearch(arr, item);
      return index >= 0;
}
