class Spring {
  float k;
  float restLength;
  Particule a;
  Particule b;

  Spring(float k, float restLength, Particule a, Particule b) {
    this.k = k;
    this.restLength = restLength;
    this.a = a;
    this.b = b;
  }

  void update() {
    PVector force = PVector.sub(this.a.position, this.b.position);
    float currentLength = force.mag();
    float x = currentLength - this.restLength; 

    if (currentLength > 0.0001) {
      force.normalize();
      
      force.mult(this.k * x);

      PVector forceOpposite = PVector.mult(force, 1);
      this.a.applyForce(forceOpposite);
      this.b.applyForce(force);
    }
  }

  void show() {
    strokeWeight(4);
    stroke(250);
    line(this.a.position.x, this.a.position.y, this.b.position.x, this.b.position.y);
  }
}
