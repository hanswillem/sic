class Number {
  float x, y, w, h, val, valDefault, st, valMin, valMax, tm;
  boolean active, hover, reset, timer, isInt;
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
    isInt = false;
    name = "unused";
  }

  // set the color and text of the nr box
  void update() {
    getHover();
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
      if (!isInt) {
        text(val, x + 10, y + 17);
      } else {
        text(int(val), x + 14, y + 17);
      }
    }

    // change the value
    if (active) {
      float d = mouseX - pmouseX;
      if (d > 0.1) {
        if (shiftDown) {
          val += st / 10;
        } else {
          val += st;
        }
      }
      if (d < -0.1) {
        if (shiftDown) {
          val -= st / 10;
        } else {
          val -= st;
        }
      }
      val = constrain(val, valMin, valMax);
    }
  }

  // check if the mouse is over the nr box (while mousePressed == true)
  void listen() {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY <y + h) {
      active = true;
    }
  }

  // check if the mouse is over the nr box
  void getHover() {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      hover = true;
    } else {
      hover = false;
    }
  }
}