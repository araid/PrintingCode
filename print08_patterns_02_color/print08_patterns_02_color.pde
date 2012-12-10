static final int ORIENTATION_LEFT = 0;
static final int ORIENTATION_RIGHT = 1;

void setup()
{
  colorMode(HSB, 360.0, 100.0, 100.0);
  size(2400, 2400);
  smooth();
  background(255);
  noStroke();

  drawSquare(width/2, width/2, width, getRandomOrientation(), getRandomColor(), getRandomColor());
}

void draw() {
}

void drawSquare(float x, float y, float siz, float orientation, color c1, color c2)
{
  if (siz > 50) {
    //noStroke();
    //stroke(30);
    //color c3 = moveHue(c1,+15);
    //color c4 = moveHue(c1, -15);
    noFill();

    pushMatrix();
    translate(x, y);
    rotate(orientation);
/*
    fill(c3, 100);
    triangle( -siz/2, -siz/2, -siz/2, siz/2, siz/2, siz/2 ); 
    fill(c4, 100);
    triangle( -siz/2, -siz/2, siz/2, -siz/2, siz/2, siz/2); 
/*
    drawSquare(-siz/4, -siz/4, siz/2, 0.0, c3, c2);                        // top left
    drawSquare(siz/4, siz/4, siz/2, 0.0, c3, c2);                    // bottom right
    drawSquare(-siz/4, siz/4, siz/2, getRandomOrientation(), c4, c2);   // bottom left
    drawSquare(siz/4, -siz/4, siz/2, getRandomOrientation(), c4, c2);   // top right
    */
      fill(c1, 50);
    triangle( -siz/2, -siz/2, -siz/2, siz/2, siz/2, siz/2 ); 
    fill(c2, 50);
    triangle( -siz/2, -siz/2, siz/2, -siz/2, siz/2, siz/2);
    color c3 = moveHue(c1,+15);
    color c4 = moveHue(c1, -15);
    color c5 = moveHue(c2,+15);
    color c6 = moveHue(c2, -15);
    
    drawSquare(-siz/4, -siz/4, siz/2, 0.0, c3, c5);                        // top left
    drawSquare(siz/4, siz/4, siz/2, 0.0, c3, c5);                    // bottom right
    drawSquare(-siz/4, siz/4, siz/2, getRandomOrientation(), c3, c4);   // bottom left
    drawSquare(siz/4, -siz/4, siz/2, getRandomOrientation(), c5, c6);   // top right
    
    popMatrix();

  }
}

float getRandomOrientation() {
  if (random(1) > 0.5) return 0.0;
  else                return PI/2;
}

int getRandomColor(){
  return color(random(360), random(25,100), random(25,100));
}

color moveHue( color c, int change){
  float h = (hue(c) + change)%360;
  if(h < 0) h += 360;
  return color(h, saturation(c), brightness(c));
}

void keyPressed(){
  if(key == ' '){
      background(255);
    drawSquare(width/2, width/2, width, getRandomOrientation(), getRandomColor(), getRandomColor());
  }
  else if (key == 's') saveFrame("img-######.tif");
}
