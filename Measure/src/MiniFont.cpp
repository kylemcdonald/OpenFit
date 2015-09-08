#include "MiniFont.h"

namespace MiniFont {
	ofTrueTypeFont font;
	
	GLdouble modelviewMatrix[16], projectionMatrix[16];
	GLint viewport[4];
	void updateProjectionState() {
		glGetDoublev(GL_MODELVIEW_MATRIX, modelviewMatrix);
		glGetDoublev(GL_PROJECTION_MATRIX, projectionMatrix);
		glGetIntegerv(GL_VIEWPORT, viewport);
	}
	
	ofVec3f ofWorldToScreen(ofVec3f world) {
		GLdouble x, y, z;
		gluProject(world.x, world.y, world.z, modelviewMatrix, projectionMatrix, viewport, &x, &y, &z);
		ofVec3f screen(x, y, z);
		screen.y = ofGetHeight() - screen.y;
		return screen;
	}
	
	void setup() {
        font.loadFont(OF_TTF_MONO, 8, true, false, true, .1);
	}
	
	void draw(string str, float x, float y) {
		font.drawStringAsShapes(str, x, y);
	}
	
	void drawHighlight(string str, const ofVec2f& position, ofColor bg, ofColor fg) {
		drawHighlight(str, position.x, position.y, bg, fg);
	}
	
	void drawHighlight(string str, float x, float y, ofColor bg, ofColor fg) {
		ofPushStyle();
		ofPushMatrix();
		ofSetColor(bg);
		ofRectangle rect = font.getStringBoundingBox(str, x, y);
		int padding = 2;
		rect.x -= padding, rect.y -= padding;
		rect.width += padding * 2, rect.height += padding * 2;
		ofTranslate(ofVec2f(x, y) - rect.getTopLeft());
		ofFill();
		ofRect(rect);
		ofSetColor(fg);
		font.drawStringAsShapes(str, x, y);
		ofPopMatrix();
		ofPopStyle();
	}
}