// all units in inches
// measured on lisa

class PantBack {
  
  float inseam; // crotch to floor 
  float sideseam; // waist to hemline (not floor to waist)
  float hipCircumference; // the "fullest part of your hip" 
  float crotchDepth; // from waist to seat when you're sitting
  float hemCircumference; // also called "ankle", based on your favorite pants
  float waist; // waist circumference
  float derriereShape; // normal/average derriere: 1+5/8, flat derriere: 2, protruding derriere: 7/8
  float takeInCenterBack; //usually 1/4" to 3/8"
  float dartDepth; //how deep you want the darts at the waist, perhaps 2"

  //also in front draft
  private PVector A, B, p1, p2, p3, p4, p5; // mark points
  private PVector p6, p6a, p7, p8; //add circumference
  private PVector p9, p10, p11, p12; //establish the crease
  private PVector p13, p14, p2b, p2c, p8b; //shape the front leg
  
  // other PVectors in David's code ... why???
  // private PVector p7a, p6b;
  // private PVector D, Aa, p5a;

  //specific to back draft
  PVector p15, p16, p17;
  PVector p18, p19, p20;

  PVector p4a, p4b, p13out, p14out, p4Aout, p4Bout, p21;

  PVector pCBtop, pCBbottom, pParallel;
  PVector p22, p23, p24, p25, p21ControlPoint;

  private float drawingScale = 13;
  PFont font;
  
  boolean showPoints, showVerticalLines, drawPant, drawDraftingLines;

  PantBack() {
    inseam = 31;
    sideseam = 38.4; 
    hipCircumference = 35; 
    crotchDepth = 8; 
    hemCircumference = 12; 
    waist = 26; 
    derriereShape = 2;
    takeInCenterBack = 3/8.; 
    dartDepth = 2;
    
    showPoints = showVerticalLines = drawPant = drawDraftingLines = true;
    
    font = createFont("Arial", 12);
    textFont(font);
  }
  
  PantBack (
    float _inseam,
    float _sideseam, 
    float _hipCircumference, 
    float _crotchDepth,
    float _hemCircumference, 
    float _waist,
    float _derriereShape,
    float _takeInCenterBack,
    float _dartDepth) {
    inseam = _inseam;
    sideseam = _sideseam; 
    hipCircumference = _hipCircumference; 
    crotchDepth = _crotchDepth; 
    hemCircumference = _hemCircumference; 
    waist = _waist; 
    derriereShape = _derriereShape;
    takeInCenterBack = -takeInCenterBack; 
    dartDepth = _dartDepth;  
    
    showPoints = showVerticalLines = drawPant = drawDraftingLines = true;

    font = createFont("Arial", 12);
    textFont(font);
  }

void update(){ 
  // mark points
  A = new PVector(0,0);
  B = A.get();
  B.y += 5/8. + sideseam;
  p1 = A.get();
  p1.y += 5/8.;
  p2 = p1.get();
  p2.y += crotchDepth;
  p3 = PVector.add(B, p2);
  p3.div(2);
  p4 = p3.get();
  p4.y -= inseam / 10.;
  p5 = p2.get();
  p5.y -= ((hipCircumference / 2.) / 10.) + (1 + 1/4.);
  
  // add circumference measurements
  p6 = p5.get();
  p6.x += (hipCircumference/ 4.) - 3/8.;
  p6a = p6.get();
  p6a.x += ((hipCircumference / 2.) / 10.) + 1/4.;
  p7 = p6.get();
  p7.y =1;
  p8 = p6.get();
  p8.y = p2.y; 
  
  //establish the crease
  p9 = PVector.add(p5, p6a);
  p9.div(2);
  p10 = p9.get();
  p10.y = p2.y;
  p11 = p9.get();
  p11.y = p4.y;
  p12 = p9.get();
  p12.y = B.y; 
  
  //shape the front leg
  p13 = p12.get();
  p13.x -= (hemCircumference / 4.) - (3/8.);
  p14 = p12.get();
  p14.x += (hemCircumference / 4.) - (3/8.);
  p2b = intersectAtDistance(p14, p6a, p2, p8); //this is confusing
  p2c = PVector.add(p2b, p8);
  p2c.div(2);
  p8b = p8.get();
  p8b.y -= (p2c.x - p8.x);
  
  //BACK DRAFT:
  //find the center back
  p15 = p9.get();
  p15.x += 3/8.;
  p16 = p15.get();
  p16.x += (((hipCircumference / 4.) + 3/8.)/ 4.);
  p17 = p2.get();
  p17.y -= derriereShape; 
  
  //shift the hips
  p18 = p16.get();
  p18.x -= (hipCircumference / 4.) + 3/8.;
  p20 = p15.get();
  p20.x += (p15.x-p18.x); 
  
  //draw the outside lines
  p4a = intersectAtDistance(p13,p5,p4,p11);
  p4b = intersectAtDistance(p6a,p14,p4,p11);
  p13out = p13.get();
  p13out.x -= 3/4.;
  p14out = p14.get();
  p14out.x += 3/4.;
  p4Aout = p4a.get();
  p4Aout.x -= 3/4.;
  p4Bout = p4b.get();
  p4Bout.x += 3/4.;
  
  p21 = intersectAtDistance(p18,p4Aout,p1, p7);
  
  // draw parallel and center back line
  float slope = (p17.y-p16.y)/(p17.x-p16.x);
  pParallel = p12.get();
  pParallel.y = (pParallel.x-p18.x);
  pParallel.y *= slope;
  pParallel.y += p18.y;
  slope = - (1/slope);
  pCBtop = p11.get();
  pCBtop.x += 1+ 3/4.; // picked 1.75" arbitrarily, CB just needs to extend above waistline
  pCBtop.y = (pCBtop.x-p16.x); 
  pCBtop.y *= slope;
  pCBtop.y += p16.y;
  pCBbottom = intersectAtDistance(p2,p10,p16,pCBtop);
  p19 = intersectAtDistance(pCBbottom,p16,p18,pParallel);
  
  //first, find yintercept of centerback line, can use slope of CB line defined previously?
  // redefine slope just in case
  //slope = (pCBtop.y - p19.y)/(pCBtop.x - p19.x);
  float yintercept = pCBtop.y - (slope*pCBtop.x);
  float radius = dist(p11.x, p11.y, p21.x, p21.y);
  p22 = A.get();
  p22.x = - sqrt( 
      - sq(yintercept) - (2.*yintercept*p11.x*slope) + (2.*yintercept*p11.y) - (sq(p11.x)*sq(slope)) + 
      (2.*p11.x*p11.y*slope) - sq(p11.y) + (sq(slope)*sq(radius)) + sq(radius)
      ) 
      - (yintercept* slope) + p11.x + (p11.y* slope);
  p22.x /= sq(slope) + 1.; 
  p22.y = slope* p22.x + yintercept;
  
  p23 = p2b.get();
  p23.y += 1/4.;
  float slopep20 = (p20.y-p4Bout.y)/(p20.x-p4Bout.x);
  float yinterceptp20 = p20.y - (slopep20 * p20.x);
  p23.x = (p23.y - yinterceptp20) / slopep20;  
  
  //i know all this math should be abstracted but not exactly sure how yet
  float slopetop = (p22.y-p21.y)/(p22.x-p21.x);
  float yintercepttop = p22.y - (slopetop * p22.x);
  p24 = p22.get();
  p24.x = - sqrt(
      - sq(yintercepttop) - (2.*yintercepttop*p22.x*slopetop) + (2.*yintercepttop*p22.y) + 
      (sq(takeInCenterBack)*sq(slopetop)) + sq(takeInCenterBack) - (sq(p22.x)*sq(slopetop)) +
      (2.*p22.x*p22.y*slopetop) - sq(p22.y)
      ) - (yintercepttop*slopetop) + p22.x + (p22.y*slopetop);
  p24.x /= sq(slopetop) +1.;
  p24.y = (p24.x*slopetop) + yintercepttop;
  
  float waistdistance = (waist / 4.) - 1/4. + dartDepth; //desired dart depth?? first time using waist?
  p25 = p24.get();
  p25.x = - sqrt(
      - sq(yintercepttop) - (2.*yintercepttop*p24.x*slopetop) + (2.*yintercepttop*p24.y) + 
      (sq(waistdistance)*sq(slopetop)) + sq(waistdistance) - (sq(p24.x)*sq(slopetop)) +
      (2.*p24.x*p24.y*slopetop) - sq(p24.y)
      ) - (yintercepttop*slopetop) + p24.x + (p24.y*slopetop);
  p25.x /= sq(slopetop) +1.;
  p25.y = (p25.x*slopetop) + yintercepttop;
  
  float slopeside = (p21.y-p18.y)/(p21.x-p18.x);
  float yinterceptside = p21.y - (slopeside * p21.x);
  p21ControlPoint = p21.get();
  p21ControlPoint.x = sqrt(
      - sq(yinterceptside) - (2.*yinterceptside*p21.x*slopeside) + (2.*yinterceptside*p21.y) + 
      (sq(dartDepth)*sq(slopeside)) + sq(dartDepth) - (sq(p21.x)*sq(slopeside)) +
      (2.*p21.x*p21.y*slopeside) - sq(p21.y)
      ) - (yinterceptside*slopeside) + p21.x + (p21.y*slopeside);
  p21ControlPoint.x /= sq(slopeside) +1.;
  p21ControlPoint.y = (p21ControlPoint.x*slopeside) + yinterceptside; 
} 

  void draw() {

    float pointSize = 6;

    // horizontal lines
    //if (showHorizontalLines) drawHorizontalLines();

    // vertical lines
    if (showVerticalLines) drawVerticalLines();

    //draw the outile of the pant
    if (drawPant)  drawPant(drawingScale);
    
    //draw drafting lines
    if (drawDraftingLines) drawDraftingLines(drawingScale);

    // points
    if (showPoints) drawPoints(pointSize);
  }
  
  void drawPoints(float pointSize) {
    noStroke();
    fill(0);
    textAlign(LEFT, CENTER);
    PVector[] points = {
      A, B, p1, p2, p3, p4, p5,
      p6, p6a, p7, p8,
      p9, p10, p11, p12,
      p13, p14, p2b, p2c, p8b,
      p15, p16, p17, p18, p20,
      p4a, p4b, p13out, p14out, p4Aout, p4Bout,
      p21, pCBtop, pCBbottom, p19, p22, p23, p24, p25,
    };
    String[] pointLabels = {
      "A", "B", "1", "2", "3", "4", "5",
      "6", "6a", "7", "8",
      "9", "10", "11", "12",
      "13", "14", "2b", "2c", "8b",
      "15", "16", "17", "18", "20",
      "4a", "4b", "13out","14out","4aout","4bout",
      "21", "CBtop", "", "19", "22", "23", "24", "25",
    };
    for (int i = 0; i < points.length; i++){
      float x = points[i].x * drawingScale, y = points[i].y * drawingScale; 
      ellipse(x, y, pointSize, pointSize); 
      text(pointLabels[i], x + pointSize, y); 
    }
  }
  
  void drawVerticalLines() {
    stroke(200);
    PVector[] verticalLines = {
      p6, p9, p1
    };
    String[] verticalLineLabels = {
      "", "Crease Line", "",
    };
    for (int i = 0; i < verticalLines.length; i++) {
      float x = verticalLines[i].x * drawingScale;
      line(x, 0, x, height);
      // turn crease line label sideways 
      pushMatrix();
      translate(x, height / 2);
      rotate(-HALF_PI);
      text(verticalLineLabels[i], 0, 0);
      popMatrix();
    }
  }
  
  void drawPant(float drawingScale) {

    //line pairs back draft
    stroke(0,0,200);
    PVector[] linePairsBack = {
      p13out, p14out,
      p19, p24, 
      p24, p25
    };
    for (int i = 0; i < linePairsBack.length; i += 2) {
      line(linePairsBack[i].x * drawingScale,
      linePairsBack[i].y * drawingScale,
      linePairsBack[i+1].x * drawingScale,
      linePairsBack[i+1].y * drawingScale);
    }
  
    //outside beziers
    pushStyle();
    stroke(0,0,200);
    noFill();
    drawBezier(p18, p4Aout, p4Aout, p13out,drawingScale);
    //all the way up to p20, dont need:
    //drawBezier(p14out,p4Bout,p4Bout,p20,drawingScale); 
    drawBezier(p14out,p4Bout,p4Bout,p23,drawingScale); 
    drawBezier(p19,p16,p2b,p23,drawingScale); 
    drawBezier(p25,p21ControlPoint,p21ControlPoint,p18,drawingScale);  
    popStyle();
  }
  
  void drawDraftingLines(float drawingScale) {
  //line pairs, in faded blue
    stroke(0, 0, 200, 50);
    PVector[] linePairs = {
      p13, p5,
      p14, p6a,
      p15, p11,
      p17, p16,
      p11,p21,
      p2b, p8b,
      pCBtop, pCBbottom,
      p18, p19,
      
    };
    for (int i = 0; i < linePairs.length; i += 2) {
      line(linePairs[i].x * drawingScale,
      linePairs[i].y * drawingScale,
      linePairs[i+1].x * drawingScale,
      linePairs[i+1].y * drawingScale);
    }
  
  }
  
  // calculate location of p2b using toxiclibs
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

  void drawBezier(PVector anchorPoint1, PVector controlPoint1, PVector controlPoint2, PVector anchorPoint2, float scale){
    
    bezier(scale * anchorPoint1.x, scale * anchorPoint1.y, 
    scale * controlPoint1.x, scale * controlPoint1.y, 
    scale * controlPoint2.x, scale * controlPoint2.y, 
    scale * anchorPoint2.x, scale * anchorPoint2.y);
  }
}
