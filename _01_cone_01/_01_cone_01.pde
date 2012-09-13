/*  Properties
 _________________________________________________________________ */

PGraphics canvas;
int canvas_width = 3508;
int canvas_height = 4961;

float ratioWidth = 1;
float ratioHeight = 1;
float ratio = 1;

/*  Setup
 _________________________________________________________________ */

void setup()
{ 
  size(800, 600);
  background(128);

  canvas = createGraphics(canvas_width, canvas_height, P2D);
  calculateResizeRatio();
  drawCone();
  noLoop();
}

void draw() {
  float resizedWidth = (float) canvas.width * ratio;
  float resizedHeight = (float) canvas.height * ratio;
  image(canvas, (width / 2) - (resizedWidth / 2), (height / 2) - (resizedHeight / 2), resizedWidth, resizedHeight);
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


/* Design 
 ----------------------------------------------------------------- */
int bigdiam = 1500;
int middiam = 1350;
int smalldiam = 150;

int circy = 1900;
int tribase = 1600;
int triheight = 2000;
int triy= 2000;
int angle = 90;

void drawCone() {
  canvas.beginDraw();

  canvas.background(255);

  canvas.noStroke();
  canvas.stroke(255,0,0);
  canvas.strokeWeight(10);
  
  // big ellipse
  canvas.fill(100);
  canvas.ellipse(canvas.width/2 + (bigdiam - middiam)/2, circy, bigdiam, bigdiam);
  
  // rectangle to hide big ellipse
  
  // middle ellipse
  canvas.fill(0,120);
  canvas.ellipse(canvas.width/2, circy, middiam, middiam);
  
  // small ellipse
  canvas.fill(255);
  canvas.ellipse(canvas.width/2, circy - middiam/2 - smalldiam/2, smalldiam, smalldiam);
  
  // cone
  fill(0);
  canvas.triangle(canvas.width/2 - tribase/2, triy, canvas.width/2 + tribase/2, triy, canvas.width/2, triy + triheight);
  canvas.endDraw();
}

void keyPressed() {
  switch(keyCode) {
  case UP:
    circy -= 20;
    println(circy);
    break;
  case DOWN:
    circy += 20;
    println(circy);
    break;
   case LEFT:
    angle --;
    println(angle);
    break;
  case RIGHT:
    angle++;
    println(angle);
    break;
  case 32:
    canvas.save("grab"+month()+day()+minute()+second()+".png");
    println("frame saved");
    break;
  }
  drawCone();
  redraw();
}

