import toxi.geom.*;
import toxi.processing.*;
import processing.pdf.*;
import controlP5.*;
ControlP5 cp5;

PFont font;
float drawingScale = 15; // 30 to zoom in on crotch, 15 is nice on macbook air, 12.295 with projector
float pointSize = 6;

// body variables
// hipSlope is not used in current version, but would like to add a way to check pattern-generated hipSlope against kinect-derived hipSlope
float ankle, calf, knee, thigh, midthigh, butt, hip, crotchLength, hipSlope, ankleToFloor, calfToFloor, kneeToFloor, thighToFloor, midthighToFloor, buttToFloor, hipToFloor;
float ankleFront, calfFront, kneeFront, thighFront, midthighFront, buttFront, hipFront, crotchLengthFront;
float ankleBack, calfBack, kneeBack, thighBack, midthighBack, buttBack, hipBack, crotchLengthBack;

float ankleRatio = .46;
float calfRatio = .42;
float kneeRatio = .42;
float thighRatio = .42857;
float midthighRatio = .42857;
float buttRatio = .46;
float hipRatio = .42857;
float rise = 6.5; // girls 6-7.5, dudes 8 or 9?
float waistbandHeight = 1.5;
//body shape adujustments
float backTilt = 20; //was b/w 0.035 and 0.05, bw 0 and 50 *.001
float frontTilt = 11.11;
float buttMeasurementAngle = 3; // inches below butt line, suggested is 3? range maybe 2-6?
float lowerLegShift = 1.25;

// for simplicity's sake, only using two pre-set styles: skinny, and regular (straight leg with a little extra room)
boolean skinnyStyle = true; 
//hemHeight is + - inches above ankle
float crotchEase, hipEase, buttEase, thighEase, midthighEase, kneeEase, calfEase, ankleEase, hemHeight; 
//pocket, seam allowance, yoke

float seamAllowance = 3/8.;

float yokeInside = 2;
float yokeOutside = 1.25;

float baselStyleY = 0; //arbitrary variable to change style of pants
float baselStyleX = 0; //arbitrary variable to change style of pants

//pattern points
PVector d0, d1, d2, d2a, d3, d4, d5, d6, d0R; // drafting points
PVector b1, b2, b3, b3a, b4, b5, b6, b7, b8, b9, b9a, b10, b11, b12, cp1, cp2; //body points front
PVector b13, b14, b15, b15a, b16, b17, b18, b19, b20, b20a, b21, b21a, b22, b23, b24, cp3, cp4; //body points back
PVector p1, p2, p3, p3a, p4, p5, p6, p7, p8, p9, p9a, p10, p11, p12; //pant points front
PVector p13, p14, p15, p15a, p16, p17, p18, p19, p20, p21, p21a, p22, p23, p24; // pant points back
PVector l1, h1, l2, h2, l3, h3, l3a, h3a, l4, h4, l5, h5, l6, h6, l7, h7, csa1, csa2, h9, l9, h9a, l9a, h10, l10, h11, l11, h12, l12; // front SA drafting
PVector sa1, sa2, sa3, sa3a, sa4, sa5, sa6, sa7, sa9, sa9a, sa10, sa11, sa12; // front SA
PVector l13, h13, l14, h14, l15, h15, l15a, h15a, l16, h16, l17, h17, l18, h18, l19, h19, csa3, csa4, h21, l21, h21a, l21a, h22, l22, h23, l23, h24, l24; // back SA drafting
PVector sa13, sa14, sa15, sa15a, sa16, sa17, sa18, sa19, sa20, sa21, sa21a, sa22, sa23, sa24; // back SA
PVector p17a, p19a, h17a, l17a, h19a, l19a, sa17a, sa19a; // yoke

boolean savePdf = false;
boolean draftingTF = true;
boolean yardsticksTF = false;
boolean gridTF = true;
boolean bodyPointsTF = false;
boolean pantPointsTF = false;
boolean bodyShapeTF = true;
boolean pantShapeTF = true;
boolean seamAllowanceTF = false;
boolean yokeTF = false;
boolean baselTF = false;

//get rid of "unstable"

void setup() {  
  size(900, 720);
  font = createFont("Arial", 12);
  textFont(font);

  loadMeasurements("measurements_rachel.json");
  printLoadedMeasurements();
  measurementGui();
}

void draw() {
  if (savePdf) beginRecord(PDF, "OpenFit-"+year()+"-"+month()+"-"+day()+"-"+minute()+"-"+second()+".pdf");
  background(255);
  //load measurement math and pattern point math
  bodyMeasurementCalculations();
  pantMeasurementCalculations();
  printFrontMeasurements();
  draftingPoints();
  bodyPointsF();
  bodyPointsB();
  pantPointsF();
  pantPointsB();
  baselPointsF();
  baselPointsB();

  if (gridTF == true) {
    grid();
  }

  if ( draftingTF == true) {
    pushMatrix();
    translateScale (4, 6);
    drawDraftingPoints();
    popMatrix();
  }

  if (yardsticksTF == true) {
    pushMatrix();
    translateScale(5, 6);
    yardsticks();
    popMatrix();
  }

  if (bodyPointsTF == true) {
    //front
    pushMatrix();
    translateScale (14, 6);
    drawBodyPointsF();
    popMatrix();
    //back
    pushMatrix();
    translateScale (30, 6);
    drawBodyPointsB();
    popMatrix();
  }

  if (bodyShapeTF == true) {
    //front
    pushMatrix();
    translateScale (14, 6);
    bodyShapeF();
    popMatrix();
    //back
    pushMatrix();
    translateScale (30, 6);
    bodyShapeB();
    popMatrix();
  }


  if (pantPointsTF == true) {
    //front
    pushMatrix();
    translateScale (14, 6);
    drawPantPointsF();
    popMatrix();
    //back
    pushMatrix();
    translateScale (30, 6);
    drawPantPointsB();
    popMatrix();
  }

  if (pantShapeTF == true) {
    //front
    pushMatrix();
    translateScale (14, 6);
    pantShapeF();
    popMatrix();
    //back
    pushMatrix();
    translateScale (30, 6);
    pantShapeB();
    popMatrix();
  }

  if (baselTF == true) {
    //front
    pushMatrix();
    translateScale (14, 6);
    drawBaselPointsF();
    baselShapeF();
    popMatrix();
    //back
    pushMatrix();
    translateScale (30, 6);
    drawBaselPointsB();
    baselShapeB();
    popMatrix();
  }

  //seam allowance, potentially unstable
  if (seamAllowanceTF == true) {
    pushMatrix();
    translateScale (14, 6);
    pantPointsSAF();
    //drawPantPointsSAF();
    pantShapeSAF();
    popMatrix();
    pushMatrix();
    translateScale (30, 6);
    pantPointsSAB();
    //drawPantPointsSAB();
    pantShapeSAB();
    popMatrix();
  }

  if (yokeTF == true) {
    pushMatrix();
    translateScale (27.5, 3.5);
    yokeSA();
    yokeShape();
    //yokeShapeSA();
    popMatrix();
  }

  if (savePdf) {
    savePdf=false; 
    endRecord();
  }
}

void keyPressed() {
  if (key=='g') {
    println("cp5 on/off");
    if (cp5.isVisible())
      cp5.hide();
    else
      cp5.show();
  }
  if (key=='s') {
    println("saved to pdf");
    savePdf=true;
  }
}

