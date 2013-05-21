import toxi.geom.*;
import toxi.processing.*;

// should be abstracted into a class
// all units in inches
// measured on lisa
float inseam = 31; // crotch to floor (not used)
float waist = 26; // waist circumference (not used)
float stomachOffset = -3/8.; // anywhere from -3/8 (flat stomach) to +5/8 (protruding stomach) (not in back)
float crotchOffset = 1/4.; // anywhere from 1/4 to 3/8 (very little difference) (not in back)

float sideseam = 38.4; // waist to hemline (not floor to waist)
float hipCircumference = 35; // the "fullest part of your hip" 
float crotchDepth = 8; // from waist to seat when you're sitting
float hemCircumference = 12; // also called "ankle", based on your favorite pants

float derriereShape = 2; // normal/average derriere: 1+5/8, flat derriere: 2, protruding derriere: 7/8

PFont font;

//also in front draft
PVector A, B, p1, p2, p3, p4, p5; // mark points
PVector p6, p6a, p7, p8; //add circumference
PVector p9, p10, p11, p12; //establish the crease
PVector p13, p14, p2b, p2c, p8b; //shape the front leg

//specific to back draft
PVector p15, p16, p17;
PVector p18, p19, p20;

PVector p4a, p4b, p13out, p14out, p4Aout, p4Bout, p21;

PVector pCBtop, pCBbottom, pParallel;
PVector yintercept, p22;

boolean drawGrid= true;

void setup() {
  size(400, 700);
  font = createFont("Arial", 12);
  textFont(font);  
}

void draw() {
  background(255);
  float translationAmount = 100 ;
  
  update(); 
  float pointSize = 6;
  float drawingScale = 13;
  drawingScale = map(mouseX, 0, width, 5, 50);

  if(drawGrid) grid(drawingScale);
  translate(translationAmount,translationAmount); // put translation somewhere else? 

  //points
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    A, B, p1, p2, p3, p4, p5,
    p6, p6a, p7, p8,
    p9, p10, p11, p12,
    p13, p14, p2b, p2c, p8b,
    p15, p16, p17, p18, p20,
    p4a, p4b, p13out, p14out, p4Aout, p4Bout,
    p21, pCBtop, pCBbottom, p19
  };
  String[] pointLabels = {
    "A", "B", "1", "2", "3", "4", "5",
    "6", "6a", "7", "8",
    "9", "10", "11", "12",
    "13", "14", "2b", "2c", "8b",
    "15", "16", "17", "18", "20",
    "4a", "4b", "13out","14out","4aout","4bout",
    "21", "CBtop", "", "19",
  };
  for (int i = 0; i < points.length; i++){
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y); 
  }
  
  //horizontal lines
  stroke(200);
  textAlign(RIGHT, BOTTOM);
  PVector[] horizontalLines = {
  p1, p2, p4, p5, B,
  };
  String[] horizontalLineLabels = {
  "Waist", "Crotch Depth", "Knee", "Hipline", "Hemline", 
  };
  for (int i = 0; i < horizontalLines.length; i++) {
    float y = horizontalLines[i].y * drawingScale;
    line(0- translationAmount, y, width- translationAmount, y);
    text(horizontalLineLabels[i], (width- translationAmount), y);
  }
  
  //vertical lines
  stroke(200);
  PVector[] verticalLines = {
    p6, p9, p1
  };
  String[] verticalLineLabels = {
    "", "Crease Line", "",
  };
  for (int i = 0; i < verticalLines.length; i++) {
    float x = verticalLines[i].x * drawingScale;
    line(x, 0 - translationAmount, x, height - translationAmount);
    // turn crease line label sideways 
    pushMatrix();
    translate(x, (height- translationAmount) / 2);
    rotate(-HALF_PI);
    text(verticalLineLabels[i], 0, 0);
    popMatrix();
  }
  
  //line pairs - front draft, in faded blue
  stroke(0, 0, 255, 50);
  PVector[] linePairs = {
    p13, p5,
    p14, p6a,
    p2b, p8b,
  };
  for (int i = 0; i < linePairs.length; i += 2) {
    line(linePairs[i].x * drawingScale,
    linePairs[i].y * drawingScale,
    linePairs[i+1].x * drawingScale,
    linePairs[i+1].y * drawingScale);
  }

  //line pairs - back draft, in green
  stroke(0, 255, 0);
  PVector[] linePairsBack = {
    p15, p11,
    p17, p16,
    p11,p21,
    pCBtop, pCBbottom,
    p18, p19,
  };
  for (int i = 0; i < linePairsBack.length; i += 2) {
    line(linePairsBack[i].x * drawingScale,
    linePairsBack[i].y * drawingScale,
    linePairsBack[i+1].x * drawingScale,
    linePairsBack[i+1].y * drawingScale);
  }
  
  //outside beziers
  pushStyle();
  stroke(0,200,0);
  noFill();
  drawBezier(p21, p18, p4Aout, p13out,drawingScale);
  drawBezier(p14out,p4Bout,p4Bout,p20,drawingScale);  
  popStyle();
  
  // p22 is the intersection of a circle created by the dist between p11 and p21 and CB
  // only need the point, can delete the following:
  float distancep21andp11;
  distancep21andp11= dist(p11.x, p11.y, p21.x, p21.y);
  ellipseMode(CENTER);
  stroke(255,0,0, 50);
  noFill();
  ellipse(p11.x*drawingScale, p11.y*drawingScale, distancep21andp11*drawingScale*2,distancep21andp11*drawingScale*2);
}

void update(){ 
  // mark points
  A = new PVector(0,0);
  B = A.get();
  B.y += 5/8. + sideseam;
  p1 = A.get();
  p1.y += 5/8.;
  p2 = p1.get();
  p2.y += crotchDepth;
  p3 = PVector.add(B, p2);
  p3.div(2);
  p4 = p3.get();
  p4.y -= inseam / 10.;
  p5 = p2.get();
  p5.y -= ((hipCircumference / 2.) / 10.) + (1 + 1/4.);
  
  // add circumference measurements
  p6 = p5.get();
  p6.x += (hipCircumference/ 4.) - 3/8.;
  p6a = p6.get();
  p6a.x += ((hipCircumference / 2.) / 10.) + 1/4.;
  p7 = p6.get();
  p7.y =1;
  p8 = p6.get();
  p8.y = p2.y; 
  
  //establish the crease
  p9 = PVector.add(p5, p6a);
  p9.div(2);
  p10 = p9.get();
  p10.y = p2.y;
  p11 = p9.get();
  p11.y = p4.y;
  p12 = p9.get();
  p12.y = B.y; 
  
  //shape the front leg
  p13 = p12.get();
  p13.x -= (hemCircumference / 4.) - (3/8.);
  p14 = p12.get();
  p14.x += (hemCircumference / 4.) - (3/8.);
  p2b = intersectAtDistance(p14, p6a, p2, p8); //this is confusing
  p2c = PVector.add(p2b, p8);
  p2c.div(2);
  p8b = p8.get();
  p8b.y -= (p2c.x - p8.x);
  
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
  p4a = intersectAtDistance(p13,p5,p4,p11);
  p4b = intersectAtDistance(p6a,p14,p4,p11);
  p13out = p13.get();
  p13out.x -= 3/4.;
  p14out = p14.get();
  p14out.x += 3/4.;
  p4Aout = p4a.get();
  p4Aout.x -= 3/4.;
  p4Bout = p4b.get();
  p4Bout.x += 3/4.;
  
  p21 = intersectAtDistance(p18,p4Aout,p1, p7);
  
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
  pCBbottom = intersectAtDistance(p2,p10,p16,pCBtop);
  p19 = intersectAtDistance(pCBbottom,p16,p18,pParallel);
  
  // calculate the intersection
  // p22 is the intersection of a circle created by the dist between p11 and p21 and CB
  float radius;
  radius= dist(p11.x, p11.y, p21.x, p21.y);
  yintercept = A.get();
  yintercept.y = p16.y - (slope*p16.x);
  // (p22.x-p11.x) ^2 + (slope*p22.x + yintercept.y - p11.y)^2 = radius^2
  // (p22.x-p11.x)(p22.x-p11.x) + (slope*p22.x + yintercept.y - p11.y)(slope*p22.x + yintercept.y - p11.y) = radius^2
  // need to isolate p22.x
  // having middle school math flashbacks
  
}

// calculate location of p2b using toxiclibs
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


void grid(float drawingScale){
  // grid
  stroke(150,150,150,30);
  int xsegments = int(width / drawingScale);
  int ysegments = int(height / drawingScale);
  for(int y = 0; y < ysegments; y++) {
    line(0, y * drawingScale, width, y * drawingScale);
  }
  for(int x = 0; x < xsegments; x++) {
    line(x * drawingScale, 0, x * drawingScale, height);
  }
}

void drawBezier(PVector anchorPoint1, PVector controlPoint1, PVector controlPoint2, PVector anchorPoint2, float scale){
    
    bezier(scale * anchorPoint1.x, scale * anchorPoint1.y, 
    scale * controlPoint1.x, scale * controlPoint1.y, 
    scale * controlPoint2.x, scale * controlPoint2.y, 
    scale * anchorPoint2.x, scale * anchorPoint2.y);
}
