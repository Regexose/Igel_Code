void loadScales(String folderName) {
  weightList = new IntList();
  // matchList = new IntList();
  scaleValues = new ArrayList();
  //counterLists.put(folderName + "Weight", weightList); 
  //counterLists.put(folderName + "Match", matchList);
  folder = new File(sketchPath("data/"+folderName));
  imgArray = loadImages(folder);
  fileNames = folder.list();
  imageClassArray = new ArrayList<ImageClass>();
  ArrayList<ImageClass> iC_Array = buildClass(folderName, imageClassArray, imgArray, fileNames);
  
  for (int i=0; i<iC_Array.size(); i++) {
      weightList = loadCites(iC_Array.get(i), weightList);
      loadRythms(iC_Array.get(i));
  }
  scaleValues.add(iC_Array);
  scaleValues.add(noMatch);
  scaleValues.add(weightList);
  // scaleValues.add(matchList);
  scaleMap.put(folderName, scaleValues);
  // println("HashMap.get(2):   " + folderName + "   weights: " + scaleMap.get(folderName).get(2));
  // println("HashMap.get(2):   " + folderName + "   matches: " + scaleMap.get(folderName).get(3));
}
