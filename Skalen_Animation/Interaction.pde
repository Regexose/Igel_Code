void keyReleased() {
  int xStep = 10;
  int yStep = 10;
  if (key == CODED) {
    stopMove = false;
    if (keyCode == LEFT) {
      moveX = xStep;
      moveY = 0;
    } else if (keyCode == RIGHT) {
      moveX = -xStep;
      moveY = 0;
    } else if (keyCode == UP) {
      moveX = 0;
      moveY = yStep;
    } else if (keyCode == DOWN) {
      moveX = 0;
      moveY = -yStep;
    }
  } else {
    if (key == 'n') {
      picIndex ++;
      moveX = 0;
      moveY = 0;
    }
    if (key == 'p') {
      if (picIndex > 0) {
        picIndex --;
      } else {
        picIndex = scales.scaleArray.size();
      }
      moveX = 0;
      moveY = 0;
    }

    if (key == ' ') {
      stopMove = true;
      moveX = 0;
      moveY = 0;
    } 
    if (key == 's') {
      stopMove = false;
      aI.scaleFactor += 0.04;
      for (Zitat z : aI.zitate) {
        z.scale += 0.06;
      }
    }

    if (key == 'a') {
      stopMove = false;
      aI.scaleFactor -= 0.1 ;
      for (Zitat z : aI.zitate) {
        z.scale -= 0.06;
      }
    }
    if (key == 'r') {
      stopMove = false;
      aI.scaleFactor = 1.0 ;
      aI.position = new PVector(0, 0);
    }

    if (key == 'o') {
      aI.rePosition(new PVector(-mouseX, -mouseY));
    }
    if (key == 'i') {
      aI.rePosition(new PVector(-width/3, -height));
    }
    if (key == 'z') {
      showZ = !showZ;
    }
    if (key == 'm') {
      mFollow = !mFollow;
    }
  }
}
