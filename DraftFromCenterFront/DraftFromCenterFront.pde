
// measurements, on kyle, in inches
// im sure there's a more elegant way to do this.. 
// abstract into class, allow for modification on the fly?

//vertical measurements
/* i think i mean "desired pant crotch" in the following crotch measurements

measurements would be more precise if taken 
while subject is dressed as green man from its always sunny 
*/

float inseam = 33; // crotch to floor 
float sideseam = 39.5; // highHip to floor
float crotchDepth = 9; // highHip to crotch 

// need ankle to floor, calf to floor, knee to floor?
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

PVector p0;

void setup() {
  size(400, 700);
}

void draw() {
  float pointSize = 6;
  float drawingScale = 13;
  //drawingScale = map(mouseX, 0, width, 5, 50);
  
  background(255);
  int translationAmountX = 200;
  int translationAmountY = 100;
  translate(translationAmountX, translationAmountY);
  
  //horizontal lines
  PVector[] horizontalLines ={
    p0,
  };
  for (int i = 0; i < 1; i++) {
    stroke (0,255,0);
    line (i-translationAmountX, 0, width-translationAmountX, 0); //why need translation amt on x and not y?
  }
  
}

