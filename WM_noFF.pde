int wmCount = 4; // number of windmills
float [] wmQueue = new float[wmCount]; //creates a new float array that is the same size as the number of windmills --> this array contains the "baskets" that the particle systems fetch from
int activeWindmills;
int ffRes = 10; // resolution of flowfield


// Using this variable to decide whether to draw all the stuff
boolean debug = false;

BoundBox boundBox;


color c0 = color(255);
color c1 = color(0, 255, 0);
color c2 = color(0, 0, 255);
color c3 = color(0, 0, 255);
color c4 = color(255, 255, 0);
color c5 = color(255, 0, 255);
color c6 = color(0, 255, 255);
color c7 = color(255, 255, 0);
color c8 = color(255, 0, 255);
color c9 = color(0, 0, 255);




color[] wmColors  = {  
  c0, c1, c2, c3, c4, c5, c6, c7, c8, c9};


ParticleSystem [] Windmills = new ParticleSystem[wmCount]; //create array of possible windmills (it's fine if not all are used)


int cols;
int rows;

import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port


void setup() {

  fullScreen();
  background(255);
  //boundBox = new BoundBox(); //creates a boundbox object
  //boundBox.initiate(); //draws initial bounbox with 100% opacity



  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  for ( int i = 0; i<wmCount; i++) {
    wmQueue[i] = 0;
    Windmills[i] = new ParticleSystem();
  }
}

void draw() {
  // boundBox.display();
  noStroke();
  fill(255, 10);
  rect(0, 0, width, height);
  fill(255,255);
  rect(0,0,300, height);
  getData(); // sorts data from serial and sends to wmQueue[]
  for (int i = 0; i < wmCount; i++) {
    if (wmQueue[i] > 0) {
      activeWindmills += 1;
      Windmills[i].addParticles(wmQueue[i], i);
      //wmQueue[i] = 0;
      //print("<" + i + ">");
      //println(activeWindmills);
    }
    Windmills[i].run();
  }

  //flowfield.update();

  // Display the flowfield in "debug" mode
  stroke(1);
  



  for (int i = 0; i<wmCount; i++) {
    String wmText = nf(wmQueue[i], 1, 2) + " Volts";
    textAlign(LEFT);
    textSize(36);
    fill(wmColors[i]);
    text(wmText, float(20), map(i, 0, wmCount, 100, height));
  }
}

void getData() {
  if ( myPort.available() > 0 )
  {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    activeWindmills = 0;

    if (val != null ) { //this probably doesn't do anything, but might defray some errors someday
      //println(val); //print it out in the console
      String[] q = splitTokens(val, ","); //splits serial line at commas, and sends each value, e.g. WM0/4.8 into an array
      for (int i = 0; (i<q.length); i++) { //cycles through the array
        for (int r = 0; r<wmCount; r++) { //loops through array, where each location r corresponds to a windmill
          String wmid = "WM" + nf(r); // creates string of "WM" plus the location within the for loop, where each location r matches a WM identity, e.g. "WM" + r = WM0, (r++)
          if (q[i].indexOf(wmid) >= 0) { //check to see if string array contains substring "WM"r. Returns location within string or -1.
            String dataval = q[i].substring(q[i].indexOf("/")+1); // If contains "WM"r, returns a substring beginning with character that follows "/" (the substring should contain the windmill's reported data, i.e. voltage
            //print(wmid);
            //print(" ");
            //println(dataval);
            wmQueue[r] = constrain(float(dataval), 0, 8); // adds the data value to the existing value in queue array location that corresponds to the windmill number (parsing errors cannot exceed 8);
          }
        }
      }
    }
  }
}
