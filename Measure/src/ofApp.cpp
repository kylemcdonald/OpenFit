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

float range = 1000;
float nearRange = 1000;
float farRange = 5000;
float globalScale = 1;
float floorOffset = -540;
float ankle = 0;
float calf = 0;
float knee = 0;
float thigh = 0;
float midthigh = 0;
float butt = 0;
bool showKinect = false;
bool saveFrame = false;
ofVec3f orientation;
ofxUIRadio* selectPlane;

int savedFrames = 0;

void ofApp::setup() {
	kinect.setRegistration(true);
	kinect.init();
	kinect.open();
	setupGui();
}

void ofApp::setupGui() {
	showKinect = true;
	
	gui = new ofxUICanvas();
	gui->addLabel("Measure");
	gui->addSpacer();
	gui->addFPS();
	gui->addSpacer();
	gui->addSlider("Near range", 0, 5000, &nearRange);
	gui->addSlider("Far range", 0, 5000, &farRange);
	gui->addSlider("Scale", 0, 2, &globalScale);
	gui->addSlider("Floor", -10000, 10000, &floorOffset);
	
	vector<string> planes;
	planes.push_back("Ankle");
	planes.push_back("Calf");
	planes.push_back("Knee");
	planes.push_back("Thigh");
	planes.push_back("Midthigh");
	planes.push_back("Butt");
	gui->addRadio("Select plane", planes);
	
	gui->addLabelToggle("Show Kinect", &showKinect);
	gui->addLabelButton("Save Frame", &saveFrame);
	gui->autoSizeToFitWidgets();
}

void ofApp::update() {
	kinect.update();
	if(kinect.isFrameNew()) {
		if(ofGetFrameNum() > 10 && ofGetFrameNum() < 240) {
			accelerationSum += kinect.getRawAccel();
			accelerationCount++;
			upVector = -accelerationSum / accelerationCount;
			upVector.y *= -1;
			ofQuaternion orientationQuat;
			upVector.normalize();
			orientationQuat.makeRotate(ofVec3f(0, -1, 0), upVector);
			orientationQuat.get(orientationMat);
		}
		mesh.clear();
		mesh.setMode(OF_PRIMITIVE_POINTS);
		for(int y = 0; y < 480; y++) {
			for(int x = 0; x < 640; x++) {
				float distance = kinect.getDistanceAt(x, y);
				if(distance > nearRange && distance < farRange) {
					ofVec3f cur = orientationMat * kinect.getWorldCoordinateAt(x, y);
					mesh.addVertex(cur);
				}
			}
		}
		if(saveFrame) {
			string frame = ofToString(savedFrames++);
			ofSaveImage(kinect.getRawDepthPixelsRef(), frame + "-depth.png");
			ofSaveImage(kinect.getPixelsRef(), frame + "-color.png");
		}
	}
}

void ofApp::draw() {
	ofBackground(0);
	ofSetColor(255);
	if(showKinect) {
		kinect.draw(0, 0);
		kinect.drawDepth(640, 0);
	}
	cam.begin();
	ofScale(globalScale, globalScale, globalScale);
	ofDrawGrid(2000, 20, false, false, true, false);
	ofTranslate(0, 0, (nearRange + farRange) / 2);
	ofPushMatrix();
	ofTranslate(0, -floorOffset, 0);
	mesh.draw();
	ofPopMatrix();
	// draw all planes
	cam.end();
}


int getSelection(ofxUIRadio* radio) {
	vector<ofxUIToggle*> toggles = radio->getToggles();
	for(int i = 0; i < toggles.size(); i++) {
		if(toggles[i]->getValue()) {
			return i;
		}
	}
	return -1;
}

void ofApp::keyPressed(int key) {
	/*
	int i = getSelection(selectPlane);
	if(i > -1) {
		selectPlane->getToggles()[i]->setValue(false);
	}
	 */
}