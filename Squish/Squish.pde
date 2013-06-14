import peasy.*;

PeasyCam cam;
Vector<Surface> surfaces = new Vector<Surface>();
Vector<Edge> edges = new Vector<Edge>();

PVector spherical(float r, float theta, float phi) {
  return new PVector(
  r * sin(theta) * cos(phi), 
  r * sin(theta) * sin(phi), 
  r * cos(theta)
    );
}

void setup() {
  size(400, 400, P3D);
  cam = new PeasyCam(this, 400);

  int h = 4, w = 8;
  float r = 200;
  float thetaStep = HALF_PI / w;
  float phiStep = QUARTER_PI / h;
  for (int j = 0; j < h; j++) {
    for (int i = 0; i < w; i++) {
      float t0 = thetaStep * i, t1 = thetaStep * (i + 1);
      float p0 = phiStep * j, p1 = phiStep * (j + 1);
      surfaces.add(new Surface(
      spherical(r, t0, p0), 
      spherical(r, t1, p0), 
      spherical(r, t1, p1)));
      surfaces.add(new Surface(
      spherical(r, t0, p0), 
      spherical(r, t1, p1), 
      spherical(r, t0, p1)));
    }
  }

  for (int j = 0; j < h; j++) {
    for (int i = 0; i < w; i++) {
      int k = j * w + i;
      Surface s0 = surfaces.get(k * 2 + 0);
      Surface s1 = surfaces.get(k * 2 + 1);
      edges.add(new Edge(s0, s1, s1.a, s1.b));
      if (i + 1 < w) {
        edges.add(new Edge(s0, surfaces.get(k * 2 + 3), s0.b, s0.c));
      }
      if (j + 1 < h) {
        edges.add(new Edge(s1, surfaces.get(k * 2 + w * 2), s1.b, s1.c));
      }
    }
  }
}

void draw() {
  background(255);
  noFill();
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i < surfaces.size(); i++) {
    surfaces.get(i).draw();
  }
  stroke(0, 255, 0);
  for (int i = 0; i < edges.size(); i++) {
    edges.get(i).draw();
  }
  
  strokeWeight(3);
  int i = (int) constrain(map(mouseX, 0, width, 0, edges.size()), 0, edges.size() - 1);
  stroke(255, 0, 0);
  edges.get(i).a.draw();
  stroke(0, 0, 255);
  edges.get(i).b.draw();
  stroke(0, 255, 0);
  edges.get(i).drawSharedEdge();

  cam.beginHUD();
  translate(width / 2, height / 2);
  stroke(255, 0, 0);
  edges.get(i).a.drawFlat();
  stroke(0, 0, 255);
  edges.get(i).b.drawFlat();
  cam.endHUD();
}

