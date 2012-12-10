static final int ORIENTATION_LEFT = 0;
static final int ORIENTATION_RIGHT = 1;

void setup()
{
  size(2400, 2400);
  smooth();
  //colorMode(HSB, 360, 100, 100);
  background(255);
  noStroke();

  drawSquare(width/2, width/2, width, getRandomOrientation(), getRandomColor(), getRandomColor());
}

void draw() {
}

void drawSquare(float x, float y, float siz, float orientation, color c1, color c2)
{
  if (siz > 30) {
    //noStroke();
    //stroke(10);
    noFill();

    pushMatrix();
    translate(x, y);
    rotate(orientation);

    fill(c1, 20);
    triangle( -siz/2, -siz/2, -siz/2, siz/2, siz/2, siz/2 ); 
    fill(c2, 20);
    triangle( -siz/2, -siz/2, siz/2, -siz/2, siz/2, siz/2); 

    drawSquare(-siz/4, -siz/4, siz/2, 0.0, c1, c2);                        // top left
    drawSquare(siz/4, siz/4, siz/2, 0.0, c1, c2);                    // bottom right
    drawSquare(-siz/4, siz/4, siz/2, getRandomOrientation(), c1, c2);   // bottom left
    drawSquare(siz/4, -siz/4, siz/2, getRandomOrientation(), c1, c2);   // top right
    
    popMatrix();

  }
}

float getRandomOrientation() {
  if (random(1) > 0.5) return 0.0;
  else                return PI/2;
}

int getRandomColor(){
  return color(random(255), random(255), random(255));
}
void keyPressed(){
  if(key == ' '){
      background(128);
    drawSquare(width/2, width/2, width, getRandomOrientation(), getRandomColor(), getRandomColor());
  }
  else if (key == 's') saveFrame("img-######.tif");
}
