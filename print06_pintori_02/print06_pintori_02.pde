/*  Properties
 _________________________________________________________________ */
import controlP5.*;
import toxi.util.datatypes.*;

ControlP5 cp5;
PGraphics canvas;
int canvas_width = 2550; //2550 x 3600 px = 8.5 x 12 inches
int canvas_height = 3600;

float ratioWidth = 1;
float ratioHeight = 1;
float ratio = 1;


/*  Setup
 _________________________________________________________________ */

void setup() { 
  size(1300, 800);
  canvas = createGraphics(canvas_width, canvas_height);
  calculateResizeRatio();
  addControllers();

  // setup consoles
  String [] buttons = { 
    "A", "B", "left", "right", "up", "down"
  };
  color  [] colors = { 
    color(#cc2229)
  };
  nes = new Console("NES", "NES.jpg", buttons, colors );

  String [] buttons2 = { 
    "A", "B", "left", "right", "up", "down", "left", "right", "up", "down"
  };
  color [] colors2  = { 
    color(#069330), color(#fe2015), color(#ffc001), color(#0222a9)
  };
  n64 = new Console("N64", "N64.jpg", buttons2, colors2 );

  String[] buttons3 = { 
    "X", "O", "square", "triangle", "left", "right", "up", "down"
  };
  color [] colors3 = { 
    color(#d92749), color(#249b8d), color(#0185c6), color(#c450b3)
  };
  psx = new Console("PSX", "PSX.jpg", buttons3, colors3 );

  currentConsole = nes;

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
  cp5.addSlider("margin", 0, 200.0).setPosition(10, 40);
  cp5.addSlider("diam", 50.0, 250.0).setPosition(10, 60);
  cp5.addButton("regenerate").setPosition(10, 80);
  cp5.addButton("reShape").setPosition(10, 110);
  cp5.addButton("reColor").setPosition(10, 140);
  cp5.addButton("reSign").setPosition(10, 170);
  cp5.addButton("saveTest").setPosition(10, 200);
  cp5.addButton("saveImage").setPosition(10, 230);

  cp5.addRadioButton("theme")
    .setPosition(10, 10)
      .setSize(40, 20)
        .setItemsPerRow(3)
          .setSpacingColumn(30)
            .addItem("nes", 0)
              .addItem("n64", 1)
                .addItem("psx", 2)
                  ;
   //r.activate(0);
}

public void controlEvent(ControlEvent theEvent) {
  drawScreen();
}

public void theme( int theValue ) {
  switch(theValue) {
  case 0: 
    currentConsole = nes; 
    break;
  case 1: 
    currentConsole = n64; 
    break;
  case 2: 
    currentConsole = psx; 
    break;
  }
  regenerate();
}



void saveTest(int theValue) {
  println("Saving test image");
  canvas.save("test_" + year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".png");
  println("Saved");
}

void saveImage(int theValue) {
  println("Saving high quality image");
  canvas.save("image_" + year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".tiff");
  println("Saved");
}

/* Design vars
 ---------------------------------------------------------------- */
float margin = 100.0;
float diam = 100.0;

ArrayList <ArrayList> curves;
ArrayList <String> signs;
ArrayList <Integer> colors;

Console nes, n64, psx, currentConsole;

/* Drawing Functions
 ---------------------------------------------------------------- */

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
  canvas.smooth();

  // draw background
  canvas.fill(240);
  canvas.noStroke();
  canvas.rect(margin, margin, canvas.width-margin*2, canvas.height-margin*2);

  // draw photo
  float w = canvas.width - margin*2 ;
  float rat = w / currentConsole.img.width;
  float h = (int)(rat * (float)currentConsole.img.height);  
  canvas.blend(currentConsole.img, 0, 0, currentConsole.img.width, currentConsole.img.height, 100, canvas.height/2, (int)w, (int)h, MULTIPLY);

  // draw curves
  canvas.fill(255, 0, 0);
  canvas.noFill();
  canvas.strokeWeight(diam);

  for (int j=0; j< curves.size(); j++ ) {
    canvas.stroke(colors.get(j), 240);
    ArrayList <PVector> crv = (ArrayList<PVector>) curves.get(j);
    for (int i=0; i<crv.size()-3; i+= 3) {
      canvas.bezier(crv.get(i).x, crv.get(i).y, crv.get(i+1).x, crv.get(i+1).y, crv.get(i+2).x, crv.get(i+2).y, crv.get(i+3).x, crv.get(i+3).y);
    }
  }

  // draw circles
  int signIndex = 0;
  for (int i=0; i<curves.size(); i++ ) {
    ArrayList <PVector> crv = (ArrayList<PVector>) curves.get(i);
    for (int j=0; j<crv.size(); j+= 3) {
      // black circle
      canvas.fill(10);
      canvas.noStroke();
      canvas.ellipse(crv.get(j).x, crv.get(j).y, diam+1, diam+1);
      if (i==crv.size()-3) canvas.ellipse(crv.get(i+2).x, crv.get(i+2).y, diam+1, diam+1);

      // sign
      drawSign(signIndex, crv.get(j).x, crv.get(j).y);
      signIndex++;
    }
  }
  canvas.endDraw();
}

void drawSign( int i, float x, float y ) {
  String s = signs.get(i);
  canvas.fill(255);
  canvas.stroke(255);
  canvas.strokeWeight(7);

  if (s == "O" ) {
    canvas.noFill();
    canvas.ellipse(x, y, diam/2, diam/2 );
  }
  else if (s  == "square") {
    canvas.noFill();
    canvas.rectMode(CENTER);
    canvas.rect(x, y, diam/2, diam/2 );
  }
  else if (s == "X" ) {
    float r = diam/4;
    canvas.noFill();
    canvas.line(x-r, y-r, x+r, y+r );
    canvas.line(x-r, y+r, x+r, y-r );
  }
  else if (s == "triangle" ) {
    canvas.noFill();
    drawTriangle(x, y, 0, diam/3);
  }

  else if (s  == "left") {
    canvas.fill(255);
    drawTriangle(x, y, 90, diam/5);
  }
  else if (s  == "right") {
    canvas.fill(255);
    drawTriangle(x, y, -90, diam/5);
  }
  else if (s  == "up") {
    canvas.fill(255);
    drawTriangle(x, y, 0, diam/5);
  }
  else if (s  == "down") {
    canvas.fill(255);
    drawTriangle(x, y, 180, diam/5);
  }
  else {
    canvas.fill(255);
    canvas.textFont(createFont("HelveticaNeue-Bold", 64));
    canvas.textAlign(CENTER, CENTER);
    canvas.text(s, x, y-diam/10);
  }
}

void drawTriangle( float x, float y, float rotation, float r) {
  canvas.pushMatrix();
  canvas.translate(x, y);
  canvas.rotate(radians(rotation));
  canvas.triangle(cos(radians(-90))*r, sin(radians(-90))*r, cos(radians(-210))*r, sin(radians(-210))*r, cos(radians(-330))*r, sin(radians(-330))*r);
  canvas.popMatrix();
}


/* Randomizing Functions--------------------------------------------------------- */
void regenerate() {
  reShape();
  reColor();
  reSign();
}

void reShape() {
  // randomize separation
  WeightedRandomSet<Integer> randSeparationX = new WeightedRandomSet<Integer>();
  WeightedRandomSet<Integer> randSeparationY = new WeightedRandomSet<Integer>();
  WeightedRandomSet<Integer> randBounceY = new WeightedRandomSet<Integer>();

  randSeparationX.add(300, 100).add(500, 100).add(700, 50).add(-300, 25);
  randSeparationY.add(100, 2).add(300, 2).add(500, 1).add(-100, 2).add(-300, 2).add(-500, 1);
  randBounceY.add(400, 1).add(600, 1);
  
  // create x random points and curves
  int numPoints = currentConsole.buttons.length;
  int numCurves = 1;
  if (numPoints > 6 )  numCurves = (int)(numPoints/4);
  int pointsPerCurve =  numPoints / numCurves;
  println("numPoints: " + numPoints + " numCurves: " + numCurves + " pointsPerCurve: " + pointsPerCurve );

  curves = new ArrayList<ArrayList>();
  for ( int j=0; j< numCurves; j++ ) {
    ArrayList <PVector> crv = new ArrayList();
    curves.add(crv);

    for (int i=0; i<pointsPerCurve; i++ ) {
      float x, y;
      if (i == 0) {
        // create 1st point of the curve
        x = random(canvas.width/pointsPerCurve);
        y = random(canvas.height/2) + canvas.height/4;
        PVector newPoint = new PVector(x, y);
        crv.add(newPoint);
      }
      else {
        // create new point and bezier control points
        PVector prevPoint = crv.get(crv.size()-1);
        x = prevPoint.x + randSeparationX.getRandom();
        y = prevPoint.y + randSeparationY.getRandom();
        PVector newPoint = new PVector(x, y);
        PVector control1 = new PVector();
        PVector control2 = new PVector();

        control1.x = prevPoint.x;    
        control2.x = newPoint.x;
        if ( prevPoint.y < newPoint.y ) control1.y = control2.y = prevPoint.y - randBounceY.getRandom();
        else                           control1.y = control2.y = newPoint.y - randBounceY.getRandom();


        crv.add(control1);
        crv.add(control2);
        crv.add(newPoint);
      }
    }
  }
}


void reSign() {
  WeightedRandomSet<String> randomSigns = new WeightedRandomSet<String>();
  for (int i=0; i<currentConsole.buttons.length; i++) {
    randomSigns.add( currentConsole.buttons[i], 1);
  }

  signs = new ArrayList();

  for (int i=0; i<currentConsole.buttons.length; i++) {
    String s = randomSigns.getRandom(); 
    signs.add(s);
    randomSigns.remove(s);
  }
}

void reColor() {
  WeightedRandomSet<Integer> randomColors = new WeightedRandomSet<Integer>();
  for (int i=0; i<currentConsole.colors.length; i++) {
    randomColors.add( new Integer(currentConsole.colors[i]), 1);
  }

  colors = new ArrayList();

  for (int i=0; i<curves.size(); i++) {
    Integer col = randomColors.getRandom();
    colors.add(col);
    randomColors.remove(col);
  }
}

