#pragma once

#include "ofMain.h"
#include "ofxKinect.h"
#include "ofxCv.h"
#include "ofxUI.h"

using namespace ofxCv;
using namespace cv;

class ofApp : public ofBaseApp {
public:
	void setup();
	void setupGui();
	void update();
	void draw();
	void keyPressed(int key);
	
	ofVec3f accelerationSum;
	int accelerationCount;
	ofVec3f upVector;
	ofMatrix4x4 orientationMat;
	
	ofxKinect kinect;
	ofxUICanvas* gui;	
	ofEasyCam cam;
	
	ofMesh mesh;
};