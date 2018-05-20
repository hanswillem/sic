PVector[] mousePositions;
int mousePositionsCounter, mousePositionsMax;
float x, y;

void setup() {
  size(720, 405);
  background(225);
  mousePositionsMax = 10;
  mousePositions = new PVector[mousePositionsMax];
  mousePositionsCounter = 0;
}


void draw() {
  background(225);
  listenToMouse();
  pushMatrix();
  translate(width / 2, height / 2);
  stroke(0);
  strokeWeight(4);
  noFill();
  line(0, 0, x, y);
  
  popMatrix();
  drawMousePositions();
}

void drawMousePositions() {
  for (int i = 1; i < mousePositionsMax; i++) {
    noStroke();
    fill(100);
    if (mousePositions[i] != null) {
      ellipse(mousePositions[i].x, mousePositions[i].y, 10, 10);
    }
  }
}

void listenToMouse() {
  if (mousePressed) {
    PVector mouseVector = new PVector(mouseX, mouseY);
    if (mousePositionsCounter < mousePositionsMax) {
      mousePositions[mousePositionsCounter] = mouseVector;
    } else {
      shiftArray();
      mousePositions[mousePositionsMax - 1] = mouseVector;
    }
    mousePositionsCounter ++;
  }
}


void shiftArray() {
  for (int i = 0; i < mousePositionsMax - 1; i++) {
    mousePositions[i] = mousePositions[i + 1];
  }
}


PVector getAverageMouseDir() {
  PVector avg = new PVector();
  int n = 0;  
  for (int i = 1; i < mousePositionsMax; i++) {
    if (mousePositions[i] != null) {
      avg.add(PVector.sub(mousePositions[i], mousePositions[i - 1]));
      n++;
    }
  }
  avg.div(n);
  avg.mult(10);
  return avg;
}


void mouseReleased() {
  x = getAverageMouseDir().x;
  y = getAverageMouseDir().y;
  mousePositions = new PVector[mousePositionsMax];
  mousePositionsCounter = 0;
}