#pragma once

#include "ofMain.h"
#include "ofxKinect.h"
#include "ofxCv.h"
#include "ofxUI.h"
#include "MiniFont.h"

using namespace ofxCv;
using namespace cv;



class ofApp : public ofBaseApp {
public:
	void setup();
	void setupGui();
	void analyze();
	void update();
	void draw();
	void keyPressed(int key);
	
	float measureSegment(int y, ofShortImage& depth, ofImage& mask,
											 int leftBoundary, int rightBoundary,
											 int& leftEdge, int& rightEdge,
											 ofVec3f& leftPoint, ofVec3f& rightPoint);
	ofVec3f ConvertProjectiveToRealWorld(float x, float y, float z);
	ofVec3f sampleDepth(ofShortImage& depth, ofVec2f position);
	
	ofxUICanvas* gui;	
	ofEasyCam cam;
	
	ofImage colorFront, maskFront;
	ofShortImage depthFront;
	
	ofImage colorSide, maskSide;
	ofShortImage depthSide;
	
	vector<pair<ofVec2f, ofVec2f> > frontEdges, sideEdges;
	vector<float> heights, circumferences;
};