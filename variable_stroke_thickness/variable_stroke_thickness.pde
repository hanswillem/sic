// mouse speed controls line thickness 
 
// Version with damping
 
float currentStrokeWeight=1.0;
 
void setup() {
  size(640, 360);
  background(102);
}
 
void draw() {
  // Call the function and send it the
  // parameters for the current mouse position
  // and the previous mouse position
  variableEllipse(mouseX, mouseY, pmouseX, pmouseY);
}
 
 
// The simple function was created specifically 
// for this program. It calculates the speed of the mouse
// and draws a small line if the mouse is moving slowly
// and draws a thicker line if the mouse is moving quickly 
 
void variableEllipse(int x, int y, int px, int py) {
 
  float speed = abs(x - px) + abs( y - py);
 
  currentStrokeWeight += (speed - currentStrokeWeight) * .1; // damping 
 
  strokeWeight(currentStrokeWeight);
  stroke(random(255));

  if (mousePressed) {
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}
