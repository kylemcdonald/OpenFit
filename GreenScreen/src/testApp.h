#pragma once

#include "ofMain.h"
#include "ofxCv.h"
#include "ofxUI.h"

class testApp : public ofBaseApp {
public:
	void setup();
	void setupGui();
	void update();
	void draw();
	
	ofxUICanvas* gui;
};
