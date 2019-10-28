/**
 Some rules that would be cool:
 
 Bobs look ahead in and have an angle of vision that they can see. If they another
 Bob then they follow it by look.
 
 Generate 2d wavy random grid of wind.
 
 
 */

ArrayList<Bob> bobs;

int LIMIT = 5;
int BOB_SIZE = 10;
PVector center;

void setup() { 
  size(500, 500);

  bobs = new ArrayList();
  for (int i = 0; i < 100; i++) {
    bobs.add(new Bob());
  }

  center = new PVector(width/2, height/2);
}

void draw() {
  background(205);

  for (Bob b : bobs) {
    b.update();
    b.show();
  }
  
  for (Bob b : bobs) {
    b.secondUpdate();
  }

  PVector mouse = new PVector(mouseX, mouseY);
 
}


class Bob {
  PVector x, v, futureV;
  
  int distance = 30;
  int angle = 15;

  Bob() {
    x = new PVector(random(0, 500), random(0, 500));
    v = PVector.random2D();
  }

  void show() {
    ellipse(x.x, x.y, 10, 10);
    PVector sight = v.copy();
    sight.rotate(radians(angle));
    PVector line1 = PVector.add(x, sight).mult(distance);
    line(x.x, x.y, line1.x, line1.y);
    sight.rotate(radians(-angle));
    PVector line2 = PVector.add(x, sight).mult(distance);
    line(x.x, x.y, line2.x, line2.y);
    
    
  }

  void update() {
    for (Bob b : bobs) {
      PVector sub = PVector.sub(b.x, x);
      float angle = PVector.angleBetween(sub, v);
      if (PVector.dist(b.x, x) < 30) {
        futureV = PVector.sub(v, sub).normalize();
      }
    }

    x.add(v);

    int topLimit = -LIMIT;
    int bottomLimit = width + LIMIT;
    int leftLimit = topLimit;
    int rightLimit = height + LIMIT;

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
    v = futureV;
  }
}
