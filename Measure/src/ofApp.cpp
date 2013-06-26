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
 
 */

float backgroundThreshold = 1300;
float ankle = 438;
float calf = 360;
float knee = 300;
float thigh = 170;
float midthigh = 208;
float butt = 134;
float hip = 90;
float center = 261;
float hipSide = 56;
float ankleSide = 420;
bool showKinect = false;
bool saveFrame = false;
ofVec3f orientation;
ofxUIRadio* selectPlane;

float millimetersToInches(float millimeters) {
	return millimeters * 0.0393701;
}

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
	MiniFont::setup();
	
	colorFront.loadImage("color-front.png");
	depthFront.loadImage("depth-front.png");
	maskFront.loadImage("mask-front.png");
	maskFront.setImageType(OF_IMAGE_GRAYSCALE);
	
	colorSide.loadImage("color-side.png");
	depthSide.loadImage("depth-side.png");
	maskSide.loadImage("mask-side.png");
	maskSide.setImageType(OF_IMAGE_GRAYSCALE);
	
	setupGui();
}

float ofApp::measureSegment(int y, ofShortImage& depth, ofImage& mask,
														int leftBoundary, int rightBoundary) {
	unsigned short farthest = 0;
	int xmin = 0, xmax = 0;
	int w = depth.getWidth(), h = depth.getHeight();
	unsigned short* depthPixels = depth.getPixels();
	unsigned char* maskPixels = mask.getPixels();
	for(int x = leftBoundary; x < rightBoundary; x++) {
		int j = y * w + x;
		if(maskPixels[j]) {
			unsigned short cur = depthPixels[j];
			if(cur > farthest) {
				farthest = cur;
			}
			if(xmin == 0) {
				xmin = x;
			}
			xmax = x;
		}
	}
	ofVec3f leftPoint(ConvertProjectiveToRealWorld(xmin, y, farthest));
	ofVec3f rightPoint(ConvertProjectiveToRealWorld(xmax, y, farthest));
	return leftPoint.distance(rightPoint);
}

void ofApp::analyze() {
	// update maskusing depth
	int w = maskFront.getWidth(), h = maskFront.getHeight(), n = w * h;
	unsigned char* maskFrontPixels = maskFront.getPixels();
	unsigned char* maskSidePixels = maskSide.getPixels();
	unsigned short* depthFrontPixels = depthFront.getPixels();
	unsigned short* depthSidePixels = depthSide.getPixels();
	unsigned short threshold = backgroundThreshold;
	for(int i = 0; i < n; i++) {
		if(depthFrontPixels[i] > threshold) {
			maskFrontPixels[i] = 0;
		}
		if(depthSidePixels[i] > threshold) {
			maskSidePixels[i] = 0;
		}
	}
	
	vector<string> names;
	vector<float> samples;
	samples.push_back(ankle); names.push_back("ankle");
	samples.push_back(calf); names.push_back("calf");
	samples.push_back(knee); names.push_back("knee");
	samples.push_back(midthigh); names.push_back("midthigh");
	samples.push_back(thigh); names.push_back("thigh");
	samples.push_back(butt); names.push_back("butt");
	samples.push_back(hip); names.push_back("hip");
	 
	bool torso[] = {
		false, false, false, false, false, true, true
	};
	
	// these are magic numbers that correspond to the shape of the given region.
	// some parts of the leg / torso are more elliptical, others are more rectangular,
	// and the perimeter between an ellipse and rectangle are very different,
	// so we calculate both and pick an inbetween value.
	float rectangularity[] = {
		0, .33, .25, .4, .35, .68, .3
	};
	for(int i = 0; i < samples.size(); i++) {
		ofVec3f left, right;
		int y = samples[i];
		float front;
		if(torso[i]) {
			front = measureSegment(y, depthFront, maskFront, 0, 640);
		} else {
			front = measureSegment(y, depthFront, maskFront, 0, center);
			front += measureSegment(y, depthFront, maskFront, center, 640);
			front /= 2;
		}
		
		y = ofMap(y, ankle, hip, ankleSide, hipSide);
		float side = measureSegment(y, depthSide, maskSide, 0, 640);
		
		float perimeterEllipse = perimeterOfEllipse(front / 2, side / 2);
		float perimeterRectangle = 2 * (front + side);
		float circumference = ofLerp(perimeterEllipse, perimeterRectangle, rectangularity[i]);
		//cout << names[i] << ": " << front << "mm x " << side << "mm = " << circumference << "mm" << endl;
		cout << names[i] << ": " << millimetersToInches(front) << "in x " << millimetersToInches(side) << "in = " << millimetersToInches(circumference) << "in" << endl;
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
	gui->addSlider("Center", 0, 640, &center);
	gui->addSlider("Hip (side)", 0, 640, &hipSide);
	gui->addSlider("Ankle (side)", 0, 640, &ankleSide);
	gui->autoSizeToFitWidgets();
}

void ofApp::update() {
	analyze();
}

void ofApp::draw() {
	ofBackground(0);
	ofSetColor(255);
	maskFront.draw(0, 0);	
	colorFront.draw(640, 0);
	
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
		MiniFont::drawHighlight(names[i], 640, y);
	}
	ofLine(center, 0, center, 480);
	
	ofPushMatrix();
	ofTranslate(0, 480);
	ofSetColor(255);
	maskSide.draw(0, 0);
	colorSide.draw(640, 0);

	for(int i = 0; i < samples.size(); i++) {
		float y = samples[i];
		y = ofMap(y, ankle, hip, ankleSide, hipSide);
		ofLine(0, y, ofGetWidth(), y);
		MiniFont::drawHighlight(names[i], 640, y);
	}
	ofPopMatrix();
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