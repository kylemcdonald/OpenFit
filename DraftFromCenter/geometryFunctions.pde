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

// bezier is a, cp1, cp2, b, find x value when y = 0
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
  }
  xAtZero = (bezierPoint(a.x, cp1.x, cp2.x, b.x, t));
  return xAtZero;
}

