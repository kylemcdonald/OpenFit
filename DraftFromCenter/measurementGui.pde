Numberbox hipNumberbox, buttNumberbox, thighNumberbox, midthighNumberbox, kneeNumberbox, calfNumberbox, ankleNumberbox;
Numberbox crotchLengthNumberbox, ankleToFloorNumberbox, calfToFloorNumberbox, kneeToFloorNumberbox, thighToFloorNumberbox, midthighToFloorNumberbox, buttToFloorNumberbox, hipToFloorNumberbox;
Numberbox ankleRatioNumberbox, calfRatioNumberbox, kneeRatioNumberbox, midthighRatioNumberbox, thighRatioNumberbox, buttRatioNumberbox, hipRatioNumberbox;
Numberbox riseNumberbox, waistbandHeightNumberbox, backTiltNumberbox, frontTiltNumberbox, buttMeasurementAngleNumberbox, lowerLegShiftNumberbox;
Numberbox crotchEaseNumberbox, hipEaseNumberbox, buttEaseNumberbox, thighEaseNumberbox, midthighEaseNumberbox, kneeEaseNumberbox, calfEaseNumberbox, ankleEaseNumberbox, hemHeightNumberbox;
//no hipSlopeNumberbox

Toggle skinnyStyleToggle, draftingToggle, yardstickToggle, gridToggle, bodyPointToggle, pantPointToggle, bodyShapeToggle, pantShapeToggle, seamAllowanceToggle, yokeToggle;
;

void measurementGui() {
  cp5 = new ControlP5(this);
  cp5.setColorCaptionLabel(0);

  float column = width- 5*drawingScale, y = 0.5*drawingScale, spacing = 2.25*drawingScale;

  hipRatioNumberbox = cp5.addNumberbox("hipRatio").setPosition(column, y).setRange(0, 1)
    .setValue(hipRatio).setMultiplier(0.001);
  buttRatioNumberbox = cp5.addNumberbox("buttRatio").setPosition(column, y+=spacing).setRange(0, 1)
    .setValue(buttRatio).setMultiplier(0.001);
  thighRatioNumberbox = cp5.addNumberbox("thighRatio").setPosition(column, y+=spacing).setRange(0, 1)
    .setValue(thighRatio).setMultiplier(0.001);
  midthighRatioNumberbox = cp5.addNumberbox("midthighRatio").setPosition(column, y+=spacing).setRange(0, 1)
    .setValue(midthighRatio).setMultiplier(0.001);
  kneeRatioNumberbox = cp5.addNumberbox("kneeRatio").setPosition(column, y+=spacing).setRange(0, 1)
    .setValue(kneeRatio).setMultiplier(0.001);
  calfRatioNumberbox = cp5.addNumberbox("calfRatio").setPosition(column, y+=spacing).setRange(0, 1)
    .setValue(calfRatio).setMultiplier(0.001);
  ankleRatioNumberbox = cp5.addNumberbox("ankleRatio").setPosition(column, y+=spacing).setRange(0, 1)
    .setValue(ankleRatio).setMultiplier(0.001);
  riseNumberbox = cp5.addNumberbox("rise").setPosition(column, y+=spacing).setRange(4.5, 10)
    .setValue(rise).setMultiplier(0.25);
  waistbandHeightNumberbox = cp5.addNumberbox("waistbandHeight").setPosition(column, y+=spacing).setRange(0, 2.5)
    .setValue(waistbandHeight).setMultiplier(0.25);
  backTiltNumberbox = cp5.addNumberbox("backTilt").setPosition(column, y+=spacing).setRange(0, 50)
    .setValue(backTilt).setMultiplier(0.25);
  frontTiltNumberbox = cp5.addNumberbox("frontTilt").setPosition(column, y+=spacing).setRange(0, 50)
    .setValue(frontTilt).setMultiplier(0.25);
  buttMeasurementAngleNumberbox = cp5.addNumberbox("buttMeasurementAngle").setPosition(column, y+=spacing).setRange(0, 6)
    .setValue(buttMeasurementAngle).setMultiplier(0.25);
  lowerLegShiftNumberbox = cp5.addNumberbox("lowerLegShift").setPosition(column, y+=spacing).setRange(0, 3)
    .setValue(lowerLegShift).setMultiplier(0.25);

  column = width- 5*2*drawingScale;
  y = 0.5*drawingScale;

  hipNumberbox = cp5.addNumberbox("hip").setPosition(column, y).setRange(25, 50)
    .setValue(hip).setMultiplier(0.25);
  buttNumberbox = cp5.addNumberbox("butt").setPosition(column, y+=spacing).setRange(25, 50)
    .setValue(butt).setMultiplier(0.25);
  thighNumberbox = cp5.addNumberbox("thigh").setPosition(column, y+=spacing).setRange(16, 28)
    .setValue(thigh).setMultiplier(0.25);
  midthighNumberbox = cp5.addNumberbox("midthigh").setPosition(column, y+=spacing).setRange(16, 28)
    .setValue(midthigh).setMultiplier(0.25);
  kneeNumberbox = kneeNumberbox = cp5.addNumberbox("knee").setPosition(column, y+=spacing).setRange(9, 28)
    .setValue(knee).setMultiplier(0.25);
  calfNumberbox = cp5.addNumberbox("calf").setPosition(column, y+=spacing).setRange(9, 28)
    .setValue(calf).setMultiplier(0.25);
  ankleNumberbox = cp5.addNumberbox("ankle").setPosition(column, y+=spacing).setRange(3, calf)
    .setValue(ankle).setMultiplier(0.25);
  hipToFloorNumberbox = cp5.addNumberbox("hipToFloor").setPosition(column, y+=spacing).setRange(30, 50)
    .setValue(hipToFloor).setMultiplier(0.5);
  buttToFloorNumberbox = cp5.addNumberbox("buttToFloor").setPosition(column, y+=spacing).setRange(25, 50)
    .setValue(buttToFloor).setMultiplier(0.5);
  thighToFloorNumberbox = cp5.addNumberbox("thighToFloor").setPosition(column, y+=spacing).setRange(20, 40.)
    .setValue(thighToFloor).setMultiplier(0.5);
  midthighToFloorNumberbox = cp5.addNumberbox("midthighToFloor").setPosition(column, y+=spacing).setRange(20, 40.)
    .setValue(midthighToFloor).setMultiplier(0.5);
  kneeToFloorNumberbox = cp5.addNumberbox("kneeToFloor").setPosition(column, y+=spacing).setRange(15, 25)
    .setValue(kneeToFloor).setMultiplier(0.25);
  calfToFloorNumberbox  = cp5.addNumberbox("calfToFloor").setPosition(column, y+=spacing).setRange(8, 18)
    .setValue(calfToFloor).setMultiplier(0.25);  
  ankleToFloorNumberbox =   cp5.addNumberbox("ankleToFloor").setPosition(column, y+=spacing).setRange(2, 7)
    .setValue(ankleToFloor).setMultiplier(0.25);
  crotchLengthNumberbox =   cp5.addNumberbox("crotchLength").setPosition(column, y+=spacing).setRange(10, 25)
    .setValue(crotchLength).setMultiplier(0.25);

  column = width- 5*3*drawingScale;
  y = 0.5*drawingScale;

  skinnyStyleToggle= cp5.addToggle("skinnyStyle").setPosition(column, y).setSize(60, 18).setMode(ControlP5.SWITCH);
  crotchEaseNumberbox = cp5.addNumberbox("crotchEase").setPosition(column, y+=spacing).setRange(-3, 3)
    .setValue(crotchEase).setMultiplier(0.25);
  hipEaseNumberbox = cp5.addNumberbox("hipEase").setPosition(column, y+=spacing).setRange(-3, 3)
    .setValue(hipEase).setMultiplier(0.25);
  buttEaseNumberbox = cp5.addNumberbox("buttEase").setPosition(column, y+=spacing).setRange(-3, 3)
    .setValue(buttEase).setMultiplier(0.25);
  thighEaseNumberbox = cp5.addNumberbox("thighEase").setPosition(column, y+=spacing).setRange(-3, 3)
    .setValue(thighEase).setMultiplier(0.25);
  midthighEaseNumberbox = cp5.addNumberbox("midthighEase").setPosition(column, y+=spacing).setRange(-3, 3)
    .setValue(midthighEase).setMultiplier(0.25);
  kneeEaseNumberbox = cp5.addNumberbox("kneeEase").setPosition(column, y+=spacing).setRange(-3, 3)
    .setValue(kneeEase).setMultiplier(0.25);
  calfEaseNumberbox = cp5.addNumberbox("calfEase").setPosition(column, y+=spacing).setRange(-3, 3)
    .setValue(calfEase).setMultiplier(0.25);
  ankleEaseNumberbox = cp5.addNumberbox("ankleEase").setPosition(column, y+=spacing).setRange(-3, 3)
    .setValue(ankleEase).setMultiplier(0.25);
  hemHeightNumberbox = cp5.addNumberbox("hemHeight").setPosition(column, y+=spacing).setRange(-10, 10)
    .setValue(hemHeight).setMultiplier(0.25);
  //unstableToggle= cp5.addToggle("unstable").setPosition(column, y+=spacing).setSize(60, 18).setMode(ControlP5.SWITCH);
  draftingToggle= cp5.addToggle("draftingTF").setPosition(column, y+=spacing).setSize(20, 20);
  yardstickToggle= cp5.addToggle("yardsticksTF").setPosition(column, y+=spacing).setSize(20, 20);
  gridToggle= cp5.addToggle("gridTF").setPosition(column, y+=spacing).setSize(20, 20);
  bodyPointToggle= cp5.addToggle("bodyPointsTF").setPosition(column, y+=spacing).setSize(20, 20);
  pantPointToggle = cp5.addToggle("pantPointsTF").setPosition(column, y+=spacing).setSize(20, 20);
  bodyShapeToggle = cp5.addToggle("bodyShapeTF").setPosition(column, y+=spacing).setSize(20, 20);
  pantShapeToggle = cp5.addToggle("pantShapeTF").setPosition(column, y+=spacing).setSize(20, 20);
  seamAllowanceToggle = cp5.addToggle("seamAllowanceTF").setPosition(column, y+=spacing).setSize(20, 20);
  //yokeToggle = cp5.addToggle("yokeTF").setPosition(column, y+=spacing).setSize(20, 20); // toxilibs null pointers.... again

  column = width- 5*4*drawingScale;
  y = 0.5*drawingScale;
}


void loadMeasurements(String filename) {
  JSONObject measurements = loadJSONObject(filename);
  ankle = measurements.getFloat("ankle");
  calf = measurements.getFloat("calf");
  knee = measurements.getFloat("knee");
  thigh = measurements.getFloat("thigh");
  midthigh = measurements.getFloat("midthigh");
  butt = measurements.getFloat("butt");
  hip = measurements.getFloat("hip");
  crotchLength = measurements.getFloat("crotchLength");
  hipSlope = measurements.getFloat("hipSlope");
  ankleToFloor = measurements.getFloat("ankleToFloor");
  calfToFloor = measurements.getFloat("calfToFloor");
  kneeToFloor = measurements.getFloat("kneeToFloor");
  thighToFloor = measurements.getFloat("thighToFloor");
  midthighToFloor = measurements.getFloat("midthighToFloor");
  buttToFloor = measurements.getFloat("buttToFloor");
  hipToFloor = measurements.getFloat("hipToFloor");
}

void printLoadedMeasurements() {
  println("ankle = "+ankle); 
  println("calf = "+calf); 
  println("knee = "+knee);  
  println("thigh = "+thigh);
  println("midthigh = "+midthigh);  
  println("butt = "+butt);  
  println("hip = "+hip);
  println("crotchLength = "+crotchLength); 
  println("hipSlope = "+hipSlope); 
  println("ankleToFloor = "+ankleToFloor); 
  println("calfToFloor = "+calfToFloor); 
  println("kneeToFloor = "+kneeToFloor); 
  println("thighToFloor = "+thighToFloor);
  println("midthighToFloor = "+midthighToFloor); 
  println("buttToFloor = "+buttToFloor);  
  println("hipToFloor = "+hipToFloor);
}

void printFrontMeasurements() {
  if (frameCount == 1) {

    println("ankleFront = "+ankleFront);
    println("calfFront = "+calfFront);
    println("kneeFront = "+kneeFront);
    println("midthighFront = "+midthighFront);
    println("thighFront = "+thighFront);
    println("buttFront = "+buttFront);
    println("hipFront = "+hipFront);
    println("crotchLengthFront = "+crotchLengthFront);
  }
}

void bodyMeasurementCalculations() {
  ankleFront  = ankleRatio*ankle;
  calfFront = calfRatio*calf;
  kneeFront = kneeRatio*knee; 
  thighFront = thighRatio*thigh;
  midthighFront = midthighRatio*midthigh;
  buttFront = buttRatio*butt;
  hipFront = hipRatio*hip;
  crotchLengthFront = (rise+waistbandHeight);
  crotchLengthBack = crotchLength - crotchLengthFront; 
  hipBack = hip - hipFront;
  buttBack = butt - buttFront;
  thighBack = thigh - thighFront; 
  midthighBack = midthigh - midthighFront;
  kneeBack = knee - kneeFront;
  calfBack= calf - calfFront;
  ankleBack = ankle - ankleFront;
}

void pantMeasurementCalculations() {
  if (skinnyStyle == true) {
    crotchEase = 0;
    hipEase = -1.;
    buttEase = -1.;
    thighEase = -.5;
    midthighEase = -.5;
    kneeEase = 1.; 
    calfEase = -.5; 
    ankleEase = (calf - 1.5)-ankle;
    hemHeight = ankleToFloor;
  } 
  else {
    crotchEase = 3; // usualy 1.25
    hipEase = 0;
    buttEase = 2;
    thighEase = 1.2;
    midthighEase = 1;
    kneeEase = 1.5; 
    calfEase = .5; 
    ankleEase = (calf - 1.5)-ankle;
    hemHeight = ankleToFloor;
  }
}

