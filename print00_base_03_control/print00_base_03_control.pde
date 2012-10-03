/*  Properties
 _________________________________________________________________ */
import controlP5.*;

ControlP5 cp5;
PGraphics canvas;
int canvas_width = 5100; //17x22 inches
int canvas_height = 5100;

float ratioWidth = 1;
float ratioHeight = 1;
float ratio = 1;


/*  Setup
 _________________________________________________________________ */

void setup()
{ 
  size(1300, 800);
  canvas = createGraphics(canvas_width, canvas_height);
  calculateResizeRatio();
  addControllers();

  regenerate();
  drawScreen();
}

void draw() {
  // needs to be here looping for ControlP5
}

/*  Calculate resizing
 _________________________________________________________________ */
void calculateResizeRatio()
{
  ratioWidth = (float) width / (float) canvas.width;
  ratioHeight = (float) height / (float) canvas.height;

  if (ratioWidth < ratioHeight)  ratio = ratioWidth;
  else                          ratio = ratioHeight;
}

/* Interface and event management
 ---------------------------------------------------------------- */
public void addControllers() {
  cp5 = new ControlP5(this);
  cp5.addSlider("sliderS", 0, 25).linebreak();

  cp5.addButton("regenerate").linebreak();
  cp5.addButton("saveImg").linebreak();
  cp5.addToggle("toggleT").linebreak();
}

public void controlEvent(ControlEvent theEvent) {
  drawScreen();
}

void saveImg(int theValue ) {
  saveImage();
}

void keyPressed()
{
  if (key == 's') saveImage();
  //if (key == 'h') cp5.h;
}
void saveImage() {
  println("Saving Image");
  canvas.save("image_" + year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".tiff");
  println("Saved Image");
}


/* Design
 ---------------------------------------------------------------- */
// design vars
int sliderA = 3;
boolean toggleT = true;

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
  canvas.ellipse(canvas.width/2, canvas.height/2, canvas.width/2, canvas.width/2);
  canvas.endDraw();
}

// regenerates random variables
void regenerate() {
  
}


