void grid() { 
  stroke(150, 150, 150, 30);
  int xsegments = int(width / drawingScale);
  int ysegments = int(height / drawingScale);
  for (int y = 0; y < ysegments; y++) {
    line(0, y * drawingScale, width, y * drawingScale);
  }
  for (int x = 0; x < xsegments; x++) {
    line(x * drawingScale, 0, x * drawingScale, height);
  }
}

void yardsticks() {
 
  noFill();
  stroke(255,0,0);
   //horizontal
  line(0,0,36*drawingScale,0);
  //vertical
  line(0,0,0,36*drawingScale);
  // notches
  for (int i = 1; i < 37; i++) {
  line(0,i*drawingScale,1*drawingScale, i*drawingScale);
  line(i*drawingScale,0,i*drawingScale, 1*drawingScale);
  }
}

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
    b9, b4, cp1, cp2, b7, b6, b8, b5, b9a, b3a, b3, b10, b2, b11, b1, b12,
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

void drawPantPointsF() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    p1, p2, p3, p3a, p4, p5, p6, p7, p8, p9, p9a, p10, p11, p12, 
    //p5a, p6a, c5, c6, p4a, p4b, p6b,
  };
  String[] pointLabels = {
    "p1", "p2", "p3", "p3a", "p4", "p5", "p6", "p7", "p8", "p9", 
    "p9a", "p10", "p11", "p12", 
    //"p5a", "p6a", "c5", "c6", "p4a", "p4b", "p6b",
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}

void drawPantPointsB() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    p13, p14, p15, p15a, p16, p17, p18, p19, p20, p21, p21a, p22, p23, p24, 
    //p17a, p19a
  };
  String[] pointLabels = {
    "p13", "p14", "p15", "p15a", "p16", "p17", "p18", "p19", "p20", 
    "p21", "p21a", "p22", "p23", "p24", 
    //"p17a", "p19a",
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}

void drawPantPointsSAF() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    //l1, h1, l2, h2, l3, h3, l3a, h3a, l4, h4, l5, h5, l6, h6, l7, h7, h9, l9, h9a, l9a, h10, l10, h11, l11, h12, l12, 
    sa1, sa2, sa3, sa3a, sa4, sa5, sa6, sa7, sa9, sa9a, sa10, sa11, sa12, csa1, csa2,
  };
  String[] pointLabels = {
    //"l1", "h1", "l2", "h2", "l3", "h3", "l3a", "h3a", "l4", "h4", "l5", "h5", "l6", "h6", 
    //"l7", "h7", "h9", "l9", "h9a", "l9a", "h10", "l10", "h11", "l11", "h12", "l12", 
    "sa1", "sa2", "sa3", "sa3a", "sa4", "sa5", "sa6", "sa7", "sa9", "sa9a", "sa10", "sa11", "sa12", "csa1", "csa2",
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}

void drawPantPointsSAB() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    //l13, h13, l14, h14, l15, h15, l15a, h15a, l16, h16, l17, h17, l18, h18, l19, h19, h21, l21, h21a, l21a, h22, l22, h23, l23, h24, l24, 
    csa3, csa4, sa13, sa14, sa15, sa15a, sa16, sa17, sa18, sa19, sa21, sa21a, sa22, sa23, sa24,
  };
  String[] pointLabels = {
    //"l13", "h13", "l14", "h14", "l15", "h15", "l15a", "h15a", "l16", "h16", "l17", "h17", "l18", "h18", 
    //"l19", "h19", "h21", "l21", "h21a", "l21a", "h22", "l22", "h23", "l23", "h24", "l24", 
    "csa3", "csa4", "sa13", "sa14", "sa15", "sa15a", "sa16", "sa17", "sa18", "sa19", "sa21", "sa21a", "sa22", "sa23", "sa24",
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}
