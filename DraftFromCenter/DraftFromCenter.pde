
// measurements on lisa, in inches

//vertical measurements
float inseam = 31; // crotch to floor 
float sideseam = 37; // highHip to floor
float crotchDepth = 6; // highHip to crotch 

// need ankle to floor, calf to floor, knee to floor, for now making up numbers
float kneeToFloor = 19; // 
float calfToFloor = 11;
float ankleToFloor = 4.75;
float instep = 3; // top of instep to floor

float crotchLength = 17; 
float crotchLengthFront = 6.5; 
float crotchLengthBack = crotchLength - crotchLengthFront; 

//circumference measurements

float highHip = 32;
float highHipFront = 15;
float highHipBack = highHip - highHipFront;

float twoThighs = 35; 
float thigh = 21;
float thighFront = 9;
float thighBack = thigh - thighFront; 

float knee = 13; 
float kneeFront = 5.5;// can simply be knee/2, -1 for front, +1 for back
float kneeBack = knee - kneeFront;
float calf = 13; //at fullest part
float calfFront= 5.5;
float calfBack= calf - calfFront;
float ankle = 7.5; 
float ankleFront = 3.5;
float ankleBack = ankle - ankleFront;


float butt = 35;
float buttFront = 16;
float buttBack = butt - buttFront;

float highHipToButtF = 3;
float highHipToButtB = 6;
//so does that make...
float crotchToButt = crotchDepth - highHipToButtF; //?

// clothing specific: ease measurements and hem
float ankleEase = 3.5; // current ankle hem circ (11) - ankle = ankleEase

PFont font;
//points

PVector center, crotchF;
PVector floorF, thighF, buttF;
PVector vert1F, vertCenterLF, vertCenterHF;
PVector kneeOF, kneeIF, calfOF, calfIF, ankleOF, ankleIF;
PVector buttOF, buttIF;

PVector crotchB;
PVector floorB, thighB;
PVector vert1B, vertCenterLB, vertCenterHB;
PVector kneeOB, kneeIB, calfOB, calfIB, ankleOB, ankleIB;
PVector buttOB, buttIB;

void setup() {
  size(800, 700);
  font = createFont("Arial", 12);
  textFont(font); 
}

void draw() {
  background(255);

  float pointSize = 6;
  float drawingScale = 13;
  //drawingScale = map(mouseX, 0, width, 5, 50);
  
  int translationAmountX = (width/2);
  int translationAmountY = (height/2);
  translate(translationAmountX, translationAmountY);
  
   update();
     //draft points
  PVector[] draftPoints ={
    center, floorF, 
    vert1F, vertCenterLF, vertCenterHF,
    vert1B, vertCenterLB, vertCenterHB,
  };
   for (int i = 0; i < draftPoints.length; i++){
     float x = draftPoints[i].x*drawingScale, y = draftPoints[i].y*drawingScale;
     noStroke();
     fill(0,255,0); // when I added no stroke and fill here, the horizontal line labels finally showed up...
     ellipse (x, y, pointSize, pointSize);
   }
   
  //body points
  PVector[] bodyPoints ={
    thighF, thighB, 
    kneeOF, kneeIF,
    kneeOB, kneeIB,
    calfOF, calfIF,
    calfOB, calfIB,
    ankleOF, ankleIF,
    ankleOB, ankleIB,
    buttOF, buttIF,
    buttOB, buttIB,
  };
   for (int i = 0; i < bodyPoints.length; i++){
     float x = bodyPoints[i].x*drawingScale, y = bodyPoints[i].y*drawingScale;
     noStroke();
     fill(255,0,0); // when I added no stroke and fill here, the horizontal line labels finally showed up...
     ellipse (x, y, pointSize, pointSize);
   }
   
   //pant points
  PVector[] pantPoints ={
    crotchF, crotchB,
  };
   for (int i = 0; i < pantPoints.length; i++){
     float x = pantPoints[i].x*drawingScale, y = pantPoints[i].y*drawingScale;
     noStroke();
     fill(0,0,255); // when I added no stroke and fill here, the horizontal line labels finally showed up...
     ellipse (x, y, pointSize, pointSize);
   }
  
  //horizontal lines
  stroke(200);
  fill(0);
  textAlign(RIGHT, BOTTOM);
  PVector[] horizontalLines ={
    center, crotchF, //crotchB is same as crotch F until inverted
    floorF, buttF, 
  };
  String [] horizontalLineLabels ={ 
    "center", "crotch",
    "floor", "butt",
  };
  for (int i = 0; i < horizontalLines.length; i++) {
    float y = horizontalLines[i].y * drawingScale;
    line(0- translationAmountX, y, width- translationAmountX, y); 
    text(horizontalLineLabels[i], (width- translationAmountX), y);
  }
  
  //vertical lines
  stroke(200);
  PVector[] verticalLines ={
    //vert1F, vert1B, 
    vertCenterHF, vertCenterHB,
  };
  for (int i = 0; i < verticalLines.length; i++) {
    float x = verticalLines[i].x * drawingScale;
    line(x, 0- translationAmountY, x, height-translationAmountY); 
  }
  
  //line pairs - back draft, in green
  stroke(255, 0, 0);
  PVector[] linePairsBack = {
   
  };
  for (int i = 0; i < linePairsBack.length; i += 2) {
    line(linePairsBack[i].x * drawingScale, //works fine without translationAmount?
    linePairsBack[i].y * drawingScale,
    linePairsBack[i+1].x * drawingScale,
    linePairsBack[i+1].y * drawingScale);
  }
  
}

void update() {
  center = new PVector(0,0);
  crotchF = center.get();
  crotchF.y -= (inseam/2.);
  floorF = crotchF.get();
  floorF.y += inseam;
  thighF = crotchF.get();
  thighF.x -= thighFront;
  buttF = thighF.get();
  buttF.y -= crotchToButt;
  vert1F = thighF.get();
  vert1F.x += (thighFront/2);
  vertCenterHF = vert1F.get();
  vertCenterHF.x -= ((butt-twoThighs) /2.) +1.; // 1 is completely arbitrary, find a better way
  vertCenterLF = vertCenterHF.get();
  vertCenterLF.y += inseam;
  
  buttOF = vertCenterHF.get();
  buttOF.y -= crotchToButt;
  buttOF.x -= buttFront /4.;
  buttIF = vertCenterHF.get();
  buttIF.y -= crotchToButt;
  buttIF.x += buttFront /4.; 
  
  //now that I'm seeing buttOF doesn't line up, adjusting vertCenterF (L & H)
  if(buttOF.x<vertCenterHF.x) {
    vertCenterHF.x -= (buttOF.x-thighF.x);
    vertCenterLF.x -= (buttOF.x-thighF.x);
  }
  
  //copy, so butt redraws:
  buttOF = vertCenterHF.get();
  buttOF.y -= crotchToButt;
  buttOF.x -= buttFront /4.;
  buttIF = vertCenterHF.get();
  buttIF.y -= crotchToButt;
  buttIF.x += buttFront /4.; 
  
  kneeOF = vertCenterLF.get();
  kneeOF.y -= kneeToFloor;
  kneeOF.x -= kneeFront /2.;
  kneeIF = vertCenterLF.get();
  kneeIF.y -= kneeToFloor;
  kneeIF.x += kneeFront /2.; 
  
  calfOF = vertCenterLF.get();
  calfOF.y -= calfToFloor;
  calfOF.x -= calfFront /2.;
  calfIF = vertCenterLF.get();
  calfIF.y -= calfToFloor;
  calfIF.x += calfFront /2.; 
  
  ankleOF = vertCenterLF.get();
  ankleOF.y -= ankleToFloor;
  ankleOF.x -= ankleFront /2.;
  ankleIF = vertCenterLF.get();
  ankleIF.y -= ankleToFloor;
  ankleIF.x += ankleFront /2.; 
  
  // back draft, points that will be later inverted
  // F and B into seaparate functions?
  crotchB = crotchF.get();
  floorB = floorF.get();
  thighB = crotchB.get();
  thighB.x += thighBack;
  vert1B = thighB.get();
  vert1B.x -= (thighBack/2);
  vertCenterHB = vert1B.get();
  vertCenterHB.x += ((butt-twoThighs) /2.)+1.; // 1 is completely arbitrary, find a better way
  vertCenterLB = vertCenterHB.get();
  vertCenterLB.y += inseam;
  
  buttOB = vertCenterHB.get();
  buttOB.y -= crotchToButt;
  buttOB.x += buttBack /4.;
  buttIB = vertCenterHB.get();
  buttIB.y -= crotchToButt;
  buttIB.x -= buttBack /4.; 
  
  //now that I'm seeing buttOF doesn't line up, adjusting vertCenterF (L & H)
  if(buttOB.x>vertCenterHB.x) {
    vertCenterHB.x += (thighB.x-buttOB.x);
    vertCenterLB.x += (thighB.x-buttOB.x);
  }
  
  //copy, so butt redraws:
  buttOB = vertCenterHB.get();
  buttOB.y -= crotchToButt;
  buttOB.x += buttBack /4.;
  buttIB = vertCenterHB.get();
  buttIB.y -= crotchToButt;
  buttIB.x -= buttBack /4.; 
  
  kneeOB = vertCenterLB.get();
  kneeOB.y -= kneeToFloor;
  kneeOB.x += kneeBack /2.;
  kneeIB = vertCenterLB.get();
  kneeIB.y -= kneeToFloor;
  kneeIB.x -= kneeBack /2.;
  
  calfOB = vertCenterLB.get();
  calfOB.y -= calfToFloor;
  calfOB.x += calfBack /2.;
  calfIB = vertCenterLB.get();
  calfIB.y -= calfToFloor;
  calfIB.x -= calfBack /2.; 
  
  ankleOB = vertCenterLB.get();
  ankleOB.y -= ankleToFloor;
  ankleOB.x += ankleBack /2.;
  ankleIB = vertCenterLB.get();
  ankleIB.y -= ankleToFloor;
  ankleIB.x -= ankleBack /2.; 

}
