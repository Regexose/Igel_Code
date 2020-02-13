class Klopfen {
  Minim minim;
  AudioInput in;
  FFT fft;
  float [] buffer;
  PGraphics audioIn;
  
  Klopfen() {
    minim = new Minim(this);
    in = minim.getLineIn();
    fft = new FFT(512, 48000);
    buffer = new float[512];
    this.audioIn = createGraphics(width, height/10);
  }
  
  void analyseInput() {
    fft.forward(buffer);
    println("level of fft[100]: " + fft.getBand(100));
    for(int i = 0; i < fft.specSize(); i++) {
    // draw the line for frequency band i, scaling it up a bit so we can see it
      this.audioIn.beginDraw();
      this.audioIn.stroke(100);
      this.audioIn.line( i, this.audioIn.height, i, this.audioIn.height - fft.getBand(i)*8 );
      this.audioIn.endDraw();
    }
  }
}
