
Particule anchor;    
Particule bob;        
PVector restPosition;  
Spring spring;         


float rectX, rectY;
float rectW = 60;
float rectH = 40;
float rectSpeed = 5;

float distanceDetection = 250;

void setup() {
  size(600, 400);

  rectX = 20;
  rectY = height - rectH - 20;

  anchor = new Particule(width / 2, 0, true);
  anchor.setRayon(32);


  bob = new Particule(width / 2, height/2, false);
  bob.setRayon(64);

  restPosition = new PVector(width / 2, height/2);
  setDistance(distanceDetection);

  spring = new Spring(0.015,200, anchor, bob);
}

void setDistance(float d) {
  distanceDetection = d;
}

void draw() {
  background(30);

  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      rectX -= rectSpeed;
    } else if (key == 'd' || key == 'D') {
      rectX += rectSpeed;
    }
  }
  rectX = constrain(rectX, 0, width - rectW);

  PVector rectCenter = new PVector(rectX + rectW / 2, rectY + rectH / 2);

  float distanceToRest = PVector.dist(restPosition, rectCenter);
  boolean isAffected = distanceToRest < distanceDetection;

  if (isAffected) {
    PVector attraction = PVector.sub(rectCenter, bob.position);
    attraction.normalize();
    attraction.mult(1);

    bob.applyForce(attraction);

    bob.setColor(color(255, 30, 30));
  } else {
    bob.setColor(color(200));
    
    float forceRappelX = (restPosition.x - bob.position.x) * 0.02;
    bob.applyForce(new PVector(forceRappelX, 0));
  }

  spring.update();
  anchor.update();
  bob.update();

  noFill();
  stroke(255, 255, 0, 80);
  strokeWeight(1);
  //ellipse(bob.position.x, bob.position.y, distanceDetection * 2, distanceDetection * 2);
  circle(bob.position.x, bob.position.y, distanceDetection + rectH);

  spring.show();
  anchor.show();
  bob.show();

  fill( color(100, 0, 200));
  stroke(255);
  strokeWeight(2);
  rect(rectX, rectY, rectW, rectH);
}
