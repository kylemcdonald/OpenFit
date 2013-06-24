#include "ofApp.h"
#include "Geometry.h"

/*
 2 vertical planes - one that splits the crotch, one that divides front and back
 
 horizontal planes
 d6 = floor
 d5 = ankle, at skinniest part
 d6 = calf, at widest part
 d3 = knee, where that bone bulges on the inside
 d2 = thigh, at the top by the crotch
 d2a = "midthigh", 3 inch below thigh (nice control point for inner leg curve)
 d1= "butt", widest part
 
 last plane, hip, is tilted forward, and butt-to-hip vertical measurements are taken for F, S, & B.
 
 need to split up everything from thigh down into two legs
 */

float backgroundThreshold = 1300;
float ankle = 438;
float calf = 364;
float knee = 300;
float thigh = 170;
float midthigh = 208;
float butt = 134;
float hip = 90;
bool showKinect = false;
bool saveFrame = false;
ofVec3f orientation;
ofxUIRadio* selectPlane;


const float FovX = 1.0144686707507438;
const float FovY = 0.78980943449644714;
const float XtoZ = tanf(FovX / 2) * 2;
const float YtoZ = tanf(FovY / 2) * 2;
const unsigned int Xres = 640;
const unsigned int Yres = 480;

ofVec3f ofApp::ConvertProjectiveToRealWorld(float x, float y, float z) {
	return ofVec3f((x / Xres - .5f) * z * XtoZ,
								 (y / Yres - .5f) * z * YtoZ,
								 z);
}

void ofApp::setup() {
	colorFront.loadImage("color-front.png");
	depthFront.loadImage("depth-front.png");
	maskFront.loadImage("mask-front.png");
	maskFront.setImageType(OF_IMAGE_GRAYSCALE);
	imitate(depthMaskFront, maskFront, CV_8UC1);
	
	colorSide.loadImage("color-front.png");
	depthSide.loadImage("depth-front.png");
	maskSide.loadImage("mask-front.png");
	maskSide.setImageType(OF_IMAGE_GRAYSCALE);
	imitate(depthMaskSide, maskSide, CV_8UC1);
	
	setupGui();
}

void ofApp::analyze() {
	// update background
	int w = mask.getWidth(), h = mask.getHeight(), n = w * h;
	unsigned char* depthMaskPixels = depthMask.getPixels();
	unsigned char* maskPixels = mask.getPixels();
	unsigned short* depthPixels = depth.getPixels();
	unsigned short threshold = backgroundThreshold;
	for(int i = 0; i < n; i++) {
		depthMaskPixels[i] = depthPixels[i] > threshold ? 0 : 255;
	}
	depthMask.update();
	
	// find the points with the farthest distance, but not background
	
	vector<string> names;
	vector<float> samples;
	samples.push_back(ankle); names.push_back("ankle");
	samples.push_back(calf); names.push_back("calf");
	samples.push_back(knee); names.push_back("knee");
	samples.push_back(midthigh); names.push_back("midthigh");
	samples.push_back(thigh); names.push_back("thigh");
	samples.push_back(butt); names.push_back("butt");
	samples.push_back(hip); names.push_back("hip");
	for(int i = 0; i < samples.size(); i++) {
		unsigned short farthest = 0;
		int y = samples[i];
		int left = 0, right = 0;
		for(int x = 0; x < w; x++) {
			int j = y * w + x;
			if(depthMaskPixels[j] && maskPixels[j]) {
				unsigned short cur = depthPixels[j];
				if(cur > farthest) {
					farthest = cur;
				}
				if(left == 0) {
					left = x;
				}
				right = x;
			}
		}
		ofVec3f leftPoint(ConvertProjectiveToRealWorld(left, y, farthest));
		ofVec3f rightPoint(ConvertProjectiveToRealWorld(right, y, farthest));
		cout << names[i] << ": " << leftPoint << " "  << (leftPoint.distance(rightPoint)) << "mm" << endl;
	}
}

void ofApp::setupGui() {
	showKinect = true;
	
	gui = new ofxUICanvas();
	gui->addLabel("Measure");
	gui->addSpacer();
	gui->addFPS();
	gui->addSpacer();
	gui->addSlider("Background threshold", 0, 5000, &backgroundThreshold);
	gui->addSlider("Ankle", 0, 640, &ankle);
	gui->addSlider("Calf", 0, 640, &calf);
	gui->addSlider("Knee", 0, 640, &knee);
	gui->addSlider("Midthigh", 0, 640, &midthigh);
	gui->addSlider("Thigh", 0, 640, &thigh);
	gui->addSlider("Butt", 0, 640, &butt);
	gui->addSlider("Hip", 0, 640, &hip);
	gui->autoSizeToFitWidgets();
}

void ofApp::update() {
	analyze();
}

void ofApp::draw() {
	ofBackground(0);
	ofSetColor(255);
	mask.draw(0, 0);
	
	ofPushStyle();
	ofEnableBlendMode(OF_BLENDMODE_ADD);
	ofSetColor(64, 0, 0);
	depthMask.draw(0, 0);
	ofPopStyle();
	
	color.draw(640, 0);
	
	vector<string> names;
	vector<float> samples;
	samples.push_back(ankle); names.push_back("ankle");
	samples.push_back(calf); names.push_back("calf");
	samples.push_back(knee); names.push_back("knee");
	samples.push_back(midthigh); names.push_back("midthigh");
	samples.push_back(thigh); names.push_back("thigh");
	samples.push_back(butt); names.push_back("butt");
	samples.push_back(hip); names.push_back("hip");
	for(int i = 0; i < samples.size(); i++) {
		float y = samples[i];
		ofLine(0, y, ofGetWidth(), y);
		ofDrawBitmapString(names[i], ofGetWidth() - 100, y);
	}
}

void ofApp::keyPressed(int key) {
	switch(key) {
		case '1':
			ankle = mouseY;
			break;
		case '2':
			calf = mouseY;
			break;
		case '3':
			knee = mouseY;
			break;
		case '4':
			thigh = mouseY;
			break;
		case '5':
			midthigh = mouseY;
			break;
		case '6':
			butt = mouseY;
			break;
		case '7':
			hip = mouseY;
			break;
	}
}