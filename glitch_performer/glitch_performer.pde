// spacebar = start /stop playing - when not playing you can draw with the mouse
// d (while hovering over a number box) = reset to default value
// e = export variables to txt file
// r = read variables from (exported) txt file
// c = clear screen
// p = open point editor
// in point editor drag points with the mouse to change position or,
// if no points are selected, drag to change position of all points
// i - set start frame while playing
// o - set end frame while playing
// s - save frame
// f - reparse file, resets global and individual position of points
// SHIFT = lower increments when draging a number box
// particles can be squares and or ellipses (but are just squares for now)
// some different colors

// use the dbl variable in setup to double the points n times upon parsing
//
// ------------------------------------------------------------------------
// NEW STUFF:
// ------------------------------------------------------------------------
// strokeWeight is now smooth
// ------------------------------------------------------------------------

ArrayList<Particle> p;
float d, et, lt, st, currentStrokeWeight;
int f, startfr, endfr, dbl;

// ---modifiers------------------------------------------------------------------------
float dm, dmDefault, strm, strmDefault, brm, brmDefault, psm;
float psmDefault, pvl, pvlDefault, dslwm, dslwmDefault, startfrm, startfrmDefault;
float endfrmm, endfrmmDefault, mySlider, mySliderDefault;
// ---modifiers------------------------------------------------------------------------

Number[] nrs;
boolean guiActive, guiIsExported, guiIsLoaded, isMousePainter, isPointEditor, imgIsSaved, shiftDown;
String[] guiSettings, trfile;
PVector[] tr;
String trFileName;


void setup() {
  size(820, 990);
  background(225);
  strokeCap(SQUARE);
  textSize(12);
  cursor(CROSS);

  p = new ArrayList<Particle>();

  isMousePainter = true;
  isPointEditor = false;
  shiftDown = false;
  trFileName = "man_01_tracked.txt";
  parseFile();
  dbl = 1; 
  doublePoints(dbl);
  startfr = 1;
  endfr = tr.length - 1;
  f = startfr;
  nrs = new Number[8];
  currentStrokeWeight = 1;

  dmDefault = .8; // distance modifer
  strmDefault = 1; // thick stroke modifier
  brmDefault = .75; // break screen modifier
  psmDefault = 2; // particle scale modifier
  pvlDefault  = 1; // particle velocity modifier
  dslwmDefault = 1.1; // distance slow down modifier
  startfrmDefault = startfr; // start frame modifier 
  endfrmmDefault = endfr; //end frame modifier

  guiActive = false;
  setupGui();
}


void draw() {
  if (!isPointEditor) {
    if (!guiActive()) {
      getDist();
      blendMode(DIFFERENCE);
      paint();
      drawParticles();
      blendMode(NORMAL);
      thickStroke();
      breakScreen();
    }
    if (!isMousePainter && f < endfr) {
      f++;
    }
  }
  if (isPointEditor) {
    clearScreen();
    pointEditor();
  }
  Gui();
}


// the shortcuts
void keyPressed() {
  //println(keyCode);
  // 'space'
  if (keyCode == 32) {
    if (!isPointEditor) {
      isMousePainter = !isMousePainter;
      if (!isMousePainter) {
        f = startfr;
        clearScreen();
      } else {
        clearFrameRangeSlider();
      }
    } else {
      isPointEditor = false;
      isMousePainter = false;
      clearScreen();
      f = startfr;
    }
  }
  // shift
  if (keyCode == SHIFT) {
    shiftDown = true;
  }
  // 'f'
  if (keyCode == 70) {
    doublePoints(0);
    parseFile();
    doublePoints(dbl);
  }
  // 'd'
  if (keyCode == 68) {
    resetGuiVariables();
  }
  // 'e'
  if (keyCode == 69) {
    saveGuiSettings();
  }
  // 'r'
  if (keyCode == 82) {
    loadGuiSettings();
  }
  // 'c'
  if (keyCode == 67) {
    clearScreen();
  }
  // 'i'
  if (keyCode == 73) {
    if (!isMousePainter) {
      nrs[6].val = f;
    }
  }
  // 'o'
  if (keyCode == 79) {
    if (!isMousePainter) {
      nrs[7].val = f;
    }
  }
  // 's'
  if (keyCode == 83) {
    renderImage();
  }
  // 'p'
  if (keyCode == 80) {
    isPointEditor = !isPointEditor;
    if (isPointEditor) {
      clearFrameRangeSlider();
      f = startfr;
    } else {
      clearScreen();
    }
  }
}


// when any key is released set shiftDown to false
void keyReleased() {
  shiftDown = false;
}


// break the screen
void breakScreen() {
  for (int i = 0; i < 25; i ++) {
    int sx = int(random(100, width));
    int sy;
    if (isMousePainter) {
      sy = int(random(height));
    } else {
      sy = int(random(height - 30));
    }
    int sw = int(random(width - sx));
    int sh;
    if (isMousePainter) {
      sh = int(random(height - sy));
    } else {
      sh = int(random(height - sy  - 30));
    }
    int dx = sx + int(random(-d * brm, d * brm));
    int dy = sy + int(random(-d * brm, d * brm));  
    copy(sx, sy, sw, sh, dx, dy, sw, sh);
  }
  d /= dslwm;
}


// add the thick stroke
void thickStroke() {
  stroke(0, 255, random(200));
  currentStrokeWeight +=  ((d * strm) - currentStrokeWeight) * .5 ;
  strokeWeight(currentStrokeWeight);
  
  if (isMousePainter) {
    if (mousePressed) {
      line(pmouseX, pmouseY, mouseX, mouseY);
    }
  } else {
    line(tr[f-1].x, tr[f - 1].y, tr[f].x, tr[f].y);
  }
}


// paint with the mouse
void paint() {
  if (isMousePainter) {
    if (mousePressed) {
      for (int i = 0; i < d / 2; i ++) {
        p.add(new Particle(mouseX + random(-d, d), mouseY + random(-d, d), true));
      }
    }
  } else {
    if (f < endfr) {
      for (int i = 0; i < d / 2; i ++) {
        p.add(new Particle(tr[f].x + random(-d, d), tr[f].y + random(-d, d), false));
      }
    }
  }
}


// draw the particles on the screen
void drawParticles() {
  for (Particle i : p) {
    PVector n = new PVector(random(-1, 1), random(-1, 1));
    i.applyForce(n);
    PVector rs = i.vel.copy();
    rs.mult(-1);
    rs.mult(.15);
    i.applyForce(rs);
    i.update();
    i.show();
  }
}


// clear the screen
void clearScreen() {
  rectMode(CORNER);
  fill(225);
  noStroke();
  if (isMousePainter) {
    rect(100, 0, width - 100, height);
  } else {
    rect(100, 0, width - 100, height - 30);
  }
}


// get the distance between this particle and the next
void getDist() {
  if (isMousePainter) {
    if (mousePressed) {
      d = dist(mouseX, mouseY, pmouseX, pmouseY);
      d *= dm;
    }
  } else {
    if (f < endfr) {
      d = dist(tr[f].x, tr[f].y, tr[f - 1].x, tr[f - 1].y);
      d *= dm;
    }
  }
  if (Float.isNaN(d)) {
    d = 0;
  }
}


// load and parse the txt file
void parseFile() {
  trfile = loadStrings(trFileName);
  tr = new PVector[trfile.length / 2];
  int j = 0;
  for (int i = 0; i < trfile.length; i+= 2) {
    tr[j] = new PVector(float(trfile[i]), float(trfile[i + 1]));
    j++;
  }
}


// double the points by adding points between existing points 
void doublePoints(int n) {
  for (int i = 0; i < n; i++) {
    PVector[] temp = new PVector[tr.length];
    arrayCopy(tr, temp);
    int count = 0;
    tr = new PVector[(temp.length * 2) - 1];
    for (int j = 0; j < temp.length - 1; j++) {
      tr[count] = temp[j];
      float x = (temp[j + 1].x - temp[j].x) / 2;
      float y = (temp[j + 1].y - temp[j].y) / 2;
      x += temp[j].x + random(-10, 10);
      y += temp[j].y + random(-10, 10);
      tr[count + 1] = new PVector(x, y);
      count += 2;
    }
    tr[tr.length - 1] = temp[temp.length - 1];
  }
}


// the point editor
void pointEditor() {
  int closest = closestPoint();
  float mouseDist = dist(tr[closest].x, tr[closest].y, mouseX, mouseY);

  //move closest point
  if (mousePressed) {
    if (!guiActive() && mouseDist < 100) {
      tr[closest].x = mouseX;
      tr[closest].y = mouseY;
    }
  }

  //move all points
  if (mousePressed) {
    if (!guiActive() && mouseDist > 100) {
      for (int i = 0; i < tr.length; i++) {
        float dx = mouseX - pmouseX;
        float dy = mouseY - pmouseY;
        tr[i].x += dx;
        tr[i].y += dy;
      }
    }
  }

  //draw line
  stroke(0);
  noFill();
  for (int i = startfr + 1; i < endfr; i++) {
    line(tr[i - 1].x, tr[i - 1].y, tr[i].x, tr[i].y);
  }

  //draw points
  for (int i = startfr; i < endfr; i++) {
    if (i == closest && mouseDist < 100) {
      noStroke();
      fill(255);
      ellipse(tr[i].x, tr[i].y, 10, 10);
      fill(0, 0, 255);
      text(i, tr[i].x + 5, tr[i].y - 5);
    } else {
      noFill();
      stroke(0, 100);
      strokeWeight(1);
      ellipse(tr[i].x, tr[i].y, 5, 5);
    }
  }
}


// find the point that is closest to the mouse
int closestPoint() {
  float record = 1000000000;
  int point = -1;
  for (int i = startfr; i < endfr; i++) {
    float d = dist(tr[i].x, tr[i].y, mouseX, mouseY);
    if (d < record) {
      record = d;
      point = i;
    }
  }
  return point;
}


// save image to disk
void renderImage() {
  PImage img = createImage(720, 960, RGB);
  img = get(100, 0, 720, 960);
  img.save("images/img.png");
  imgIsSaved = true;
  st = millis();
}


// ---GUI------------------------------------------------------------------------


void setupGui() {
  float y = 10; 
  for (int i = 0; i < nrs.length; i++) {
    nrs[i] = new Number(10, y, 0);
    y += 27;
  }

  // distance modifier
  nrs[0].name = "distance"; 
  nrs[0].valDefault = dmDefault;
  nrs[0].val = dmDefault;
  nrs[0].st = .01;

  // thick stroke modifier
  nrs[1].name = "stroke"; 
  nrs[1].valDefault = strmDefault;
  nrs[1].val = strmDefault;
  nrs[1].st = .1;

  // break screen modifier
  nrs[2].name = "break scr"; 
  nrs[2].valDefault = brmDefault;
  nrs[2].val = brmDefault;
  nrs[2].st = .01;

  // particle scale modifier
  nrs[3].name = "ptcl scale"; 
  nrs[3].valDefault = psmDefault;
  nrs[3].val = psmDefault;
  nrs[3].st = .025;

  // particle velocity modifier
  nrs[4].name = "ptcl vel"; 
  nrs[4].valDefault = pvlDefault;
  nrs[4].val = pvlDefault;
  nrs[4].st = .01;

  // distance slow down modifier
  nrs[5].name = "dist slwdn"; 
  nrs[5].valDefault = dslwmDefault;
  nrs[5].val = dslwmDefault;
  nrs[5].valMin = 1;
  nrs[5].st = .001;

  // start frame modifier
  nrs[6].name = "start fr"; 
  nrs[6].isInt = true;
  nrs[6].valDefault = startfrmDefault;
  nrs[6].val = startfrmDefault;
  nrs[6].valMin = 1;
  nrs[6].valMax = tr.length;
  nrs[6].st = 1;

  // end frame modifier
  nrs[7].name = "end fr"; 
  nrs[7].isInt = true;
  nrs[7].valDefault = endfrmmDefault;
  nrs[7].val = endfrmmDefault;
  nrs[7].valMin = 1;
  nrs[7].valMax = tr.length;
  nrs[7].st = 1;
}


// reset the giu variable
void resetGuiVariables() { 
  for (int i = 0; i < nrs.length; i++) {
    if (nrs[i].hover || nrs[i].active) {
      nrs[i].val = nrs[i].valDefault;
      nrs[i].reset = true;
      nrs[i].timer = true;
      nrs[i].tm = millis();
    }
  }
}


// when the mouse is pressed the Number instances check if the mouse moves over them
void mousePressed() {
  for (int i = 0; i < nrs.length; i++) {
    nrs[i].listen();
  }
}


// when the mouse is released the Number instances stop being active
void mouseReleased() {
  for (int i = 0; i < nrs.length; i++) {
    nrs[i].active = false;
  }
}


// return if the gui is active, i.e. if any of the Number instances is active 
boolean guiActive() {
  boolean ga = false;
  for (int i = 0; i < nrs.length; i++) {
    if (nrs[i].active) {
      ga = true;
      break;
    }
  }
  return ga;
}


// save the gui settings as txt file
void saveGuiSettings() {
  String[] guiSettings = new String[nrs.length];
  for (int i = 0; i < nrs.length; i++) {
    guiSettings[i] = nf(nrs[i].val);
  }
  saveStrings("settings.txt", guiSettings);
  guiIsExported = true;
  et = millis();
}


// load the gui settings from txt file
void loadGuiSettings() {
  File f = new File(sketchPath("settings.txt"));
  if (f.exists()) {
    String[] readSettings = loadStrings("settings.txt");
    for (int i = 0; i < readSettings.length; i++) {
      nrs[i].val = float(readSettings[i]);
    }
    guiIsLoaded = true;
    lt = millis();
  }
}


// remove the frame range slider from view
void clearFrameRangeSlider() {
  fill(225);
  noStroke();
  rect(100, height - 30, width, 30);
}


// the frame range slider
void frameRangeSlider() {
  clearFrameRangeSlider();
  stroke(0, 100);
  strokeWeight(1);
  line (100, height - 30, width, height - 30);

  float fullRange = width - 100 - 10 - 2;
  float off = fullRange / float(tr.length);

  //current frame
  float currentFramePos = 101 + f * off;
  noStroke();
  fill(0);
  rect(currentFramePos, height - 27, 10, 25);
}


// the gui
void Gui() {
  fill(225);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, 100, height);

  stroke(0, 100);
  strokeWeight(1);
  line(99, 0, 99, height);

  if (!isMousePainter && !isPointEditor) {

    frameRangeSlider();
  }

  for (int i = 0; i < nrs.length; i++) {
    nrs[i].update();
    if (nrs[i].timer) {
      if (millis() - nrs[i].tm > 250) {
        nrs[i].reset = false;
        nrs[i].timer = false;
      }
    }
  }

  // tie the gui to the variables
  dm = nrs[0].val; // distance modifier
  strm = nrs[1].val; // thick stroke modifier
  brm = nrs[2].val;  // break screen modifier
  psm = nrs[3].val; // particle scale modifier
  pvl = nrs[4].val; // particle velocity modifier
  dslwm = nrs[5].val; // distance slow down modifier
  startfr = int(nrs[6].val); // start frame modifier
  endfr = int(nrs[7].val); // end frame modifier

  if (guiIsExported) {
    noStroke();
    fill(0, 255, 0);
    rect(10, 10 + nrs.length * 27, 80, 25);
    fill(0);
    text("vrs saved", 20, 10 + nrs.length * 27 + 17);
    if (millis() - et > 1000) {
      guiIsExported = false;
    }
  }

  if (guiIsLoaded) {
    noStroke();
    fill(0, 255, 0);
    rect(10, 10 + nrs.length * 27, 80, 25);
    fill(0);
    text("vrs loaded", 20, 10 + nrs.length * 27 + 17);
    if (millis() - lt > 1000) {
      guiIsLoaded = false;
    }
  }

  if (imgIsSaved) {
    noStroke();
    fill(0, 255, 0);
    rect(10, 10 + nrs.length * 27, 80, 25);
    fill(0);
    text("img saved", 20, 10 + nrs.length * 27 + 17);
    if (millis() - st > 1000) {
      imgIsSaved = false;
    }
  }
}
