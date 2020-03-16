
void buildRythms(ArrayList<ArrayList<Float>> rythms) {
  rythms.add(new ArrayList<Float>(Arrays.asList(4000.0, 1202.0, 580.0, 1202.0, 580.0, 1800.0, 78.0,  1100.0, 250.0, 1100.0, 250.0, 120.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(4000.0, 750.0, 330.0, 750.0, 330.0, 750.0, 500.0, 1100.0, 500.0, 1100.0, 210.0, 820.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(50.0, 10.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(300.0, 400.0)));
}

void getRythm() {
  getScaleName();
  timedEvents();
  if (beatNumber >= newRythms.get(rScale).size()) {
    println("beatNumber set to 0!: " + beatNumber);
    beatNumber = 0;
 }
  if (globalCounter != newglobalCounter) {
    println("globalCounter: " + globalCounter);
    newglobalCounter = globalCounter;
 }
   println("scalename timing: " + currentScaleName); 
   scale = scaleMap.get(currentScaleName);
}

void getScaleName() {
  if(minute()%2 == 0) {
    rScale = 0;
    currentScaleName = "PlanscheSinger";
  }  else {
    rScale = 1;
    currentScaleName = "PlanscheWeyde";
    // println("currentScaleName:  " + currentScaleName + "\nweigths: " + (IntList)scaleMap.get(currentScaleName).get(2));
  }
}

void timedEvents() {
  pleaseKnock = (second()>=25 && second() <= 45);
  // flicker3min = (minute()%3 ==0 && (second()>=15 && second() <= 18));
  // flicker7min = (minute()% 7 == 0 &&  (second()>=49 && second() <= 54));
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
