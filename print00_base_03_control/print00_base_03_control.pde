/*  App config
 _________________________________________________________________ */
import controlP5.*;

int canvas_width = 5100; //17x22 inches
int canvas_height = 5100;
float ratio = 1;
ControlP5 cp5;
PGraphics canvas;

void setup(){ 
  size(1300, 800);
  canvas = createGraphics(canvas_width, canvas_height);
  ratio = min(float) width / (float) canvas.width, (float) height / (float) canvas.height);  
  addControllers();
  regenerate();
  drawScreen();
}

void draw() {}

/* Interface and event management
 ---------------------------------------------------------------- */
public void addControllers() {
  cp5 = new ControlP5(this);
  cp5.addSlider("radius", 0, 1000).linebreak();
  cp5.addToggle("bCircle").linebreak();

  cp5.addButton("regenerate").linebreak();
  cp5.addButton("saveTest").linebreak();
  cp5.addButton("saveImage").linebreak();
}

public void controlEvent(ControlEvent theEvent) {
  drawScreen();
}

void saveTest(int theValue ) {
  println("Saving test image");
  canvas.save("test_" + year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".png");
  println("Saved");
}

void saveImage(int theValue ) {
  println("Saving high quality image");
  canvas.save("image_" + year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".tiff");
  println("Saved");
}

/* Design
 ---------------------------------------------------------------- */
// design vars
int radius = 300;
boolean bCircle = true;

// updates screen when called
void drawScreen() {
  background(100);
  drawCanvas();
  float resizedWidth = (float) canvas.width * ratio;
  float resizedHeight = (float) canvas.height * ratio;
  image(canvas, (width / 2) - (resizedWidth / 2), (height / 2) - (resizedHeight / 2), resizedWidth, resizedHeight);
}

// updates canvas
void drawCanvas() {
  canvas.beginDraw();
  canvas.noStroke();
  canvas.background(255);

  // draw stuff
  canvas.fill(255,0,0);
  canvas.ellipse(canvas.width/2, canvas.height/2, radius, radius);
  canvas.endDraw();
}

// regenerates random variables
void regenerate() {
  
}
