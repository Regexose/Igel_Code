import processing.sound.*;

FFT fft;
PFont font;
AudioIn in;
int bands = 512;
int fac, savedTime, second, ms;
float[] spectrum = new float[bands];
float scale = 2.0;
PrintWriter output;


void setup() {
  size(512, 360);
  background(255);
  font = createFont("Arial", 12, true);
  textFont(font);
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 1);

  // start the Audio Input
  in.start();

  // patch the AudioIn
  fft.input(in);
  output = createWriter("levels.txt");
  second = second();
  fac = 0;
  ms = 0;
  savedTime = millis();
  
}      

void draw() { 
  background(255);
  fft.analyze(spectrum);
  strokeWeight(2);
  for (int i = 0; i < bands; i ++) {
    // The result of the FFT is normalized
    // draw the line for frequency band i scaling it up by 5 to get more amplitude.
    stroke(255-i, 200, 200);
    line(i, height, i, height - spectrum[i]*height*scale );
  }
  ms += millis() - savedTime;
  if (second != second()) {
    fac += 1;
    ms = 0;
    second = second();
    } 
    int x = 200;
    int y = 10;
    if (spectrum[x] > 0.005) {
    String level = str(spectrum[x]);
    output.println(hour() + " : " + minute() + " : " + second() + " : " + ms + " : \t\t " + level);
    pushMatrix();
    translate(x, y);
    rotate(HALF_PI);
    fill(0);
    text(spectrum[x], 0, 0);
    popMatrix(); 
    }
    savedTime = millis();
   
}

void keyPressed() {
    output.flush();
    output.close();
    exit();
}
