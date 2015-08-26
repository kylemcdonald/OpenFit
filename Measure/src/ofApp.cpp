#include "ofApp.h"
#include "Geometry.h"

/*
 show floor points without depth data as magenta
 
 the center of the side view should be taken as the depth for the front, and
 the center of the front view should be taken as the depth for the side.
 
 - should visualize fg/bg
 - run a contour finder on the masks, use bounding box to set ankles and hips,
 use centroid instead of calculating it manually
 */

bool exportData = false,
sampleSide = false,
sampleFront = false,
useKinect = false;

float
hueCenter = 54,
hueRange = 24,
svPadding = 10,
backgroundErode = 8,
foregroundDilate = 2,
foregroundErode = 8,
pyramidLevels = 3,
spatialRadius = 10,
colorRadius = 25,
colorAlpha = 128,
backgroundThreshold = 1300,
hipSide = 56,
ankleSide = 420,
ankleFront = 438,
hipFront = 90,
calf = .25, //.24
knee = .40, // .39
midthigh = .67, // .67
thigh = .75, // .75
butt = .90, // .90
hipSlope = .32; // .32

ofVec2f centroid;

ofVec3f orientation;
ofxUIRadio* selectPlane;

ofVec3f floor1(569, 406),
floor2(576, 444),
floor3(112, 416);

float millimetersToInches(float millimeters) {
	return millimeters * 0.0393701;
}

// depth
// const float FovX = 1.0144686707507438; // 58.12
// const float FovY = 0.78980943449644714; // 45.25
// color, http://msdn.microsoft.com/en-us/library/hh855368
const float FovX = 1.08210413624; // 62.0
const float FovY = 0.84823001646; // 48.6
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

ofVec3f ofApp::sampleDepth(ofShortImage& depth, ofVec2f position, int radius) {
	int w = depth.getWidth(), h = depth.getHeight();
	int x = position.x, y = position.y;
	ofVec3f result;
	for(int j = -radius; j <= +radius; j++) {
		for(int i = -radius; i <= +radius; i++) {
			int cx = x + i, cy = y + j;
			result += ConvertProjectiveToRealWorld(x, y, depth.getPixels()[w * cy + cx]);
		}
	}
	int side = radius * 2 + 1;
	return result / (side * side);
}

void ofApp::setup() {
	MiniFont::setup();
	
    colorFront.loadImage("0-color.png");
    depthFront.loadImage("0-depth.png");
    colorSide.loadImage("1-color.png");
    depthSide.loadImage("1-depth.png");
    updateMeanShift();
	
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
		if(slope != 0 && foundLeft) {
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

cv::Mat depthMask, fg, bg, markers8u, hsvBuffer;
void ofApp::buildMask(ofImage& mask, Mat& img, ofShortImage& depth) {
	cvtColor(img, hsvBuffer, CV_RGB2HSV);
	Scalar lowerb(hueCenter - hueRange, svPadding, svPadding);
	Scalar upperb(hueCenter + hueRange, 255 - svPadding, 255 - svPadding);
	inRange(hsvBuffer, lowerb, upperb, fg);
	
	Mat depthMat = toCv(depth);
	// you can remove the & (depthMat > 0) if you want to use color info from no-depth areas 
	depthMask = (depthMat < backgroundThreshold) & (depthMat > 0);
	fg = fg & depthMask;
	bg = ~fg;
	erode(bg, (int) backgroundErode);
	dilate(fg, (int) foregroundDilate);
	erode(fg, (int) foregroundErode);
	
	Mat markers = Mat::zeros(depth.getHeight(), depth.getWidth(), CV_32SC1);
	markers.setTo(1, bg);
	markers.setTo(2, fg);
	watershed(img, markers);
	
	imitate(mask, depth, CV_8UC1);
	Mat maskMat = toCv(mask);
	markers.convertTo(maskMat, CV_8UC1, 255, -255);
}

Mat meanShiftFront, meanShiftSide;
void ofApp::updateMeanShift() {
	Mat colorFrontMat = toCv(colorFront);
	pyrMeanShiftFiltering(colorFrontMat, meanShiftFront, spatialRadius, colorRadius, pyramidLevels);
	Mat colorSideMat = toCv(colorSide);
	pyrMeanShiftFiltering(colorSideMat, meanShiftSide, spatialRadius, colorRadius, pyramidLevels);
}
	
void ofApp::analyze() {
	buildMask(maskFront, meanShiftFront, depthFront);
	maskFront.update();
	buildMask(maskSide, meanShiftSide, depthSide);
	maskSide.update();
	
	centroid = ofVec2f();
	int centroidCount = 0;
	int w = maskFront.getWidth(), h = maskFront.getHeight();
	unsigned char* maskFrontPixels = maskFront.getPixels();
	for(int y = 0; y < h; y++) {
		for(int x = 0; x < w; x++) {
			int i = y * w + x;
			if(maskFrontPixels[i]) {
				centroid += ofVec2f(x, y);
				centroidCount++;
			}
		}
	}
	centroid /= centroidCount;
	
	ofVec3f f1 = sampleDepth(depthFront, floor1, 2);
	ofVec3f f2 = sampleDepth(depthFront, floor2, 2);
	ofVec3f f3 = sampleDepth(depthFront, floor3, 2);
	ofVec3f floorNormal = getNormal(f1, f2, f3);
	
	vector<string> names;
	vector<float> samples;
	samples.push_back(ankleFront); names.push_back("ankle");
	samples.push_back(ofLerp(ankleFront, hipFront, calf)); names.push_back("calf");
	samples.push_back(ofLerp(ankleFront, hipFront, knee)); names.push_back("knee");
	samples.push_back(ofLerp(ankleFront, hipFront, midthigh)); names.push_back("midthigh");
	samples.push_back(ofLerp(ankleFront, hipFront, thigh)); names.push_back("thigh");
	samples.push_back(ofLerp(ankleFront, hipFront, butt)); names.push_back("butt");
	samples.push_back(hipFront); names.push_back("hip");
	
	bool torso[] = {
		false, false, false, false, false, true, true
	};
	
	// these are magic numbers that correspond to the shape of the given region.
	// some parts of the leg / torso are more elliptical, others are more rectangular,
	// and the perimeter between an ellipse and rectangle are very different,
	// so we calculate both and pick an inbetween value.
	float rectangularity[] = {.27, .24, .33, .15, .10, .25, .20};
	frontEdges.clear();
	sideEdges.clear();
	heights.clear();
	circumferences.clear();
	depths.clear();
	for(int i = 0; i < samples.size(); i++) {
		int y = samples[i];
		ofVec3f leftPoint, rightPoint;
		ofVec3f leftEdge, rightEdge;
		float height = 0;
		int heightCount = 0;
		float front = 0;
		if(torso[i]) {
			front = measureSegment(y, depthFront, maskFront, 0, 640, leftEdge, rightEdge, leftPoint, rightPoint);
			frontEdges.push_back(pair<ofVec2f, ofVec2f>(leftEdge, rightEdge));
			height += leftPoint.distance(closestPointOnPlane(f1, floorNormal, leftPoint));
			height += rightPoint.distance(closestPointOnPlane(f1, floorNormal, rightPoint));
			heightCount += 2;
		} else {
			front = measureSegment(y, depthFront, maskFront, 0, centroid.x, leftEdge, rightEdge, leftPoint, rightPoint);
			frontEdges.push_back(pair<ofVec2f, ofVec2f>(leftEdge, rightEdge));
			height += leftPoint.distance(closestPointOnPlane(f1, floorNormal, leftPoint));
			height += rightPoint.distance(closestPointOnPlane(f1, floorNormal, rightPoint));
			front += measureSegment(y, depthFront, maskFront, centroid.x, 640, leftEdge, rightEdge, leftPoint, rightPoint);
			frontEdges.push_back(pair<ofVec2f, ofVec2f>(leftEdge, rightEdge));
			height += leftPoint.distance(closestPointOnPlane(f1, floorNormal, leftPoint));
			height += rightPoint.distance(closestPointOnPlane(f1, floorNormal, rightPoint));
			heightCount += 4;
			front /= 2;
		}
		
		y = ofMap(y, ankleFront, hipFront, ankleSide, hipSide);
		float slope = 0;
		if(names[i] == "hip") {
			slope = hipSlope;
		}
		float side = measureSegment(y, depthSide, maskSide, 0, 640, leftEdge, rightEdge, leftPoint, rightPoint, slope);
		sideEdges.push_back(pair<ofVec2f, ofVec2f>(leftEdge, rightEdge));
		depths.push_back(leftPoint.z);
		
		height += leftPoint.distance(closestPointOnPlane(f1, floorNormal, leftPoint));
		height += rightPoint.distance(closestPointOnPlane(f1, floorNormal, rightPoint));
		heightCount += 2;
		heights.push_back(height / heightCount);
		
		float perimeterEllipse = perimeterOfEllipse(front / 2, side / 2);
		float perimeterRectangle = 2 * (front + side);
		float circumference = ofLerp(perimeterEllipse, perimeterRectangle, rectangularity[i]);
		circumferences.push_back(circumference);
	}
	
	crotch.clear();

    crotch.curveTo(sideEdges[6].first);
	crotch.curveTo(sideEdges[6].first);
	crotch.curveTo(sideEdges[5].first);
	ofVec2f thighMidpoint = (sideEdges[4].first + sideEdges[4].second) / 2;
	crotch.curveTo(thighMidpoint);
	crotch.curveTo(sideEdges[5].second);
	crotch.curveTo(sideEdges[6].second);
	crotch.curveTo(sideEdges[6].second);
	
	float crotchDepth = 0;
	// should use points instead of depths
	for(int i = 0; i < depths.size(); i++) {
		if(i == 0 || depths[i] > crotchDepth) {
			crotchDepth = depths[i];
		}
	}
	crotchLength = ConvertProjectiveToRealWorld(crotch, crotchDepth).getPerimeter();
}

void ofApp::setupGui() {
	gui = new ofxUICanvas();
	gui->setTheme(OFX_UI_THEME_MINBLACK);
	gui->addLabel("Measure");
	gui->addSpacer();
	gui->addFPS();
	gui->addSpacer();
	gui->addLabelToggle("Export", &exportData);
	gui->addLabelToggle("Use Kinect", &useKinect);
	gui->addButton("Sample front", &sampleFront);
	gui->addButton("Sample side", &sampleSide);
	gui->addMinimalSlider("Background threshold", 0, 5000, &backgroundThreshold);
	gui->addMinimalSlider("Hip (front)", 0, 640, &hipFront);
	gui->addMinimalSlider("Hip (side)", 0, 640, &hipSide);
	gui->addMinimalSlider("Ankle (front)", 0, 640, &ankleFront);
	gui->addMinimalSlider("Ankle (side)", 0, 640, &ankleSide);
	gui->addMinimalSlider("Hip slope", -1, 1, &hipSlope);
	gui->addSpacer();
	gui->addMinimalSlider("Calf", 0, 1, &calf);
	gui->addMinimalSlider("Knee", 0, 1, &knee);
	gui->addMinimalSlider("Midthigh", 0, 1, &midthigh);
	gui->addMinimalSlider("Thigh", 0, 1, &thigh);
	gui->addMinimalSlider("Butt", 0, 1, &butt);
	gui->addMinimalSlider("Color alpha", 0, 255, &colorAlpha);
	gui->addMinimalSlider("Hue center", 0, 255, &hueCenter);
	gui->addMinimalSlider("Hue range", 0, 255, &hueRange);
	gui->addMinimalSlider("Saturation/Value padding", 0, 255, &svPadding);
	gui->addMinimalSlider("Background erode", 1, 16, &backgroundErode);
	gui->addMinimalSlider("Foreground dilate", 1, 8, &foregroundDilate);
	gui->addMinimalSlider("Foreground erode", 1, 16, &foregroundErode);
	//gui->addMinimalSlider("Pyramid levels", 0, 6, &pyramidLevels);
	//gui->addMinimalSlider("Spatial radius", 1, 64, &spatialRadius);
	//gui->addMinimalSlider("Color radius", 1, 128, &colorRadius);
	
	gui->add2DPad("Floor.1", ofVec2f(0, 640), ofVec2f(0, 480), &floor1, 100, 75);
	gui->add2DPad("Floor.2", ofVec2f(0, 640), ofVec2f(0, 480), &floor2, 100, 75);
	gui->add2DPad("Floor.3", ofVec2f(0, 640), ofVec2f(0, 480), &floor3, 100, 75);
	
	gui->autoSizeToFitWidgets();
}

void ofApp::update() {
	if(useKinect && !kinect.isConnected()) {
		kinect.setRegistration(true);
		kinect.init();
		kinect.open();
	}
	kinect.update();
	if(kinect.isFrameNew()) {
		if(sampleFront) {
			copy(kinect.getPixelsRef(), colorFront);
			copy(kinect.getRawDepthPixelsRef(), depthFront);
			colorFront.update();
			sampleFront = false;
			updateMeanShift();
		} else if(sampleSide) {
			copy(kinect.getPixelsRef(), colorSide);
			copy(kinect.getRawDepthPixelsRef(), depthSide);
			colorSide.update();
			sampleSide = false;
			updateMeanShift();
		}
	}
	analyze();
	if(exportData) {
		ofFileDialogResult result = ofSystemSaveDialog("New Folder", "Enter output directory.");
		string dir = result.getPath() + "/";
		colorFront.saveImage(dir + "color-front.png");
		colorSide.saveImage(dir + "color-side.png");
		depthFront.saveImage(dir + "depth-front.png");
		depthSide.saveImage(dir + "depth-side.png");
		ofFile file(dir + "measurements.json", ofFile::WriteOnly);
		file << "{" << endl;
		file << "\t\"ankle\" : " << millimetersToInches(circumferences[0]) << "," << endl;
		file << "\t\"calf\" : " << millimetersToInches(circumferences[1]) << "," << endl;
		file << "\t\"knee\" : " << millimetersToInches(circumferences[2]) << "," << endl;
		file << "\t\"midthigh\" : " << millimetersToInches(circumferences[3]) << "," << endl;
		file << "\t\"thigh\" : " << millimetersToInches(circumferences[4]) << "," << endl;
		file << "\t\"butt\" : " << millimetersToInches(circumferences[5]) << "," << endl;
		file << "\t\"hip\" : " << millimetersToInches(circumferences[6]) << "," << endl;
		file << "\t\"crotchLength\" : " << millimetersToInches(crotchLength) << "," << endl;
		file << "\t\"hipSlope\" : " << hipSlope << "," << endl;
		file << "\t\"ankleToFloor\" : " << millimetersToInches(heights[0]) << "," << endl;
		file << "\t\"calfToFloor\" : " << millimetersToInches(heights[1]) << "," << endl;
		file << "\t\"kneeToFloor\" : " << millimetersToInches(heights[2]) << "," << endl;
		file << "\t\"midthighToFloor\" : " << millimetersToInches(heights[3]) << "," << endl;
		file << "\t\"thighToFloor\" : " << millimetersToInches(heights[4]) << "," << endl;
		file << "\t\"buttToFloor\" : " << millimetersToInches(heights[5]) << "," << endl;
		file << "\t\"hipToFloor\" : " << millimetersToInches(heights[6]) << endl;
		file << "}" << endl;
		exportData = false;
	}
}

void ofApp::draw() {
	ofBackground(0);
	
	ofSetColor(255);
	if(useKinect) {
		kinect.draw(0, 0);
		kinect.drawDepth(0, 480);
	}
	
	ofPushMatrix();
	ofTranslate(640, 0);
	
	maskFront.draw(0, 0);	
	ofPushStyle();
	ofSetColor(255, colorAlpha);
	colorFront.draw(0, 0);
	ofPopStyle();
	
	vector<string> names;
	vector<float> samples;
	samples.push_back(ankleFront); names.push_back("ankle");
	samples.push_back(ofLerp(ankleFront, hipFront, calf)); names.push_back("calf");
	samples.push_back(ofLerp(ankleFront, hipFront, knee)); names.push_back("knee");
	samples.push_back(ofLerp(ankleFront, hipFront, midthigh)); names.push_back("midthigh");
	samples.push_back(ofLerp(ankleFront, hipFront, thigh)); names.push_back("thigh");
	samples.push_back(ofLerp(ankleFront, hipFront, butt)); names.push_back("butt");
	samples.push_back(hipFront); names.push_back("hip");
	for(int i = 0; i < samples.size(); i++) {
		int y = samples[i];
		ofLine(0, y, 640, y);
		MiniFont::drawHighlight(names[i], 540, y);
	}
	ofLine(centroid.x, 0, centroid.x, 480);
	MiniFont::drawHighlight("centroid", centroid.x, 0);
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
		y = ofMap(y, ankleFront, hipFront, ankleSide, hipSide);
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
	
	ofSetColor(magentaPrint);
	crotch.draw();
	ofVec2f crotchLabelPosition = (sideEdges[4].first + sideEdges[4].second + sideEdges[5].first + sideEdges[5].second) / 4;
	MiniFont::drawHighlight("crotch " + ofToString(millimetersToInches(crotchLength)), crotchLabelPosition);
	
	ofPopMatrix();
	ofPopMatrix();
}

void ofApp::keyPressed(int key) {
	if(key == 'f') {
		ofToggleFullscreen();
	}
	if(key == 's') {
		gui->saveSettings("settings.xml");
	}
	if(key == 'l') {
		gui->loadSettings("settings.xml");
	}
	if(key == '1') {
		floor1.set(mouseX, mouseY);
	}
	if(key == '2') {
		floor2.set(mouseX, mouseY);
	}
	if(key == '3') {
		floor3.set(mouseX, mouseY);
	}
}