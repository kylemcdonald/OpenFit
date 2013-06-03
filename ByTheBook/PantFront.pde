// all units in inches
// measured on lisa
class PantFront {

  float inseam; // crotch to floor (not used)
  float waist; // waist circumference (not used)

  float sideseam; // waist to hemline (not floor to waist)
  float hipCircumference; // the "fullest part of your hip" 
  float crotchDepth; // from waist to seat when you're sitting
  float hemCircumference; // also called "ankle", based on your favorite pants
  float stomachOffset; // anywhere from -3/8 (flat stomach) to +5/8 (protruding stomach)
  float crotchOffset; // anywhere from 1/4 to 3/8 (very little difference)

  private float drawingScale = 20;

  private PVector A, B, p1, p2, p3, p4, p5;
  private PVector p6, p7, p8, p6a;
  private PVector p9, p10, p11, p12;
  private PVector p13, p14, p2b, p2c, p8b;
  private PVector p7a, p6b;
  private PVector D, Aa, p5a;

  PFont font;

  //drawing debug information
  boolean showPoints, showHorizontalLines, showVerticalLines, drawPant;

  /*
   PantsFront() - default constructor
   PantsFront( float _inseam, float _waist, float _sideseam, float _hipCircumference, float _crotchDepth, float _hemCircumference, float _stomachOffset, float _crotchOffset) - constructor
   
   void update() - is called every iteration to update the values of the variables from the pants
   void draw() - where we draw the pants
   
   //auxiliar methods
   PVector intersectAtDistance(PVector a, PVector b, PVector c, PVector d) - returns a PVector, (for us a point) where two lines cross (line ab crosses with line cd) 
   Line2D makeLine (PVector a, PVector b) - returns a Line2d done out of two vectors
   
   //setters
   void setDrawingScale(float s) - sets the drawing scale. Remember, sizes are in inches, so if we set 3 means we are setting 3 inches and then when we draw we multiply it for 
   the drawing scale so we can see it in the sketch.
   
   //getters
   float getDrawingScale() - returns the scale in which we are scaling the drawing. 
   
   //drawing
   void drawPant() - will draw the pant
   void drawVerticalLines() - will draw the vertical lines with the labels
   void drawHorizontalLines() - will draw the horizontal lines with the labels
   void drawPoints() - will draw the point that are important and relevant for the drawing of the pant
   
   */
  PantFront() {
    //Pants properties
    inseam = 31;
    waist = 26;
    sideseam = 38.4;
    hipCircumference = 35;
    crotchDepth = 8; 
    hemCircumference = 12;
    stomachOffset = -3/8.;
    crotchOffset = 1/4.;

    showPoints = showHorizontalLines = showVerticalLines = drawPant = true;

    //font for displaying information
    font = createFont("Arial", 12);
    textFont(font);
  }

  PantFront( float _inseam, float _waist, float _sideseam, float _hipCircumference, float _crotchDepth, float _hemCircumference, float _stomachOffset, float _crotchOffset) {           
    //Pants properties
    inseam = _inseam;
    waist = _waist;

    sideseam = _sideseam;
    hipCircumference = _hipCircumference;
    crotchDepth = _crotchDepth; 
    hemCircumference = _hemCircumference;
    stomachOffset = _stomachOffset;
    crotchOffset = _crotchOffset;

    showPoints = showHorizontalLines = showVerticalLines = drawPant = true;

    //font for displaying information
    font = createFont("Arial", 12);
    textFont(font);
  }
  void update() {
    // mark points
    A = new PVector(0, 0);
    B = A.get();
    B.y += 5./8 + sideseam;
    p1 = A.get();
    p1.y += 5./8;
    p2 = p1.get();
    p2.y += crotchDepth;
    p3 = PVector.add(B, p2);
    p3.div(2);
    p4 = p3.get();
    p4.y -= inseam / 10.;

    // add circumference measurements
    p5 = p2.get();
    p5.y -= (hipCircumference / 2.) / 10. + (1 + 1/4.);
    p6 = p5.get();
    p6.x += hipCircumference / 4. - 3/8.;
    p7 = p6.get();
    p7.y = p1.y;
    p8 = p6.get();
    p8.y = p2.y;
    p6a = p6.get();
    p6a.x += ((hipCircumference / 2.) / 10.) + (1/4.);

    // establish the crease line
    p9 = PVector.add(p5, p6a);
    p9.div(2);
    p10 = p9.get();
    p10.y = p8.y;
    p11 = p9.get();
    p11.y = p4.y;
    p12 = p9.get();
    p12.y = B.y;

    // shape the leg
    p13 = p12.get();
    p13.x -= (hemCircumference / 4.) - (3/8.);
    p14 = p12.get();
    p14.x += (hemCircumference / 4.) - (3/8.);
    p2b = intersectAtDistance(p14, p6a, p2, p8);
    p2c = PVector.add(p2b, p8);
    p2c.div(2);
    p8b = p8.get();
    p8b.y -= (p2c.x - p8.x);

    // adjust for the stomach
    p7a = p7.get();
    p7a.x += stomachOffset;
    p6b = p6.get();
    p6b.x += crotchOffset;

    // curve the waistline
    D = p7a.get();
    D.x = p9.x;
    Aa = A.get();
    Aa.x += 1.; // should be along bezier (p7a, D, D, A)
    p5a = PVector.add(p5, A);
    p5a.div(2);
  }
  void draw() {
    //hemCircumference = mouseX / 3.;
    //crotchDepth = mouseY / 10.;
    //sideseam = mouseX;
    //stomachOffset = map(mouseX, 0, width, -3/8., +5/8.);
    //crotchOffset = map(mouseX, 0, width, 1/4., 3/8.);
    float pointSize = 6;

    // horizontal lines
    if (showHorizontalLines) drawHorizontalLines();

    // vertical lines
    if (showVerticalLines) drawVerticalLines();

    //draw the outile of the pant
    if (drawPant)  drawPant(drawingScale);

    // points
    if (showPoints) drawPoints(pointSize);
  }
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

  void drawPant(float drawingScale) {
    // line pairs
    noFill();
    stroke(0, 0, 200);
    PVector[] linePairs = {
      p13, p5, 
      p14, p6a, 
      p8b, p2b
    };
    for (int i = 0; i < linePairs.length; i += 2) {
      line(drawingScale * linePairs[i].x, drawingScale * linePairs[i].y, 
      drawingScale * linePairs[i+1].x, drawingScale * linePairs[i+1].y);
    }

    // beziers
    PVector[] bezierPoints = {
      p7a, p6b, p8b, p2b, 
      p7a, D, D, A, 
      p5, p5a, p5a, Aa
    };
    for (int i = 0; i < bezierPoints.length; i += 4) {
      bezier(drawingScale * bezierPoints[i].x, drawingScale * bezierPoints[i].y, 
      drawingScale * bezierPoints[i+1].x, drawingScale * bezierPoints[i+1].y, 
      drawingScale * bezierPoints[i+2].x, drawingScale * bezierPoints[i+2].y, 
      drawingScale * bezierPoints[i+3].x, drawingScale * bezierPoints[i+3].y);
    }
  }
  /************************
   DRAW DEBUG INFORMATION***
   *************************/
  void drawPoints(float pointSize) {
    noStroke();
    fill(0);
    textAlign(LEFT, CENTER);
    PVector[] points = {
      A, B, p1, p2, p3, p4, 
      p5, p6, p7, p8, p6a, 
      p9, p10, p11, p12, 
      p13, p14, p2b, p2c, p8b, 
      p7a, p6b,
    };
    String[] pointLabels = {
      "A", "B", "1", "2", "3", "4", 
      "5", "6", "7", "8", "6a", 
      "9", "10", "11", "12", 
      "13", "14", "2b", "2c", "8b", 
      "7a", "6b",
    };
    for (int i = 0; i < points.length; i++) {
      float x = points[i].x * drawingScale, y = points[i].y * drawingScale;
      ellipse(x, y, pointSize, pointSize);
      text(pointLabels[i], x + pointSize, y);
    }
  }

  void drawHorizontalLines() {
    noFill();
    stroke(200);
    textAlign(RIGHT, BOTTOM);
    PVector[] horizontalLines = {
      p1, p5, p2, p4, B
    };
    String[] horizontalLineLabels = {
      "Waist", "Hipline", "Crotch depth", "Knee", "Hemline"
    };
    for (int i = 0; i < horizontalLines.length; i++) {
      float y = horizontalLines[i].y * drawingScale;
      line(0, y, width/2, y);
      text(horizontalLineLabels[i], width/2, y);
    }
  }

  void drawVerticalLines() {
    noFill();
    stroke(200);

    //add the points that you will use to make lines
    PVector[] verticalLines = {
      p6, p9
    };

    //add the label you want those lines to be labeled like. "" means no name will be displayed
    String[] verticalLineLabels = {
      "", "Crease line"
    };

    //for loop that will go trough the line vector to 
    for (int i = 0; i < verticalLines.length; i++) {
      float x = verticalLines[i].x * drawingScale;
      line(x, 0, x, height);
      pushMatrix();
      translate(x, height / 2);
      rotate(-HALF_PI);
      text(verticalLineLabels[i], 0, 0);
      popMatrix();
    }
  }
  /************************
   SETTERS******************
   *************************/
  void setDrawingScale(float s) {
    drawingScale = s;
  }

  /************************
   GETTERS******************
   *************************/
  public float getDrawingScale() {
    return drawingScale;
  }
}

