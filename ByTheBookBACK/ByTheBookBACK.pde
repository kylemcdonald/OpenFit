import toxi.geom.*;
import toxi.processing.*;

// should be abstracted into a class, but I have no idea how :)
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

void setup() {
  size(400, 700);
  font = createFont("Arial", 12);
  textFont(font);  
  //need to call update(); in setup?
}

void update(){ // <-- compute stuff here: how points are related
  // mark points
  // remember: 0 is at top, therefore plus is down!
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
  //find the center back:
  p15 = p9.get();
  p15.x += 3/8.;
  p16 = p15.get();
  p16.x += (((hipCircumference / 4.) + 3/8.)/ 4.);
  p17 = p2.get();
  p17.y -= derriereShape; 
}

// toxilibs stuff is confusing... all for p2b?

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

void draw() {
  update(); // <-- forget this and you will have null pointer exception frustration!
  
  float translationAmount = 100 ;
  translate(translationAmount,translationAmount); // put translation somewhere else? 
  
  background(255);
  float pointSize = 6;
  float drawingScale = 13;
  //drawingScale = map(mouseX, 0, width, 5, 50);
  
  //points
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    A, B, p1, p2, p3, p4, p5,
    p6, p6a, p7, p8,
    p9, p10, p11, p12,
    p13, p14, p2b, p2c, p8b,
    p15, p16, p17,
  };
  String[] pointLabels = {
    "A", "B", "1", "2", "3", "4", "5",
    "6", "6a", "7", "8",
    "9", "10", "11", "12",
    "13", "14", "2b", "2c", "8b",
    "15", "16", "17",
    
  };
  for (int i = 0; i < points.length; i++){
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
    ellipse(x, y, pointSize, pointSize); 
    text(pointLabels[i], x + pointSize, y); 
  }
  
  //horizontal lines
  noFill();
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
  noFill();
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
  noFill();
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
  noFill();
  stroke(0, 255, 0);
  PVector[] linePairsBack = {
    p15, p11,
    p17, p16,
  };
  for (int i = 0; i < linePairsBack.length; i += 2) {
    line(linePairsBack[i].x * drawingScale,
    linePairsBack[i].y * drawingScale,
    linePairsBack[i+1].x * drawingScale,
    linePairsBack[i+1].y * drawingScale);
  }
  
  //square a line perpendicular to linePairsBack p16, p17 & declare Center Back
  pushMatrix();
  translate(p16.x*drawingScale,p16.y*drawingScale);
  noFill();
  stroke(0, 255, 0);
  rotate(radians(90));
  line(0, 0, -(p16.x*drawingScale)-(p17.x*drawingScale), (p17.y*drawingScale)-(p16.y*drawingScale));
  rotate(radians(-5));
  text("Center Back",0,0);
  popMatrix();
   
}

