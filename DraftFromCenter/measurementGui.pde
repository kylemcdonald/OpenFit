
Numberbox kneeNumberbox;

void measurementGui() { 
  cp5 = new ControlP5(this);
  cp5.setColorCaptionLabel(0);
  float column0 = width- 5*drawingScale, y = 0.5*drawingScale, spacing = 2.25*drawingScale;

  cp5.addNumberbox("inseam").setPosition(column0, y).setRange(20, 40.)
    .setValue(inseam).setMultiplier(0.5);

  cp5.addNumberbox("sideseam").setPosition(column0, y+=spacing).setRange(30, 50)
    .setValue(sideseam).setMultiplier(0.5);

  cp5.addNumberbox("kneeToFloor").setPosition(column0, y+=spacing).setRange(15, 25)
    .setValue(kneeToFloor).setMultiplier(0.25);
  cp5.addNumberbox("calfToFloor").setPosition(column0, y+=spacing).setRange(8, 18)
    .setValue(calfToFloor).setMultiplier(0.25);
  cp5.addNumberbox("ankleToFloor").setPosition(column0, y+=spacing).setRange(2, 7)
    .setValue(ankleToFloor).setMultiplier(0.25);
  cp5.addNumberbox("crotchLength").setPosition(column0, y+=spacing).setRange(10, 25)
    .setValue(crotchLength).setMultiplier(0.25);
  cp5.addNumberbox("crotchLengthFront").setPosition(column0, y+=spacing).setRange(4, crotchLength) // build in more checks like this
    .setValue(crotchLengthFront).setMultiplier(0.25);
  //circumference measurements   
  cp5.addNumberbox("hip").setPosition(column0, y+=spacing).setRange(25, 50)
    .setValue(hip).setMultiplier(0.25);
  cp5.addNumberbox("hipFront").setPosition(column0, y+=spacing).setRange(9, hip)
    .setValue(hipFront).setMultiplier(0.25);
  cp5.addNumberbox("butt").setPosition(column0, y+=spacing).setRange(25, 50)
    .setValue(butt).setMultiplier(0.25);
  cp5.addNumberbox("buttFront").setPosition(column0, y+=spacing).setRange(9, butt)
    .setValue(buttFront).setMultiplier(0.25);
  cp5.addNumberbox("thigh").setPosition(column0, y+=spacing).setRange(16, 28)
    .setValue(thigh).setMultiplier(0.25);
  cp5.addNumberbox("thighFront").setPosition(column0, y+=spacing).setRange(5, thigh)
    .setValue(thighFront).setMultiplier(0.25);
  cp5.addNumberbox("midthigh").setPosition(column0, y+=spacing).setRange(16, 28)
    .setValue(midthigh).setMultiplier(0.25);
  cp5.addNumberbox("midthighFront").setPosition(column0, y+=spacing).setRange(5, thigh)
    .setValue(midthighFront).setMultiplier(0.25);

  kneeNumberbox = cp5.addNumberbox("knee").setPosition(column0, y+=spacing).setRange(9, 28)
    .setValue(knee).setMultiplier(0.25);

  cp5.addNumberbox("kneeFront").setPosition(column0, y+=spacing).setRange(3, knee)
    .setValue(kneeFront).setMultiplier(0.25);
  cp5.addNumberbox("calf").setPosition(column0, y+=spacing).setRange(9, 28)
    .setValue(calf).setMultiplier(0.25);
  cp5.addNumberbox("calfFront").setPosition(column0, y+=spacing).setRange(3, calf)
    .setValue(calfFront).setMultiplier(0.25);
  cp5.addNumberbox("ankle").setPosition(column0, y+=spacing).setRange(3, calf)
    .setValue(ankle).setMultiplier(0.25);
  cp5.addNumberbox("ankleFront").setPosition(column0, y+=spacing).setRange(2, ankle)
    .setValue(ankleFront).setMultiplier(0.25);

  float column1 = column0- 5*drawingScale;
  y = 0.5*drawingScale;

  //currently not using hip to butt
  /*  cp5.addNumberbox("hipToButtF").setPosition(column1, y).setRange(1, 8)
   .setValue(hipToButtF).setMultiplier(0.25); 
   cp5.addNumberbox("hipToButtB").setPosition(column1, y+=spacing).setRange(1, 10)
   .setValue(hipToButtB).setMultiplier(0.25);
   cp5.addNumberbox("hipToButtS").setPosition(column1, y+=spacing).setRange(1, 10)
   .setValue(hipToButtS).setMultiplier(0.25);*/
  cp5.addNumberbox("crotchToButt").setPosition(column1, y).setRange(1, 10)
    .setValue(crotchToButt).setMultiplier(0.25);    // seems like an infinite while when you pull this guy outta range
  /*  
   cp5.addNumberbox("ankleEase").setPosition(z, y+=spacing).setRange(0, 8)
   .setValue(ankleEase).setMultiplier(0.25);
   cp5.addNumberbox("hemHeight").setPosition(z, y+=spacing).setRange(-5, 15)
   .setValue(hemHeight).setMultiplier(0.25);
     cp5.addNumberbox("seamAllowance").setPosition(w, y).setRange(0, 2)
   .setValue(seamAllowance).setMultiplier(0.125); 
   
   cp5.addBang("tuckWaist").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addBang("tightenButt").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addBang("loosenButt").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addBang("dropCrotch").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addBang("thighSeparation").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addBang("ankleLength").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addBang("regularLength").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addBang("floorLength").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addToggle("skinnyKnees").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addToggle("pocket").setPosition(z, y+=spacing).setSize(20, 20);
   cp5.addToggle("yoke").setPosition(z, y+=spacing).setSize(20, 20); */

  cp5.addBang("frontBackRatio").setPosition(column1, y+=spacing).setSize(20, 20);
}

public void frontBackRatio() {
  kneeNumberbox.getValue();
  kneeFront = knee* .42;
  kneeBack = knee- kneeFront;
  println("knee = " + knee + " kneeFront = " + kneeFront + " kneeBack = " + kneeBack);
  // controller name,  set value
  //now the variables are changed but they arent returning to the numberbox NOR redrawing the leg, though points are calculated in the draw
}

