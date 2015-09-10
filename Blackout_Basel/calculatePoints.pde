
void draftingPoints() {
  // drafting points
  d0 = new PVector(0, 0);
  d0R = d0.get();
  d0R.x += width;
  d6 = d0.get();
  d6.y += (hipToFloor);
  d1 = d6.get();
  d1.y -= buttToFloor;
  d2 = d6.get();
  d2.y -= thighToFloor;
  d2a = d6.get();
  d2a.y -= midthighToFloor;
  d3 = d6.get();
  d3.y -= kneeToFloor;
  d4 = d6.get();
  d4.y -= calfToFloor;
  d5 = d6.get();
  d5.y -= ankleToFloor;

  //manually shift lower leg over, need to animate
  d3.x -= lowerLegShift;
  d4.x -= lowerLegShift;
  d5.x -= lowerLegShift;
}

void bodyPointsF() {
  // draft thigh points
  b4 = d2.get();
  b4.x -= thighFront/2.;
  b9 = b4.get();
  b9.x+= thighFront;
  // control points for crotch curve are all in relation to inner thigh point (b9)
  cp1 = b9.get();
  cp1.x -= 1.3; 
  cp1.y -= .5;
  cp2 = cp1.get();
  cp2.y -= 4.;
  cp2.x -= 0.4; 
  // b7 (hip point in the center front begins at the control point and is extended until crotchLengthFront
  b7 = cp2.get();
  int i = 0;
  while (bezierLength (b9, cp1, cp2, b7)< crotchLengthFront) {
    b7.y -= 0.1;
    b7.x -= frontTilt*.001;
    if(i++ > 1000) {
      println("checking bezierLength is stuck.");
      break;
    }
  }
  // draft outer hip point so that distance from b7 is half of hip front and the height is sideseam
  b6 = circleIsecLine(d0, d0R, b7, (hipFront/2), true);
  // find butt point along bezier and draft outside butt point
  b8 = d1.get();
  b8.x = bezierCrossesZero(b7, cp1, cp2, b9);
  b5 = b8.get();
  b5.x -= buttFront/2.;
  // theory: butt width is accounted for in the pattern on a slanted line from the sideseam (@ crotch y) to the crotch curve (@ butt y) 
  // maybe sideseam point is a little higher than crotch point? hence the -1 in (b5.y < (b4.y-1))
  i = 0;
  while (b5.y < (d1.y+buttMeasurementAngle)) {  
    rotate2D(b5, -1);
    if(i++ > 1000) {
      println("checking buttMeasurementAngle #1 is stuck.");
      break;
    }
  }
  // midthigh point defaults to three in below and an inch to the left of crotch point
  b9a = b9.get();
  b9a.y += 3.;
  b9a.x -= 1; // change here to shift manually  // NEED TO ANIMATE L/R!!
  b3a = b9a.get();
  b3a.x -= midthighFront;
  // draft knee, calf and ankles around center
  //NEED TO ANIMATE L/R!!
  b3 = d3.get();
  b3.x -= kneeFront/2.;
  b10 = b3.get();
  b10.x += kneeFront;
  b2 = d4.get();
  b2.x -= calfFront/2.;
  b11 = b2.get();
  b11.x += calfFront;
  b1 = d5.get();
  b1.x -= ankleFront/2.;
  b12 = b1.get();
  b12.x += ankleFront;
}

void bodyPointsB() {
  // draft thigh points
  b16 = d2.get();
  b16.x -= thighBack/2.;
  b21 = b16.get();
  b21.x += thighBack;
  // control points for crotch curve are all in relation to inner thigh point (b21)
  cp3 = b21.get();
  cp3.x -= 4; 
  cp4 = cp3.get();
  cp4.y -= 4.;
  // if "long" (curr. defined as 21) crotch length, scoot control points
  if (crotchLength > 21) {
    cp3.x -= .5; 
    cp4.x -= .5;
  }
  // b19 (hip point in the center front begins at the control point and is extended until crotchLengthBack
  b19 = cp4.get();
  int i = 0;
  while (bezierLength (b21, cp3, cp4, b19)< crotchLengthBack) {
    b19.y -= 0.1;
    b19.x -= backTilt*.001; //experiment here with steepness of crotch curve, was .05
    if(i++ > 1000) {
      println("getting crotchLengthBack right is stuck.");
      break;
    }
  }
  // draft outer hip point so that distance from b19 is half of hip back and the height is sideseam
  b18 = circleIsecLine(d0, d0R, b19, (hipBack/2), true);
  //println(b18.x+"   "+b18.y);
  // find butt point along bezier and draft outside butt point
  b20 = d1.get();
  b20.x = bezierCrossesZero(b19, cp4, cp3, b21);
  b17 = b20.get();
  b17.x -= buttBack/2.;
  // theory: butt width is accounted for in the pattern on a slanted line from the sideseam (@ crotch y) to the crotch curve (@ butt y) 
  // maybe sideseam point is a little higher than crotch point? hence the -1 in (b5.y < (b4.y-1))
  /*while (b17.y < (b16.y-1)) {
   rotate2D(b17, 360-angle);
   angle += 1;
   }*/
  i = 0;
  while (b17.y < (d1.y+buttMeasurementAngle)) { 
    rotate2D(b17, -1);
    if(i++ > 1000) {
      println("getting buttMeasurementAngle #2 right is stuck.");
      break;
    }
  }
  // midthigh point defaults to three in below and an inch to the left of crotch point
  b21a = b21.get();
  b21a.y += 3.;
  b21a.x -= 1; // change here to shift manually   // NEED TO ANIMATE L/R!!
  b15a = b21a.get();
  b15a.x -= midthighBack;
  // draft knee, calf and ankles around center
  //NEED TO ANIMATE L/R!!
  b15 = d3.get();
  b15.x -= kneeBack/2.;
  b22 = b15.get();
  b22.x += kneeBack;
  b14 = d4.get();
  b14.x -= calfBack/2.;
  b23 = b14.get();
  b23.x += calfBack;
  b13 = d5.get();
  b13.x -= ankleBack/2.;
  b24 = b13.get();
  b24.x += ankleBack;
}

// rise refers to the pant not the body?
// drop crotch (crotchEase) happens after rise is measured

PVector lowD0, lowD0R, cpp1, cpp2, cpp3, cpp4; 

float test;

void pantPointsF() {

  p1 = b1.get();
  p1.x -= ankleEase/4.;
  p1.y += hemHeight;
  p12 = b12.get();
  p12.x += ankleEase/4.;
  p12.y += hemHeight; 
  p2 = b2.get();
  p2.x -= calfEase/4.;
  p11 = b11.get();
  p11.x += calfEase/4.;
  p3 = b3.get();
  p3.x -= kneeEase/4.;
  p10 = b10.get();
  p10.x += kneeEase/4.;
  p3a = b3a.get();
  p3a.x -= midthighEase/4.;
  p9a = b9a.get();
  p9a.x += midthighEase/4.;  
  p4 = b4.get();
  p4.x -= thighEase/2.;
  p5 = b5.get();
  p5.x -= buttEase/4.;

  p8 = b8.get();
  p9 = b9.get();
  p7 = cp2.get();
  int i = 0;
  while (bezierLength (p9, cp1, cp2, p7)< rise) {
    p7.y -= 0.1;
    p7.x -= frontTilt*.001;
    if(i++ > 1000) {
      println("getting rise right is stuck.");
      break;
    }
  }
  lowD0 = d0.get();
  lowD0.y += waistbandHeight;
  lowD0R = d0R.get();
  lowD0R.y += waistbandHeight;
  p6 = circleIsecLine(lowD0, lowD0R, p7, (hipFront/2), true);
  p6.x -= hipEase/2.; // not accurate, need pointonline

  //should this change after while loop with rise (if dropping crotch, length will be longer than rise?)
  cpp1 = cp1.get();
  cpp1.y += crotchEase/2.;
  cpp2 = cp2.get();
  cpp2.y += crotchEase/2.;
  p9.y +=crotchEase/2;

  //no concave thigh
  if (p4.x >p6.x) {
    p4.x = p6.x;
  }
}

void pantPointsB() {
  // pant points are using same control points as body
  p13 = b13.get();
  p13.x -= ankleEase/4.;
  p13.y += hemHeight;
  p24 = b24.get();
  p24.x += ankleEase/4.;
  p24.y += hemHeight; 
  p14 = b14.get();
  p14.x -= calfEase/4.;
  p23 = b23.get();
  p23.x += calfEase/4.;
  p15 = b15.get();
  p15.x -= kneeEase/4.;
  p22 = b22.get();
  p22.x += kneeEase/4.;
  //midthigh points shouldn't affect shape too much-- will cause peaking
  p15a = b15a.get();
  p15a.x -= midthighEase/4.;
  p21a = b21a.get(); 
  p21a.x += midthighEase/4.;  
  p16 = b16.get();
  p16.x -= thighEase/2.;
  p17 = b17.get();
  p17.x -= buttEase/4.;

  p20 = b20.get();
  p21 = b21.get();
  p19 = cp4.get();
  int i = 0;
  while (bezierLength (p21, cp3, cp4, p19) < (crotchLengthBack-waistbandHeight)) {
    p19.y -= 0.1;
    p19.x -= backTilt*.001;
    if(i++ > 1000) {
      println("getting crotchLengthBack-waistbandHeight is stuck.");
      break;
    }
  }
  p18 = circleIsecLine(lowD0, lowD0R, p19, (hipBack/2), true);
  p18.x -= hipEase/4.; // not accurate, need point on line?
  p19.x += hipEase/4;// not accurate, need point on line?

  //should this change after while loop with rise (if dropping crotch, length will be longer than rise?)
  cpp3 = cp3.get();
  cpp3.y += crotchEase/2.;
  cpp4 = cp4.get();
  cpp4.y += crotchEase/2.;
  p21.y +=crotchEase/2;

  p17a =pointOnLine(p17, p18, yokeOutside, false);
  p19a =pointOnLine(p20, p19, yokeInside, false);
}

// potentially unstable: 
void pantPointsSAF() {
  h1 = parallelLinePoint(p1, p2, seamAllowance, true, true);
  l2 = parallelLinePoint(p1, p2, seamAllowance, false, true);
  h2 = parallelLinePoint(p2, p3, seamAllowance, true, true);
  l3 = parallelLinePoint(p2, p3, seamAllowance, false, true);
  h3 = parallelLinePoint(p3, p3a, seamAllowance, true, true);
  l3a = parallelLinePoint(p3, p3a, seamAllowance, false, true);
  h3a = parallelLinePoint(p3a, p4, seamAllowance, true, true);
  l4 = parallelLinePoint(p3a, p4, seamAllowance, false, true);
  h4 = parallelLinePoint(p4, p5, seamAllowance, true, true);
  l5 = parallelLinePoint(p4, p5, seamAllowance, false, true);
  h5 = parallelLinePoint(p5, p6, seamAllowance, true, true);
  l6 = parallelLinePoint(p5, p6, seamAllowance, false, true);
  h6 = parallelLinePoint(p6, p7, seamAllowance, true, false);
  h7 = parallelLinePoint(p6, p7, seamAllowance, false, false);
  l7 = parallelLinePoint(p7, p9, seamAllowance, true, false);
  h9 = parallelLinePoint(p7, p9, seamAllowance, false, false);
  l9 = parallelLinePoint(p9, p9a, seamAllowance, true, false);
  h9a = parallelLinePoint(p9, p9a, seamAllowance, false, false);
  l9a = parallelLinePoint(p9a, p10, seamAllowance, true, false);
  h10 = parallelLinePoint(p9a, p10, seamAllowance, false, false);
  l10 = parallelLinePoint(p10, p11, seamAllowance, true, false);
  h11 = parallelLinePoint(p10, p11, seamAllowance, false, false);
  l11 = parallelLinePoint(p11, p12, seamAllowance, true, false);
  h12 = parallelLinePoint(p11, p12, seamAllowance, false, false);
  l1 = p1.get();
  l1.y += seamAllowance*2.;
  l12 = p12.get();
  l12.y += seamAllowance*2.;
  csa1= shiftControlPoint(p7, p9, cp1, seamAllowance, false);
  csa2= shiftControlPoint(p7, p9, cp2, seamAllowance, false);

  sa1 = intersectAtDistance(l12, l1, l2, h1);
  sa2 = intersectAtDistance(h1, l2, l3, h2);
  sa3 = intersectAtDistance(h2, l3, l3a, h3);
  sa3a = intersectAtDistance(h3, l3a, l4, h3a);
  sa4 = intersectAtDistance(h3a, l4, l5, h4);
  sa5 = intersectAtDistance(h4, l5, l6, h5);
  sa6 = intersectAtDistance(h5, l6, h7, h6);
  sa7 = intersectAtDistance(h6, h7, h9, l7);
  sa9 = intersectAtDistance(l7, h9, h9a, l9);
  sa9.y -= seamAllowance/3; //manual adjustment
  sa9a = intersectAtDistance(l9, h9a, h10, l9a);
  sa10 = intersectAtDistance(l9a, h10, h11, l10);
  sa11 = intersectAtDistance(l10, h11, h12, l11);
  sa12 = intersectAtDistance(l11, h12, l1, l12);
}

void pantPointsSAB() {
  h13 = parallelLinePoint(p13, p14, seamAllowance, true, true);
  l14 = parallelLinePoint(p13, p14, seamAllowance, false, true);
  h14 = parallelLinePoint(p14, p15, seamAllowance, true, true);
  l15 = parallelLinePoint(p14, p15, seamAllowance, false, true);
  h15 = parallelLinePoint(p15, p15a, seamAllowance, true, true);
  l15a = parallelLinePoint(p15, p15a, seamAllowance, false, true);
  h15a = parallelLinePoint(p15a, p16, seamAllowance, true, true);
  l16 = parallelLinePoint(p15a, p16, seamAllowance, false, true);
  h16 = parallelLinePoint(p16, p17, seamAllowance, true, true);
  l17 = parallelLinePoint(p16, p17, seamAllowance, false, true);
  h17 = parallelLinePoint(p17, p18, seamAllowance, true, true);
  l18 = parallelLinePoint(p17, p18, seamAllowance, false, true);
  h18 = parallelLinePoint(p18, p19, seamAllowance, true, true);
  h19 = parallelLinePoint(p18, p19, seamAllowance, false, true);
  l19 = parallelLinePoint(p19, p21, seamAllowance, true, false);
  h21 = parallelLinePoint(p19, p21, seamAllowance, false, false);
  l21 = parallelLinePoint(p21, p21a, seamAllowance, true, false);
  h21a = parallelLinePoint(p21, p21a, seamAllowance, false, false);
  l21a = parallelLinePoint(p21a, p22, seamAllowance, true, false);
  h22 = parallelLinePoint(p21a, p22, seamAllowance, false, false);
  l22 = parallelLinePoint(p22, p23, seamAllowance, true, false);
  h23 = parallelLinePoint(p10, p23, seamAllowance, false, false);
  l23 = parallelLinePoint(p23, p24, seamAllowance, true, false);
  h24 = parallelLinePoint(p23, p24, seamAllowance, false, false);
  l13 = p13.get();
  l13.y += seamAllowance*2.;
  l24 = p24.get();
  l24.y += seamAllowance*2.;
  csa3= shiftControlPoint(p19, p21, cp3, seamAllowance, false);
  csa4= shiftControlPoint(p19, p21, cp4, seamAllowance, false);

  sa13 = intersectAtDistance(l24, l13, l14, h13);
  sa14 = intersectAtDistance(h13, l14, l15, h14);
  sa15 = intersectAtDistance(h14, l15, l15a, h15);
  sa15a = intersectAtDistance(h15, l15a, l16, h15a);
  sa16 = intersectAtDistance(h15a, l16, l17, h16);
  sa17 = intersectAtDistance(h16, l17, l18, h17);
  sa18 = intersectAtDistance(h17, l18, h19, h18);
  sa19 = intersectAtDistance(h18, h19, h21, l19);
  sa21 = intersectAtDistance(l19, h21, h21a, l21);
  sa21.y -= seamAllowance/3; //manual adjustment
  sa21a = intersectAtDistance(l21, h21a, h22, l21a);
  sa22 = intersectAtDistance(l21a, h22, h23, l22);
  sa23 = intersectAtDistance(l22, h23, h24, l23);
  sa24 = intersectAtDistance(l23, h24, l13, l24);
}

void yokeSA() {
  //sa17a, sa19a

  h17a =parallelLinePoint(p17, p17a, seamAllowance, false, true);
  h19a =parallelLinePoint(p19, p19a, seamAllowance, false, false);
  l19a = parallelLinePoint(p19a, p17a, seamAllowance, true, false);
  l17a = parallelLinePoint(p19a, p17a, seamAllowance, false, false);
  
  sa17a = intersectAtDistance(sa17, h17a, l19a, l17a);
  sa19a = intersectAtDistance(sa19, h19a, l17a, l19a);
}


// ***** NEW for basel ******

//PVector p1, p2, p3, p3a, p4, p5, p6, p7, p8, p9, p9a, p10, p11, p12; //pant points front
//PVector p13, p14, p15, p15a, p16, p17, p18, p19, p20, p21, p21a, p22, p23, p24; // pant points back
// copy p oints and control points
// then add v points 1 -15

PVector v1;
void baselPointsF() {

}

void baselPointsB() {

}

