int margin;


void setup() {
  size(720, 960, P3D);
  background(255);
  margin = 500;
  noSmooth();
}


void draw() {
  background(255);
  moire(4);
  //render();
}


void moire(float n) {
  pushMatrix();
  translate(width / 2 + mouseX / 5, height / 2 + mouseY / 5);
  float rx = map(mouseX, 0, width, -45, 45);
  rotateX(radians(rx));
  float ry = map(mouseY, 0, height, -45, 45);
  rotateY(radians(ry));
  lineGrid(n);
  popMatrix();
}


void lineGrid(float n) {
  noFill();
  stroke(0);
  strokeWeight(1);
  for (int x = -width / 2 - margin; x < width / 2 + margin; x += n) {
    line(x, -height / 2 - margin, x, height / 2 + margin);
  }
  for (int y = -height / 2 - margin; y < height / 2 + margin; y += n) {
    line(-width / 2 - margin, y, width / 2 + margin, y);
  }

  for (int i = 0; i < 5; i++) {
    int x = int(random(width / n));
    int y = int(random(height / n));
    noStroke();
    fill(0);
    rect((x * n) - width / 2, (y * n) - height / 2, n, n);
  }
}


void pointGrid(float n) {
  noFill();
  stroke(0);
  strokeWeight(2);
  for (int x = -width / 2 - margin; x < width / 2 + margin; x += n) {
    for (int y = -height / 2 - margin; y < height / 2 + margin; y += n) {
      point(x, y);
    }
  }
}


void render() {
  saveFrame("renders/moire_####.png");
}