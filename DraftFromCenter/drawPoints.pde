void drawDraftingPoints() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    d1, d2, d2a, d3, d4, d5, d6, 
    d2a, d0,
  };
  String[] pointLabels = {
    "d1", "d2", "d2a", "d3", "d4", "d5", "d6", 
    "d2a", "d0",
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}

void drawBodyPointsF() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    b9, b4, cp1, cp2, b7, b6, b8, b5, b9a, b3a, b3, b10, b2, b11, b1, b12
  };
  String[] pointLabels = {
    "b9", "b4", "cp1", "cp2", "b7", "b6", "b8", "b5", "b9a", "b3a", "b3", "b10", "b2", "b11", "b1", "b12",
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}

void drawBodyPointsB() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    b16, b21, cp3, cp4, b19, b20, b17, b18, b21a, b15a, b15, b22, b14, b23, b13, b24
  };
  String[] pointLabels = {
    "b16", "b21", "cp3","cp4","b19", "b20", "b17", "b18", "b21a", "b15a", "b15", "b22", "b14", "b23", "b13", "b24"
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}

