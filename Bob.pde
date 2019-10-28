
class Bob {
  PVector x, v, a, prevX;
  
  float aMax = 1;
  float vMax = 2;

  int distance = 50;
  float sightAngle = radians(50);

  float opacityMax = 0.4;
  float maxSize = 0.5;
  float size = 0;
  float sizeChange = 0.005;

  float hue;
  float hueChange = 1;
  float hueMin = 0;
  float hueMax = 137;

  float elbowRoom = 4;
  float elbowRoomMult = 1;
  
  float followMult = 0.5;

  int framesUntilShow = 0;

  Bob() {
    x = new PVector(random(0, width), random(0, height));
    v = PVector.random2D();
    a = new PVector();
    hue = random(hueMin, hueMax);
    prevX = x;
  }

  Bob(PVector x, PVector v) {
    this.x = x;
    this.v = v;
    a = new PVector();
    hue = random(hueMin, hueMax);
    prevX = x;
  }

  void show() {
    if (size < maxSize && size/maxSize < opacityMax) {
      size += sizeChange;
    }
    hue += hueChange;
    if (hue > hueMax) {
      hueChange = -hueChange;
    }
    if (hue < hueMin) {
      hueChange = -hueChange;
    }

    //fill(hue, 100, 100);
    stroke(hue, 100, 100, size/maxSize*100);
    if (frameCount == framesUntilShow) {
      background(0);
    }
    
    strokeWeight(size);
    if (PVector.dist(prevX, x) < width - 10) {
      line(prevX.x, prevX.y, x.x, x.y);
    }
    prevX = x.copy();
    //ellipse(x.x, x.y, size, size);
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
        c.mult(followMult);
        a.add(c);
      }

      if (PVector.dist(b.x, x) < elbowRoom) {
        PVector c = PVector.sub(x, b.x);
        c.mult(elbowRoomMult);
        a.add(c);
      }
    }

    a.limit(aMax);
    v.add(a);
    v.limit(vMax);
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
