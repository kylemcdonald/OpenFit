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
PFont font;

void setup() {
  size(350, 800);
  
  font = createFont("Arial", 16);
  textFont(font);
  
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
  p4.y -= inseam / 10.; // knee position
  p5 = p2.get();
  p5.y -= (hipCircumference / 2.) / 10. + (1 + 1/4.);
}

void draw() {
  background(255);
  float pointSize = 4;
  float drawingScale = 20;
    
  noFill();
  stroke(200);
  textAlign(LEFT, BOTTOM);
  PVector[] lines = {p1, p5, p2, p4, B};
  String[] lineLabels = {"Waist", "Hipline", "Crotch depth", "Knee", "Hemline"};
  for(int i = 0; i < lines.length; i++) {
    float y = lines[i].y * drawingScale;
    line(0, y, width, y);
    text(lineLabels[i], width / 2, y);
  }
  
  noStroke();
  fill(0);
  textAlign(LEFT, CENTER);
  PVector[] points = {A, B, p1, p2, p3, p4, p5};
  String[] pointLabels = {"A", "B", "p1", "p2", "p3", "p4", "p5"};
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * drawingScale, y = points[i].y * drawingScale;
    rect(x, y, pointSize, pointSize);
    text(pointLabels[i], x + pointSize, y);
  }
}

