
// measurements, on kyle, in inches
// im sure there's a better way to do this.. 
// abstract into class, allow for modification on the fly?

//vertical measurements
/* i think i mean "desired pant crotch" in the following crotch measurements

measurements would be more precise if taken 
while subject is dressed as green man from its always sunny 
*/

float inseam = 33; // crotch to floor 
float sideseam = 39.5; // highHip to floor
float crotchDepth = 9; // highHip to crotch 

// need ankle to floor, calf to floor, knee to floor, for now making up numbers
float kneeToFloor = 19; // 
float calfToFloor = 11.5;
float ankleToFloor = 5.25;
float instep = 3; // top of instep to floor

float crotchLength = 25.5; 
float crotchLengthFront = 9; 
float crotchLengthBack = crotchLength - crotchLengthFront;

//circumference measurements
/* High Hip: refers to top of hip bone, where pants usually sit, 
probably will be lower in front and higher in the back.
however, measurement only needs to be taken at desired pant waist-- 
so low rise or high waist also ok
*/
float highHip = 33;
float highHipFront = 17;
float highHipBack = highHip - highHipFront;

float thigh = 22;
float thighFront = 13;
float thighBack = thigh - thighFront; 

float knee = 13.5; // hasty notes, gonna assume 13.5 is circ, not to floor
float calf = 15; //at fullest part
float ankle = 6; // current ankle hem circ (14) - ankle = ankleEase
float ankleEase = 8;

// euphimistically termed "fullest part"
// gonna just say butt cuz hip is taken
// unlike highHip, measurement should be taken parallel to floor all around
float butt = 38;
float buttFront = 17.5;
float buttBack = butt - buttFront;

float highHipToButtF = 4; // vertical distance fron high hip to butt circ
float highHipToButtB = 6;

PVector p0, p1, p2; // center and high hip, crotch, floor, 
PVector p3, p4, p5, p6; //knee, calf, ankle, instep, respectively

PFont font;

void setup() {
  size(400, 700);
  font = createFont("Arial", 12);
  textFont(font); 
}

void draw() {
  background(255);
  update();
  float pointSize = 6;
  float drawingScale = 13;
  //drawingScale = map(mouseX, 0, width, 5, 50);
  
  int translationAmountX = 200;
  int translationAmountY = 100;
  translate(translationAmountX, translationAmountY);
  
  //points
  PVector[] points ={
    p0,
  };
   for (int i = 0; i < points.length; i++){
     float x = points[i].x*drawingScale, y = points[i].y*drawingScale;
     noStroke();
     fill(0); // when I added no stroke and fill here, the horizontal line labels finally showed up...
     ellipse (x, y, pointSize, pointSize);
   }
  
  //horizontal lines
  stroke(200);
  textAlign(RIGHT, BOTTOM);
  PVector[] horizontalLines ={
    p0, p1, p2, p3, p4, p5, p6,
  };
  String [] horizontalLineLabels ={ 
    "high hip", "crotch", "floor", "knee", "calf", "ankle", "instep",
  };
  for (int i = 0; i < horizontalLines.length; i++) {
    float y = horizontalLines[i].y * drawingScale;
    line(0- translationAmountX, y, width- translationAmountX, y);
    text(horizontalLineLabels[i], (width- translationAmountX), y);
  }
  
}

void update() {
  p0 = new PVector (0,0);
  p1 = p0.get();
  p1.y += crotchDepth;
  p2 = p0.get();
  p2.y += sideseam;
  p3 = p2.get();
  p3.y -= kneeToFloor;
  p4 = p2.get();
  p4.y -= calfToFloor;
  p5 = p2.get();
  p5.y -= ankleToFloor;
  p6 = p2.get();
  p6.y -= instep;
  
  
}
