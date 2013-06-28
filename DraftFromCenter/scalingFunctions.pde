// translate in inches
void translateScale(float x, float y) {
  translate(x*drawingScale, y*drawingScale);
}

void drawBezier(PVector a, PVector b, PVector c, PVector d) {
  noFill();
  stroke(0);
  bezier(a.x*drawingScale, a.y*drawingScale, b.x*drawingScale, b.y*drawingScale, 
  c.x*drawingScale, c.y*drawingScale, d.x*drawingScale, d.y*drawingScale);
}

// draw shapes in current drawing scale using PVectors
void vertexScale(PVector a) {
  vertex(a.x*drawingScale, a.y*drawingScale);
}

void bezierVertexScale (PVector a, PVector b, PVector c) {
  bezierVertex(a.x*drawingScale, a.y*drawingScale, b.x*drawingScale, b.y*drawingScale, 
  c.x*drawingScale, c.y*drawingScale);
}

