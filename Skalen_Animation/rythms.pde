
void buildRythms(ArrayList rythms) {
  rythms.add(new ArrayList<Float>(Arrays.asList(4000.0, 1202.0, 580.0, 1202.0, 580.0, 1800.0, 78.0,  1100.0, 250.0, 1100.0, 250.0, 120.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(4000.0, 750.0, 330.0, 750.0, 330.0, 750.0, 500.0, 1100.0, 500.0, 1100.0, 210.0, 820.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(50.0, 10.0)));
  rythms.add(new ArrayList<Float>(Arrays.asList(300.0, 400.0)));
}

void getRythm() {
  if(minute()%2 == 0) {
    rScale = 0;
    currentScaleName = "singer";
  }  else {
    rScale = 1;
    currentScaleName = "weyde";
    // println("currentScaleName:  " + currentScaleName + "\nweigths: " + (IntList)scaleMap.get(currentScaleName).get(2));
  }
  timedEvents();
  if (beatNumber >= newRythms.get(rScale).size()) {
    println("beatNumber set to 0!: " + beatNumber);
    beatNumber = 0;
 }
  if (globalCounter != newglobalCounter) {
    println("globalCounter: " + globalCounter);
    newglobalCounter = globalCounter;
 }
   scale = scaleMap.get(currentScaleName);
   noMatch = scale.noMatch;
}

void timedEvents() {
  flicker30sec = (second()>=30 && second() <= 35);
  flicker3min = (minute()%3 ==0 && (second()>=15 && second() <= 18));
  flicker7min = (minute()% 7 == 0 &&  (second()>=49 && second() <= 54));
  if (flicker3min || flicker7min) {
    rScale = 2;
    scale.flicker = true;
  } else if (flicker30sec) {
    rScale = 3;
    currentScaleName = "klopf";
    message = true;
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
