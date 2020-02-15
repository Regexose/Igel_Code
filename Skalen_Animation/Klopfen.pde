class Klopfen {
  Minim minim;
  AudioInput in;
  FFT fft;
  float [] buffer;
  PGraphics audioIn;
  
  Klopfen() {
    minim = new Minim(this);
    in = minim.getLineIn();
    fft = new FFT(in.bufferSize(), 48000);
    buffer = new float[512];
    this.audioIn = createGraphics(width, height/10);
  }
  
  void analyseInput() {
    fft.forward(in.mix);
    this.audioIn.beginDraw();
    this.audioIn.clear();
    this.audioIn.endDraw();
    for(int i = 0; i < fft.specSize(); i++) {
    // draw the line for frequency band i, scaling it up a bit so we can see it
      this.audioIn.beginDraw();
      this.audioIn.stroke(255);
      this.audioIn.line( i, this.audioIn.height, i, this.audioIn.height - fft.getBand(i)*8 );
      this.audioIn.endDraw();
      audio = this.audioIn;
    }
    
  }
}
