import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;


import processing.opengl.*;

HE_Mesh mesh;
WB_Render render;

void setup() {
  size(600, 600, OPENGL);
  smooth();

  //Custom mesh creation is easiest by creating an array of vertices and the corresponding faces
  //and calling the faceList creator. Writing a full-blown implementation of a HEC_Creator
  //is best done in Eclipse with full access to the code repository.

  //Array of all vertices
  float[][] vertices=new float[121][3];
  int index = 0;
  for (int j = 0; j < 11; j++) {
    for (int i = 0; i < 11; i++) {
      vertices[index][0] =-200+ i * 40+(((i!=0)&&(i!=10))?random(-20, 20):0);
      vertices[index][1] =-200+j * 40+(((j!=0)&&(j!=10))?random(-20, 20):0);
      vertices[index][2] = sin(TWO_PI/20*i)*40+cos(TWO_PI/10*j)*40;
      index++;
    }
  }
  //Array of faces. Each face is an arry of vertex indices;
  index = 0;
  int[][] faces = new int[100][];
  for (int j = 0; j < 10; j++) {
    for (int i = 0; i < 10; i++) {
      faces[index]=new int[4];
      faces[index][0] = i + 11 * j;
      faces[index][1] = i + 1 + 11 * j;
      faces[index][2] = i + 1 + 11 * (j + 1);
      faces[index][3] = i + 11 * (j + 1);
      index++;
    }
  }

//HEC_Facelist uses the vertices and the indexed faces to create a mesh with all connectivity.
  HEC_FromFacelist facelistCreator=new HEC_FromFacelist().setVertices(vertices).setFaces(faces).setDuplicate(false);
  mesh=new HE_Mesh(facelistCreator);
  
  //check mesh validity, surfaces meshes will have "Null reference (face)" for the outer halfedges.
  //other messages could refer to inconsistent face orientation, missing faces or meshes not representable by
  //the hemesh datastructure
  mesh.validate(true, true);

  //This should work
  mesh.modify(new HEM_Lattice().setDepth(5).setWidth(5));
  mesh.subdivide(new HES_Smooth());
  render=new WB_Render(this);
}

void draw() {
  background(120);
  lights();
  translate(300, 300, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}





