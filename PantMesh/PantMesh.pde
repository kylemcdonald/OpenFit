import unlekker.util.*;
import unlekker.modelbuilder.*;
import ec.util.*;

import peasy.*;

PeasyCam cam;

float sliceResolution = 5;
int ellipseResolution = 100;

float hipToFloor = 37;
float buttToFloor = 32.5;
float crotchToFloor = 31; 
float kneeToFloor = 19; 
float ankleToFloor = 4.75;
float calfToFloor = 12.5;

float crotchLength = 17;

float hipCircumference = 32;
float buttCircumference = 35;
float thighCircumference = 21;
float kneeCircumference = 13;
float calfCircumference = 13;
float ankleCircumference = 7.5;

// to get hipHeight wolfram alpha:
// solve c=pi [ 2*(a*a + b*b) - 0.5*(a-b)*(a-b) ]^(1/2) where a=11.5/2 and c=32
// and click on "approximate solutions" under b = 
float hipWidth = 11.5;
float hipHeight = 2*4.39;

// solve c=pi [ 2*(a*a + b*b) - 0.5*(a-b)*(a-b) ]^(1/2) where a=11.5/2 and c=35
float buttWidth = 12.5;
float buttHeight = 2*4.84;

// solve c=pi [ 2*(a*a + b*b) - 0.5*(a-b)*(a-b) ]^(1/2) where a=5/2 and c=21
float thighWidth = 5.5;
float thighHeight = 2*3.8;
float thighSpacing = 1.5;

// solve c=pi [ 2*(a*a + b*b) - 0.5*(a-b)*(a-b) ]^(1/2) where a=4/2 and c=13
float kneeWidth = 4;
float kneeHeight = 2*2.13;

// solve c=pi [ 2*(a*a + b*b) - 0.5*(a-b)*(a-b) ]^(1/2) where a=4/2 and c=13
float calfWidth = 4;
float calfHeight = 2*2.13;

// solve c=pi [ 2*(a*a + b*b) - 0.5*(a-b)*(a-b) ]^(1/2) where a=2/2 and c=7.5
float ankleWidth = 2;
float ankleHeight = 2*1.37;

float hipTilt = 0;
float kneeOffset = 0; // left/right only

// to add:
// calves
// thigh spacing at crotch
// crotch front length vs back length
// butt front/back offset

void setup() {
  size(1024, 1024, P3D);
  smooth();
  cam = new PeasyCam(this, 150);
}

void draw() {
  rotateX(45);
  translate(0, 0, -crotchToFloor);
  //rotateZ(millis() / 2000.);

  //buttHeight = map(mouseX, 0, width, 0, 20);
  // buttToFloor = map(mouseY, 0, height, 20, 40);

  background(255);
  drawGrid();

  noFill();
  stroke(0);

  pushMatrix();
  translate(0, 0, hipToFloor);
  ellipse(0, 0, hipWidth, hipHeight);
  popMatrix();

  pushMatrix();
  translate(0, 0, buttToFloor);
  float buttOffset = hipHeight / 2 - buttHeight / 2;
  ellipse(0, buttOffset, buttWidth, buttHeight); // always flat on the front
  popMatrix();

  pushMatrix();
  translate(0, 0, crotchToFloor);
  float thighCenter = (thighWidth + thighSpacing) / 2;
  ellipse(-thighCenter, 0, thighWidth, thighHeight);
  ellipse(+thighCenter, 0, thighWidth, thighHeight);
  popMatrix();

  pushMatrix();
  translate(0, 0, kneeToFloor);
  float kneeCenter = thighCenter + kneeOffset;
  ellipse(-kneeCenter, 0, kneeWidth, kneeHeight);
  ellipse(+kneeCenter, 0, kneeWidth, kneeHeight);
  popMatrix();

  pushMatrix();
  translate(0, 0, calfToFloor);
  float calfCenter = kneeCenter;
  ellipse(-calfCenter, 0, calfWidth, calfHeight);
  ellipse(+calfCenter, 0, calfWidth, calfHeight);
  popMatrix();

  pushMatrix();
  translate(0, 0, ankleToFloor);
  float ankleCenter = thighCenter;
  ellipse(-ankleCenter, 0, ankleWidth, ankleHeight);
  ellipse(+ankleCenter, 0, ankleWidth, ankleHeight);
  popMatrix();

  ellipseLerp(
  hipToFloor, buttToFloor, 
  hipWidth, buttWidth, 
  hipHeight, buttHeight, 
  0, 0, 
  0, hipHeight / 2 - buttHeight / 2);

  ellipseLerp(
  crotchToFloor, kneeToFloor, 
  thighWidth, kneeWidth, 
  thighHeight, kneeHeight, 
  -thighCenter, -kneeCenter, 
  0, 0);

  ellipseLerp(
  crotchToFloor, kneeToFloor, 
  thighWidth, kneeWidth, 
  thighHeight, kneeHeight, 
  +thighCenter, +kneeCenter, 
  0, 0);

  ellipseLerp(
  kneeToFloor, calfToFloor, 
  kneeWidth, calfWidth, 
  kneeHeight, calfHeight, 
  -kneeCenter, -calfCenter, 
  0, 0);

  ellipseLerp(
  kneeToFloor, calfToFloor, 
  kneeWidth, calfWidth, 
  kneeHeight, calfHeight, 
  +kneeCenter, +calfCenter, 
  0, 0);

  ellipseLerp(
  calfToFloor, ankleToFloor, 
  calfWidth, ankleWidth, 
  calfHeight, ankleHeight, 
  -ankleCenter, -ankleCenter, 
  0, 0);

  ellipseLerp(
  calfToFloor, ankleToFloor, 
  calfWidth, ankleWidth, 
  calfHeight, ankleHeight, 
  +ankleCenter, +ankleCenter, 
  0, 0);
  
  // butt to thigh transition geometry generation
  int n = ellipseResolution;
  int m = (int) (sliceResolution * abs(crotchToFloor - buttToFloor));
  PVector[][] allVertices = new PVector[m][n];
  for (int j = 0; j < m; j++) {
    float t = map(j, 0, m - 1, 0, 1);
    float mt = pow(t, 4);//map(mouseX, 0, width, 0, 10));
    float lastx = 0;
    float lasty = 0;
    float initialx = 0;
    float initialy = 0;
    for (int i = 0; i < n; i++) {
      float thighx, thighy, buttx, butty;
      if (i < n / 2) {
        float thightheta = map(i, 0, n / 2, 0, TWO_PI);
        thighx = cos(thightheta) * thighWidth / 2;
        thighy = sin(thightheta) * thighHeight / 2;
        thighx -= thighCenter;
      } 
      else {
        float thightheta = map(i, n / 2, n, 0, TWO_PI) + PI;
        thighx = cos(thightheta) * thighWidth / 2;
        thighy = sin(thightheta) * thighHeight / 2;
        thighx += thighCenter;
      }

      float butttheta = map(i, 0, n, 0, TWO_PI) + HALF_PI;
      buttx = cos(butttheta) * buttWidth / 2;
      butty = sin(butttheta) * buttHeight / 2;
      butty += buttOffset;

      float x = lerp(buttx, thighx, mt);
      float y = lerp(butty, thighy, mt);
      float z = lerp(buttToFloor, crotchToFloor, t);
      if (lastx != 0 && lasty != 0) {
        line(x, y, z, lastx, lasty, z);
      }
      lastx = x;
      lasty = y;
      if (i == 0) {
        initialx = x;
        initialy = y;
      }
      if (i == n - 1) {
        line(x, y, z, initialx, initialy, z);
      }
      allVertices[j][i] = new PVector(x, y, z);
    }
  }

  // saves all geometry to the stl file
  if (frameCount == 1) {
    UGeometry model = new UGeometry();
    model.beginShape(TRIANGLES);
    for (int j = 0; j < m - 1; j++) {
      for (int i = 0; i < n; i++) {
        PVector nw = allVertices[j][i];
        PVector ne = allVertices[j][(i + 1) % n];
        PVector sw = allVertices[(j + 1) % m][i];
        PVector se = allVertices[(j + 1) % m][(i + 1) % n];
        model.addFace(new UVec3(nw.x, nw.y, nw.z), new UVec3(se.x, se.y, se.z), new UVec3(ne.x, ne.y, ne.z));
        model.addFace(new UVec3(nw.x, nw.y, nw.z), new UVec3(sw.x, sw.y, sw.z), new UVec3(se.x, se.y, se.z));
      }
    }
    
    PVector nw = allVertices[m - 1][0];
    PVector ne = allVertices[m - 1][n / 2 - 1]; // good
    PVector sw = allVertices[m - 1][n / 2];
    PVector se = allVertices[m - 1][n - 1];
    model.addFace(new UVec3(nw.x, nw.y, nw.z), new UVec3(sw.x, sw.y, sw.z), new UVec3(ne.x, ne.y, ne.z));
    model.addFace(new UVec3(nw.x, nw.y, nw.z), new UVec3(se.x, se.y, se.z), new UVec3(sw.x, sw.y, sw.z));

    ellipseLerp(model, 
    hipToFloor, buttToFloor, 
    hipWidth, buttWidth, 
    hipHeight, buttHeight, 
    0, 0, 
    0, hipHeight / 2 - buttHeight / 2,
    1);

    ellipseLerp(model, 
    crotchToFloor, kneeToFloor, 
    thighWidth, kneeWidth, 
    thighHeight, kneeHeight, 
    -thighCenter, -kneeCenter, 
    0, 0,
    2);

    ellipseLerp(model, 
    crotchToFloor, kneeToFloor, 
    thighWidth, kneeWidth, 
    thighHeight, kneeHeight, 
    +thighCenter, +kneeCenter, 
    0, 0,
    2);

    ellipseLerp(model, 
    kneeToFloor, calfToFloor, 
    kneeWidth, calfWidth, 
    kneeHeight, calfHeight, 
    -kneeCenter, -calfCenter, 
    0, 0,
    2);

    ellipseLerp(model, 
    kneeToFloor, calfToFloor, 
    kneeWidth, calfWidth, 
    kneeHeight, calfHeight, 
    +kneeCenter, +calfCenter, 
    0, 0,
    2);

    ellipseLerp(model, 
    calfToFloor, ankleToFloor, 
    calfWidth, ankleWidth, 
    calfHeight, ankleHeight, 
    -ankleCenter, -ankleCenter, 
    0, 0,
    2);

    ellipseLerp(model, 
    calfToFloor, ankleToFloor, 
    calfWidth, ankleWidth, 
    calfHeight, ankleHeight, 
    +ankleCenter, +ankleCenter, 
    0, 0,
    2);

    model.writeSTL(this, "out.stl");
  }
}

// cylinder generation for saving to a file
void ellipseLerp(UGeometry model, float z1, float z2, float w1, float w2, float h1, float h2, float x1, float x2, float y1, float y2, int subdivide) {
  int m = ellipseResolution / subdivide;
  int n = (int) (sliceResolution * abs(z1 - z2));
  PVector[][] allVertices = new PVector[n][m];
  for (int i = 0; i < n; i++) {  
    float t = map(i, 0, n - 1, 0, 1);
    float x = lerp(x1, x2, t);
    float y = lerp(y1, y2, t);
    float z = lerp(z1, z2, t);
    float w = lerp(w1, w2, t);
    float h = lerp(h1, h2, t);
    for (int j = 0; j < m; j++) {
      float theta = map(j, 0, m, 0, TWO_PI);
      float curx = x + cos(theta) * w / 2;
      float cury = y + sin(theta) * h / 2;
      allVertices[i][j] = new PVector(curx, cury, z);
    }
  }

  for (int j = 0; j < n - 1; j++) {
    for (int i = 0; i < m; i++) {
      PVector nw = allVertices[j][i];
      PVector ne = allVertices[j][(i + 1) % m];
      PVector sw = allVertices[(j + 1) % n][i];
      PVector se = allVertices[(j + 1) % n][(i + 1) % m];
      model.addFace(new UVec3(nw.x, nw.y, nw.z), new UVec3(se.x, se.y, se.z), new UVec3(ne.x, ne.y, ne.z));
      model.addFace(new UVec3(nw.x, nw.y, nw.z), new UVec3(sw.x, sw.y, sw.z), new UVec3(se.x, se.y, se.z));
    }
  }
}

// cylinder generation for drawing to the screen
void ellipseLerp(float z1, float z2, float w1, float w2, float h1, float h2, float x1, float x2, float y1, float y2) {
  int n = (int) (sliceResolution * abs(z1 - z2));
  for (int i = 0; i < n; i++) {
    float t = map(i, 0, n, 0, 1);
    pushMatrix();
    translate(0, 0, lerp(z1, z2, t));
    ellipse(
    lerp(x1, x2, t), 
    lerp(y1, y2, t), 
    lerp(w1, w2, t), 
    lerp(h1, h2, t));
    popMatrix();
  }
}

void drawGrid() {
  noFill();
  stroke(0);
  int floorResolution = 11;
  float floorScale = 50;
  for (int j = 0; j < floorResolution; j++) {
    float y = map(j, 0, floorResolution - 1, -floorScale, floorScale);
    line(-floorScale, y, floorScale, y);
  }
  for (int i = 0; i < floorResolution; i++) {
    float x = map(i, 0, floorResolution - 1, -floorScale, floorScale);
    line(x, -floorScale, x, floorScale);
  }

  fill(255, 0, 0);
  noStroke();
  box(2);
}

