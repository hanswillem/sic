void setup() {
  size(720, 960);
  background(255);
  stroke(0);
  strokeWeight(4);
  noFill();
  noSmooth();
}


void draw() {
  background(255);
  grid();
  //render();
}


void grid() {
  float off = (frameCount % 16) / 2;
  for (int x = - 8; x < width + height; x += 8) {
    line(x + off, 0, 0, x + off);
  }
}


void render() {
  if (frameCount < 16) {
    saveFrame("renders/marching_ants_####.png");
  }
}