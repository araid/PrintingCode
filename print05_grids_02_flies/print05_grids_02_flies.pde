/*  Properties
 _________________________________________________________________ */
import controlP5.*;

ControlP5 cp5;
PGraphics canvas;
int canvas_width = 1659; //17x22 inches
int canvas_height = 2400;

float ratioWidth = 1;
float ratioHeight = 1;
float ratio = 1;


/*  Setup
 _________________________________________________________________ */

void setup()
{ 
  size(1300, 800);
  println(  PFont.list());

  canvas = createGraphics(canvas_width, canvas_height); // need P3D if we want to blend
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
  cp5.addSlider("numShapes", 1, 5).linebreak();
  cp5.addSlider("numFlies", 1, 25).linebreak();
  cp5.addSlider("flySize", 0.0, 150.0).linebreak();

  cp5.addSlider("fontSize", 40.0, 400.0).linebreak();
  cp5.addSlider("leadingSize", 40.0, 400.0).linebreak();
  cp5.addButton("regenerate").linebreak();
  cp5.addButton("saveTest").linebreak();
  cp5.addButton("saveImg").linebreak();
  cp5.addToggle("bGrid");
  cp5.addToggle("bTitle");
}

public void controlEvent(ControlEvent theEvent) {
  drawScreen();
}

void saveTest(int theValue ) {
  println("Saving test image");
  canvas.save("image_" + year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".png");
  println("Saved");
}

void saveImage(int theValue ) {
  println("Saving high quality image");
  canvas.save("image_" + year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".tiff");
  println("Saved");
}

void keyPressed()
{
  if (key == 's') saveImage(0);
}


/* Design
 ---------------------------------------------------------------- */
// design vars
boolean bGrid = false;
boolean bTitle = false;
boolean bFlies = true;
int numShapes = 4;
int numFlies = 6;
float angle = 15.0;
float fontSize = 180.0;
float leadingSize = 190.0;
float flySize = 50.0;
String title = "LORD OF THE FLIES";
String[] author = {"William", "Golding", "Penguin Classics"};
color[] palette;
PVector[] flies;

ModularGrid rowGrid;
ModularGrid diaGrid;
Module[] rowModules;
Module[] diaModules;

// regenerates random variables
void regenerate() {
  rowGrid = new ModularGrid(1, 12, 30, 0, 30, canvas.width, canvas.height);
  diaGrid = new ModularGrid(4, 6, 30, 0, 0, canvas.width, canvas.height);
  rowModules = new Module[3];
  diaModules = new Module[5];
  
  // chose row modules
  int row = floor(random(rowGrid.rows-1));
  rowModules[0] = rowGrid.getModule( 0, row );     //author first name
  rowModules[1] = rowGrid.getModule( 0, row+1 );   //author last name 
  if ( row > rowGrid.rows/2 ) row = 0;
  else row = rowGrid.rows-1;
  rowModules[2] = rowGrid.getModule( 0, row );   //book publisher

  // chose diagonal modules, 1 is text, the others are shapes
  diaModules[0] = diaGrid.getRandomModule(3, 3, false); //book title
  diaModules[1] = diaGrid.getRandomModule(3, 3, false);  
  diaModules[2] = diaGrid.getRandomModule(3, 3, false); 
  diaModules[3] = diaGrid.getRandomModule(3, 3, false); 
  diaModules[4] = diaGrid.getRandomModule(3, 3, false); 
  
  // create palette
  colorMode(HSB, 360, 100, 100 );
  palette = new color[5];
  float h = random(0,360);
  float s = 0;
  float b = 50;
  float a = 150; 
  for( int i=0; i<5; i++ ){
    palette[i] = color(h, s, b, a);
    s += 20;
    //b += 20;
  }
  
  // create flies aligned with diagonal grid
  flies = new PVector[25];
  for( int i=0; i<flies.length; i++ ){
    float offset = 25;
    Module m = diaGrid.modules[floor(random(diaGrid.cols))][floor(random(diaGrid.rows))];
    flies[i] = new PVector(m.x + random(-offset, offset), m.y + random(-offset, offset), random(2*PI));
  }
  
  // rotation angle
  angle = random(-20.0, 20.0);
  
}

// updates screen when called
void drawScreen() {
    colorMode(RGB, 255);
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
  
  // BACKGROUND - DIAGONAL GRID
  canvas.pushMatrix();
  canvas.translate(canvas.width/2, canvas.height/2);
  canvas.rotate(radians(angle));
  canvas.translate(-canvas.width/2, -canvas.height/2);
    
    for( int i=0; i<numShapes; i++ ){
      Module m = diaModules[i];
      if(i != 0 ){
        // draw bg boxes
        colorMode(HSB, 360, 100, 100 );
        canvas.fill(palette[i-1]);
        canvas.rect(m.x, m.y, m.w, m.h);
        colorMode(RGB, 255);
      }
      else{
        // draw title
        PFont font = createFont("Futura-CondensedExtraBold", fontSize);
        canvas.fill(0);
        if(bTitle){
          canvas.rect(m.x, m.y, m.w, m.h);
          canvas.fill(255);
        }
        canvas.textFont( font );
        canvas.textLeading(leadingSize);
        canvas.textAlign(LEFT);
        canvas.text(title, m.x, m.y, m.w, m.h);
      }   
    }
  canvas.popMatrix();

  // FOREGROUND - ROW GRID
  // draw author (with or without black box)
  PFont authorfont = createFont("Futura-Medium", rowModules[0].h*0.7);
  PFont publisherfont = createFont("Futura-Medium", rowModules[0].h/3); 

  for( int i=0; i<rowModules.length; i++ ){
     Module m = rowModules[i];
     canvas.textFont( publisherfont );
     canvas.textAlign(CENTER);
     canvas.fill(0);
     if( i!=2 ){
       canvas.rect(m.x, m.y, m.w, m.h);
       canvas.fill(255);
       canvas.textFont( authorfont );
     }
     canvas.text(author[i], m.x, m.y, m.w, m.h );
  }

  // draw flies
  if( bFlies ){
    for( int i=0; i<numFlies; i++ ){
      drawFly(flies[i]);
    }
  }

  // SHOW GRID
  if(bGrid){
    rowGrid.display(color(255, 0, 0, 100));
  
    canvas.pushMatrix();
    canvas.translate(canvas.width/2, canvas.height/2);
    canvas.rotate(radians(angle));
    canvas.translate(-canvas.width/2, -canvas.height/2);
    diaGrid.display(color(0, 0, 255, 100));
    canvas.popMatrix();
   }
  canvas.endDraw();
}

void drawFly( PVector fly ){
  canvas.rectMode(CENTER);
  canvas.pushMatrix();
  canvas.translate(canvas.width/2, canvas.height/2);
  canvas.rotate(radians(angle));
  canvas.translate(-canvas.width/2, -canvas.height/2);
  
  canvas.translate(fly.x, fly.y);
  canvas.rotate(fly.z);
  canvas.rect(0, 0, flySize, flySize);
  
  canvas.popMatrix();
  canvas.rectMode(CORNER);

}
