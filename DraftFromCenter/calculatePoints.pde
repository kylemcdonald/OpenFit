void draftingPoints() {
  // drafting points
  d1 = new PVector(0, 0);
  d2 = d1.get();
  d2.y += crotchToButt; // not sure about this measurement
  d2a = d2.get();
  d2a.y += midthighToCrotch; 
  d6 = d2.get();
  d6.y += inseam;

  d0 = d6.get();
  d0.y -= sideseam;
  d0R = d0.get();
  d0R.x += width;

  d3 = d6.get();
  d3.y -= kneeToFloor;
  d4 = d6.get();
  d4.y -= calfToFloor;
  d5 = d6.get();
  d5.y -= ankleToFloor;

  float shift = 1.25;
  //manually shift lower leg over, need to animate
  d3.x -= shift;
  d4.x -= shift;
  d5.x -= shift;
}

void bodyPointsF() {
  // draft thigh points
  b4 = d2.get();
  b4.x -= thighFront/2.;
  b9 = b4.get();
  b9.x+= thighFront;
  // control points for crotch curve are all in relation to inner thigh point (b9)
  cp1 = b9.get();
  cp1.x -= 1.5; // add .25 if large size
  cp2 = cp1.get();
  cp2.y -= 3.;
  cp2.x -= 0.5; // add .25 if large size
  // if "long" (curr. defined as 9) crotch length front, scoot control points
  if (crotchLengthFront > 9) {
    cp1.x -= .333333333; 
    cp2.x -= .33333333;
  }
  // b7 (hip point in the center front begins at the control point and is extended until crotchLengthFront
  b7 = cp2.get();
  while (bezierLength (b9, cp1, cp2, b7)< crotchLengthFront) {
    b7.y -= 0.1;
    b7.x -= .01111111; //b7.x -= .0166666666; //experiment here with steepness of crotch curve
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
  int angle = 0; 
  while (b5.y < (b4.y-1)) {
    rotate2D(b5, 360-angle);
    angle += 1;
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
  while (bezierLength (b21, cp3, cp4, b19)< crotchLengthBack) {
    b19.y -= 0.1;
    b19.x -= .05; //experiment here with steepness of crotch curve
  }
  // draft outer hip point so that distance from b19 is half of hip back and the height is sideseam
  b18 = circleIsecLine(d0, d0R, b19, (hipBack/2), true);
  //println(b18.x+"   "+b18.y);
  // find butt point along bezier and draft outside butt point
  b20 = d1.get();
  b20.x = bezierCrossesZero(b19, cp3, cp4, b21);
  b17 = b20.get();
  b17.x -= buttBack/2.;
  // theory: butt width is accounted for in the pattern on a slanted line from the sideseam (@ crotch y) to the crotch curve (@ butt y) 
  // maybe sideseam point is a little higher than crotch point? hence the -1 in (b5.y < (b4.y-1))
  int angle = 0; 
  while (b17.y < (b16.y-1)) {
    rotate2D(b17, 360-angle);
    angle += 1;
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

void pantPointsF() {
  // pant points are using same control points as body
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
  //midthigh points shouldn't affect shape too much-- will cause peaking
  p3a = b3a.get();
  p9a = b9a.get();   
  p4 = b4.get();
  p4.x -= thighEase/2.;
  p5 = b5.get();
  p5.x -= buttEase/4.;
  p6 = b6.get(); 
  p6.x -= hipEase/4.;
  // keep crotch curve as is
  p7 = b7.get();
  p8 = b8.get();
  p9 = b9.get();
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
  p21a = b21a.get();   
  p16 = b16.get();
  p16.x -= thighEase/2.;
  p17 = b17.get();
  p17.x -= buttEase/4.;
  p18 = b18.get(); 
  p18.x -= hipEase/4.;
  // keep crotch curve as is
  p19 = b19.get();
  p20 = b20.get();
  p21 = b21.get();
}

