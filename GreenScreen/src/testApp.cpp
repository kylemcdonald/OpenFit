#include "testApp.h"

using namespace ofxCv;
using namespace cv;

ofShortImage depth;
ofImage color;
cv::Mat depthMask, meanShiftMat, fg, bg, markers8u, hsvBuffer;

bool useMeanShift = false;

float
hueCenter = 55,
hueRange = 25,
svPadding = 35,
backgroundErode = 8,
foregroundDilate = 2,
foregroundErode = 8,
maskAlpha = 128,
pyramidLevels = 3,
spatialRadius = 10,
colorRadius = 25,
depthThreshold = 1300;

void testApp::setup() {
	depth.loadImage("depth.png");
	color.loadImage("color.png");	
	setupGui();
}

void testApp::setupGui() {	
	gui = new ofxUICanvas();
	gui->addLabel("Measure");
	gui->addSpacer();
	gui->addFPS();
	gui->addSpacer();
	gui->addSlider("Hue center", 0, 255, &hueCenter);
	gui->addSlider("Hue range", 0, 255, &hueRange);
	gui->addSlider("Saturation/Value padding", 0, 255, &svPadding);
	gui->addSlider("Depth threshold", 1000, 3000, &depthThreshold);
	gui->addSlider("Background erode", 1, 16, &backgroundErode);
	gui->addSlider("Foreground dilate", 1, 8, &foregroundDilate);
	gui->addSlider("Foreground erode", 1, 16, &foregroundErode);
	gui->addSlider("Mask alpha", 0, 255, &maskAlpha);
	gui->addLabelToggle("Use Mean Shift", &useMeanShift);
	gui->addSlider("Pyramid levels", 0, 6, &pyramidLevels);
	gui->addSlider("Spatial radius", 1, 64, &spatialRadius);
	gui->addSlider("Color radius", 1, 128, &colorRadius);
	gui->autoSizeToFitWidgets();
}

void testApp::update() {
	Mat colorMat = toCv(color);
	Mat img;
	if(useMeanShift) {
		pyrMeanShiftFiltering(colorMat, meanShiftMat, spatialRadius, colorRadius, pyramidLevels);
		img = meanShiftMat;
	} else {
		img = colorMat;
	}
	
	cvtColor(img, hsvBuffer, CV_RGB2HSV);
	Scalar lowerb(hueCenter - hueRange, svPadding, svPadding);
	Scalar upperb(hueCenter + hueRange, 255 - svPadding, 255 - svPadding);
	inRange(hsvBuffer, lowerb, upperb, fg);
	
	Mat depthMat = toCv(depth);
	depthMask = (depthMat < depthThreshold) & (depthMat > 0);
	fg = fg & depthMask;
	bg = ~fg;
	erode(bg, (int) backgroundErode);
	dilate(fg, (int) foregroundDilate);
	erode(fg, (int) foregroundErode);
	
	Mat markers = Mat::zeros(depth.getHeight(), depth.getWidth(), CV_32SC1);
	markers.setTo(1, bg);
	markers.setTo(2, fg);
	watershed(img, markers);
	markers.convertTo(markers8u, CV_8UC1, 255, -255);
}

void testApp::draw() {
	ofBackground(0);
	
	color.draw(0, 0);
	ofPushStyle();
	ofEnableBlendMode(OF_BLENDMODE_ADD);
	ofSetColor(255, maskAlpha);
	drawMat(markers8u, 0, 0);
	ofPopStyle();
	
	ofPushStyle();
	ofEnableBlendMode(OF_BLENDMODE_ADD);
	ofSetColor(cyanPrint);
	drawMat(fg, 640, 0);
	ofSetColor(magentaPrint);
	drawMat(bg, 640, 0);
	ofPopStyle();
	
	drawMat(meanShiftMat, 0, 480);
}
