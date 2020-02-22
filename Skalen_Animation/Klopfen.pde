class Klopfen {
  Minim minim;
  AudioInput in;
  FFT fft;
  PGraphics audioIn;
  float pause, previousTime;
  FloatList pauses = new FloatList();

  Klopfen(Minim minim) {
    this.in = minim.getLineIn();
    this.fft = new FFT(this.in.bufferSize(), 48000);
    this.audioIn = createGraphics(width, height/10);
    this.audioIn.smooth();
    this.previousTime = 0;
  }
  
  void analyseInput() {
    this.fft.forward(this.in.mix);
    this.audioIn.beginDraw();
    this.audioIn.textFont(Arial, 50);
    this.audioIn.textAlign(CENTER);
    this.audioIn.clear();
    if (this.fft.getBand(3) > 1.5) {
      println("\nindex to freq(3): " + this.fft.indexToFreq(3) + " volume: " + this.fft.getBand(3));
      knock = true;
      float elapsedTime = millis() - startTime;
      this.pause = elapsedTime - this.previousTime;
      print("\nthis.pause:  " + this.pause);
      scale.selectImage(this.pause, "augmented");
      this.previousTime = elapsedTime;
      
      // this.audioIn.text("Klopf Klopf", this.audioIn.width/2, this.audioIn.height/2);
      }
    for(int i = 0; i < fft.specSize(); i++) {
    // draw the line for frequency band i, scaling it up a bit so we can see it
      this.audioIn.beginDraw();
      this.audioIn.stroke(255);
      this.audioIn.line( i, this.audioIn.height, i, this.audioIn.height - fft.getBand(i)*5 );
      this.audioIn.endDraw();
      audio = this.audioIn;
    }
    
  }
}
