void line(PVector a, PVector b) {
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}

void triangle(PVector a, PVector b, PVector c) {
  line(a, b);
  line(b, c);
  line(c, a);
}

float getAngle(float a, float b, float c) {
  return acos((a * a + b * b - c * c) / (2 * a * b));
}

class Edge {
  Surface a, b;
  PVector start, end;
  Edge(Surface a, Surface b, PVector start, PVector end) {
    this.a = a;
    this.b = b;
    this.start = start;
    this.end = end;
  }
  void draw() {
    line(a.getCenter(), b.getCenter());
  }
  void drawSharedEdge() {
    line(start, end);
  }
}

class Surface {
  PVector a, b, c;
  Surface(PVector a, PVector b, PVector c) {
    this.a = a;
    this.b = b;
    this.c = c;
  }
  void draw() {
    triangle(a, b, c);
  }
  PVector getCorner(int corner) {
    if(corner == 0) {
      return a;
    } else if(corner == 1) {
      return b;
    } else {
      return c;
    }
  }
  PVector getFlatCorner(int corner) {
    if(corner == 0) {
      return new PVector(0, 0);
    }
    float r1 = a.dist(b);
    if(corner == 2) {
      float r2 = b.dist(c), r3 = c.dist(a), angle = getAngle(r1, r2, r3);
      PVector cur = new PVector(r2, 0);
      cur.rotate(angle);
      return cur;
    }
    return new PVector(r1, 0);
  }
  void drawFlat() {
    triangle(
      getFlatCorner(0),
      getFlatCorner(1),
      getFlatCorner(2));
  }
  void transformToFlatEdge(int edge) {
    PVector a = getFlatCorner(edge);
    PVector b = getFlatCorner((edge + 1) % 3);
    float angle = atan2(b.y - a.y, b.x - a.x);
    translate(a.x, a.y);
    rotate(angle);
  }
  PVector getCenter() {
    return new PVector(
      (a.x + b.x + c.x) / 3,
      (a.y + b.y + c.y) / 3,
      (a.z + b.z + c.z) / 3);
  }
}
