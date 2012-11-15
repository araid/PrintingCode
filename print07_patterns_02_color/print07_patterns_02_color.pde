static final int ORIENTATION_LEFT = 0;
static final int ORIENTATION_RIGHT = 1;

void setup()
{
  colorMode(HSB, 360.0, 100.0, 100.0);
  size(800, 800);
  smooth();
  background(255);
  noStroke();

  drawSquare(width/2, width/2, width, getRandomOrientation(), getRandomColor(), getRandomColor());
}

void draw() {
}

void drawSquare(float x, float y, float siz, float orientation, color c1, color c2)
{
  if (siz > 10) {
    //noStroke();
    //stroke(10);
    color c3 = moveHue(c1,+15);
    color c4 = moveHue(c1, -15);
    noFill();

    pushMatrix();
    translate(x, y);
    rotate(orientation);

    fill(c3, 75);
    triangle( -siz/2, -siz/2, -siz/2, siz/2, siz/2, siz/2 ); 
    fill(c4, 75);
    triangle( -siz/2, -siz/2, siz/2, -siz/2, siz/2, siz/2); 

    drawSquare(-siz/4, -siz/4, siz/2, 0.0, c3, c2);                        // top left
    drawSquare(siz/4, siz/4, siz/2, 0.0, c3, c2);                    // bottom right
    drawSquare(-siz/4, siz/4, siz/2, getRandomOrientation(), c4, c2);   // bottom left
    drawSquare(siz/4, -siz/4, siz/2, getRandomOrientation(), c4, c2);   // top right
    
    
    popMatrix();

  }
}

float getRandomOrientation() {
  if (random(1) > 0.5) return 0.0;
  else                return PI/2;
}

int getRandomColor(){
  return color(random(360), random(100), random(100));
}

color moveHue( color c, int change){
  float h = (hue(c) + change)%360;
  if(h < 0) h += 360;
  return color(h, saturation(c), brightness(c));
}

