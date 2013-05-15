import toxi.geom.*;
import toxi.processing.*;

// should be abstracted into a class, but I have no idea how :)
// all units in inches
// measured on lisa
float inseam = 31; // crotch to floor (not used)
float waist = 26; // waist circumference (not used)

float sideseam = 38.4; // waist to hemline (not floor to waist)
float hipCircumference = 35; // the "fullest part of your hip" 
float crotchDepth = 8; // from waist to seat when you're sitting
float hemCircumference = 12; // also called "ankle", based on your favorite pants
float stomachOffset = -3/8.; // anywhere from -3/8 (flat stomach) to +5/8 (protruding stomach)
float crotchOffset = 1/4.; // anywhere from 1/4 to 3/8 (very little difference)

PFont font;

//also in front draft
PVector A, B, p1, p2, p3, p4, p5; // mark points
PVector p6, p6a, p7, p8; //add circumference
PVector p9, p10, p11, p12; //establish the crease
PVector p13, p14, p2b, p2c, p8b; //shape the front leg

//specific to back draft

void setup() {
  size(300, 600);
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
 
  background(255);
  float pointSize = 6;
  float drawingScale = 13;
  //drawingScale = map(mouseX, 0, width, 5, 20);
  
  //points
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {
    A, B, p1, p2, p3, p4, p5,
    p6, p6a, p7, p8,
    p9, p10, p11, p12,
    p13, p14, p2b, p2c, p8b,
  };
  String[] pointLabels = {
    "A", "B", "1", "2", "3", "4", "5",
    "6", "6a", "7", "8",
    "9", "10", "11", "12",
    "13", "14", "2b", "2c", "p8",
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
    line(0, y, width, y);
    text(horizontalLineLabels[i], width, y);
  }
  
  //vertical lines
  noFill();
  stroke(200);
  PVector[] verticalLines = {
    p6, p9
  };
  String[] verticalLineLabels = {
    "", "Crease Line",
  };
  for (int i = 0; i < verticalLines.length; i++) {
    float x = verticalLines[i].x * drawingScale;
    line(x, 0, x, height);
    // turn crease line label sideways 
    pushMatrix();
    translate(x, height / 2);
    rotate(-HALF_PI);
    text(verticalLineLabels[i], 0, 0);
    popMatrix();
  }
  
  //line pairs
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
  
}

