class Number {
  float x, y, w, h, val, valDefault, st, valMin, valMax, tm;
  boolean active, hover, reset, timer;
  String name;


  Number(float _x, float _y, float _val) {
    x = _x;
    y = _y;
    w = 80;
    h = 25;
    st = 1;
    val = _val;
    valDefault = _val;
    valMin = 0;
    valMax = 255;
    active = false;
    reset = false;
    name = "unused";
  }


  void update() {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      hover = true;
    } else {
      hover = false;
    } 

    noStroke();
    if (active || hover) {
      fill(255);
    } else {
      fill(0);
    }
    rect (x, y, w, h);
    
    if (active || hover) {
      fill(0);
    } else {
      fill(255);
    }
    if (hover && !active && !reset) {
      text(name, x + 10, y + 17);
    } else {
      text(val, x + 10, y + 17);
    }

    if (active) {
      float d = mouseX - pmouseX;
      if (d > 0.1) {
        val += st;
      }
      if (d < -0.1) {
        val -= st;
      }
      val = constrain(val, valMin, valMax);
    }
  }
}