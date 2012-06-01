/**
 * Patterns. 
 * 
 * Move the cursor over the image to draw with a software tool 
 * which responds to the speed of the mouse. 
 */
import processing.serial.*;

Serial myPort;        // The serial port
int xPos, prevXpos = 0;
String serialVal;
int serialIntVal, prevSerialIntVal = 0;
int highestPoint;

int lowerVal =0;
int upperVal =1023;

//labels
Label label_current, label_adjusted, label_high, label_low;

ArrayList quickSampleArrayList, longSampleArrayList;
Timer timer, timerLong;

FileWriter logFile;
int logTimerDelay = 10;

void setup()
{
  size(600, 400);
  background(0);
  smooth();

  // List all the available serial ports
  println(Serial.list()); 
  myPort = new Serial(this, Serial.list()[0], 38400);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  highestPoint = 0;

  //set up labels
  setupLabels();

  quickSampleArrayList = new ArrayList();
  longSampleArrayList = new ArrayList();

  timer = new Timer(5);
  timer.start();

  timerLong = new Timer(250);
  timerLong.start();

  //create thread to save kinect joint data
  logFile = new FileWriter(logTimerDelay, "log1");
}

void draw() 
{
  background(0);
  stroke(255);
  strokeWeight(1);
  line(0, 145, width, 145);

  if (highestPoint > serialIntVal) {
    highestPoint = serialIntVal;
  }

  strokeWeight(4);
  line(0, highestPoint, width, highestPoint);

  //println(highestPoint + " -- " + serialIntVal);
  displayLine();
  displayLabels();
}


void mousePressed() {
  highestPoint = height;
}

void setSample(int value) {

  if (quickSampleArrayList.size() > width-25) {
    quickSampleArrayList.remove(0);
  }

  Sample tmpSample = new Sample(value);
  quickSampleArrayList.add(tmpSample);
}

void setLongSample(int value) {

  if (longSampleArrayList.size() > width) {
    longSampleArrayList.remove(0);
  }

  Sample tmpSample = new Sample(value);
  longSampleArrayList.add(tmpSample);
}

void displayLine() {
  int currX = 0;
  int prevX = 0;
  int prevPoint = 0;
  strokeWeight(3);
  for (int i=0; i<quickSampleArrayList.size();i++) {
    Sample tmpSample = (Sample)quickSampleArrayList.get(i);
    fill(255, 0, 0);
    line(prevX, prevPoint, currX, tmpSample.val());

    prevX = currX;
    currX++;
    prevPoint = tmpSample.val();
  }

  currX = 0;
  prevX = 0;
  prevPoint = 0;
  strokeWeight(1);
  for (int i=0; i<longSampleArrayList.size(); i++) {
    Sample tmpSample = (Sample)longSampleArrayList.get(i);
    fill(255, 0, 0);
    int adjustedY = int(map(tmpSample.val(), lowerVal, upperVal, 60, 140));
    line(prevX, prevPoint, currX, adjustedY);

    prevX = currX;
    currX++;
    prevPoint =adjustedY;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      upperVal = int(serialVal);
      label_high.setText("Upper : " + str(upperVal));
    } 
    else if (keyCode == DOWN) {
      lowerVal = int(serialVal);
      label_low.setText("Lower : " + str(lowerVal));
    }
  }

  if (key == 'r' || key == 'R') {
    lowerVal = 0;
    upperVal = 1023;
    setupLabels();
  }
}



void setupLabels() {
  int top = 25;
  int padding = 30;
  label_current = new Label(5, top);
  label_adjusted = new Label(130, top);
  label_high = new Label(5, 40);
  label_low = new Label(5, 53);

  label_high.setText("Upper limit: raise and press up key to calibrate");
  label_low.setText("Lower limit: lower and press down key to calibrate");
}

void displayLabels() {
  label_current.display();
  label_adjusted.display();
  label_high.display();
  label_low.display();
}


void serialEvent (Serial myPort) {
  // get the ASCII string:
  String tmpSerialVal = myPort.readStringUntil('\n');

  if (tmpSerialVal != null) {
    // trim off any whitespace:
    serialVal = trim(tmpSerialVal);

    //convert to int
    serialIntVal = int( map(float(serialVal), upperVal, lowerVal, 150, height) );

    label_current.setText("current : " + serialVal);
    label_adjusted.setText("adjusted : " + serialIntVal);

    if (timer.isFinished()) {
      setSample(serialIntVal);
      timer.start();
    }

    if (timerLong.isFinished()) {
      setLongSample(serialIntVal);
      timerLong.start();
    }

    if ( !logFile.isRunning() ) {
      logFile.start();
      println("starting log");
    }
  }
}

