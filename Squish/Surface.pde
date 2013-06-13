void line(PVector a, PVector b) {
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}

void triangle(PVector a, PVector b, PVector c) {
  line(a, b);
  line(b, c);
  line(c, a);
}

class Edge {
  Surface a, b;
  Edge(Surface a, Surface b) {
    this.a = a;
    this.b = b;
  }
  void draw() {
    line(a.getCenter(), b.getCenter());
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
  void drawFlat() {
    float r1 = a.dist(b), r2 = a.dist(c), r3 = c.dist(a);
    // the first two points are (0, 0) and (r1, 0)
    line(0, 0, r1, 0);
    // the third point is at the intersection of these two circles
    // which can be solved from the fact that we know all the sides
    ellipse(0, 0, r2 * 2, r2 * 2);
    ellipse(r1, 0, r3 * 2, r3 * 2);
  }
  PVector getCenter() {
    return new PVector(
      (a.x + b.x + c.x) / 3,
      (a.y + b.y + c.y) / 3,
      (a.z + b.z + c.z) / 3);
  }
}
