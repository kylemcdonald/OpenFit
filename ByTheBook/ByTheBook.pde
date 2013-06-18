import toxi.geom.*;
import toxi.processing.*;
import processing.pdf.*;
import controlP5.*;
ControlP5 cp5;

static int screenWidth = 700;
static int screenHeight = 600;
float pointSize = 6;
float drawingScale = 13;

boolean showGrid = false;
boolean frontSeamAllowance = false;
boolean backSeamAllowance = false;
boolean cutLayout = false;
boolean draftingMarks = false;
boolean savePdf = false;
// need booleans for: drafting lines, gui on and off, pdf, 

PFont font;

float seamAllowance = 3/8.;

// measurements
float inseam = 31; // crotch to floor 
float sideseam = 38.4; // waist to hemline (not floor to waist)
float hipCircumference = 35; // the "fullest part of your hip" 
float crotchDepth = 8; // from waist to seat when you're sitting
float hemCircumference = 12; // also called "ankle", based on your favorite pants
// measurements, pant front only
float stomachOffset = -3/8.; // anywhere from -3/8 (flat stomach) to +5/8 (protruding stomach) 
float crotchOffset = 1/4.; // anywhere from 1/4 to 3/8 (very little difference)
//measurements, pant back only
float waist = 26; // waist circumference
float derriereShape = 2; // normal/average derriere: 1+5/8, flat derriere: 2, protruding derriere: 7/8
float takeInCenterBack = 3/8.; //usually 1/4" to 3/8"
float dartDepth = 2;

//front and back
PVector A, B, p1, p2, p3, p4, p5; //mark points
PVector p6, p6a, p7, p8; //add circumference
PVector p9, p10, p11, p12; // establish crease
PVector p13, p14, p2b, p2c, p8b; // shape front leg
//pant front
PVector p7a, p6b; // stomach and crotch
PVector D, Aa, p5a; //front waistline
//pant back
PVector p15, p16, p17; 
PVector p18, p19, p20;
PVector pCBtop, pCBbottom, pParallel; //shift hips, find center back
PVector p4a, p4b, p13out, p14out, p4Aout, p4Bout, p21; //outside legs
PVector p22, p23, p24, p25, p21ControlPoint; // curve back, crotch hips
//seam allowance points front
PVector h13, lp5, hp5, lAa, hAa, h7a, l7a, h2b, l2b, h14, l14, l13; //extend corners
PVector sa13, sa5, saAa, sa7a, sa2b, sa14; // intersect at distance
PVector sa5a, saD, sa6b, sa8b; //shift control points
// seam allowance points back
PVector h13out, l18, h18, l25, h24, h25, h19, l24, l19, h23, l23, h14out, l13out, l14out; // extend corners
PVector sa13out, sa18, sa25, sa24, sa19, sa23, sa14out; //intersect at distance
PVector sa4Aout, sa21ControlPoint, sa16, sa2b2, sa4Bout; //shift control points

void setup() {
  size(screenWidth, screenHeight);

  font = createFont("Arial", 12);
  textFont(font);

  cp5 = new ControlP5(this);
  measurementGui();
}

void draw() {
  background(255);
  
  if (savePdf) beginRecord(PDF, "Pant-"+year()+"-"+month()+"-"+day()+"-"+minute()+"-"+second()+".pdf");

  float translationAmountX = width/16;
  float translationAmountY = height/16;

  if (showGrid) grid(drawingScale);

  update();

  pushMatrix();
  translate(0, translationAmountY);
  if (draftingMarks) horizontalDraftingLines();
  popMatrix();

  pushMatrix();
  translate(translationAmountX, translationAmountY);
  pantFrontShape();
  if (frontSeamAllowance) pantFrontShapeSA();
  if (draftingMarks) seamAllowanceDraftingPointsF();
  if (draftingMarks) verticalDraftingLines();

  popMatrix();

  pushMatrix();
  if (cutLayout) {
    translate(translationAmountX, translationAmountY);
    rotate(PI);
    translate(-width*.45, -height*.85); // manual translation
  } else {
    translate((width/2) - translationAmountX, translationAmountY);
  }
  pantBackShape();
  if (backSeamAllowance) pantBackShapeSA();
  if (draftingMarks) seamAllowanceDraftingPointsB();
  if (draftingMarks) verticalDraftingLines();
  popMatrix();
  
  if (savePdf) {
    savePdf=false; 
    endRecord();
  }

  /*can delete:
   float test = 1;
   float test2 = 0;
   test = map(mouseX, 0, width, 0,400);
   test2 = map(mouseY, 0, width, -200, 200);
   pushMatrix();
   translate(test, test2);
   scale(1.1); 
   pantBackShape();
   popMatrix(); */
}

void keyPressed() {
  println(key);
  if (key=='d') {
    if (cp5.isVisible())
      cp5.hide();
    else
      cp5.show();
  }
  if (key=='s') {
    savePdf=true;
  }
}

void grid(float drawingScale) { // why do i need to pass drawing scale here? -- if isnt global? 
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

void seamAllowanceDraftingPointsF() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    //lp5, h13, hp5, lAa, hAa, h7a, l7a, h2b, l2b, h14, l14, l13,
    sa13, sa5, saAa, sa7a, sa2b, sa14, 
    sa5a, saD, sa6b, sa8b
  };
  String[] pointLabels = {
    //"lp5", "h13", "hp5", "lAa", "hAa", "h7a", "l7a", "h2b", "l2b", "h14", "l14", "l13",
    "sa13", "sa5", "saAa", "sa7a", "sa2b", "sa14", 
    "sa5a", "saD", "sa6b", "sa8b",
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}

void seamAllowanceDraftingPointsB() {
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    //h13out, l18, h18, l25, h24, h25, h19, l24, l19, h23, l23, h14out, l13out, l14out,
    sa13out, sa18, sa25, sa24, sa19, sa23, sa14out, 
    sa4Aout, sa21ControlPoint, sa16, sa2b2, sa4Bout,
  };
  String[] pointLabels = {
    //"h13out", "l18", "h18", "l25", "h24", "h25", "h19", "l24", "l19", "h23", "l23", "h14out", "l13out", "l14out",
    "sa13out", "sa18", "sa25", "sa24", "sa19", "sa23", "sa14out", 
    "sa4Aout", "sa21CP", "sa16", "sa2b2", "sa4Bout",
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y);
  }
}

// drafting lines and points
void horizontalDraftingLines() {
  noFill();
  stroke(200);
  textAlign(RIGHT, BOTTOM);
  PVector[] horizontalLines = {
    p1, p5, p2, p4, B
  };
  String[] horizontalLineLabels = {
    "Waist", "Hipline", "Crotch depth", "Knee", "Hemline"
  };
  for (int i = 0; i < horizontalLines.length; i++) {
    float y = horizontalLines[i].y * drawingScale;
    line(0, y, width, y);
    text(horizontalLineLabels[i], width, y);
  }
}

void verticalDraftingLines() {
  translate( 0, -height/16);
  noFill();
  stroke(200);
  line(p9.x*drawingScale, 0, p9.x*drawingScale, height);
  pushMatrix();
  translate(p9.x*drawingScale, height / 2);
  rotate(-HALF_PI);
  text("Crease Line", 0, 0);
  popMatrix();
} 

// set up control panel for changing measurements
void measurementGui() {
  cp5.setColorCaptionLabel(0);

  /*
  int x = 500, y = 10, spacing = 10;
   cp5.addSlider("seamAllowance").setPosition(x, y+=spacing).setRange(1./4, 2);
   cp5.addSlider("inseam").setPosition(x, y+=spacing).setRange(20, 40);
   cp5.addSlider("sideseam").setPosition(x, y+=spacing).setRange(30, 50);
   cp5.addSlider("hipCircumference").setPosition(x, y+=spacing).setRange(30, 50);
   cp5.addSlider("crotchDepth").setPosition(x, y+=spacing).setRange(5, 15);
   cp5.addSlider("hemCircumference").setPosition(x, y+=spacing).setRange(5, 15);
   // pant front
   cp5.addSlider("stomachOffset").setPosition(x, y+=spacing).setRange(-3./8, +5./8);
   cp5.addSlider("crotchOffset").setPosition(x, y+=spacing).setRange(1./4, 3./8);
   // pant back
   cp5.addSlider("waist").setPosition(x, y+=spacing).setRange(20, 40);
   cp5.addSlider("derriereShape").setPosition(x, y+=spacing).setRange(7./8, 2);
   cp5.addSlider("takeInCenterBack").setPosition(x, y+=spacing).setRange(1./4, 3./8);
   cp5.addSlider("dartDepth").setPosition(x, y+=spacing).setRange(0, 4); */

  int x = 500, y = 10, spacing = 40;
  cp5.addNumberbox("seamAllowance").setPosition(x, y).setRange(1./4, 2)
    .setValue(seamAllowance).setMultiplier(0.125);
  cp5.addNumberbox("inseam").setPosition(x, y+=spacing).setRange(20, 40.)
    .setValue(inseam).setMultiplier(0.5);
  cp5.addNumberbox("sideseam").setPosition(x, y+=spacing).setRange(30, 50)
    .setValue(sideseam).setMultiplier(0.5);
  cp5.addNumberbox("hipCircumference").setPosition(x, y+=spacing).setRange(30, 50)
    .setValue(hipCircumference).setMultiplier(0.25);
  cp5.addNumberbox("crotchDepth").setPosition(x, y+=spacing).setRange(5, 15)
    .setValue(crotchDepth).setMultiplier(0.25);
  cp5.addNumberbox("hemCircumference").setPosition(x, y+=spacing).setRange(5, 15)
    .setValue(hemCircumference).setMultiplier(0.25);
  // pant front
  cp5.addNumberbox("stomachOffset").setPosition(x, y+=spacing).setRange(-3./8, +5./8)
    .setValue(stomachOffset).setMultiplier(0.125);
  cp5.addNumberbox("crotchOffset").setPosition(x, y+=spacing).setRange(1./4, 3./8)
    .setValue(crotchOffset).setMultiplier(0.125);
  // pant back
  cp5.addNumberbox("waist").setPosition(x, y+=spacing).setRange(20, 40)
    .setValue(waist).setMultiplier(0.25);
  cp5.addNumberbox("derriereShape").setPosition(x, y+=spacing).setRange(7./8, 2)
    .setValue(derriereShape).setMultiplier(0.125);
  cp5.addNumberbox("takeInCenterBack").setPosition(x, y+=spacing).setRange(1./4, 3./8)
    .setValue(takeInCenterBack).setMultiplier(0.125);
  cp5.addNumberbox("dartDepth").setPosition(x, y+=spacing).setRange(0, 4)
    .setValue(dartDepth).setMultiplier(0.125);  
  cp5.addNumberbox("drawingScale").setPosition(x, y+=spacing).setRange(8, 25)
    .setValue(drawingScale).setMultiplier(1.);  

  cp5.addToggle("showGrid").setPosition(x, y+=spacing).setSize(20, 20);
  cp5.addToggle("cutLayout").setPosition(x+=spacing, y).setSize(20, 20);
  cp5.addToggle("frontSeamAllowance").setPosition(x+=spacing, y).setSize(20, 20);
  cp5.addToggle("backSeamAllowance").setPosition(x-=spacing*2, y+=spacing).setSize(20, 20);
  cp5.addToggle("draftingMarks").setPosition(x+=spacing*2, y).setSize(20, 20);
}

// shape function for pant front 
void pantFrontShape() {
  stroke(100);
  noFill();
  beginShape();
  vertexScale(p13);
  vertexScale(p5);
  bezierVertexScale(p5a, p5a, Aa);
  bezierVertexScale(D, D, p7a);
  bezierVertexScale(p6b, p8b, p2b);
  vertexScale(p14);
  endShape(CLOSE);
}

// shape function for pant front with seam allowance
void pantFrontShapeSA() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(sa13);
  vertexScale(sa5);
  bezierVertexScale(sa5a, sa5a, saAa);
  bezierVertexScale(saD, saD, sa7a);
  bezierVertexScale(sa6b, sa8b, sa2b);
  vertexScale(sa14);
  endShape(CLOSE);
}

// shape function for pant back
void pantBackShape() {
  stroke(100);
  noFill();
  beginShape();
  vertexScale(p13out);
  bezierVertexScale(p4Aout, p4Aout, p18);
  bezierVertexScale(p21ControlPoint, p21ControlPoint, p25);
  vertexScale(p24);
  vertexScale(p19);
  bezierVertexScale(p16, p2b, p23);
  bezierVertexScale(p4Bout, p4Bout, p14out);
  endShape(CLOSE);
}

// shape function for pant back with seam allowance
void pantBackShapeSA() {
  stroke(0);
  noFill();
  beginShape();
  vertexScale(sa13out);
  bezierVertexScale(sa4Aout, sa4Aout, sa18);
  bezierVertexScale(sa21ControlPoint, sa21ControlPoint, sa25);
  vertexScale(sa24);
  vertexScale(sa19);
  bezierVertexScale(sa16, sa2b, sa23);
  bezierVertexScale(sa4Bout, sa4Bout, sa14out);
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

// calculate all points
void update() {
  // mark points
  A = new PVector(0, 0);
  B = A.get();
  B.y += 5./8 + sideseam;
  p1 = A.get();
  p1.y += 5./8;
  p2 = p1.get();
  p2.y += crotchDepth;
  p3 = PVector.add(B, p2);
  p3.div(2);
  p4 = p3.get();
  p4.y -= inseam / 10.;

  // add circumference measurements
  p5 = p2.get();
  p5.y -= (hipCircumference / 2.) / 10. + (1 + 1/4.);
  p6 = p5.get();
  p6.x += hipCircumference / 4. - 3/8.;
  p7 = p6.get();
  p7.y = p1.y;
  p8 = p6.get();
  p8.y = p2.y;
  p6a = p6.get();
  p6a.x += ((hipCircumference / 2.) / 10.) + (1/4.);

  // establish the crease line
  p9 = PVector.add(p5, p6a);
  p9.div(2);
  p10 = p9.get();
  p10.y = p8.y;
  p11 = p9.get();
  p11.y = p4.y;
  p12 = p9.get();
  p12.y = B.y;

  // shape the leg
  p13 = p12.get();
  p13.x -= (hemCircumference / 4.) - (3/8.);
  p14 = p12.get();
  p14.x += (hemCircumference / 4.) - (3/8.);
  p2b = intersectAtDistance(p14, p6a, p2, p8);
  p2c = PVector.add(p2b, p8);
  p2c.div(2);
  p8b = p8.get();
  p8b.y -= (p2c.x - p8.x);

  // adjust for the stomach
  p7a = p7.get();
  p7a.x += stomachOffset;
  p6b = p6.get();
  p6b.x += crotchOffset;

  // curve the waistline
  D = p7a.get();
  D.x = p9.x;
  Aa = pointOnLine(D, A, 1., false);
  p5a = PVector.add(p5, A);
  p5a.div(2);

  //BACK DRAFT:
  //find the center back
  p15 = p9.get();
  p15.x += 3/8.;
  p16 = p15.get();
  p16.x += (((hipCircumference / 4.) + 3/8.)/ 4.);
  p17 = p2.get();
  p17.y -= derriereShape; 

  //shift the hips
  p18 = p16.get();
  p18.x -= (hipCircumference / 4.) + 3/8.;
  p20 = p15.get();
  p20.x += (p15.x-p18.x); 

  //draw the outside lines
  p4a = intersectAtDistance(p13, p5, p4, p11);
  p4b = intersectAtDistance(p6a, p14, p4, p11);
  p13out = p13.get();
  p13out.x -= 3/4.;
  p14out = p14.get();
  p14out.x += 3/4.;
  p4Aout = p4a.get();
  p4Aout.x -= 3/4.;
  p4Bout = p4b.get();
  p4Bout.x += 3/4.;

  p21 = intersectAtDistance(p18, p4Aout, p1, p7);

  // draw parallel and center back line
  float slope = (p17.y-p16.y)/(p17.x-p16.x);
  pParallel = p12.get();
  pParallel.y = (pParallel.x-p18.x);
  pParallel.y *= slope;
  pParallel.y += p18.y;
  slope = - (1/slope);
  pCBtop = p11.get();
  pCBtop.x += 1+ 3/4.; // picked 1.75" arbitrarily, CB just needs to extend above waistline
  pCBtop.y = (pCBtop.x-p16.x); 
  pCBtop.y *= slope;
  pCBtop.y += p16.y;
  pCBbottom = intersectAtDistance(p2, p10, p16, pCBtop);
  p19 = intersectAtDistance(pCBbottom, p16, p18, pParallel);

  float radius = dist(p11.x, p11.y, p21.x, p21.y);
  p22 = circleIsecLine(pCBtop, p19, p11, radius, true);
  p23 = pointOnLine(p4Bout, p20, ((hipCircumference / 2.) / 10. + (1 + 1/4.)) + 1/4., true);
  p24 = pointOnLine(p21, p22, takeInCenterBack, true);
  p25 = pointOnLine(p21, p24, (((waist/4.)-1/4.)+dartDepth), true);
  p21ControlPoint = pointOnLine(p18, p21, dartDepth, false); 

  // seam allowance front:
  lp5 = parallelLinePoint(p5, p13, seamAllowance, true, true);
  h13 = parallelLinePoint(p5, p13, seamAllowance, false, true);
  lAa = parallelLinePoint(Aa, p5, seamAllowance, true, true);
  hp5 = parallelLinePoint(Aa, p5, seamAllowance, false, true);
  hAa = parallelLinePoint(Aa, p7a, seamAllowance, true, false);
  h7a = parallelLinePoint(Aa, p7a, seamAllowance, false, false);
  l7a = parallelLinePoint(p7a, p2b, seamAllowance, true, false);
  h2b = parallelLinePoint(p7a, p2b, seamAllowance, false, false);
  l2b = parallelLinePoint(p2b, p14, seamAllowance, true, false);
  h14 = parallelLinePoint(p2b, p14, seamAllowance, false, false);
  l14 = p14.get();
  l14.y += seamAllowance*2; // *2 because need double seam allowance for hem
  l13 = p13.get();
  l13.y += seamAllowance*2;

  sa13 = intersectAtDistance(l14, l13, lp5, h13);
  sa5 = intersectAtDistance(h13, lp5, lAa, hp5);
  saAa = intersectAtDistance(hp5, lAa, h7a, hAa);
  sa7a = intersectAtDistance(hAa, h7a, h2b, l7a);
  sa2b = intersectAtDistance(l7a, h2b, h14, l2b);
  sa14 = intersectAtDistance(l2b, h14, l13, l14);

  sa5a = shiftControlPoint (p5, Aa, p5a, seamAllowance, true);
  saD = shiftControlPoint (Aa, p7a, D, seamAllowance, false);
  sa6b = shiftControlPoint (p7a, p2b, p6b, seamAllowance, false);
  sa8b = shiftControlPoint (p7a, p2b, p8b, seamAllowance, false);

  // seam allowance back:
  l18 = parallelLinePoint(p18, p13out, seamAllowance, true, true);
  h13out = parallelLinePoint(p18, p13out, seamAllowance, false, true);
  l25 = parallelLinePoint(p25, p18, seamAllowance, true, true);
  h18 = parallelLinePoint(p25, p18, seamAllowance, false, true);
  h24 = parallelLinePoint(p24, p25, seamAllowance, true, true);
  h25 = parallelLinePoint(p24, p25, seamAllowance, false, true);
  h19 = parallelLinePoint(p19, p24, seamAllowance, true, false);
  l24 = parallelLinePoint(p19, p24, seamAllowance, false, false);
  h23 = parallelLinePoint(p23, p19, seamAllowance, true, false);
  l19 = parallelLinePoint(p23, p19, seamAllowance, false, false);
  h14out = parallelLinePoint(p14out, p23, seamAllowance, true, false);
  l23 = parallelLinePoint(p14out, p23, seamAllowance, false, false);
  l14out = p14out.get();
  l14out.y += seamAllowance*2; // *2 because need double seam allowance for hem
  l13out = p13out.get();
  l13out.y += seamAllowance*2;

  sa13out = intersectAtDistance(l14out, l13out, l18, h13out);
  sa18 = intersectAtDistance(h13out, l18, l25, h18);
  sa25 = intersectAtDistance(h18, l25, h24, h25);
  sa24 = intersectAtDistance(h25, h24, l19, l24);
  //sa19 = intersectAtDistance(l24, l19, h23, h19); // l19 is high and h19 is low due to concave angle, a little too close
  sa19 = shiftControlPoint (p24, p2b, p19, (seamAllowance+(seamAllowance/4.)), false); // use either method for sa19, 1+1/4 seam allowance is manual adjustment
  sa23 = intersectAtDistance(h19, h23, h14out, l23);
  sa23.y -= seamAllowance/2.; // manual adjustment, give more space in crotch
  sa14out = intersectAtDistance(l23, h14out, l13out, l14out);

  sa4Aout = shiftControlPoint (p13out, p18, p4Aout, seamAllowance, true);
  sa21ControlPoint = shiftControlPoint (p18, p25, p21ControlPoint, seamAllowance, true);
  sa16 = shiftControlPoint (p24, p23, p16, (seamAllowance+(seamAllowance/4.)), false); // 1+1/4 seam allowance is manual adjustment
  sa2b2 = shiftControlPoint (p16, p23, p2b, seamAllowance*2., false); // manual adjustment, give more space in crotch
  sa4Bout = shiftControlPoint (p23, p14out, p4Bout, seamAllowance, false);
}

// geometry functions used in update:
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

