import toxi.geom.*;
import toxi.processing.*;
import processing.pdf.*;
import controlP5.*;
ControlP5 cp5;

// measurements on lisa, in inches
//vertical measurements
float inseam = 31; // crotch to floor 
//float sideseam = 37; // hip to floor, not used
//float crotchDepth = 6; // hip to crotch  --- F, S or B??, ambiguous, not used

// need ankle to floor, calf to floor, knee to floor, for now making up numbers
float kneeToFloor = 19; // 
float calfToFloor = 11;
float ankleToFloor = 4.75;
float instep = 3; // top of instep to floor

float crotchLength = 17; 
float crotchLengthFront = 6.5; 

//circumference measurements
float hip = 32;
float hipFront = 15;

float butt = 35;
float buttFront = 16;

//float twoThighs = 35; //unused, goes with crotch width?
float thigh = 21;
float thighFront = 9;

float midthighToCrotch = 3;
float midthigh = 18.5;
float midthighFront = 7.75;

float knee = 13; 
float kneeFront = 5.5;// can simply be knee/2, -1 for front, +1 for back
float calf = 13; //at fullest part
float calfFront= 5.5;
float ankle = 7.5; 
float ankleFront = 3.5;

float hipToButtF = 3;
float hipToButtB = 6;
float hipToButtS = 4;

float crotchToButt = 3; //crotchDepth - hipToButtF;

PFont font;

PVector d1, d2, d3, d4, d5, d6; //d2endpoint, d2endpoint2; // drafting points
PVector b5, b8, b4, b9, b3, b10, b2, b11, b1, b12, b6, b7; //body points front
PVector b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24; //body points back
PVector c1, c2, c3, c4;
PVector b3a, b9a, b15a, b21a, d2a; // added midthigh
PVector p1, p2, p3, p3a, p4, p5, p6, p7, p8, p9, p9a, p10, p11, p12; //pant points front
PVector p13, p14, p15, p15a, p16, p17, p18, p19, p20, p21, p21a, p22, p23, p24; // pant points back
PVector p5a, p6a, c5, c6, p4a, p4b, p6b; // front pocket, currently only half size
PVector p17a, p19a; // yoke
PVector l1, h1, l2, h2, l3, h3, l3a, h3a, l4, h4, l5, h5, l6, h6, l7, h7, csa1, csa2, h9, l9, h9a, l9a, h10, l10, h11, l11, h12, l12; // front SA drafting
PVector sa1, sa2, sa3, sa3a, sa4, sa5, sa6, sa7, sa9, sa9a, sa10, sa11, sa12; // front SA
PVector l13, h13, l14, h14, l15, h15, l15a, h15a, l16, h16, l17, h17, l18, h18, l19, h19, csa3, csa4, h21, l21, h21a, l21a, h22, l22, h23, l23, h24, l24; // back SA drafting
PVector sa13, sa14, sa15, sa15a, sa16, sa17, sa18, sa19, sa20, sa21, sa21a, sa22, sa23, sa24; // back SA

float drawingScale = 13;
float pointSize = 6;
// modifications performed on body points
float thighShift = 0;
float bowlegs = 0;
float thighSeparation = 0;

//modifications performed on pant points and pant shape
float ankleEase = 3.5; // current ankle hem circ (11) - ankle = ankleEase
float pantHeight = 0; // 0 is ankle, - or + inches above and below
boolean skinnyKnees = false;
boolean pocket = false;
float pocketHeight = 2;
float pocketWidth = 3;
boolean yoke = false;
float yokeInside = 2;
float yokeOutside = 1.25;

float seamAllowance = 3/8.;

void setup() {
  size(900, 700);
  font = createFont("Arial", 12);
  textFont(font); 
  cp5 = new ControlP5(this);
  measurementGui();
}

void measurementGui() {
  cp5.setColorCaptionLabel(0);
  int x = 600, y = 10, spacing = 35;
  cp5.addNumberbox("inseam").setPosition(x, y).setRange(20, 40.)
    .setValue(inseam).setMultiplier(0.5);
  //cp5.addNumberbox("sideseam").setPosition(x, y+=spacing).setRange(30, 50)
  //.setValue(sideseam).setMultiplier(0.5);
  //cp5.addNumberbox("crotchDepth").setPosition(x, y+=spacing).setRange(5, 15)
  //.setValue(crotchDepth).setMultiplier(0.25);
  cp5.addNumberbox("kneeToFloor").setPosition(x, y+=spacing).setRange(15, 25)
    .setValue(kneeToFloor).setMultiplier(0.25);
  cp5.addNumberbox("calfToFloor").setPosition(x, y+=spacing).setRange(8, 18)
    .setValue(calfToFloor).setMultiplier(0.25);
  cp5.addNumberbox("ankleToFloor").setPosition(x, y+=spacing).setRange(2, 7)
    .setValue(ankleToFloor).setMultiplier(0.25);
  cp5.addNumberbox("crotchLength").setPosition(x, y+=spacing).setRange(10, 25)
    .setValue(crotchLength).setMultiplier(0.25);
  cp5.addNumberbox("crotchLengthFront").setPosition(x, y+=spacing).setRange(4, crotchLength) // build in more checks like this
    .setValue(crotchLengthFront).setMultiplier(0.25);
  //circumference measurements   
  cp5.addNumberbox("hip").setPosition(x, y+=spacing).setRange(25, 50)
    .setValue(hip).setMultiplier(0.25);
  cp5.addNumberbox("hipFront").setPosition(x, y+=spacing).setRange(9, hip)
    .setValue(hipFront).setMultiplier(0.25);
  cp5.addNumberbox("butt").setPosition(x, y+=spacing).setRange(25, 50)
    .setValue(butt).setMultiplier(0.25);
  cp5.addNumberbox("buttFront").setPosition(x, y+=spacing).setRange(9, butt)
    .setValue(buttFront).setMultiplier(0.25);
  cp5.addNumberbox("thigh").setPosition(x, y+=spacing).setRange(16, 28)
    .setValue(thigh).setMultiplier(0.25);
  cp5.addNumberbox("thighFront").setPosition(x, y+=spacing).setRange(5, thigh)
    .setValue(thighFront).setMultiplier(0.25);
  cp5.addNumberbox("knee").setPosition(x, y+=spacing).setRange(9, 28)
    .setValue(knee).setMultiplier(0.25);
  cp5.addNumberbox("kneeFront").setPosition(x, y+=spacing).setRange(3, knee)
    .setValue(kneeFront).setMultiplier(0.25);
  cp5.addNumberbox("calf").setPosition(x, y+=spacing).setRange(9, 28)
    .setValue(calf).setMultiplier(0.25);
  cp5.addNumberbox("calfFront").setPosition(x, y+=spacing).setRange(3, calf)
    .setValue(calfFront).setMultiplier(0.25);
  cp5.addNumberbox("ankle").setPosition(x, y+=spacing).setRange(3, calf)
    .setValue(ankle).setMultiplier(0.25);
  cp5.addNumberbox("ankleFront").setPosition(x, y+=spacing).setRange(2, ankle)
    .setValue(ankleFront).setMultiplier(0.25);

  int z = x + 100;
  y = 10;

  cp5.addNumberbox("hipToButtF").setPosition(z, y).setRange(1, 8)
    .setValue(hipToButtF).setMultiplier(0.25);
  cp5.addNumberbox("hipToButtB").setPosition(z, y+=spacing).setRange(1, 10)
    .setValue(hipToButtB).setMultiplier(0.25);
  cp5.addNumberbox("hipToButtS").setPosition(z, y+=spacing).setRange(1, 10)
    .setValue(hipToButtS).setMultiplier(0.25);
  cp5.addNumberbox("CrotchToButt").setPosition(z, y+=spacing).setRange(1, 10)
    .setValue(hipToButtS).setMultiplier(0.25);
  cp5.addNumberbox("bowlegs").setPosition(z, y+=spacing).setRange(0, 2)
    .setValue(bowlegs).setMultiplier(0.125);
  cp5.addNumberbox("thighShift").setPosition(z, y+=spacing).setRange(0, 1)
    .setValue(thighShift).setMultiplier(0.1);
  cp5.addNumberbox("ankleEase").setPosition(z, y+=spacing).setRange(0, 8)
    .setValue(ankleEase).setMultiplier(0.25);
  cp5.addNumberbox("pantHeight").setPosition(z, y+=spacing).setRange(-5, 15)
    .setValue(pantHeight).setMultiplier(0.25);

  cp5.addBang("tuckWaist").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addBang("tightenButt").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addBang("loosenButt").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addBang("dropCrotch").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addBang("thighSeparation").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addBang("ankleLength").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addBang("regularLength").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addBang("floorLength").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addToggle("skinnyKnees").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addToggle("pocket").setPosition(z, y+=spacing).setSize(20, 20);
  cp5.addToggle("yoke").setPosition(z, y+=spacing).setSize(20, 20);

  int w = x - 100;
  y = 10;

  cp5.addNumberbox("seamAllowance").setPosition(w, y).setRange(0, 2)
    .setValue(seamAllowance).setMultiplier(0.125);
}

float crotchLengthBack, hipBack, buttBack, thighBack, midthighBack, kneeBack, calfBack, ankleBack;

void draw() {
  crotchLengthBack = crotchLength - crotchLengthFront; 
  hipBack = hip - hipFront;
  buttBack = butt - buttFront;
  thighBack = thigh - thighFront; 
  midthighBack = midthigh - midthighFront;
  kneeBack = knee - kneeFront;
  calfBack= calf - calfFront;
  ankleBack = ankle - ankleFront;

  background(255);
  //calculate vectors
  draftingPoints();
  bodyPointsF();
  bodyPointsB();
  pantPointsF();
  pantPointsB();
  pantPointsSAF();
  pantPointsSAB();

  // draw drafting points
  pushMatrix();
  translate (10, 150);
  drawDraftingPoints();
  popMatrix();

  // pant front
  pushMatrix();
  translate (200, 150);
  //drawBodyPointsF();
  //drawPantPointsF();
  //drawPantPointsSAF();
  bodyShapeF();
  pantShapeF();
  pantShapeSAF();
  popMatrix();

  //pant back
  pushMatrix();
  translate (400, 150);
  //drawBodyPointsB();
  //drawPantPointsB();
  //drawPantPointsSAB();
  bodyShapeB();
  pantShapeB();
  pantShapeSAB();
  popMatrix();

  if (yoke == true) {
    pushMatrix();
    translate (400, 120);
    yokeShape();
    popMatrix();
  }

  if (pocket == true) {
    pushMatrix();
    translate (100, 150);
    pocketShape();
    popMatrix();
  }
}


public void tuckWaist() {
  float ratio = hipFront/hip;
  hip -= .5;
  hipFront = hip* ratio;
  println("hip = " + hip + " hipFront = " + hipFront + " ratio = " + ratio);
}

public void tightenButt() {
  float buttRatio = buttFront/butt;
  butt -= .5;
  buttFront = butt* buttRatio;
  float thighRatio = thighFront/thigh;
  thigh -= .5;
  thighFront = thigh* thighRatio;
  float midthighRatio = midthighFront/midthigh;
  midthigh -= .5;
  midthighFront = midthigh* midthighRatio;
  println("butt = "+butt+" buttFront = "+buttFront+" buttBack = "+buttBack+" buttRatio = "+buttRatio);
}

public void loosenButt() {
  float buttRatio = buttFront/butt;
  butt += .5;
  buttFront = butt* buttRatio;
  float thighRatio = thighFront/thigh;
  thigh += .5;
  thighFront = thigh* thighRatio;
  float midthighRatio = midthighFront/midthigh;
  midthigh += .5;
  midthighFront = midthigh* midthighRatio;
  println("butt = "+butt+" buttFront = "+buttFront+" buttBack = "+buttBack+" buttRatio = "+buttRatio);
}

public void dropCrotch() {
  crotchToButt += 0.25;
  inseam -= 0.25;
  float crotchRatio = crotchLengthFront/ crotchLength;
  crotchLength += .5; 
  crotchLengthFront = crotchLength* crotchRatio;
  println("crotchLength = "+crotchLength+" crotchLengthFront = "+crotchLengthFront);
  println(" crotchLengthBack = "+crotchLengthBack+" crotchRatio = "+crotchRatio);
}

public void thighSeparation() {
  midthighToCrotch -= .25;
}

public void ankleLength() {
  pantHeight = -1;
}

public void regularLength() {
  pantHeight = (ankleToFloor-instep) + 1.5;
}

public void floorLength() {
  pantHeight = ankleToFloor;
}

void bodyShapeF() {
  stroke(255, 0, 0);
  noFill();
  beginShape();
  vertexScale(b1);
  vertexScale(b2);
  vertexScale(b3);
  vertexScale(b3a);
  vertexScale(b4);
  vertexScale(b5);
  //bezierVertexScale(b2,b4,b5);
  vertexScale(b6);
  vertexScale(b7);
  bezierVertexScale(c1, c2, b9);
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
  vertexScale(b16);
  vertexScale(b17);
  vertexScale(b18);
  vertexScale(b19);
  //vertexScale(b20);
  //vertexScale(b21);
  bezierVertexScale(c3, c4, b21);
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
  if (skinnyKnees == true) {
    bezierVertexScale(p2, p2, p3);
    bezierVertexScale(p3a, p4, p5);
  } else {
    bezierVertexScale(p2, p3a, p5);
  }
  if (pocket == true) {
    vertexScale(p5a);
    bezierVertexScale(c5, c6, p6a);
    vertexScale(p7);
  } else {
    vertexScale(p6);
    vertexScale(p7);
  }
  bezierVertexScale(c1, c2, p9);
  if (skinnyKnees == true) {
    bezierVertexScale(p9a, p9a, p10);
    bezierVertexScale(p11, p11, p12);
  } else {
    bezierVertexScale(p9a, p10, p12);
  }
  endShape(CLOSE);
}

void pantShapeB() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(p13);
  if (skinnyKnees == true) {
    bezierVertexScale(p14, p14, p15);
    bezierVertexScale(p15a, p16, p17);
  } else {
    bezierVertexScale(p14, p15a, p17);
  }
  if (yoke == true) {
    vertexScale(p17a);
    vertexScale(p19a);
  } else {
    vertexScale(p18);
    vertexScale(p19);
  }
  bezierVertexScale(c3, c4, p21);
  if (skinnyKnees == true) {
    bezierVertexScale(p21a, p21a, p22);
    bezierVertexScale(p23, p23, p24);
  } else {
    bezierVertexScale(p21a, p22, p24);
  }
  endShape(CLOSE);
}

void pantShapeSAF() {
  stroke(0, 0, 255);
  noFill();
  beginShape();
  vertexScale(sa1);
  if (skinnyKnees == true) {
    bezierVertexScale(sa2, sa2, sa3);
    bezierVertexScale(sa3a, sa4, sa5);
  } else {
    bezierVertexScale(sa2, sa3a, sa5);
  }
  //if (pocket == true) {
  //vertexScale(p5a);
  //bezierVertexScale(c5, c6, p6a);
  //vertexScale(p7);
  //} else {
  vertexScale(sa6);
  vertexScale(sa7);
  //}
  bezierVertexScale(csa1, csa2, sa9);
  if (skinnyKnees == true) {
    bezierVertexScale(sa9a, sa9a, sa10);
    bezierVertexScale(sa11, sa11, sa12);
  } else {
    bezierVertexScale(sa9a, sa10, sa12);
  }
  endShape(CLOSE);
}

void pantShapeSAB() {
  stroke(0, 0, 255);
  noFill();
  beginShape();
  vertexScale(sa13);
  if (skinnyKnees == true) {
    bezierVertexScale(sa14, sa14, sa15);
    bezierVertexScale(sa15a, sa16, sa17);
  } else {
    bezierVertexScale(sa14, sa15a, sa17);
  }
  //if (yoke == true) {
    //vertexScale(17a);
    //vertexScale(p19a);
  //} else {
    vertexScale(sa18);
    vertexScale(sa19);
  //}
  bezierVertexScale(csa3, csa4, sa21);
  if (skinnyKnees == true) {
    bezierVertexScale(sa21a, sa21a, sa22);
    bezierVertexScale(sa23, sa23, sa24);
  } else {
    bezierVertexScale(sa21a, sa22, sa24);
  }
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

void pocketShape() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(p6);
  vertexScale(p6b);
  bezierVertexScale(p4b, p4b, p4a);
  vertexScale(p5);
  endShape(CLOSE);
}

// use PVectors and drawing scale to draw pattern pieces
void vertexScale(PVector a) {
  vertex(a.x*drawingScale, a.y*drawingScale);
}

void bezierVertexScale (PVector a, PVector b, PVector c) {
  bezierVertex(a.x*drawingScale, a.y*drawingScale, b.x*drawingScale, b.y*drawingScale, 
  c.x*drawingScale, c.y*drawingScale);
}
/*
public void controlEvent(ControlEvent theEvent) {
 //println(theEvent.getController().getValue());
 
 if (theEvent.isFrom(cp5.getController("calf"))) {
 println("calf ="+ theEvent.getController().getValue());
 }
 } */

void drawDraftingPoints() {
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    d1, d2, d3, d4, d5, d6, 
    d2a,
  };
  String[] pointLabels = {
    "d1", "d2", "d3", "d4", "d5", "d6", 
    "d2a"
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
    b5, b8, b4, b9, b3, b10, b2, b11, b1, b12, b6, b7, 
    c1, c2, 
    b3a, b9a,
  };
  String[] pointLabels = {  
    "b5", "", "b4", "b9", "b3", "b10", "b2", "b11", "b1", "b12", "b6", "b7", 
    "c1", "c2", 
    "b3a", "b9a",
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
    b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24, 
    c3, c4, 
    b15a, b21a,
  };
  String[] pointLabels = {
    "b13", "b14", "b15", "b16", "b17", "b18", "b19", "b20", "b21", "b22", "b23", "b24", 
    "c3", "c4", 
    "b15a", "b21a",
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
    p5a, p6a, c5, c6, p4a, p4b, p6b,
  };
  String[] pointLabels = {
    "p1", "p2", "p3", "p3a", "p4", "p5", "p6", "p7", "p8", "p9", 
    "p9a", "p10", "p11", "p12", 
    "p5a", "p6a", "c5", "c6", "p4a", "p4b", "p6b",
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
    p17a, p19a
  };
  String[] pointLabels = {
    "p13", "p14", "p15", "p15a", "p16", "p17", "p18", "p19", "p20", 
    "p21", "p21a", "p22", "p23", "p24", 
    "p17a", "p19a",
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

void draftingPoints() {
  // drafting points
  d1 = new PVector(0, 0);
  d2 = d1.get();
  d2.y += crotchToButt; // not sure about this measurement
  d2a = d2.get();
  d2a.y += midthighToCrotch; 
  d6 = d2.get();
  d6.y += inseam;

  d2a.x -= bowlegs/3.;
  d6.x -= bowlegs; // shift lower leg over for bowlegs

    d3 = d6.get();
  d3.y -= kneeToFloor;
  d4 = d6.get();
  d4.y -= calfToFloor;
  d5 = d6.get();
  d5.y -= ankleToFloor;
}

void bodyPointsF() {  
  //mark body points using drafting points
  b5 = d1.get();
  b5.x -= buttFront/4.; 
  b8 = b5.get();
  b8.x += buttFront/2.;

  b4 = b5.get(); // can also base b4 off d2
  b4.y += crotchToButt;
  b4.x -= thighShift; // does crotch bezier length adjust properly?

  b9 = b4.get();
  b9.x += thighFront;
  b3 = d3.get();
  b3.x -= kneeFront/2.;
  b10 = b3.get();
  b10.x += kneeFront;
  b2 = d4.get();
  b2.x -= calfFront/2.;
  b11 = b2.get();
  b11.x += calfFront;
  b1 = d5.get();
  b1.x -= ankleFront/2.;
  b12 = b1.get();
  b12.x += ankleFront;

  //midthigh F
  b3a = d2a.get();
  b3a.x -= midthighFront /2.;
  b9a = b3a.get();
  b9a.x += midthighFront;

  /* wtf why was this working earlier?
   d2endpoint = d2.get();
   d2endpoint.x += 50;
   d2endpoint2 = d2endpoint.get();
   d2endpoint2.x += 50;
   b4 = intersectAtDistance(b5, b3a, d2endpoint, d2endpoint2); */

  // b6 and b7 are the correct height above b5 and b8
  b6 = b5.get();
  b6.y -= hipToButtS;
  b7 = b8.get();
  b7.y -= hipToButtF;
  // b6 and b7 are tilted in to create the correct distance
  // problem with this while statement is that while the distances are correct, 
  // both points come in evenly to meet the distance
  float angle = 0; 
  while (b6.dist (b7) >= (hipFront/2.)) {
    // angle ++ is clockwise
    rotate2D(b7, 360-angle);
    rotate2D(b6, angle);
    angle += 1;
  }

  //next, control points for the front crotch curve, adjust length with while loop 
  // initial location of control points decided by eyeballing/convenience
  c1= b8.get();
  c2= b8.get();
  c2.y += crotchToButt;
  //c2= b8.get();
  //c2.add(b9);
  //c2.div(2);
  //println(bezierLength(b7,c1,c2,b9));
  while (bezierLength (b7, c1, c2, b9) < crotchLengthFront) {
    b9.x += .25;
    //c1.x -= .05;
    //c2.x -= .1;
    //c2.y += .25;
  }  

  // this is a hack to shift b4 and b9 over so the thigh isnt so loopy and the crotch curve looks right
  /*boolean thinThighs = true;
   if (thinThighs == true) {
   b4.x = b5.x;
   while (b4.dist (b9) < thighFront) {
   b9.x += 0.25;
   }
   } */
}

void bodyPointsB() {
  /* back body points based on drafting points
   b17 = d1.get();
   b17.x -= buttBack/4.; 
   b20 = b17.get();
   b20.x += buttBack/2.;
   b16 = d2.get();
   b16.x -= thighBack/2.;
   b21 = b16.get();
   b21.x += thighBack;
   b15 = d3.get();
   b15.x -= kneeBack/2.;
   b22 = b15.get();
   b22.x += kneeBack;
   b14 = d4.get();
   b14.x -= calfBack/2.;
   b23 = b14.get();
   b23.x += calfBack;
   b13 = d5.get();
   b13.x -= ankleBack/2.;
   b24 = b13.get();
   b24.x += ankleBack;
   b18 = b17.get();
   b18.y -= hipToButtS;
   b19 = b20.get();
   b19.y -= hipToButtB; */

  //rather than using the drafting points, the outseam of the back is taken from the front:
  b17 = b5.get(); 
  b20 = b17.get();
  b20.x += buttBack/2.;
  b16 = b4.get();
  b21 = b16.get();
  b21.x += thighBack;
  b15 = b3.get();
  b22 = b15.get();
  b22.x += kneeBack;
  b14 = b2.get();
  b23 = b14.get();
  b23.x += calfBack;

  // this needs to be centered
  float offset = (calfBack/2.)-(calfFront/2.);
  b13 = d5.get();
  b13.x += offset;
  b13.x -= ankleBack/2;
  b24 = b13.get();
  b24.x += ankleBack;

  //midthigh
  b15a = b3a.get();
  b21a= b15a.get();
  b21a.x += midthighBack;

  //b18 matches b6 and b19 is tilted in so that the distance between b18 and b19 is correct

  //b18 = b17.get();
  //b18.y -= hipToButtS;
  b18 = b6.get();
  b19 = b20.get();
  b19.y -= hipToButtB;

  float angle = 0; 
  while (b18.dist (b19) >= (hipBack/2.)) {
    // angle ++ is clockwise
    rotate2D(b19, 360-angle);
    //rotate2D(b18, angle);
    angle += 1;
  }

  //control points for back crotch curve
  // initial location of control points decided by eyeballing/convenience
  c3= b20.get();
  c4= b20.get();
  c4.y += crotchToButt;
  //move control points until crotch is long enough
  while (bezierLength (b19, c3, c4, b21) < crotchLengthBack) {
    c3.x -= .2;
    c4.x -= .1;
  }
}

void pantPointsF() {
  // for now, pant points are using same control points as body
  p1 = b1.get();
  p1.x -= ankleEase/4.;
  p1.y += pantHeight;
  p2 = b2.get();
  p3 = b3.get();
  p3a = b3a.get();
  p4 = b4.get();
  p5 = b5.get();
  p6 = b6.get();
  p7 = b7.get();
  p8 = b8.get();
  p9 = b9.get();
  p9a = b9a.get();
  p10 = b10.get();
  p11 = b11.get();
  p12 = b12.get();
  p12.x += ankleEase/4.;
  p12.y += pantHeight;

  // front pocket
  c5 = p6.get();
  c5.y += pocketHeight;
  c5.x += pocketWidth*.6;
  c6 = p6.get();
  c6.x += pocketWidth;
  c6.y += pocketHeight;
  p5a= pointOnLine(p5, p6, pocketHeight, true);
  p6a= pointOnLine(p7, p6, pocketWidth, false);
  p6b= pointOnLine(p7, p6, pocketWidth*1.7, false);
  p4a= pointOnLine(p3a, p5, 4., false); // why does this break? 
  p4b = p4a.get();
  p4b.x += pocketWidth*1.7;
}

void pantPointsB() {
  // for now, pant points are using same control points as body
  p13 = b13.get();
  p13.x -= ankleEase/4.;
  p13.y += pantHeight;
  p14 = b14.get();
  p15 = b15.get();
  p15a = b15a.get();
  p16 = b16.get();
  p17 = b17.get();
  p18 = b18.get();
  p19 = b19.get();
  p20 = b20.get();
  p21 = b21.get();
  p21a = b21a.get();
  p22 = b22.get();
  p23 = b23.get();
  p24 = b24.get();
  p24.x += ankleEase/4.;
  p24.y += pantHeight;

  p17a =pointOnLine(p17, p18, yokeOutside, true);
  p19a =pointOnLine(p20, p19, yokeInside, false);
}

void pantPointsSAF() {
  h1 = parallelLinePoint(p1, p2, seamAllowance, true, true);
  l2 = parallelLinePoint(p1, p2, seamAllowance, false, true);
  h2 = parallelLinePoint(p2, p3, seamAllowance, true, true);
  l3 = parallelLinePoint(p2, p3, seamAllowance, false, true);
  h3 = parallelLinePoint(p3, p3a, seamAllowance, true, true);
  l3a = parallelLinePoint(p3, p3a, seamAllowance, false, true);
  h3a = parallelLinePoint(p3a, p4, seamAllowance, true, true);
  l4 = parallelLinePoint(p3a, p4, seamAllowance, false, true);
  h4 = parallelLinePoint(p4, p5, seamAllowance, true, true);
  l5 = parallelLinePoint(p4, p5, seamAllowance, false, true);
  h5 = parallelLinePoint(p5, p6, seamAllowance, true, true);
  l6 = parallelLinePoint(p5, p6, seamAllowance, false, true);
  h6 = parallelLinePoint(p6, p7, seamAllowance, true, false);
  h7 = parallelLinePoint(p6, p7, seamAllowance, false, false);
  l7 = parallelLinePoint(p7, p9, seamAllowance, true, false);
  h9 = parallelLinePoint(p7, p9, seamAllowance, false, false);
  l9 = parallelLinePoint(p9, p9a, seamAllowance, true, false);
  h9a = parallelLinePoint(p9, p9a, seamAllowance, false, false);
  l9a = parallelLinePoint(p9a, p10, seamAllowance, true, false);
  h10 = parallelLinePoint(p9a, p10, seamAllowance, false, false);
  l10 = parallelLinePoint(p10, p11, seamAllowance, true, false);
  h11 = parallelLinePoint(p10, p11, seamAllowance, false, false);
  l11 = parallelLinePoint(p11, p12, seamAllowance, true, false);
  h12 = parallelLinePoint(p11, p12, seamAllowance, false, false);
  l1 = p1.get();
  l1.y += seamAllowance*2.;
  l12 = p12.get();
  l12.y += seamAllowance*2.;
  csa1= shiftControlPoint(p7, p9, c1, seamAllowance, false);
  csa2= shiftControlPoint(p7, p9, c2, seamAllowance, false);

  sa1 = intersectAtDistance(l12, l1, l2, h1);
  sa2 = intersectAtDistance(h1, l2, l3, h2);
  sa3 = intersectAtDistance(h2, l3, l3a, h3);
  sa3a = intersectAtDistance(h3, l3a, l4, h3a);
  sa4 = intersectAtDistance(h3a, l4, l5, h4);
  sa5 = intersectAtDistance(h4, l5, l6, h5);
  sa6 = intersectAtDistance(h5, l6, h7, h6);
  sa7 = intersectAtDistance(h6, h7, h9, l7);
  sa9 = intersectAtDistance(l7, h9, h9a, l9);
  sa9.y -= seamAllowance/3; //manual adjustment
  sa9a = intersectAtDistance(l9, h9a, h10, l9a);
  sa10 = intersectAtDistance(l9a, h10, h11, l10);
  sa11 = intersectAtDistance(l10, h11, h12, l11);
  sa12 = intersectAtDistance(l11, h12, l1, l12);
}

void pantPointsSAB() {
  h13 = parallelLinePoint(p13, p14, seamAllowance, true, true);
  l14 = parallelLinePoint(p13, p14, seamAllowance, false, true);
  h14 = parallelLinePoint(p14, p15, seamAllowance, true, true);
  l15 = parallelLinePoint(p14, p15, seamAllowance, false, true);
  h15 = parallelLinePoint(p15, p15a, seamAllowance, true, true);
  l15a = parallelLinePoint(p15, p15a, seamAllowance, false, true);
  h15a = parallelLinePoint(p15a, p16, seamAllowance, true, true);
  l16 = parallelLinePoint(p15a, p16, seamAllowance, false, true);
  h16 = parallelLinePoint(p16, p17, seamAllowance, true, true);
  l17 = parallelLinePoint(p16, p17, seamAllowance, false, true);
  h17 = parallelLinePoint(p17, p18, seamAllowance, true, true);
  l18 = parallelLinePoint(p17, p18, seamAllowance, false, true);
  h18 = parallelLinePoint(p18, p19, seamAllowance, true, true);
  h19 = parallelLinePoint(p18, p19, seamAllowance, false, true);
  l19 = parallelLinePoint(p19, p21, seamAllowance, true, false);
  h21 = parallelLinePoint(p19, p21, seamAllowance, false, false);
  l21 = parallelLinePoint(p21, p21a, seamAllowance, true, false);
  h21a = parallelLinePoint(p21, p21a, seamAllowance, false, false);
  l21a = parallelLinePoint(p21a, p22, seamAllowance, true, false);
  h22 = parallelLinePoint(p21a, p22, seamAllowance, false, false);
  l22 = parallelLinePoint(p22, p23, seamAllowance, true, false);
  h23 = parallelLinePoint(p10, p23, seamAllowance, false, false);
  l23 = parallelLinePoint(p23, p24, seamAllowance, true, false);
  h24 = parallelLinePoint(p23, p24, seamAllowance, false, false);
  l13 = p13.get();
  l13.y += seamAllowance*2.;
  l24 = p24.get();
  l24.y += seamAllowance*2.;
  csa3= shiftControlPoint(p19, p21, c3, seamAllowance, false);
  csa4= shiftControlPoint(p19, p21, c4, seamAllowance, false);

  sa13 = intersectAtDistance(l24, l13, l14, h13);
  sa14 = intersectAtDistance(h13, l14, l15, h14);
  sa15 = intersectAtDistance(h14, l15, l15a, h15);
  sa15a = intersectAtDistance(h15, l15a, l16, h15a);
  sa16 = intersectAtDistance(h15a, l16, l17, h16);
  sa17 = intersectAtDistance(h16, l17, l18, h17);
  sa18 = intersectAtDistance(h17, l18, h19, h18);
  sa19 = intersectAtDistance(h18, h19, h21, l19);
  sa21 = intersectAtDistance(l19, h21, h21a, l21);
  sa21.y -= seamAllowance/3; //manual adjustment
  sa21a = intersectAtDistance(l21, h21a, h22, l21a);
  sa22 = intersectAtDistance(l21a, h22, h23, l22);
  sa23 = intersectAtDistance(l22, h23, h24, l23);
  sa24 = intersectAtDistance(l23, h24, l13, l24);
}

///FUNCTIONS

float bezierLength(PVector a, PVector cp1, PVector cp2, PVector b) {
  float l = 0;
  float precision = .01;
  for (int i = 0; i <= 1/precision; i++) { // 1/precision is a float? works?)
    float t = i*precision;
    float x1 = bezierPoint(a.x, cp1.x, cp2.x, b.x, t);
    float x2 = bezierPoint(a.x, cp1.x, cp2.x, b.x, t+precision);
    float y1 = bezierPoint(a.y, cp1.y, cp2.y, b.y, t);
    float y2 = bezierPoint(a.y, cp1.y, cp2.y, b.y, t+precision);
    l += dist(x1, y1, x2, y2);
  }
  return l;
}

// Rotate a vector in 2D
void rotate2D(PVector v, float angle) {
  float theta = map(angle, 0, 360, 0, TWO_PI);
  // What's the magnitude?
  float m = v.mag();
  // What's the angle?
  float a = v.heading();
  // Change the angle
  a += theta;
  // Polar to cartesian for the new xy components
  v.x = m * cos(a);
  v.y = m * sin(a);
}

PVector intersectAtDistance(PVector a, PVector b, PVector c, PVector d) {
  float maxScale = 10; // line has to be within this normalized distance
  Line2D ab = makeLine(a, b);
  Line2D cd = makeLine(c, d);
  ab.offsetAndGrowBy(0, maxScale, ab.getMidPoint());
  cd.offsetAndGrowBy(0, maxScale, cd.getMidPoint());
  Line2D.LineIntersection isec = ab.intersectLine(cd);
  Vec2D pos = isec.getPos();
  return new PVector(pos.x, pos.y);
}

Line2D makeLine(PVector a, PVector b) {
  Vec2D va = new Vec2D(a.x, a.y);
  Vec2D vb = new Vec2D(b.x, b.y);
  return new Line2D(va, vb);
}

//distance in relation to point 2
PVector pointOnLine(PVector point1, PVector point2, float distance, boolean posNeg) { 
  float slope = (point2.y - point1.y)/(point2.x - point1.x);
  float yintercept = point2.y - (slope * point2.x);
  PVector isec = new PVector (0, 0);
  if (posNeg == true) {
    isec.x = - sqrt(
    - sq(yintercept) - (2.*yintercept*point2.x*slope) + (2.*yintercept*point2.y) + 
      (sq(distance)*sq(slope)) + sq(distance) - (sq(point2.x)*sq(slope)) +
      (2.*point2.x*point2.y*slope) - sq(point2.y)
      ) - (yintercept*slope) + point2.x + (point2.y*slope);
  } else {
    isec.x = sqrt(
    - sq(yintercept) - (2.*yintercept*point2.x*slope) + (2.*yintercept*point2.y) + 
      (sq(distance)*sq(slope)) + sq(distance) - (sq(point2.x)*sq(slope)) +
      (2.*point2.x*point2.y*slope) - sq(point2.y)
      ) - (yintercept*slope) + point2.x + (point2.y*slope);
  } 
  isec.x /= sq(slope) +1.;
  isec.y = (isec.x*slope) + yintercept;
  return new PVector (isec.x, isec.y);
}

// a and b points on line, c is center of circle, r is radius
// posNeg if need to toggle between two solutions
PVector circleIsecLine(PVector a, PVector b, PVector c, float r, boolean posNeg) {
  float slope = (b.y - a.y)/(b.x - a.x);
  float yintercept = b.y - (slope*b.x);
  PVector isec = new PVector(0, 0);
  if (posNeg == true) {
    isec.x = - sqrt( 
    - sq(yintercept) - (2.*yintercept*c.x*slope) + (2.*yintercept*c.y) - (sq(c.x)*sq(slope)) + 
      (2.*c.x*c.y*slope) - sq(c.y) + (sq(slope)*sq(r)) + sq(r)
      ) 
      - (yintercept* slope) + c.x + (c.y* slope);
  } else {
    isec.x = sqrt( 
    - sq(yintercept) - (2.*yintercept*c.x*slope) + (2.*yintercept*c.y) - (sq(c.x)*sq(slope)) + 
      (2.*c.x*c.y*slope) - sq(c.y) + (sq(slope)*sq(r)) + sq(r)
      ) 
      - (yintercept* slope) + c.x + (c.y* slope);
  }
  isec.x /= sq(slope) + 1.; 
  isec.y = slope* isec.x + yintercept;
  return new PVector (isec.x, isec.y);
}

// seam allowance functions:

// generate parallel lines from two points, doesn't work with horizontal lines
// a and b are two points, seam allowance is distance, toggle between new points c and d, toggle direction
PVector parallelLinePoint(PVector a, PVector b, float seamAllowance, boolean togglePoint, boolean posNeg) {
  float slope = (b.y - a.y)/(b.x - a.x);
  float yintercept = b.y - (slope*b.x);
  float perpSlope = -(1/slope);
  float aYintercept = a.y - (perpSlope*a.x); // y intercept for perpendicular from point a
  float bYintercept = b.y - (perpSlope*b.x); // y intercept for perpendicular from point b
  PVector c = new PVector(0, 0);
  PVector d = new PVector(0, 0);
  // find the points along perpendicular slope, seam allowance is distance
  if (posNeg == true) {
    c.x = - sqrt(
    - sq(aYintercept) - (2.*aYintercept*a.x*perpSlope) + (2.*aYintercept*a.y) + 
      (sq(seamAllowance)*sq(perpSlope)) + sq(seamAllowance) - (sq(a.x)*sq(perpSlope)) +
      (2.*a.x*a.y*perpSlope) - sq(a.y)
      ) - (aYintercept*perpSlope) + a.x + (a.y*perpSlope);
    d.x = - sqrt(
    - sq(bYintercept) - (2.*bYintercept*b.x*perpSlope) + (2.*bYintercept*b.y) + 
      (sq(seamAllowance)*sq(perpSlope)) + sq(seamAllowance) - (sq(b.x)*sq(perpSlope)) +
      (2.*b.x*b.y*perpSlope) - sq(b.y)
      ) - (bYintercept*perpSlope) + b.x + (b.y*perpSlope);
  } else {
    c.x = sqrt(
    - sq(aYintercept) - (2.*aYintercept*a.x*perpSlope) + (2.*aYintercept*a.y) + 
      (sq(seamAllowance)*sq(perpSlope)) + sq(seamAllowance) - (sq(a.x)*sq(perpSlope)) +
      (2.*a.x*a.y*perpSlope) - sq(a.y)
      ) - (aYintercept*perpSlope) + a.x + (a.y*perpSlope);
    d.x = sqrt(
    - sq(bYintercept) - (2.*bYintercept*b.x*perpSlope) + (2.*bYintercept*b.y) + 
      (sq(seamAllowance)*sq(perpSlope)) + sq(seamAllowance) - (sq(b.x)*sq(perpSlope)) +
      (2.*b.x*b.y*perpSlope) - sq(b.y)
      ) - (bYintercept*perpSlope) + b.x + (b.y*perpSlope);
  }
  c.x /= sq(perpSlope) +1.;
  c.y = (c.x*perpSlope) + aYintercept; 
  d.x /= sq(perpSlope) +1.;
  d.y = (d.x*perpSlope) + bYintercept; 
  if (togglePoint == true) {
    return new PVector(c.x, c.y);
  } else {
    return new PVector(d.x, d.y);
  }
} 

// shift control point toward outside of pattern amount of seam allowance
/* a and b are points that lie on a line perpendicular to the one 
 that we shift the control, c is the control point, seam allowance is the distance,
 toggle direction
 */
PVector shiftControlPoint (PVector a, PVector b, PVector c, float seamAllowance, boolean posNeg) {
  float parallelSlope = (b.y - a.y)/(b.x - a.x);
  float slope = -(1/parallelSlope); // slope that control point lies along
  float yintercept = c.y -(slope*c.x);
  PVector d = new PVector(0, 0);
  if (posNeg == true) {
    d.x = - sqrt(
    - sq(yintercept) - (2.*yintercept*c.x*slope) + (2.*yintercept*c.y) + 
      (sq(seamAllowance)*sq(slope)) + sq(seamAllowance) - (sq(c.x)*sq(slope)) +
      (2.*c.x*c.y*slope) - sq(c.y)
      ) - (yintercept*slope) + c.x + (c.y*slope);
  } else {
    d.x = sqrt(
    - sq(yintercept) - (2.*yintercept*c.x*slope) + (2.*yintercept*c.y) + 
      (sq(seamAllowance)*sq(slope)) + sq(seamAllowance) - (sq(c.x)*sq(slope)) +
      (2.*c.x*c.y*slope) - sq(c.y)
      ) - (yintercept*slope) + c.x + (c.y*slope);
  }
  d.x /= sq(slope) +1.;
  d.y = (d.x*slope) + yintercept; 
  return new PVector(d.x, d.y);
}

