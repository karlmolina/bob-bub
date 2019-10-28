/**
 Some rules that would be cool:
 
 Bobs look ahead in and have an angle of vision that they can see. If they another
 Bob then they follow it by look.
 
 Generate 2d wavy random grid of wind.
 
 
 */

ArrayList<Bob> bobs;

int LIMIT = 1;
int BOB_SIZE = 1;
PVector center;

void setup() { 
  size(500, 500);
  //fullScreen();

  center = new PVector(width/2, height/2);
  bobs = new ArrayList();
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++ ) {
      PVector x = new PVector(width/10.0*(i+.5), height/10.0*(j+.5));
      PVector v = PVector.sub(center, x);
      v.normalize();
      v.rotate(PI/2);
      bobs.add(new Bob(x, v));
    }
  }
  
  //for (int i = 0; i < 200; i++) {
  //  bobs.add(new Bob());
  //}

  noStroke();
  colorMode(HSB, 360, 100, 100);
  background(0);
  pixelDensity(2);
  println(height);
  println(width);
  //frameRate();
}

void draw() {
  //background(0);
  if (frameCount % 50 == 0) {
    //fill(0.1, 0, 0, .01);
    //rect(0, 0, height, width);
  }

  for (Bob b : bobs) {
    b.update();
    b.show();
    //b.showSight();
  }

  PVector mouse = new PVector(mouseX, mouseY);
}


class Bob {
  PVector x, v, a;

  int distance = 500;
  float sightAngle = radians(30);

  float maxSize = 0.3;
  float size = 0;
  float sizeChange = 0.3;

  float hue;
  float hueChange = 1;
  float hueMax = 328;
  float hueMin = 200;

  float elbowRoom = 4;

  int framesUntilShow = 0;

  Bob() {
    x = new PVector(random(0, width), random(0, height));
    v = PVector.random2D();
    a = new PVector();
    hue = random(hueMin, hueMax);
  }

  Bob(PVector x, PVector v) {
    this.x = x;
    this.v = v;
    a = new PVector();
    hue = random(hueMin, hueMax);
  }

  void show() {
    if (size < maxSize) {
      size += sizeChange;
    }
    hue += hueChange;
    if (hue > hueMax) {
      hueChange = -hueChange;
    }
    if (hue < hueMin) {
      hueChange = -hueChange;
    }

    fill(hue, 100, 100);
    if (frameCount == framesUntilShow) {
      background(0);
    }
    ellipse(x.x, x.y, size, size);
  }

  void showSight() {
    PVector sub = v.copy();
    sub.normalize();
    sub.rotate(sightAngle);
    PVector line1 = PVector.add(x, sub.mult(distance));
    line(x.x, x.y, line1.x, line1.y);
    sub.rotate(-2*sightAngle);
    PVector line2 = PVector.add(x, sub);
    line(x.x, x.y, line2.x, line2.y);
  }

  void update() {
    for (Bob b : bobs) {
      if (b == this) {
        continue;
      }

      PVector sub = PVector.sub(b.x, x);
      float angle = PVector.angleBetween(sub, v);
      if (angle < sightAngle && PVector.dist(b.x, x) < distance) {
        PVector c = PVector.sub(b.x, x);
        //println(a);
        c.mult(0.1);
        a.add(c);
      }

      if (PVector.dist(b.x, x) < elbowRoom) {
        PVector c = PVector.sub(x, b.x);
        c.mult(1);
        a.add(c);
      }
    }

    a.limit(0.05);
    v.add(a);
    v.limit(0.5);
    x.add(v);

    int topLimit = -LIMIT;
    int bottomLimit = height + LIMIT;
    int leftLimit = topLimit;
    int rightLimit = width + LIMIT;

    if (x.x > rightLimit) {
      x.x = leftLimit;
    } else if (x.x < leftLimit) {
      x.x = rightLimit;
    }

    if (x.y > bottomLimit) {
      x.y = topLimit;
    } else if (x.y < topLimit) {
      x.y = bottomLimit;
    }
  }

  void secondUpdate() {
    //v = futureV;
  }
}
