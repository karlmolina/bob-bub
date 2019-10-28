/**
 Some rules that would be cool:
 
 Bobs look ahead in and have an angle of vision that they can see. If they another
 Bob then they follow it by look.
 
 Generate 2d wavy random grid of wind.
 
 
 */
 
import processing.pdf.*;

ArrayList<Bob> bobs;

int LIMIT = 1;
int BOB_SIZE = 1;
int frameMax = 1000;
//int frameMax = 1000000;
PVector center;

void gridInit() {
  int amount = 10;
  for (int i = 0; i < amount; i++) {
    for (int j = 0; j < amount; j++ ) {
      PVector x = new PVector(width/amount*(i+.5), height/amount*(j+.5));
      PVector v = PVector.sub(center, x);
      v.normalize();
      v.rotate(PI/3);
      bobs.add(new Bob(x, v));
      println(x);
    }
  }
}

void randomInit() {
  for (int i = 0; i < 300; i++) {
    bobs.add(new Bob());
  }
}

void setup() { 
  size(500, 500, PDF, "test.pdf");
  //size(500, 500);
  //fullScreen();

  center = new PVector(width/2, height/2);
  bobs = new ArrayList();
  
  randomInit();
  
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  //pixelDensity(2);
  println(height);
  println(width);
  //frameRate();
}

void draw() {
  //background(0);
  if (frameCount % 1 == 0) {
    fill(0, 0, 0, 0);
    rect(0, 0, height, width);
  }
  
  if (frameCount % 25 == 0) {
    println(round(frameCount/(float)frameMax*100), "%");
  }

  for (Bob b : bobs) {
    b.update();
    b.show();
    //b.showSight();
  }
  
  if (frameCount == frameMax) {
    exit();
  }
}
