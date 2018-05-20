class Particle {
  float x, y, r;
  boolean colorSwitch, isMouseParticle;
  PVector pos, vel, acc;


  Particle(float _x, float _y, boolean _isMouseParticle) {
    x = _x;
    y = _y;
    r = random(d * psm);
    isMouseParticle = _isMouseParticle;

    pos = new PVector(x, y);

    if (isMouseParticle) {
      vel = new PVector(mouseX + random(-d, d), mouseY + random(-d, d)).sub(new PVector(pmouseX, pmouseY));
    } else {
      vel = new PVector(x + random(-d, d), y + random(-d, d)).sub(new PVector(tr[f -1].x, tr[f -1].y));
    }
    vel.mult(pvl);
    acc = new PVector(0, 0);
    if (random(100) < 35) {
      colorSwitch = true;
    } else {
      colorSwitch = false;
    }
  }


  void show() {
    if (colorSwitch) {
      fill(random(255), 0, 0);
    } else {
      fill(random(255));
    }
    noStroke();
    if (random(1) < .5) {
      rect(pos.x, pos.y, r, r); // change this to an ellipse for variation
    } else {
      rect(pos.x, pos.y, r, r);
    }
  }


  void update() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    if (r > .01) {
      r /= 1.25;
    } else {
      r = 0;
    }
  }


  void applyForce(PVector f) {
    acc.add(f);
  }
}
