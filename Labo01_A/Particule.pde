class Particule {
  PVector position;
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  boolean isStatic = false;
  float rayon = 12;
  color c = color(200); // Couleur par défaut

  Particule(float x, float y, boolean isStatic) {
    this.position = new PVector(x, y);
    this.isStatic = isStatic;
  }

  void setRayon(float r) {
    this.rayon = r;
  }

  void setColor(color c) {
    this.c = c;
  }

  void applyForce(PVector force) {
    if (!isStatic) {
      this.acceleration.add(force);
    }
  }

  void update() {
    if (!isStatic) {
      this.velocity.add(this.acceleration);
      this.velocity.mult(0.94);
      this.velocity.limit(20);
      this.position.add(this.velocity);
      this.acceleration.mult(0);
    }
  }

  void show() {
    fill(this.c);
    noStroke();
    ellipse(position.x, position.y, this.rayon * 2, this.rayon * 2);
  }
}
