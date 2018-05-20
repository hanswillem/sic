// d (while hovering over a number box) = reset to default value
// e = export variables to txt file
// r = read variables from (exported) txt file


float youSketchVal01, youSketchVal02, youSketchVal03;
float et, lt;
Number[] nrs;
boolean guiActive, guiIsExported, guiIsLoaded;
String[] guiSettings;


void setup() {
  size(820, 960);
  background(225);

  textSize(12);
  nrs = new Number[3];
  guiSettings = new String[nrs.length];
  guiActive = false;
  setupGui();
}


void draw() {
  Gui();
}


void keyPressed() {
  if (keyCode == 68) {
    resetGuiVariables();
  }
  if (keyCode == 69) {
    saveGuiSettings();
  }
  if (keyCode == 82) {
    loadGuiSettings();
  }
}


void setupGui() {
  float y = 10; 
  for (int i = 0; i < nrs.length; i++) {
    nrs[i] = new Number(10, y, 0);
    y += 27;
  }

  // example 01
  nrs[0].name = "var 01"; 
  nrs[0].val = 1;
  nrs[0].valDefault = 1;
  nrs[0].st = .01;

  // example 02
  nrs[1].name = "var 02"; 
  nrs[1].val = 10;
  nrs[1].valDefault = 10;
  nrs[1].st = 1;

  // example 03
  nrs[2].name = "var 03"; 
  nrs[2].val = 100;
  nrs[2].valDefault = 100;
  nrs[2].st = 10;

}


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


void mousePressed() {
  for (int i = 0; i < nrs.length; i++) {
    if (mouseX > nrs[i].x && mouseX < nrs[i].x + nrs[i].w && mouseY > nrs[i].y && mouseY < nrs[i].y + nrs[i].h) {
      nrs[i].active = true;
    }
  }
}


void mouseReleased() {
  for (int i = 0; i < nrs.length; i++) {
    nrs[i].active = false;
  }
}


void getGuiActive() {
  for (int i = 0; i < nrs.length; i++) {
    if (nrs[i].active) {
      guiActive = true;
      break;
    }
    guiActive = false;
  }
}


void saveGuiSettings() {
  for (int i = 0; i < nrs.length; i++) {
    guiSettings[i] = nf(nrs[i].val);
  }
  saveStrings("settings.txt", guiSettings);
  guiIsExported = true;
  et = millis();
}


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


void Gui() {
  fill(225);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, 100, height);
  stroke(0, 100);
  strokeWeight(1);
  line(99, 0, 99, height);

  for (int i = 0; i < nrs.length; i++) {
    nrs[i].update();
    if (nrs[i].timer) {
      if (millis() - nrs[i].tm > 250) {
        nrs[i].reset = false;
        nrs[i].timer = false;
      }
    }
  }


  // bind the sketch variables to the numberboxes here
  youSketchVal01 = nrs[0].val; 
  youSketchVal02 = nrs[1].val; 
  youSketchVal03 = nrs[2].val; 


  if (guiIsExported) {
    noStroke();
    fill(0, 255, 0);
    rect(10, height - 35, 80, 25);
    fill(0);
    text("vrs saved", 20, height - 35 + 17);
    if (millis() - et > 1000) {
      guiIsExported = false;
    }
  }


  if (guiIsLoaded) {
    noStroke();
    fill(0, 255, 0);
    rect(10, height - 35, 80, 25);
    fill(0);
    text("vrs loaded", 20, height - 35 + 17);
    if (millis() - lt > 1000) {
      guiIsLoaded = false;
    }
  }
}