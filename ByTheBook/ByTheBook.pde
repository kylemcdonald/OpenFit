import toxi.geom.*;
import toxi.processing.*;
import processing.pdf.*;
import controlP5.*;

static int WSCREEN = 700;
static int HSCREEN = 800;

/* variables */
//display grid
boolean showGrid=true;
//save to pdf
boolean savePdf=false;

//pant object
PantFront pantFront;
PantBack pantBack;

//gui variables
ControlP5 cp5;
Accordion accordion;
int accordionWidth = 200;

void setup() {
  size(WSCREEN, HSCREEN);
  pantFront = new PantFront();
  pantBack = new PantBack();
  setupGui();
}

void draw() {
  if (savePdf) beginRecord(PDF, "Pant-"+year()+"-"+month()+"-"+day()+"-"+minute()+"-"+second()+".pdf");

  background(255);
  if (showGrid) drawGrid();

  pantFront.update();
  pantFront.draw();

  pantBack.update();
  translate(width/2, 0);
  pantBack.draw();
  if (savePdf) {
    savePdf=false; 
    endRecord();
  }
  translate(-width/2, 0);
}  
void keyPressed() {
  println("d "+key);
  if (key=='d') {
    if (cp5.isVisible())
      cp5.hide();
    else
      cp5.show();
  }
  if (key=='s') {
    savePdf=true;
  }
}
void drawGrid() {
  // grid
  stroke(245);
  int xsegments = int(width / pantFront.getDrawingScale());
  int ysegments = int(height / pantFront.getDrawingScale());
  for (int y = 0; y < ysegments; y++)
    line(0, y * pantFront.getDrawingScale(), width, y * pantFront.getDrawingScale());
  for (int x = 0; x < xsegments; x++)
    line(x * pantFront.getDrawingScale(), 0, x * pantFront.getDrawingScale(), height);
}

void setupGui() {
  cp5 = new ControlP5(this);

  Group horizontal = cp5.addGroup("Horizontal")
    .setBackgroundHeight(100);

  Group display = cp5.addGroup("Display")
    .setBackgroundHeight(100);

  cp5.addSlider("pant  .hipCircumference")
    .setPosition(0, 0)
      .setSize(100, 20)
        .setRange(0, 200)
          .setCaptionLabel("Hip cirumference")
            .moveTo(horizontal)
              .setColorCaptionLabel(0);


  cp5.addToggle("showGrid")
    .setPosition(0, 0)
      .setSize(50, 20)
        .setValue(true)
          .moveTo(display)
            .setCaptionLabel("Show/Hide grid")
              .setColorCaptionLabel(0);

  accordion = cp5.addAccordion("acc")
    .setPosition(width-accordionWidth-40, 30)
      .setWidth(accordionWidth)
        .addItem(display)
          .addItem(horizontal);

  cp5.show();
}

