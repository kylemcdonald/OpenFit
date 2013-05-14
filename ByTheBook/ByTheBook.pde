// should be abstracted into a class
// all units in inches
// measured on lisa
float inseam = 31; // crotch to floor
float waist = 26; // waist circumference
float sideseam = 38.4; // waist to hemline (not floor to waist)
float hipCircumference = 35; // the "fullest part of your hip" 
float crotchDepth = 8; // from waist to seat when you're sitting
float ankle = 12; // based on your favorite pants

PVector A, B, p1, p2, p3, p4, p5;
PVector p6, p7, p8, p6a;
PVector p9;
PFont font;

void setup() {
  size(350, 800);
  
  font = createFont("Arial", 16);
  textFont(font);
  
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
}

void draw() {
  background(255);
  float pointSize = 6;
  float drawingScale = 20;
    
  // horizontal lines
  noFill();
  stroke(200);
  textAlign(LEFT, BOTTOM);
  PVector[] horizontalLines = {p1, p5, p2, p4, B};
  String[] horizontalLineLabels = {"Waist", "Hipline", "Crotch depth", "Knee", "Hemline"};
  for(int i = 0; i < horizontalLines.length; i++) {
    float y = horizontalLines[i].y * drawingScale;
    line(0, y, width, y);
    text(horizontalLineLabels[i], width / 2, y);
  }
  
  // vertical lines
  noFill();
  stroke(200, 0, 0);
  PVector[] verticalLines = {p6, p9};
  String[] verticalLineLabels = {"", "Crease line"};
  for(int i = 0; i < verticalLines.length; i++) {
    float x = verticalLines[i].x * drawingScale;
    line(x, 0, x, height);
    pushMatrix();
    translate(x, height / 2);
    rotate(-HALF_PI);
    text(verticalLineLabels[i], 0, 0);
    popMatrix();
  }
  
  // points
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {A, B, p1, p2, p3, p4, p5, p6, p7, p8, p6a, p9};
  String[] pointLabels = {
    "A", "B", "1", "2", "3", "4",
    "5", "6", "7", "8", "6a",
    "9"    
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale;
    ellipse(x, y, pointSize, pointSize);
    text(pointLabels[i], x + pointSize, y);
  }
}

