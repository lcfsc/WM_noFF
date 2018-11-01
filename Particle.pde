// A simple Particle class

class Particle {
  PVector position;
  PVector prevPosition;
  PVector velocity;
  PVector acceleration;
  float magnitude;
  float lifespan;
  int wmid;
  float pColor;
  int index;
  
  float xoff = random(0,1000);

  float c = 0; //coefficient of friction

  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  float opacity;






  Particle(float tempMagnitude, int tempID) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector((-10*tempMagnitude), 0);
    magnitude =(12*tempMagnitude);
    velocity.setMag(magnitude);
    position = new PVector((width-50), map(tempID, 0, wmCount, 100, height));
    wmid = tempID;
    //opacity = map(magnitude, 0, 12*tempMagnitude, 0, 255);
    opacity = 255;
  }

  //void follow(FlowField flow) {
  //  // What is the vector at that spot in the flow field?
  //  PVector desired = flow.lookup(position);
  //  desired.mult(velocity.mag());
  //  PVector newDirection = PVector.lerp(velocity, desired, .05);
  //  velocity = newDirection;
  //}

  void run() {


    checkEdges();
    update();
    display();
  }  

  // Method to update position
  void update() {
    //PVector friction = velocity.get();

    prevPosition = position.copy();

    //friction.mult(-1);
    //friction.normalize();
    //friction.mult(c);
    //applyForce(friction);
    //velocity.x =+ .0001;
    oscillateY();
    velocity.add(acceleration);
    //velocity.limit(10);
    position.add(velocity);

    acceleration.mult(0);
    velocity.x = velocity.x + .25;
  }

  // Method to display
  void display() {


    noStroke();
    fill(wmColors[wmid], opacity);
    //ellipse(position.x, position.y, 6, 6);
    strokeWeight(8);
    stroke(wmColors[wmid], opacity);
    line(position.x, position.y, prevPosition.x, prevPosition.y);
    noStroke();
  }

  void applyForce(PVector force) {
    PVector f = force.get();
    acceleration.add(f);
  }

  void oscillateY() {
    acceleration.add(0, map(noise(xoff), 0, 1, -.2, .2));
    xoff += .01;
  }

  // Is the particle still useful?
  boolean isDead() {
    if ((velocity.x >= 0)) {
      return true;
    } else {
      return false;
    }
  }
  void checkEdges() {
    if (position.x>=width) {
      velocity.x = velocity.x*(-1);
    }
    if (position.x <=0) {
      velocity.x = velocity.x*(-1);
    }
    if (position.y>=height) {
      velocity.y = velocity.y*(-1);
    }
    if (position.y <=0) {
      velocity.y = velocity.y*(-1);
    }


    //}
  }
}
