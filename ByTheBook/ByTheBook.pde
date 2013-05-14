// should be abstracted into a class
// all units in inches
// measured on lisa
float inseam = 31; // crotch to floor
float waist = 26; // waist circumference
float sideseam = 39; // floor to waist
float hipCircumference = 35; // the "fullest part of your hip" 
float crotchDepth = 8; // from waist to seat when you're sitting
float ankle = 12; // based on your favorite pants

PVector A, p1, p2;
String[] labels = {"A", "p1", "p2"};
PFont font;

void setup() {
  size(500, 500);
  
  font = createFont("Arial", 16);
  textFont(font);
  textAlign(LEFT, CENTER);
  
  A = new PVector(0, 0);
  p1 = A.get();
  p1.y += 5./8;
  p2 = p1.get();
  p2.y += crotchDepth;
}

void draw() {
  background(255);
  float pointSize = 4;
  float drawingScale = mouseX;
  noStroke();
  fill(0);
  PVector[] points = {
    A, p1, p2
  };
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x * mouseX, y = points[i].y * mouseX;
    rect(x, y, pointSize, pointSize);
    text(labels[i], x + pointSize, y);
  }
}

