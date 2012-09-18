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

  canvas = createGraphics(canvas_width, canvas_height, P2D);
  calculateResizeRatio();
  drawCone();
  noLoop();
}

void draw() {  
  background(128);
 
  float resizedWidth = (float) canvas.width * ratio;
  float resizedHeight = (float) canvas.height * ratio;
  image(canvas, (width / 2) - (resizedWidth / 2), (height / 2) - (resizedHeight / 2), resizedWidth, resizedHeight);

  String s = "Play with arrows.\nSave with space\nShow strokes with S.";
  fill(50);
  text(s, 10, 10, 150, 150);
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
int bigdiam = 1935;
int middiam = 1350;
int circy = 1900;
int tribase = 1600;
int triheight = 2000;
int triy= 2000;
int angle = 95;
boolean bShowStrokes = false;

void drawCone() {
  canvas.beginDraw();
  canvas.background(255);

  if ( bShowStrokes ) {
    canvas.stroke(255, 0, 0); // for debugging
    canvas.strokeWeight(10);
  }
  else {
    canvas.noStroke();
  }

  // big ellipse
  canvas.fill(0);
  canvas.ellipse(canvas.width/2 + (bigdiam - middiam)/2, circy, bigdiam, bigdiam);

  // rectangle to hide big ellipse
  canvas.fill(255);
  canvas.pushMatrix();
  canvas.translate(canvas.width/2, circy);
  canvas.rotate(radians(-angle));
  canvas.rect(-canvas.width/2, 0, canvas.width, canvas.height/2);
  canvas.popMatrix();

  // middle ellipse
  canvas.fill(0);
  canvas.ellipse(canvas.width/2, circy, middiam, middiam);

  // small ellipse
  //I can't find the exact function to map the growth of the diameter in one ellipse to the other
  //float smalldiam = ((bigdiam - middiam)*cos(radians(angle)));
  int d = (int) (map(angle, 180, 0, 0, (bigdiam - middiam)));
  int smalldiam = (int) (d*d);
  float rad = middiam/2 + smalldiam/2;
  canvas.fill(255);
  canvas.ellipse(canvas.width/2 + rad*cos(radians(angle)), circy - rad*sin(radians(angle)), smalldiam, smalldiam);

  // cone
  canvas.fill(0);
  canvas.triangle(canvas.width/2 - tribase/2, triy, canvas.width/2 + tribase/2, triy, canvas.width/2, triy + triheight);
  canvas.endDraw();
}

void keyPressed() {
  switch(keyCode) {
  case UP:
    bigdiam += 15;
    println(bigdiam);
    break;
  case DOWN:
    bigdiam -= 15;
    println(bigdiam);
    break;
  case LEFT:
    angle += 2;
    println(angle);
    break;
  case RIGHT:
    angle -= 2;
    println(angle);
    break;
  }
  if ( key == 's' ) {
    bShowStrokes = !bShowStrokes;
  }
  else if ( key == ' ' ) {
    canvas.save("grab"+month()+day()+minute()+second()+".png");
    println("frame saved");
  }

  drawCone();
  redraw();
}

