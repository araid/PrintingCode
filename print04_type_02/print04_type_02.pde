/*  Properties
 _________________________________________________________________ */
import controlP5.*;

ControlP5 cp5;
PGraphics canvas;
int canvas_width = 5100; //17x22 inches
int canvas_height = 6100;

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

  randomize();
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
  cp5.addSlider("centerRad", 250, 150).linebreak();
  cp5.addSlider("strokeInside", minStroke, maxStroke).linebreak();
  cp5.addSlider("strokeCenter", minStroke, maxStroke).linebreak();
  cp5.addSlider("strokeOutside", minStroke, maxStroke).linebreak();
  cp5.addSlider("separation", minSep, maxSep).linebreak();
  cp5.addSlider("globalScale", 0.0, 3.0).linebreak();
  cp5.addSlider("cap", 1, 3).linebreak();
  cp5.addButton("randomize").linebreak();
  cp5.addButton("saveImg").linebreak();
  cp5.addToggle("toggleT").linebreak();
}

void strokeInside(int val){
  strokes[0] = val;
}
void strokeCenter(int val){
  strokes[1] = val;
}
void strokeOutside(int val){
  strokes[2] = val;
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
// start1, stop1, start2, stop2, start3, stop3 from inside to outside
float[][][] letters = {
  {{0, 0}, {40, 320}, {40, 320}}, // C
  {{0, 0}, {0, 360}, {0, 360}}, // O  
  {{0,225}, {10, 45, 190, 225}, {130, 225, 310, 405}}, // N
  {{140, 220}, {140, 220}, {60, 140, 220, 300}}, // E
  {{70,110}, {70,110}, {220, 320}}, // T
  {{270, 450}, {270, 420}, {35,60}}, // R
  {{0, 360}, {0, 0}, {255, 285, 75, 105}}  // I
};

float globalScale = 1.0;
boolean toggleT = true;
int minStroke = 25;
int maxStroke = 75;
int minSep = 5;
int maxSep = 75;
int cap = 2;
int separation = 30;
int centerRad = 50;
int[] strokes = {
  60, 60, 60, 120
};

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
  canvas.background(255);
  canvas.noStroke();
  canvas.noFill();
  canvas.smooth();
  canvas.stroke(0);
  canvas.ellipseMode(RADIUS);
  if( cap == 1 ) canvas.strokeCap(ROUND);
  else if( cap == 2 ) canvas.strokeCap(SQUARE);
  else if( cap == 3 ) canvas.strokeCap(PROJECT);
      
  drawLetter( 0, canvas.width*0.20, canvas.height*0.25 );  // C
  drawLetter( 1, canvas.width*0.50, canvas.height*0.25 );  // O
  drawLetter( 2, canvas.width*0.80, canvas.height*0.25 );  // N
  drawLetter( 0, canvas.width*0.20, canvas.height*0.5 );   // C
  drawLetter( 3, canvas.width*0.50, canvas.height*0.5 );   // E
  drawLetter( 2, canvas.width*0.80, canvas.height*0.5 );   // N
  drawLetter( 4, canvas.width*0.20, canvas.height*0.75 );  // T
  drawLetter( 5, canvas.width*0.40, canvas.height*0.75 );  // R
  drawLetter( 6, canvas.width*0.60, canvas.height*0.75 );  // I
  drawLetter( 0, canvas.width*0.80, canvas.height*0.75 );  // C
  
  canvas.endDraw();
}

// randomizes random variables
void randomize() {
  strokes[0] = (int)random(minStroke,maxStroke);
  strokes[1] = (int)random(minStroke,maxStroke);
  strokes[2] = (int)random(minStroke,maxStroke);
  separation = (int)random(minSep, maxSep);
  centerRad = (int)random(5, 100);
}

void drawLetter( int i, float x, float y ) {
  float rad = centerRad+strokes[0]/2; 
  
  canvas.pushMatrix();
  canvas.translate(x, y);
  canvas.scale(globalScale);
  // access every circle
  for (int j=0; j<letters[i].length; j++ ) {
    canvas.strokeWeight( strokes[j] );
    
    // access every arc (pair of numbers) inside that circle
    for( int k=0; k<letters[i][j].length/2; k++ ){
      if ( letters[i][j][k] + letters[i][j][k+1] != 0 ) {
        canvas.arc(0, 0, rad, rad, radians(letters[i][j][k*2]), radians(letters[i][j][k*2+1]));
      }
    }
    rad += strokes[j]/2 + strokes[j+1]/2 + separation;
  }
  canvas.popMatrix();
}

