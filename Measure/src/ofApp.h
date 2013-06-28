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
	void updateMeanShift();
	void analyze();
	void update();
	void draw();
	void keyPressed(int key);
	
	void buildMask(ofImage& mask, Mat& color, ofShortImage& depth);
	float measureSegment(int y, ofShortImage& depth, ofImage& mask,
											 int leftBoundary, int rightBoundary,
											 ofVec3f& leftEdge, ofVec3f& rightEdge,
											 ofVec3f& leftPoint, ofVec3f& rightPoint,
											 float slope = 0);
	ofVec3f ConvertProjectiveToRealWorld(const ofVec3f& point);
	ofVec3f ConvertProjectiveToRealWorld(float x, float y, float z);
	ofPolyline ConvertProjectiveToRealWorld(const ofPolyline& polyline, float z);
	ofVec3f sampleDepth(ofShortImage& depth, ofVec2f position, int radius = 0);
	
	ofxUICanvas* gui;	
	ofEasyCam cam;
	
	ofImage colorFront, maskFront;
	ofShortImage depthFront;
	
	ofImage colorSide, maskSide;
	ofShortImage depthSide;
	
	vector<pair<ofVec2f, ofVec2f> > frontEdges, sideEdges;
	vector<float> heights, circumferences, depths;
	
	ofPolyline crotch;
	float crotchLength;
	
	ofxKinect kinect;
};