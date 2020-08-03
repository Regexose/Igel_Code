
void buildRythms(ArrayList<ArrayList<Float>> rythms) {
  rythms.add(new ArrayList<Float>(Arrays.asList(16000.0, 4800.0, 2320.0, 4800.0, 2320.0, 7200.0, 312.0,  4400.0, 1000.0, 4400.0, 1000.0, 480.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(16000.0, 3000.0, 1320.0, 3000.0, 1320.0, 3000.0, 2000.0, 4400.0, 2000.0, 4400.0, 840.0, 3280.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(50.0, 10.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(300.0, 400.0)));
}

void getRythm() {
  timedEvents();
  getScaleName();
  if (beatNumber >= newRythms.get(rScale).size()) {
    println("beatNumber set to 0!: " + beatNumber);
    beatNumber = 0;
 }
  if (globalCounter != newglobalCounter) {
    // println("globalCounter: " + globalCounter);
    newglobalCounter = globalCounter;
 }
   // println("scalename timing: " + currentScaleName); 
   scale = scaleMap.get(currentScaleName);
}

void getScaleName() {
  if(minute()%2 == 0) {
    rScale = 0;
    currentScaleName = "PlanscheSinger";
    scaleType = "augmented";
  }  else {
    rScale = 1;
    currentScaleName = "test";
    scaleType = "noText";
    // println("currentScaleName:  " + currentScaleName + "\nweigths: " + (IntList)scaleMap.get(currentScaleName).get(2));
  }
}

void timedEvents() {
  pleaseKnock = (second()>=25 && second() <= 30);
  if (pleaseKnock) {
    rScale = 3;
    currentScaleName = "Klopf";
    scaleType = "message";
    messageTime = true;
  } else {
    messageTime = false;
    scaleType = "augmented";
  }
}

void updateRythms() {
  
}

void updatePause() {
  ArrayList<Float> r_list = newRythms.get(rScale);
  if (minute()%3 == 0) {
  factor = 1.05;
  } else {
    factor = 0.95;
  }
  println("factor  " + factor);
  for (int i=0; i<r_list.size(); i++) {
      float pause = (float)r_list.get(i);
      float newPause = pause * factor;
      // println("new Pause  " + newPause + "for element " + i);
      r_list.set(i, newPause);
   }
   globalCounter = 0;
   printArray("r_list:   " + r_list + "\n ryhtmlist: " + newRythms.get(rScale));
}

void changeRythms() {
}
