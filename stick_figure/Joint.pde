class Joint {
  float x, y, r;
  String label, parent;
  PVector pos;
  boolean active;
  

  Joint(String _label, String _parent, float _x, float _y) {
    x = _x;
    y = _y;
    r = 12;
    label = _label;
    parent = _parent;
    pos = new PVector(x, y);
    active = false;
  }


  void show() {
    noStroke();
    if (active) {
      fill(0, 255, 0);
    } else {
      fill(0);
    }
    ellipse(pos.x, pos.y, r, r);
  }


  void drawLineToParent() {
    if (label != "root") {
      Joint p = null;
      for (int i = 0; i < j.length; i++) {
        if (j[i].label == parent) {
          p = j[i];
        }
      }
      stroke(0);
      noFill();
      line(pos.x, pos.y, p.pos.x, p.pos.y);
    }
  }
}