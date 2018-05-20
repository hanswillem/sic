// a = previous frame
// s = next frame
// ] = goto next keyframe boundry
// [ = goto previous keyframe boundryj
// spacebar = start / stop play forward
// j = play backward (press repeatedly to speed up)
// k = play forward (press repeatedly to speed up)
// l = stop playing
// h = show / hide hud
// c = reset all
// e = export results to export.txt in sketch folder
// r = read exported txt file
// arrow keys = nudge by 1 pixel


import java.io.File;


PImage cf;
int f, et, lt, ps;
String[] filenames, te;
PVector[] t;
boolean rec[], hud, isExported, playingForward, playingBackward, isLoaded;


void setup() {
  size(720, 960);
  background(0);
  noStroke();
  fill(255);

  File hiddenFile = new File(dataPath(".DS_Store"));
  if (hiddenFile.exists()) {
    hiddenFile.delete();
  }

  java.io.File folder = new java.io.File(dataPath(""));
  filenames = folder.list();
  t = new PVector[filenames.length];
  te = new String[filenames.length * 2];
  rec = new boolean[filenames.length];
  resetAll();
  f = 0;
  loadFrame();
  hud = true;
  isExported = false;
  isLoaded = false;
  playingForward = false;
  ps = 0;
}


void draw() {
  image(cf, 0, 0);
  if ((playingForward) || (playingBackward)) {
    playback();
  } else {
    drawCross();
  }
  if (hud) {
    showHud();
  }
  if (mousePressed) {
    rec[f] = true;
    t[f].x = mouseX;
    t[f].y = mouseY;
    noCursor();
  }
}


void mouseReleased() {
  cursor(ARROW);
}


void keyPressed() {
  //println(keyCode);
  if (keyCode == 83) {
    if (f < filenames.length - 1) {
      f += 1;
      loadFrame();
      checkNextFrame();
    }
  }
  if (keyCode == 65) {
    if (f > 0) {
      f -= 1;
      loadFrame();
      checkPreviousFrame();
    }
  }
  if (keyCode == 67) {
    resetAll();
  }
  if (keyCode == 93) {
    gotoNextFrameBoundry();
  }
  if (keyCode == 91) {
    gotoPreviousFrameBoundry();
  }
  if (keyCode == 37) {
    rec[f] = true;
    t[f].x -= 1;
  }
  if (keyCode == 39) {
    rec[f] = true;
    t[f].x += 1;
  }
  if (keyCode == 38) {
    rec[f] = true;
    t[f].y -= 1;
  }
  if (keyCode == 40) {
    rec[f] = true;
    t[f].y += 1;
  }
  if (keyCode == 72) {
    hud = !hud;
  }
  if (keyCode == 69) {
    export();
  }
  if (keyCode == 76) {
    if (playingBackward) {
      ps = 0;
    }
    ps += 1;
    playingBackward = false;
    playingForward = true;
  }
  if (keyCode == 75) {
    playingForward = false;
    playingBackward = false;
    ps = 0;
  }
  if (keyCode == 74) {
    if (playingForward) {
      ps = 0;
    }
    ps += 1;
    playingForward = false;
    playingBackward = true;
  }
  if (keyCode == 82) {
    loadFile();
  }
  if (keyCode == 32) {
    ps = 1;
    playingForward = !playingForward;
  }
}


void loadFrame() {
  cf = loadImage(filenames[f]);
}


void writeFrameNumber() {
  if (rec[f]) {
    fill(0, 255, 0);
  } else {
    fill(255, 0, 0);
  }
  noStroke(); 
  rect(0, 0, 50, 30); 
  noStroke(); 
  fill(0); 
  text(f, 10, 20);
}


void drawCross() {
  noFill(); 
  stroke(255); 
  line(t[f].x, t[f].y - 25, t[f].x, t[f].y + 25); 
  line(t[f].x - 25, t[f].y, t[f].x + 25, t[f].y); 
  stroke(0, 100); 
  line(t[f].x - 20, t[f].y - 20, t[f].x + 20, t[f].y + 20); 
  line(t[f].x - 20, t[f].y + 20, t[f].x + 20, t[f].y - 20);
}


void checkNextFrame() {
  if (f > 0) {
    if (!rec[f] && rec[f - 1]) {
      t[f] = new PVector(t[f - 1].x, t[f - 1].y);
    }
  }
}


void checkPreviousFrame() {
  if (f < te.length) {
    if (!rec[f] && rec[f + 1]) {
      t[f] = new PVector(t[f + 1].x, t[f + 1].y);
    }
  }
}


void gotoNextFrameBoundry() {
  if (rec[f]) {
    for (int i = f; i < rec.length; i++) {
      if (!rec[i]) {
        f = i;
        loadFrame();
        checkNextFrame();
        break;
      }
    }
  } else {
    for (int i = f; i < rec.length; i++) {
      if (rec[i]) {
        f = i;
        loadFrame();
        checkNextFrame();
        break;
      }
    }
  }
}


void gotoPreviousFrameBoundry() {
  if (rec[f]) {
    for (int i = f; i >= 0; i--) {
      if (!rec[i]) {
        f = i;
        loadFrame();
        checkPreviousFrame();
        break;
      }
    }
  } else {
    for (int i = f; i >= 0; i--) {
      if (rec[i]) {
        f = i;
        loadFrame();
        checkPreviousFrame();
        break;
      }
    }
  }
}


void drawTimeline() {
  noStroke();
  float w = float(width) / float(t.length);
  for (int i = 0; i < t.length; i++) {
    if (rec[i]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(i * w, height - 10, w, 10);
  }
  noFill();
  stroke(0);
  rect(f * w, height - 11, w, 10);
}


void showHud() {
  writeFrameNumber();
  drawTimeline();
  if (isExported) { 
    if (millis() - et < 1500) {
      writeExported();
    } else {
      isExported = false;
    }
  }
  if (isLoaded) { 
    if (millis() - lt < 1500) {
      writeLoaded();
    } else {
      isLoaded = false;
    }
  }
}


void writeExported() {
  noStroke();
  fill(0, 255, 0);
  rect(51, 0, 135, 30);
  fill(0);
  text("results exported", 70, 20);
}


void writeLoaded() {
  noStroke();
  fill(0, 255, 0);
  rect(51, 0, 100, 30);
  fill(0);
  text("file loaded", 70, 20);
}


void playback() {
  if (playingForward) {
    if (f + ps < t.length) {
      f += ps;
    } else {
      f = t.length - 1;
      ps = 0;
      playingForward = false;
    }
  }
  if (playingBackward) {
    if (f - ps >= 0) {
      f -= ps;
    } else {
      f = 0;
      ps = 0;
      playingBackward = false;
    }
  }
  loadFrame();
}


void resetAll() {
  loadFrame();
  for (int i = 0; i < t.length; i++) {
    t[i] = new PVector(width/2, height/2);
  }
  for (int i = 0; i < rec.length; i++) {
    rec[i] = false;
  }
}


void export() {
  int counter = 0;
  for (int i = 0; i < t.length; i++) {
    if (rec[i]) {
      te[counter] = nf(t[i].x);
      te[counter + 1] = nf(t[i].y);
    } else {
      te[counter] = "null";
      te[counter + 1] = "null";
    }
    counter += 2;
  }
  saveStrings("export.txt", te);
  isExported = true;
  isLoaded = false;
  et = millis();
}


void loadFile() {
  File f = new File(sketchPath("export.txt"));
  if (f.exists()) {
    resetAll(); 
    String readExport[] = loadStrings("export.txt");
    int counter = 0;
    for (int i = 0; i < t.length; i++) {   
      if (readExport[counter].equals("null") == false) {
        t[i].x = float(readExport[counter]);
        rec[i] = true;
      } else {
        t[i].x = width / 2;
        rec[i] = false;
      }
      if (readExport[counter + 1].equals("null") == false) {
        t[i].y = float(readExport[counter + 1]);
        rec[i] = true;
      } else {
        t[i].y = height / 2;
        rec[i] = false;
      }
      counter += 2;
    }
  }
  isLoaded = true;
  isExported = false;
  lt = millis();
}