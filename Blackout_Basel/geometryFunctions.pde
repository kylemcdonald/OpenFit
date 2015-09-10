//return missing point on two similar triangles (triangle a,b,c and triangle d,e,x; solve for x)
PVector trianglePoint(PVector a, PVector b, PVector c, PVector d, PVector e) {
// get magnitudes in order to scale later
  float mag31 = PVector.dist(b, a);
  float mag23 = PVector.dist(c, b);
  float mag64 = PVector.dist(d, e);
   // get angle at b
  PVector ab = PVector.sub(b, a);
  PVector bc = PVector.sub(c, b);
  float angle = PI - PVector.angleBetween(ab, bc);
  // get vector from d to e
  PVector t = PVector.sub(d, e);  
  t.rotate(angle);                    // rotate it by found angle
  t.setMag(mag23 * mag64 / mag31);    // rescale it
  // find x by adding t to e
  PVector x = PVector.add(e, t);
  return x;
}

// Rotate a vector in 2D
void rotate2D(PVector v, float angle) {
  float theta = map(angle, 0, 360, 0, TWO_PI);
  // What's the magnitude?
  float m = v.mag();
  // What's the angle?
  float a = v.heading();
  // Change the angle
  a += theta;
  // Polar to cartesian for the new xy components
  v.x = m * cos(a);
  v.y = m * sin(a);
}

float bezierLength(PVector a, PVector cp1, PVector cp2, PVector b) {
  float l = 0;
  float precision = .01;
  for (int i = 0; i <= 1/precision; i++) { // 1/precision is a float? works?)
    float t = i*precision;
    float x1 = bezierPoint(a.x, cp1.x, cp2.x, b.x, t);
    float x2 = bezierPoint(a.x, cp1.x, cp2.x, b.x, t+precision);
    float y1 = bezierPoint(a.y, cp1.y, cp2.y, b.y, t);
    float y2 = bezierPoint(a.y, cp1.y, cp2.y, b.y, t+precision);
    l += dist(x1, y1, x2, y2);
  }
  return l;
}

// a and b points on line, c is center of circle, r is radius
// posNeg if need to toggle between two solutions
PVector circleIsecLine(PVector a, PVector b, PVector c, float r, boolean posNeg) {
  float slope = (b.y - a.y)/(b.x - a.x);
  float yintercept = b.y - (slope*b.x);
  PVector isec = new PVector(0, 0);
  if (posNeg == true) {
    isec.x = - sqrt( 
    - sq(yintercept) - (2.*yintercept*c.x*slope) + (2.*yintercept*c.y) - (sq(c.x)*sq(slope)) + 
      (2.*c.x*c.y*slope) - sq(c.y) + (sq(slope)*sq(r)) + sq(r)
      ) 
      - (yintercept* slope) + c.x + (c.y* slope);
  } 
  else {
    isec.x = sqrt( 
    - sq(yintercept) - (2.*yintercept*c.x*slope) + (2.*yintercept*c.y) - (sq(c.x)*sq(slope)) + 
      (2.*c.x*c.y*slope) - sq(c.y) + (sq(slope)*sq(r)) + sq(r)
      ) 
      - (yintercept* slope) + c.x + (c.y* slope);
  }
  isec.x /= sq(slope) + 1.; 
  isec.y = slope* isec.x + yintercept;
  return new PVector (isec.x, isec.y);
}

// bug: its totally off, lol
// bezier is a, cp1, cp2, b, find x value when y = 0, bezier has to start from above zero
float bezierCrossesZero(PVector a, PVector cp1, PVector cp2, PVector b) {
  float precision = .01;
  int i = 0;
  float t = 0;
  float xAtZero = 0;
  float yAlongBezier = -200;
  while (yAlongBezier < 0) {
    i += 1;
    t = i*precision; 
    yAlongBezier = bezierPoint (a.y, cp1.y, cp2.y, b.y, t);
    //println(yAlongBezier);
    if(i > 1000) {
      println("bezierCrossesZero() is stuck.");
      break;
    }
  }
  xAtZero = (bezierPoint(a.x, cp1.x, cp2.x, b.x, t));
  return xAtZero;
}

// three more unsuccessful attempts to fix the butt! 

/*
// this is worse
 float bezierCrossesZero(PVector a, PVector cp1, PVector cp2, PVector b) {
 float precision = .01;
 float t = 0;
 float xAtZero = 0;
 float yAlongBezier = 0;
 boolean calculateBezier = false;
 for (int i= 0; i< (1/precision); i++) {
 t = i*precision; 
 yAlongBezier = bezierPoint (a.y, cp1.y, cp2.y, b.y, t);
 //if ((yAlongBezier>= -0.1)&&(yAlongBezier<=0.1)) {
 if (yAlongBezier == 0) {
 calculateBezier = true;
 }
 }
 if (calculateBezier == true) {
 xAtZero = (bezierPoint(a.x, cp1.x, cp2.x, b.x, t));
 }
 calculateBezier = false;
 return xAtZero;
 } */

/* can't see x inside return
float bezierCrossesZero(PVector a, PVector cp1, PVector cp2, PVector b) {
  float precision = .01;
  float t = 0;
  float x = 0;
  float y = -100000;
  boolean calculateBezier = false;
  for (int i= 0; i< (1/precision); i++) {
    t = i*precision; 
    y = bezierPoint (a.y, cp1.y, cp2.y, b.y, t);
    x = (bezierPoint(a.x, cp1.x, cp2.x, b.x, t));
  }
  if ((y >= -0.1)&&(y <=0.1)) {
    return x;
  }
}
*/

/* thinks float is a pvector wtf, would still need to filter return, !=0
PVector bezierCrossesZero(PVector a, PVector cp1, PVector cp2, PVector b) {
  float precision = .01;
  float t = 0;
  float x = 0;
  float y = -100000;
  boolean calculateBezier = false;
  float returnValue = 0;
  for (int i= 0; i< (1/precision); i++) {
    t = i*precision; 
    y = bezierPoint (a.y, cp1.y, cp2.y, b.y, t);
    x = (bezierPoint(a.x, cp1.x, cp2.x, b.x, t));
  }
  if ((y >= -0.1)&&(y <=0.1)) {
    x = returnValue;
  }
  return returnValue;
} 
*/

PVector intersectAtDistance(PVector a, PVector b, PVector c, PVector d) {
  float maxScale = 10; // line has to be within this normalized distance
  Line2D ab = makeLine(a, b);
  Line2D cd = makeLine(c, d);
  ab.offsetAndGrowBy(0, maxScale, ab.getMidPoint());
  cd.offsetAndGrowBy(0, maxScale, cd.getMidPoint());
  Line2D.LineIntersection isec = ab.intersectLine(cd);
  Vec2D pos = isec.getPos();
  return new PVector(pos.x, pos.y);
}

Line2D makeLine(PVector a, PVector b) {
  Vec2D va = new Vec2D(a.x, a.y);
  Vec2D vb = new Vec2D(b.x, b.y);
  return new Line2D(va, vb);
}

//distance in relation to point 2
PVector pointOnLine(PVector point1, PVector point2, float distance, boolean posNeg) { 
  float slope = (point2.y - point1.y)/(point2.x - point1.x);
  float yintercept = point2.y - (slope * point2.x);
  PVector isec = new PVector (0, 0);
  if (posNeg == true) {
    isec.x = - sqrt(
    - sq(yintercept) - (2.*yintercept*point2.x*slope) + (2.*yintercept*point2.y) + 
      (sq(distance)*sq(slope)) + sq(distance) - (sq(point2.x)*sq(slope)) +
      (2.*point2.x*point2.y*slope) - sq(point2.y)
      ) - (yintercept*slope) + point2.x + (point2.y*slope);
  } else {
    isec.x = sqrt(
    - sq(yintercept) - (2.*yintercept*point2.x*slope) + (2.*yintercept*point2.y) + 
      (sq(distance)*sq(slope)) + sq(distance) - (sq(point2.x)*sq(slope)) +
      (2.*point2.x*point2.y*slope) - sq(point2.y)
      ) - (yintercept*slope) + point2.x + (point2.y*slope);
  } 
  isec.x /= sq(slope) +1.;
  isec.y = (isec.x*slope) + yintercept;
  return new PVector (isec.x, isec.y);
}

// seam allowance functions:

// generate parallel lines from two points, doesn't work with horizontal lines
// a and b are two points, seam allowance is distance, toggle between new points c and d, toggle direction
PVector parallelLinePoint(PVector a, PVector b, float seamAllowance, boolean togglePoint, boolean posNeg) {
  float slope = (b.y - a.y)/(b.x - a.x);
  float yintercept = b.y - (slope*b.x);
  float perpSlope = -(1/slope);
  float aYintercept = a.y - (perpSlope*a.x); // y intercept for perpendicular from point a
  float bYintercept = b.y - (perpSlope*b.x); // y intercept for perpendicular from point b
  PVector c = new PVector(0, 0);
  PVector d = new PVector(0, 0);
  // find the points along perpendicular slope, seam allowance is distance
  if (posNeg == true) {
    c.x = - sqrt(
    - sq(aYintercept) - (2.*aYintercept*a.x*perpSlope) + (2.*aYintercept*a.y) + 
      (sq(seamAllowance)*sq(perpSlope)) + sq(seamAllowance) - (sq(a.x)*sq(perpSlope)) +
      (2.*a.x*a.y*perpSlope) - sq(a.y)
      ) - (aYintercept*perpSlope) + a.x + (a.y*perpSlope);
    d.x = - sqrt(
    - sq(bYintercept) - (2.*bYintercept*b.x*perpSlope) + (2.*bYintercept*b.y) + 
      (sq(seamAllowance)*sq(perpSlope)) + sq(seamAllowance) - (sq(b.x)*sq(perpSlope)) +
      (2.*b.x*b.y*perpSlope) - sq(b.y)
      ) - (bYintercept*perpSlope) + b.x + (b.y*perpSlope);
  } else {
    c.x = sqrt(
    - sq(aYintercept) - (2.*aYintercept*a.x*perpSlope) + (2.*aYintercept*a.y) + 
      (sq(seamAllowance)*sq(perpSlope)) + sq(seamAllowance) - (sq(a.x)*sq(perpSlope)) +
      (2.*a.x*a.y*perpSlope) - sq(a.y)
      ) - (aYintercept*perpSlope) + a.x + (a.y*perpSlope);
    d.x = sqrt(
    - sq(bYintercept) - (2.*bYintercept*b.x*perpSlope) + (2.*bYintercept*b.y) + 
      (sq(seamAllowance)*sq(perpSlope)) + sq(seamAllowance) - (sq(b.x)*sq(perpSlope)) +
      (2.*b.x*b.y*perpSlope) - sq(b.y)
      ) - (bYintercept*perpSlope) + b.x + (b.y*perpSlope);
  }
  c.x /= sq(perpSlope) +1.;
  c.y = (c.x*perpSlope) + aYintercept; 
  d.x /= sq(perpSlope) +1.;
  d.y = (d.x*perpSlope) + bYintercept; 
  if (togglePoint == true) {
    return new PVector(c.x, c.y);
  } else {
    return new PVector(d.x, d.y);
  }
} 

// shift control point toward outside of pattern amount of seam allowance
/* a and b are points that lie on a line perpendicular to the one 
 that we shift the control, c is the control point, seam allowance is the distance,
 toggle direction
 */
PVector shiftControlPoint (PVector a, PVector b, PVector c, float seamAllowance, boolean posNeg) {
  float parallelSlope = (b.y - a.y)/(b.x - a.x);
  float slope = -(1/parallelSlope); // slope that control point lies along
  float yintercept = c.y -(slope*c.x);
  PVector d = new PVector(0, 0);
  if (posNeg == true) {
    d.x = - sqrt(
    - sq(yintercept) - (2.*yintercept*c.x*slope) + (2.*yintercept*c.y) + 
      (sq(seamAllowance)*sq(slope)) + sq(seamAllowance) - (sq(c.x)*sq(slope)) +
      (2.*c.x*c.y*slope) - sq(c.y)
      ) - (yintercept*slope) + c.x + (c.y*slope);
  } else {
    d.x = sqrt(
    - sq(yintercept) - (2.*yintercept*c.x*slope) + (2.*yintercept*c.y) + 
      (sq(seamAllowance)*sq(slope)) + sq(seamAllowance) - (sq(c.x)*sq(slope)) +
      (2.*c.x*c.y*slope) - sq(c.y)
      ) - (yintercept*slope) + c.x + (c.y*slope);
  }
  d.x /= sq(slope) +1.;
  d.y = (d.x*slope) + yintercept; 
  return new PVector(d.x, d.y);
}

