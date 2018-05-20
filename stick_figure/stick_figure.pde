// move the joints with the mouse
// shift = also move all of the children of the selected joint
// move the whole chain by clicking and dragging without a joint selected


Joint j[];
PVector jrecord[];
int jointMoveIndex;
boolean shiftDown;


void setup() {
  size(720, 960);
  background(225);
  j = new Joint[15];
  jrecord = new PVector[j.length];
  setupJoints();
  shiftDown = false;
}


void draw() {
  background(225);
  showJoints();
  moveJoints();
}


void keyPressed() {
  //println(keyCode);
  if (keyCode == SHIFT) {
    shiftDown = true;
  }
}


void keyReleased() {
  shiftDown = false;
}


// setting up the joint chain
void setupJoints() {
  j[0] = new Joint("root", "none", width / 2, height / 2);
  j[1] = new Joint("neck", "root", width / 2, height / 2 - 50);
  j[2] = new Joint("elbow_right", "shoulder_right", width / 2 - 50, height / 2 - 50);
  j[3] = new Joint("elbow_left", "shoulder_left", width / 2 + 50, height / 2 - 50);
  j[4] = new Joint("wrist_right", "elbow_right", width / 2 - 100, height / 2 - 50);
  j[5] = new Joint("wrist_left", "elbow_left", width / 2 + 100, height / 2 - 50);
  j[6] = new Joint("head", "neck", width / 2, height / 2 - 100);
  j[7] = new Joint("knee_right", "hip_right", width / 2 - 25, height / 2 + 50);
  j[8] = new Joint("knee_left", "hip_left", width / 2 + 25, height / 2 + 50);
  j[9] = new Joint("ankle_right", "knee_right", width / 2 - 25, height / 2 + 100);
  j[10] = new Joint("ankle_left", "knee_left", width / 2 + 25, height / 2 + 100);
  j[11] = new Joint("shoulder_right", "neck", width / 2 - 25, height / 2 - 50);
  j[12] = new Joint("shoulder_left", "neck", width / 2 + 25, height / 2 - 50);
  j[13] = new Joint("hip_right", "root", width / 2 - 25, height / 2);
  j[14] = new Joint("hip_left", "root", width / 2 + 25, height / 2);
}


// draw the joints on the canvas
void showJoints() {
  for (int i = 0; i < j.length; i++) {
    j[i].drawLineToParent();
  }
  for (int i = 0; i < j.length; i++) {
    j[i].show();
  }
}


// when the mouse is pressed, move the joint closest to the mouse
void moveJoints() {
  setMoveJointIndex();
  if (jointMoveIndex != -1) {
    //make closest joint green
    j[jointMoveIndex].active = true;
    // make all other joints black
    for (int i = 0; i < j.length; i++) {
      if (i != jointMoveIndex) {
        j[i].active = false;
      }
    }
    // move the selected joint
    if (mousePressed) {
      j[jointMoveIndex].pos.x += mouseX - pmouseX;
      j[jointMoveIndex].pos.y += mouseY - pmouseY;
      // if shift key is pressed also move the children of the selected joint
      if (shiftDown) {
        moveChildren(jointMoveIndex);
      }
    }
  } else {
    // make all joints black
    for (int i = 0; i < j.length; i++) {
      j[i].active = false;
    }
    // if no joints are selected move the whole chain
    if (mousePressed) {
      for (int i = 0; i < j.length; i++) {
        j[i].pos.x += mouseX - pmouseX;
        j[i].pos.y += mouseY - pmouseY;
      }
    }
  }
}


// if the mouse is not pressed get the closest joint to the mouse
void setMoveJointIndex() {
  if (!mousePressed) {
    jointMoveIndex = getClosestJointIndex();
  }
}


// get the index of the joint closest to the mouse
int getClosestJointIndex() {
  float rec = 10000000;
  int closest = -1; 
  for (int i = 0; i < j.length; i++) {
    float d = dist(mouseX, mouseY, j[i].pos.x, j[i].pos.y);
    if (d < rec) {
      rec = d;
      closest = i;
    }
  }
  if (rec > 25) {
    return -1;
  } else {
    return closest;
  }
}


// recursion galore
// move the children of the selected joint when shift is pressed
void moveChildren(int parentIndex) {
  for (int i = 0; i < j.length; i++) {
    if (j[i].parent == j[parentIndex].label) {
      if (j[i].label != "neck") { // this if statment makes sure that only the legs move with the root
        j[i].pos.x += mouseX - pmouseX;
        j[i].pos.y += mouseY - pmouseY;
        moveChildren(i);
      }
    }
  }
}