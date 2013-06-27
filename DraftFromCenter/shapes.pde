void bodyShapeF() {
  stroke(255, 0, 0);
  noFill();
  beginShape();
  vertexScale(b1);
  vertexScale(b2);
  vertexScale(b3);
  vertexScale(b3a);
  if (b4.x < b5.x) {
    vertexScale(b4);
  } 
  else {
    vertexScale(b5);
  }
  //bezierVertexScale(b2,b4,b5);
  vertexScale(b6);
  vertexScale(b7);
  bezierVertexScale(cp1, cp2, b9); // why dis fucked up???
  vertexScale(b9a);
  vertexScale(b10);
  vertexScale(b11);
  vertexScale(b12);
  endShape(CLOSE);
}

void bodyShapeB() {
  stroke(255, 0, 0);
  noFill();
  beginShape();
  vertexScale(b13);
  vertexScale(b14);
  vertexScale(b15);
  vertexScale(b15a);
  if (b16.x < b17.x) {
    vertexScale(b16);
  } 
  else {
    vertexScale(b17);
  }
  vertexScale(b18);
  vertexScale(b19);
  //vertexScale(b20);
  //vertexScale(b21);
  bezierVertexScale(cp3, cp4, b21);
  vertexScale(b21a);
  vertexScale(b22);
  vertexScale(b23);
  vertexScale(b24);
  endShape(CLOSE);
}

void pantShapeF() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(p1);
  vertexScale(p3);
  if (p4.x < p5.x) {
    vertexScale(p4);
  } 
  else {
    vertexScale(p5);
  }
  vertexScale(p6);
  vertexScale(p7);
  bezierVertexScale(cp2, cp1, p9);
vertexScale(p10);
  vertexScale(p12);
  endShape(CLOSE);
}

void pantShapeB() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(p13);
  vertexScale(p15);
  if (p16.x < p17.x) {
    vertexScale(p16);
  } 
  else {
    vertexScale(p17);
  }
  vertexScale(p18);
  vertexScale(p19);
  bezierVertexScale(cp4, cp3, p21);
vertexScale(p22);
  vertexScale(p24);
  endShape(CLOSE);
}
