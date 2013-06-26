#include "ofApp.h"
#include "Geometry.h"

bool saveToJson = false;
bool useCurvedCrotch = false;
float colorAlpha = 128;
float backgroundThreshold = 1300;
float ankle = 438;
float calf = 360;
float knee = 290;
float thigh = 170;
float midthigh = 208;
float butt = 134;
float hip = 90;
float hipSlope = .32;
float center = 261;
float hipSide = 56;
float ankleSide = 420;
ofVec3f orientation;
ofxUIRadio* selectPlane;

ofVec3f floor1(576, 444),
floor2(585, 473),
floor3(16, 464);

float millimetersToInches(float millimeters) {
	return millimeters * 0.0393701;
}

const float FovX = 1.0144686707507438;
const float FovY = 0.78980943449644714;
const float XtoZ = tanf(FovX / 2) * 2;
const float YtoZ = tanf(FovY / 2) * 2;
const unsigned int Xres = 640;
const unsigned int Yres = 480;

ofVec3f ofApp::ConvertProjectiveToRealWorld(const ofVec3f& point) {
	return ConvertProjectiveToRealWorld(point.x, point.y, point.z);
}
	
ofVec3f ofApp::ConvertProjectiveToRealWorld(float x, float y, float z) {
	return ofVec3f((x / Xres - .5f) * z * XtoZ,
								 (y / Yres - .5f) * z * YtoZ,
								 z);
}

ofPolyline ofApp::ConvertProjectiveToRealWorld(const ofPolyline& polyline, float z) {
	ofPolyline result;
	for(int i = 0; i < polyline.size(); i++) {
		result.addVertex(ConvertProjectiveToRealWorld(polyline[i].x, polyline[i].y, z));
	}
	return result;
}

ofVec3f ofApp::sampleDepth(ofShortImage& depth, ofVec2f position) {
	int w = depth.getWidth(), h = depth.getHeight();
	int x = position.x, y = position.y;
	return ConvertProjectiveToRealWorld(x, y, depth.getPixels()[w * y + x]);
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
														int leftBoundary, int rightBoundary,
														ofVec3f& leftEdge, ofVec3f& rightEdge,
														ofVec3f& leftPoint, ofVec3f& rightPoint,
														float slope) {
	unsigned short farthest = 0;
	leftEdge = ofVec3f(), rightEdge = ofVec3f();
	bool foundLeft = false;
	int w = depth.getWidth(), h = depth.getHeight();
	unsigned short* depthPixels = depth.getPixels();
	unsigned char* maskPixels = mask.getPixels();
	for(int x = leftBoundary; x < rightBoundary; x++) {
		int j;
		int cury = y;
		if(foundLeft) {
			cury = y + (x - leftEdge.x) * -slope;
		}
		if(cury < 0 || cury >= h) {
			break;
		}
		j = cury * w + x;
		if(maskPixels[j] == 255) {
			unsigned short curDepth = depthPixels[j];
			if(curDepth > farthest) {
				farthest = curDepth;
			}
			if(!foundLeft) {
				leftEdge.set(x, cury);
				foundLeft = true;
			}
			rightEdge.set(x, cury);
		}
	}
	leftEdge.z = farthest;
	rightEdge.z = farthest;
	leftPoint.set(ConvertProjectiveToRealWorld(leftEdge));
	rightPoint.set(ConvertProjectiveToRealWorld(rightEdge));
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
			maskFrontPixels[i] = 128;
		}
		if(depthSidePixels[i] > threshold) {
			maskSidePixels[i] = 128;
		}
	}
	maskFront.update();
	maskSide.update();
	
	ofVec3f f1 = sampleDepth(depthFront, floor1);
	ofVec3f f2 = sampleDepth(depthFront, floor2);
	ofVec3f f3 = sampleDepth(depthFront, floor3);
	ofVec3f floorNormal = getNormal(f1, f2, f3);
	
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
	float rectangularity[] = {0, .33, .25, .4, .35, .68, .3};
	frontEdges.clear();
	sideEdges.clear();
	heights.clear();
	circumferences.clear();
	depths.clear();
	for(int i = 0; i < samples.size(); i++) {
		int y = samples[i];
		ofVec3f leftPoint, rightPoint;
		ofVec3f leftEdge, rightEdge;
		float front;
		if(torso[i]) {
			front = measureSegment(y, depthFront, maskFront, 0, 640, leftEdge, rightEdge, leftPoint, rightPoint);
			frontEdges.push_back(pair<ofVec2f, ofVec2f>(leftEdge, rightEdge));
		} else {
			front = measureSegment(y, depthFront, maskFront, 0, center, leftEdge, rightEdge, leftPoint, rightPoint);
			frontEdges.push_back(pair<ofVec2f, ofVec2f>(leftEdge, rightEdge));
			front += measureSegment(y, depthFront, maskFront, center, 640, leftEdge, rightEdge, leftPoint, rightPoint);
			frontEdges.push_back(pair<ofVec2f, ofVec2f>(leftEdge, rightEdge));
			front /= 2;
		}
		
		ofVec3f projectedToFloor = closestPointOnPlane(f1, floorNormal, leftPoint);
		heights.push_back(leftPoint.distance(projectedToFloor));
		
		y = ofMap(y, ankle, hip, ankleSide, hipSide);
		float slope = 0;
		if(names[i] == "hip") {
			slope = hipSlope;
		}
		float side = measureSegment(y, depthSide, maskSide, 0, 640, leftEdge, rightEdge, leftPoint, rightPoint, slope);
		sideEdges.push_back(pair<ofVec2f, ofVec2f>(leftEdge, rightEdge));
		depths.push_back(leftPoint.z);
		
		float perimeterEllipse = perimeterOfEllipse(front / 2, side / 2);
		float perimeterRectangle = 2 * (front + side);
		float circumference = ofLerp(perimeterEllipse, perimeterRectangle, rectangularity[i]);
		circumferences.push_back(circumference);
		//cout << names[i] << ": " << front << "mm x " << side << "mm = " << circumference << "mm" << endl;
		//cout << names[i] << ": " << millimetersToInches(front) << "in x " << millimetersToInches(side) << "in = " << millimetersToInches(circumference) << "in" << endl;
	}
}

void ofApp::setupGui() {
	gui = new ofxUICanvas();
	gui->addLabel("Measure");
	gui->addSpacer();
	gui->addFPS();
	gui->addSpacer();
	gui->addLabelButton("Save to JSON", &saveToJson);
	gui->addLabelToggle("Curved crotch", &useCurvedCrotch);
	gui->addSlider("Color alpha", 0, 255, &colorAlpha);
	gui->addSlider("Background threshold", 0, 5000, &backgroundThreshold);
	gui->addSlider("Ankle", 0, 640, &ankle);
	gui->addSlider("Calf", 0, 640, &calf);
	gui->addSlider("Knee", 0, 640, &knee);
	gui->addSlider("Midthigh", 0, 640, &midthigh);
	gui->addSlider("Thigh", 0, 640, &thigh);
	gui->addSlider("Butt", 0, 640, &butt);
	gui->addSlider("Hip", 0, 640, &hip);
	gui->addSlider("Hip slope", -1, 1, &hipSlope);
	gui->addSlider("Center", 0, 640, &center);
	gui->addSlider("Hip (side)", 0, 640, &hipSide);
	gui->addSlider("Ankle (side)", 0, 640, &ankleSide);
	gui->add2DPad("Floor.1", ofVec2f(0, 640), ofVec2f(0, 480), &floor1, 200, 150);
	gui->add2DPad("Floor.2", ofVec2f(0, 640), ofVec2f(0, 480), &floor2, 200, 150);
	gui->add2DPad("Floor.3", ofVec2f(0, 640), ofVec2f(0, 480), &floor3, 200, 150);
	gui->autoSizeToFitWidgets();
}

void ofApp::update() {
	analyze();
	if(saveToJson) {
		ofFile file("measurements.json", ofFile::WriteOnly);
		file << "{" << endl;
		file << "\t\"ankle\" : " << millimetersToInches(circumferences[0]) << "," << endl;
		file << "\t\"calf\" : " << millimetersToInches(circumferences[1]) << "," << endl;
		file << "\t\"knee\" : " << millimetersToInches(circumferences[2]) << "," << endl;
		file << "\t\"thigh\" : " << millimetersToInches(circumferences[3]) << "," << endl;
		file << "\t\"midthigh\" : " << millimetersToInches(circumferences[4]) << "," << endl;
		file << "\t\"butt\" : " << millimetersToInches(circumferences[5]) << "," << endl;
		file << "\t\"hip\" : " << millimetersToInches(circumferences[6]) << "," << endl;
		file << "\t\"hipSlope\" : " << hipSlope << "," << endl;
		file << "\t\"ankleToFloor\" : " << millimetersToInches(heights[0]) << "," << endl;
		file << "\t\"calfToFloor\" : " << millimetersToInches(heights[1]) << "," << endl;
		file << "\t\"kneeToFloor\" : " << millimetersToInches(heights[2]) << "," << endl;
		file << "\t\"thighToFloor\" : " << millimetersToInches(heights[3]) << "," << endl;
		file << "\t\"midthighToFloor\" : " << millimetersToInches(heights[4]) << "," << endl;
		file << "\t\"buttToFloor\" : " << millimetersToInches(heights[5]) << "," << endl;
		file << "\t\"hipToFloor\" : " << millimetersToInches(heights[6]) << endl;
		file << "}" << endl;
		saveToJson = false;
	}
}

void ofApp::draw() {
	ofBackground(0);
	
	ofSetColor(255);
	maskFront.draw(0, 0);	
	ofPushStyle();
	ofSetColor(255, colorAlpha);
	colorFront.draw(0, 0);
	ofPopStyle();
	
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
		int y = samples[i];
		ofLine(0, y, 640, y);
		MiniFont::drawHighlight(names[i], 540, y);
	}
	ofLine(center, 0, center, 480);
	for(int i = 0; i < frontEdges.size(); i++) {
		ofSetColor(0);
		ofLine(frontEdges[i].first, frontEdges[i].second);
		ofSetColor(cyanPrint);
		ofNoFill();
		ofCircle(frontEdges[i].first, 3);
		ofCircle(frontEdges[i].second, 3);
	}
	
	ofPushMatrix();
	ofSetColor(255);
	ofCircle(floor1, 4); MiniFont::drawHighlight("floor1", floor1);	
	ofCircle(floor2, 4); MiniFont::drawHighlight("floor2", floor2);
	ofCircle(floor3, 4); MiniFont::drawHighlight("floor3", floor3);
	ofPopMatrix();
	
	ofPushMatrix();
	ofTranslate(0, 480);
	ofSetColor(255);
	maskSide.draw(0, 0);
	ofPushStyle();
	ofSetColor(255, colorAlpha);
	colorSide.draw(0, 0);
	ofPopStyle();
	
	for(int i = 0; i < samples.size(); i++) {
		float y = samples[i];
		y = ofMap(y, ankle, hip, ankleSide, hipSide);
		ofLine(0, y, 640, y);
	}
	for(int i = 0; i < sideEdges.size(); i++) {
		ofSetColor(0);
		ofLine(sideEdges[i].first, sideEdges[i].second);
		ofSetColor(cyanPrint);
		ofNoFill();
		ofCircle(sideEdges[i].first, 3);
		ofCircle(sideEdges[i].second, 3);
		if(i + 1 < sideEdges.size()) {
			ofSetColor(cyanPrint);
			ofLine(sideEdges[i].first, sideEdges[i + 1].first);
			ofLine(sideEdges[i].second, sideEdges[i + 1].second);
		}
		MiniFont::drawHighlight(names[i], sideEdges[i].first);
		MiniFont::drawHighlight("h" + ofToString(millimetersToInches(heights[i])) + " / c" + ofToString(millimetersToInches(circumferences[i])), sideEdges[i].second);
	}
	
	ofPolyline crotch;
	if(useCurvedCrotch) {
		crotch.curveTo(sideEdges[6].first);
		crotch.curveTo(sideEdges[6].first);
		crotch.curveTo(sideEdges[5].first);
		crotch.curveTo(sideEdges[4].second);
		crotch.curveTo(sideEdges[5].second);
		crotch.curveTo(sideEdges[6].second);
		crotch.curveTo(sideEdges[6].second);
	} else {
		crotch.addVertex(sideEdges[6].first);
		crotch.addVertex(sideEdges[5].first);
		crotch.addVertex(sideEdges[4].second);
		crotch.addVertex(sideEdges[5].second);
		crotch.addVertex(sideEdges[6].second);
	}
	ofSetColor(magentaPrint);
	crotch.draw();
	float crotchDepth = 0;
	for(int i = 0; i < depths.size(); i++) {
		if(i == 0 || depths[i] > crotchDepth) {
			crotchDepth = depths[i];
		}
	}
	float crotchLength = ConvertProjectiveToRealWorld(crotch, crotchDepth).getPerimeter();
	MiniFont::drawHighlight("crotch " + ofToString(millimetersToInches(crotchLength)), crotch.getCentroid2D());
	
	ofPopMatrix();
}

void ofApp::keyPressed(int key) {
}