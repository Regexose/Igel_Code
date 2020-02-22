class Klopfen {
  Minim minim;
  AudioInput in;
  FFT fft;
  PGraphics audioIn;
  
  Klopfen() {
    minim = new Minim(this);
    in = minim.getLineIn();
    fft = new FFT(in.bufferSize(), 48000);
    this.audioIn = createGraphics(width, height/10);
  }
  
  void analyseInput() {
    fft.forward(in.mix);
    if (fft.getFreq(300) > 16.0) {
      knock = true;
      print("fft(300): " + fft.getFreq(300) + "\n");
    }
    this.audioIn.beginDraw();
    this.audioIn.clear();
    this.audioIn.endDraw();
    for(int i = 0; i < fft.specSize(); i++) {
    // draw the line for frequency band i, scaling it up a bit so we can see it
      this.audioIn.beginDraw();
      this.audioIn.stroke(255);
      this.audioIn.line( i, this.audioIn.height, i, this.audioIn.height - fft.getBand(i)*5 );
      this.audioIn.textFont(Arial, 30);
      this.audioIn.textAlign(CENTER);
      this.audioIn.text(str(knock), this.audioIn.width/2, this.audioIn.height/2);
      this.audioIn.endDraw();
      audio = this.audioIn;
      knock = false;
    }
    
  }
}
