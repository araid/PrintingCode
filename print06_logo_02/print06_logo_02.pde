/*  Properties
 _________________________________________________________________ */
import controlP5.*;
import geomerative.*;

ControlP5 cp5;
PGraphics canvas;
int canvas_width = 4500; //15x15 inches
int canvas_height = 4500;

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
  // initialize the geomerative library
  RG.init(this);
  regenerate();
  drawScreen();
}

void draw() {
  // needs to be here looping for ControlP5
  drawScreen();
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
  cp5.addSlider("segmentLength", 0.0, 200.0).linebreak();
  cp5.addSlider("dispersion", 0.0, 50.0).linebreak();
  cp5.addButton("regenerate").linebreak();
  cp5.addButton("saveTest").linebreak();
  cp5.addButton("saveImage").linebreak();
  cp5.addToggle("debug").linebreak();
  cp5.addToggle("white").linebreak();
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
boolean debug = true;
boolean white = true;
int numLines = 20;
int numSegments = 20;
float dispersion = 0.3;
float segmentLength = 9.0;
float space = 15;
PVector attractor;
PVector lines[][]; //[numLines][numSegments]
RFont font;
RGroup fontgrp;
RPoint[] fontpnts;

// regenerates random variables
void regenerate() {
  // Font setup
  font = new RFont("Arial Bold Italic.ttf", 680, RFont.CENTER);
  RCommand.setSegmentLength(100);

  // tell the library that the points should have same distance
  //RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  //RCommand.setSegmentator(RCommand.UNIFORMSTEP);
  //RCommand.setSegmentator(RCommand.ADAPTATIVE);  

  // get the points on font outline.
  fontgrp = font.toGroup("HEAT");
  fontgrp = fontgrp.toPolygonGroup();
  fontpnts = fontgrp.getPoints();

  int numPoints = numLines = fontpnts.length;

  // lines setup
  lines = new PVector[numPoints][numSegments];
  attractor = new PVector( random(-canvas.width/2, canvas.width/2), random(-canvas.height/2, canvas.height/2));

  for (int i=0; i<numLines; i++) { // for each line
    for (int j=0; j<numSegments; j++) { // for each segment
      //lines[i][j] = new PVector(i * space, map(j, 0, numSegments, 0.0, 0.5));
      lines[i][j] = new PVector(fontpnts[i].x, fontpnts[i].y + map(j, 0, numSegments, 0.0, 0.5));

    }
  }
}



// updates canvas
void drawCanvas() {

  // update pseudo flames

    // for each line
  for (int i=0; i<numLines; i++) {

    // set its initial position
    float x = fontpnts[i].x;
    float y = fontpnts[i].y;
    PVector direction = new PVector( attractor.x - lines[i][1].x, attractor.y - lines[i][1].y);
    direction.normalize();

    lines[i][0].set(x, y, 0); // set init pos
    lines[i][1].set(x+random(-dispersion, dispersion), y+random(-dispersion, dispersion), 0); // set first segment x and y randomly
    lines[i][1].y += direction.y; // stablish direction of y (-1 MEANS UP)            
    lines[i][1].x += direction.x; // stablish direction of y (-1 MEANS UP)            

    // for each segment of each thread, starting with 3rd segment
    for (int j=2; j<numSegments; j++) {
      PVector vec = PVector.sub(lines[i][j], lines[i][j-2]); // create vector from himself - 2 points erlier
      vec.normalize();
      vec.mult(segmentLength);

      lines[i][j] = PVector.add(lines[i][j-1], vec); // calculate new position
    }
  }

  // quick hack: for each 2 lines, we make their points closer from end to beggining

  // for each line
 /* for (int i=0; i<numLines; i+=2) {
    for (int j=0; j<numSegments; j++) {
      PVector vec = PVector.sub(lines[i][j], lines[i+1][j]); 
      //vec.mult(closeFactor);

      float closeFactor = map(float(j), 0.0, float(numSegments-1), 0.0, 0.5);
      float x1 = lines[i][j].x;
      float y1 = lines[i][j].y;
    }
  }*/

  // draw flames
  canvas.beginDraw();
  canvas.noStroke();
  canvas.background(255);

  canvas.pushMatrix();
  canvas.translate(canvas.width/2, canvas.height/2);
  canvas.stroke(0);

  // attractor
  canvas.fill(200);
      canvas.noStroke();
  if (debug) canvas.ellipse(attractor.x, attractor.y, 50, 50);

  // the lines
  canvas.noFill();
  canvas.stroke(0);
  canvas.strokeWeight(10);
  for (int i=0; i<numLines; i++) {

    canvas.beginShape();
    for (int j=0; j<numSegments; j++) {
      canvas.curveVertex(lines[i][j].x, lines[i][j].y);
      //canvas.vertex(lines[i+1][j].x, lines[i+1][j].y);
    }
    canvas.endShape();
  }
  canvas.popMatrix();  

  // draw text
  canvas.pushMatrix();  
  canvas.translate(canvas.width/2, canvas.height/2);
  if(white) canvas.fill(255);
  else canvas.fill(0);
  canvas.noStroke();
  font.draw("HEAT", canvas);

  if(debug) for(int i=0; i<fontpnts.length; i++){
    canvas.noStroke();
    canvas.fill(200);
    canvas.ellipse(fontpnts[i].x, fontpnts[i].y, 20, 20);

  }
  canvas.popMatrix();

  canvas.endDraw();
}


// updates screen when called
void drawScreen() {
  background(100);
  drawCanvas();
  float resizedWidth = (float) canvas.width * ratio;
  float resizedHeight = (float) canvas.height * ratio;
  image(canvas, (width / 2) - (resizedWidth / 2), (height / 2) - (resizedHeight / 2), resizedWidth, resizedHeight);
}

