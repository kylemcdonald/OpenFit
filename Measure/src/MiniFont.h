#pragma once

#include "ofMain.h"

namespace MiniFont {
	void updateProjectionState();
	ofVec3f ofWorldToScreen(ofVec3f world);
	void setup();
	void draw(string str, float x, float y);
	void drawHighlight(string str, float x, float y, ofColor bg = ofColor(0), ofColor fg = ofColor(255));
	void drawScreen(string str, ofVec3f position);
}