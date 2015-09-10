void bodyShapeF() {
  stroke(255, 0, 0);
  noFill();
  beginShape();
  vertexScale(b1);
  vertexScale(b2);
  vertexScale(b3);
  vertexScale(b3a);
  if ((b3a.x < b4.x)||(b3a.x < b5.x)) {
    vertexScale(b6);
  } else { 
    if (b4.x < b5.x) {
      vertexScale(b4);
      vertexScale(b6);
    } else {
      vertexScale(b5);
      vertexScale(b6);
    }
  }
  vertexScale(b7);
  bezierVertexScale(cp2, cp1, b9); // why dis fucked up???
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
  } else {
    vertexScale(b17);
  }
  vertexScale(b18);
  vertexScale(b19);
  bezierVertexScale(cp4, cp3, b21);
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
  } else {
    vertexScale(p5);
  }
  vertexScale(p6);
  vertexScale(p7);
  bezierVertexScale(cpp2, cpp1, p9);
  vertexScale(p10);
  vertexScale(p12);
  endShape(CLOSE);
}

void pantShapeB() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(p13);
  vertexScale(p15a);
  /*
  vertexScale(p15);
   if (p16.x < p17.x) {
   vertexScale(p16);
   } 
   else {
   vertexScale(p17);
   }
   */
  //close pant lower if yoke is on, null pointer
  /*  if (yokeTF ==true) {
   vertexScale(p17a);
   vertexScale(p19a);
   } 
   else { */
  vertexScale(p18);
  vertexScale(p19);
  // }
  bezierVertexScale(cpp4, cpp3, p21);
  vertexScale(p22);
  vertexScale(p24);
  endShape(CLOSE);
}

void baselShapeF() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(v1);
  vertexScale(v2);
  vertexScale(v3);
  vertexScale(v4);
  bezierVertexScale(cpp2,cpp1,v5);
  vertexScale(v6);
  vertexScale(v7);
  endShape(CLOSE);
}

void baselShapeB() {
  stroke(0);
  noFill();
  beginShape();
    vertexScale(v8);
  vertexScale(v9);
  vertexScale(v10);
  vertexScale(v11);
  bezierVertexScale(cpp3,cpp3,v12);
  vertexScale(v13);
  vertexScale(v14);
  endShape(CLOSE);
}


//potentially unstable
void pantShapeSAF() {
  stroke(0, 0, 255);
  noFill();
  beginShape();
  vertexScale(sa1);
  vertexScale(sa3);
  if (sa4.x < sa5.x) {
    vertexScale(sa4);
  } else {
    vertexScale(sa5);
  }
  vertexScale(sa6);
  vertexScale(sa7);
  bezierVertexScale(cpp2, cpp1, sa9);
  vertexScale(sa10);
  vertexScale(sa12);
  endShape(CLOSE);
}

void pantShapeSAB() {
  stroke(0, 0, 255);
  noFill();
  beginShape();
  vertexScale(sa13);
  vertexScale(sa15a);
  /*
  vertexScale(p15);
   if (p16.x < p17.x) {
   vertexScale(p16);
   } 
   else {
   vertexScale(p17);
   }
   */
  vertexScale(sa18);
  vertexScale(sa19);
  bezierVertexScale(cpp4, cpp3, sa21);
  vertexScale(sa22);
  vertexScale(sa24);
  endShape(CLOSE);
}

void yokeShape() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(p18);
  vertexScale(p19);
  vertexScale(p19a);
  vertexScale(p17a);
  endShape(CLOSE);
}

void yokeShapeSA() {
  stroke(0, 0, 255);
  noFill();
  beginShape();
  vertexScale(sa18);
  vertexScale(sa19);
  vertexScale(sa19a);
  vertexScale(sa17a);
  endShape(CLOSE);
}

