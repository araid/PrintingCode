/*
Key-commands
 ALT-mouseMove move controllers
 ALT-h show and hide controllers
 ALT-shift-s save controller setup in an properties-document
 ALT-shift-l load a controller setup from a properties-document
 */
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
  background(80);

  addControllers();
  canvas = createGraphics(canvas_width, canvas_height);
  recolor();
  regenerate();
}

void draw() {
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
  cp5.addSlider("numBars", 0, 50).linebreak();
  cp5.addSlider("numStripes", 0, 50).linebreak();
  cp5.addSlider("barWidth", 0, 6000).linebreak();
  cp5.addSlider("paletteLength", 0, 10).linebreak();

  cp5.addButton("regenerate").linebreak();
  cp5.addButton("recolor").linebreak();
  cp5.addButton("saveImg").linebreak();
  cp5.addToggle("useGradients").linebreak();
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
int numBars = 3;
int numStripes = 15;
int barWidth = 2300;
int paletteLength = 4;
HSBColor[] palette;

void regenerate() {
  drawCanvas();
  calculateResizeRatio();
  float resizedWidth = (float) canvas.width * ratio;
  float resizedHeight = (float) canvas.height * ratio;
  image(canvas, (width / 2) - (resizedWidth / 2), (height / 2) - (resizedHeight / 2), resizedWidth, resizedHeight);
}

void recolor() {
  palette = new HSBColor[paletteLength];
  int h = (int)random(360);
  int s;
  int b;

  // create 4 analogous colors separated by 15 degrees. I don't know whether to make brighness fixed or random
  for ( int i=0; i<palette.length-1; i++ ) {
    s = (int)random(0,100);
    b = (int)random(20,80);
    palette[i] = new HSBColor((h + 30*i)%360, s, b );
  }

  // ad 1 color complementary to one of the previous
  h = palette[floor(random(palette.length-1))].h;
  h = (h + 180)%360;
  s = (int)random(20,100);
  b = (int)random(20,80);
  palette[palette.length-1] = new HSBColor(h, s, b);

  for ( int i=0; i<palette.length; i++ ) {
    palette[i].display(width - 30 - 20*i, 10, 20, 20);
  }
}

void drawCanvas() {
  canvas.beginDraw();
  canvas.rectMode(CENTER);
  canvas.colorMode(HSB, 360, 100, 100);
  canvas.noStroke();
  HSBColor c = palette[(int)random(palette.length-1)];
  canvas.background(c.h, c.s, c.b);

  // draw bars
  for ( int i=0; i<numBars; i++) {
    canvas.pushMatrix();
    canvas.translate(canvas.width/2, canvas.height/2); // move to center
    canvas.rotate(random(2*PI)); // rotate
    canvas.translate(random(  canvas.width), 0); //move somewhere away from center
    drawBar();
    canvas.popMatrix();
  }
  canvas.endDraw();
}

void drawBar() {

  int stripeWidth = barWidth/numStripes;
  int col=0, newcol=0;
  for ( int i=0; i<numStripes; i++ ) {
    while( newcol == col ){
      newcol = (int)random(palette.length);
    }
    col = newcol;
    HSBColor c = palette[col];
    canvas.fill(c.h, c.s, c.b);
    //canvas.fill(random(255));
    canvas.rect( -barWidth/2 + (stripeWidth-1)*i, 0, stripeWidth, canvas.height*10);
  }
}

