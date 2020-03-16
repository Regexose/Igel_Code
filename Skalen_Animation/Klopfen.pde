class Klopfen {
  Minim minim;
  Table klopfLog;
  AudioInput in;
  Recorder recorder;
  FFT fft;
  PGraphics audioIn;
  float pause, previousTime, textPosX;
  int index = 0;
  int recNumber = 1;
 
  FloatList pauses = new FloatList();

  Klopfen(Minim minim) {
    this.minim = minim;
    this.in = this.minim.getLineIn();
    this.fft = new FFT(this.in.bufferSize(), 48000);
    this.audioIn = createGraphics(width, height/10);
    this.audioIn.smooth();
    this.previousTime = 0;
    this.recorder = null;
    this.textPosX = -this.audioIn.width/2;
    buildLog();
    
  }
  
  void buildLog() {
    this.klopfLog = new Table();
    this.klopfLog.addColumn("mm:ss");
    this.klopfLog.addColumn("pause");
  }
  
  void analyseInput() {
    this.fft.forward(this.in.mix);
    float elapsedTime = millis() - startTime; //vergangene Zeit seit run
    if (this.fft.getBand(3) > 7.8) {
      // println("\nindex to freq(3): " + this.fft.indexToFreq(3) + " volume: " + this.fft.getBand(3));
      knock = true;
      createRecorder();
      this.pause = elapsedTime - this.previousTime;
      this.previousTime = elapsedTime; 
      scale.selectImage(float(this.index), "klopf");
      this.index ++;
      writeLog(this.pause);
      }   
      audioInfo();
    
    // println("elapsed: " + elapsedTime + "  previous: " + this.previousTime + "  pause: " + this.pause);
    this.pause = elapsedTime - this.previousTime;
    if (knock) {checkTime();}
    
    }
    void audioInfo() {
      if (this.textPosX < this.audioIn.width) {
        this.textPosX += 7;
        this.audioIn.beginDraw();
        this.audioIn.textFont(Arial, 45);
        this.audioIn.textAlign(LEFT);
        this.audioIn.background(color(245, 66, 245));
        this.audioIn.text("klopf, KLOPF an die Scheibe !", this.textPosX, this.audioIn.height/2);
        this.audioIn.endDraw();
        // this.audioIn.clear();
        for(int i = 0; i < this.fft.specSize(); i++) {
      // draw the line for frequency band i, scaling it up a bit so we can see it
          this.audioIn.beginDraw();
          this.audioIn.stroke(255);
          this.audioIn.line(i, this.audioIn.height, i, this.audioIn.height - this.fft.getBand(i)*5 );
          this.audioIn.endDraw();
          }
      } else {
      
      this.textPosX = -this.audioIn.width/2;
      } 
      // scale.surface = this.audioIn;
    }
  
  void createRecorder() {
    if (knock && this.recorder == null) {
      this.recorder = new Recorder(this.minim);
      this.recorder.timedRecording();
    } 
  }
  
  void checkTime() {
    println("this.pause: " + this.pause);
    if (this.pause > 5000.0) {
      knock = false;
      println("\t\t5 sec !!  " + knock);
      this.recorder.stopRec = true;
      this.recorder.timedRecording();
      this.recorder = null;
    } 
  }
  void writeLog (float pause) {
    String log = minute() + ":" + second() ;
    TableRow newRow = this.klopfLog.addRow();
    newRow.setString("mm:ss", log +"\t");
    newRow.setFloat("pause", pause);
    saveTable(this.klopfLog, audioPath + "/log.csv");
  }
  
  void updateSurface(FFT fft) {
   if (knock) {
    this.audioIn.beginDraw();
    this.audioIn.textFont(Arial, 50);
    this.audioIn.textAlign(CENTER);
    this.audioIn.clear();
    for(int i = 0; i < fft.specSize(); i++) {
  // draw the line for frequency band i, scaling it up a bit so we can see it
    this.audioIn.beginDraw();
    this.audioIn.stroke(255);
    this.audioIn.line( i, this.audioIn.height, i, this.audioIn.height - fft.getBand(i)*5 );
    this.audioIn.text(str(knock), this.audioIn.width/2, this.audioIn.height/2);
    this.audioIn.endDraw();
    }
   }
  }
}

class Recorder {
  AudioRecorder recorder;
  boolean recorded, stopRec;
  String date;
  
  Recorder(Minim minim) {
    this.date = month() + "." + day() + "_" +hour() + ":" +minute() + ":" + second();
    this.recorder = minim.createRecorder(minim.getLineIn(), audioPath + this.date + ".wav");
    this.stopRec = false;
  }
  void timedRecording() {
    if (this.stopRec || globalStop) {
      if (this.recorder.isRecording()) {
        this.recorder.endRecord();
        println("stopping...");
        recorded = true;
        this.recorder.save();
        println("done saving");
        } 
    } else {
        this.recorder.beginRecord();
        println("recording..." + this.recorder.isRecording());
      }
    }
}
