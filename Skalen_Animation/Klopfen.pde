class Klopfen {
  Minim minim;
  AudioInput in;
  FFT fft;
  PGraphics audioIn;
  float pause;
  FloatList pauses = new FloatList();
  
  Klopfen(Minim minim) {
    this.in = minim.getLineIn();
    this.fft = new FFT(this.in.bufferSize(), 48000);
    this.audioIn = createGraphics(width, height/10);
    this.audioIn.smooth();
  }
  
  void analyseInput() {
    this.fft.forward(this.in.mix);
    this.audioIn.beginDraw();
    this.audioIn.textFont(Arial, 50);
    this.audioIn.textAlign(CENTER);
    this.audioIn.clear();
    if (this.fft.getBand(30) > 25.0) {
      knock = true;
      // print("fft(30): " + this.fft.getBand(30) + "\n");
      this.audioIn.text("Klopf Klopf", this.audioIn.width/2, this.audioIn.height/2);
      }
    for(int i = 0; i < fft.specSize(); i++) {
    // draw the line for frequency band i, scaling it up a bit so we can see it
      this.audioIn.beginDraw();
      this.audioIn.stroke(255);
      this.audioIn.line( i, this.audioIn.height, i, this.audioIn.height - fft.getBand(i)*5 );
      this.audioIn.endDraw();
      audio = this.audioIn;
      knock = false;
    }
    
  }
}
