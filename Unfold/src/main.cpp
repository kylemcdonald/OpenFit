#include "ofMain.h"

float getAngleOppositeC(float a, float b, float c) {
    return acos((a * a + b * b - c * c) / (2 * a * b));
}

bool lineIntersection(const ofVec2f& v1, const ofVec2f& v2, const ofVec2f& v3, const ofVec2f& v4) {
    float d = (v4.y-v3.y)*(v2.x-v1.x)-(v4.x-v3.x)*(v2.y-v1.y);
    float u = (v4.x-v3.x)*(v1.y-v3.y)-(v4.y-v3.y)*(v1.x-v3.x);
    float v = (v2.x-v1.x)*(v1.y-v3.y)-(v2.y-v1.y)*(v1.x-v3.x);
    if (d < 0) u = -u; v = -v; d = -d;
    return (0<u && u<d) && (0<v && v<d);
}

float cross(const ofVec2f& u, const ofVec2f& v) {
    return u.x*v.y-u.y*v.x;
}

// being on a corner or on an edge is not being inside
bool pointInTriangle(const ofVec2f& P, const ofVec2f& A, const ofVec2f& B, const ofVec2f& C) {
    ofVec2f v0(C.x-A.x, C.y-A.y);
    ofVec2f v1(B.x-A.x, B.y-A.y);
    ofVec2f v2(P.x-A.x, P.y-A.y);
    float u = cross(v2,v0);
    float v = cross(v1,v2);
    float d = cross(v1,v0);
    if (d < 0) u = -u; v = -v; d = -d;
    return u>0 && v>0 && ((u+v) < d);
}

bool nearbyCircle(const ofVec2f& A1, const ofVec2f& B1, const ofVec2f& C1,
                  const ofVec2f& A2, const ofVec2f& B2, const ofVec2f& C2) {
    ofVec2f center1 = (A1 + B1 + C1) / 3;
    ofVec2f center2 = (A2 + B2 + C2) / 3;
    float sizeSquared1 = MAX(A1.squareDistance(center1), MAX(B1.squareDistance(center1), C1.squareDistance(center1)));
    float sizeSquared2 = MAX(A2.squareDistance(center2), MAX(B2.squareDistance(center2), C2.squareDistance(center2)));
    float minimumDistance = sqrtf(sizeSquared1) + sqrtf(sizeSquared2);
    return center1.squareDistance(center2) <= (minimumDistance * minimumDistance);
}

bool triangleIntersection(const ofVec2f& A1, const ofVec2f& B1, const ofVec2f& C1,
                          const ofVec2f& A2, const ofVec2f& B2, const ofVec2f& C2) {
    return
    pointInTriangle(A1, A2, B2, C2) ||
    pointInTriangle(B1, A2, B2, C2) ||
    pointInTriangle(C1, A2, B2, C2) ||
    pointInTriangle(A2, A1, B1, C1) ||
    pointInTriangle(B2, A1, B1, C1) ||
    pointInTriangle(C2, A1, B1, C1) ||
    lineIntersection(A1, B1, A2, B2) ||
    lineIntersection(A1, B1, B2, C2) ||
    lineIntersection(A1, B1, C2, A2) ||
    lineIntersection(B1, C1, A2, B2) ||
    lineIntersection(B1, C1, B2, C2) ||
    lineIntersection(B1, C1, C2, A2) ||
    lineIntersection(C1, A1, A2, B2) ||
    lineIntersection(C1, A1, B2, C2) ||
    lineIntersection(C1, A1, C2, A2);
}

// this is faster if most triangles are small and spread out
bool triangleIntersectionFast(const ofVec2f& A1, const ofVec2f& B1, const ofVec2f& C1,
                              const ofVec2f& A2, const ofVec2f& B2, const ofVec2f& C2) {
    return nearbyCircle(A1, B1, C1, A2, B2, C2) &&
    triangleIntersection(A1, B1, C1, A2, B2, C2);
}

namespace Geometry {
    class Triangle;
    class Point {
    public:
        ofVec2f v2;
        ofVec3f v3;
        ofIndexType i;
    };
    class Edge {
    private:
        vector<Point*> points;
    public:
        Triangle *src, *dst;
        Edge()
        :points(2, nullptr)
        ,src(nullptr)
        ,dst(nullptr) {
        }
        bool matches(Edge& e) {
            return i(0) == e.i(1) && i(1) == e.i(0);
        }
        void set(Point* p0, Point* p1, Triangle* src) {
            p(0) = p0;
            p(1) = p1;
            this->src = src;
        }
        Point*& p(int index) {
            return points[index];
        }
        ofVec3f& v3(int index) {
            return points[index]->v3;
        }
        ofVec2f& v2(int index) {
            return points[index]->v2;
        }
        ofIndexType& i(int index) {
            return points[index]->i;
        }
    };
    class Triangle {
    private:
        vector<Point> points;
        vector<Edge> edges;
        vector<Triangle*> triangles;
    public:
        bool placed;
        Triangle(ofMesh& mesh, int triangleNumber)
        :placed(false)
        ,points(3)
        ,edges(3)
        ,triangles(3) {
            int o = triangleNumber * 3;
            vector<ofIndexType>& indices = mesh.getIndices();
            vector<ofVec3f>& vertices = mesh.getVertices();
            i(0) = indices[o+0];
            i(1) = indices[o+1];
            i(2) = indices[o+2];
            v3(0) = vertices[i(0)];
            v3(1) = vertices[i(1)];
            v3(2) = vertices[i(2)];
            e(0).set(&p(0), &p(1), this);
            e(1).set(&p(1), &p(2), this);
            e(2).set(&p(2), &p(0), this);
        }
        void connect(Triangle& t) {
            for(Edge& e0 : edges) {
                for(Edge& e1 : t.edges) {
                    if(e0.matches(e1)) {
                        e0.dst = &t;
                    }
                }
            }
        }
        void draw2() {
            if(!placed) return;
            ofFill();
            ofSetColor(255);
            ofDrawTriangle(v2(0), v2(1), v2(2));
            ofNoFill();
            ofSetColor(128);
            ofDrawTriangle(v2(0), v2(1), v2(2));
//            ofDrawBitmapString(ofToString(i(0)), v2(0));
//            ofDrawBitmapString(ofToString(i(1)), v2(1));
//            ofDrawBitmapString(ofToString(i(2)), v2(2));
        }
        void draw3() {
            ofDrawTriangle(v3(0), v3(1), v3(2));
        }
        Point& p(int index) {
            return points[index];
        }
        ofVec3f& v3(int index) {
            return points[index].v3;
        }
        ofVec2f& v2(int index) {
            return points[index].v2;
        }
        ofIndexType& i(int index) {
            return points[index].i;
        }
        Edge& e(int index) {
            return edges[index];
        }
        vector<Edge>& e() {
            return edges;
        }
        void set() {
            for(int i = 0; i < edges.size(); i++) {
                triangles[i] = edges[i].dst;
            }
        }
        Triangle& t(int index) {
            return *triangles[index];
        }
        vector<Triangle*>& t() {
            return triangles;
        }
        void matchEdge(Triangle& t, Edge*& src, Edge*& dst) {
            for(Edge& e0 : edges) {
                for(Edge& e1 : t.edges) {
                    if(e0.matches(e1)) {
                        src = &e0;
                        dst = &e1;
                        return;
                    }
                }
            }
            throw;
        }
        void translate(const ofVec2f& from, const ofVec2f& to) {
            ofVec2f diff = to - from;
            for(Point& point : points) {
                point.v2 += diff;
            }
        }
        void rotate(Edge& src, Edge& dst) {
            ofVec2f srcDir = src.v2(1) - src.v2(0);
            ofVec2f dstDir = dst.v2(0) - dst.v2(1);
            float angle = srcDir.angle(dstDir);
            for(Point& point : points) {
                point.v2.rotate(angle);
            }
        }
        bool intersects(Triangle& t) {
            return placed && t.placed && triangleIntersectionFast(v2(0), v2(1), v2(2), t.v2(0), t.v2(1), t.v2(2));
        }
        bool intersects(vector<Triangle>& t, Triangle& exception) {
            for(Triangle& triangle : t) {
//                ofLog() << "checking " << &triangle << " vs " << &exception << " vs " << this;
                if(&triangle != this && &triangle != &exception && intersects(triangle)) {
                    return true;
                }
            }
            return false;
        }
        void unplace() {
            placed = false;
        }
        void place() {
            float a = v3(0).distance(v3(1));
            float b = v3(1).distance(v3(2));
            float c = v3(2).distance(v3(0));
            v2(0).set(0, 0);
            v2(1).set(a, 0);
            v2(2).set(c, 0);
            v2(2).rotateRad(getAngleOppositeC(c, a, b));
            placed = true;
        }
        void place(Triangle& t) {
            place();
            Edge *src, *dst;
            matchEdge(t, src, dst);
            translate(src->v2(0), ofVec2f());
            rotate(*src, *dst);
            translate(ofVec2f(), dst->v2(1));
            placed = true;
        }
        void placeRecursive() {
            for(Triangle* triangle : triangles) {
                if(triangle != nullptr && !triangle->placed) {
                    triangle->place(*this);
                    triangle->placeRecursive();
                }
            }
        }
    };
    class Mesh {
    private:
        vector<Triangle> triangles;
    public:
        void setup(ofMesh& mesh) {
            // add all triangles and edges
            for(ofIndexType i = 0; i < mesh.getNumIndices(); i += 3) {
                triangles.emplace_back(mesh, i / 3);
            }
            // fill out edge adjacencies
            for(Triangle& t0 : triangles) {
                for(Triangle& t1 : triangles) {
                    if(&t0 != &t1) {
                        t0.connect(t1);
                    }
                }
            }
            // setup out triangle adjacencies
            for(Triangle& t : triangles) {
                t.set();
            }
            ofLog() << "loaded " << triangles.size() << " triangles";
        }
        void placeAll(int root) {
            // after doing our best to place everything
            // there will still be some things that overlapped and were never visited
            // we need to build a separate flattened mesh for those
            t(root).place();
            int triangleCount = 1;
            list<Triangle*> q;
            q.push_back(&t(root));
            int unplaceable = 0;
            int iterationsWithoutPlacement = 10000; // should be a better way to do this
            while(!q.empty() && unplaceable < iterationsWithoutPlacement) {
                Triangle& src = *q.front();
                bool placedSomething = false;
                for(Triangle* dst : src.t()) {
                    if(!dst->placed) {
                        dst->place(src);
                        if(dst->intersects(triangles, src)) {
                            dst->unplace();
                        } else {
                            q.push_back(dst);
                            placedSomething = true;
                            triangleCount++;
                        }
                    }
                }
                unplaceable = placedSomething ? 0 : unplaceable + 1;
                q.pop_front();
            }
//            ofLog() << triangleCount;
        }
        void unplace() {
            for(Triangle& triangle : triangles) {
                triangle.unplace();
            }
        }
        void draw2() {
            for(Triangle& triangle : triangles) {
                triangle.draw2();
//                triangle.draw3();
//                ofDrawLine(triangle.v2(0), triangle.v3(0));
//                ofDrawLine(triangle.v2(1), triangle.v3(1));
//                ofDrawLine(triangle.v2(2), triangle.v3(2));
            }
        }
        void draw3() {
            for(Triangle& triangle : triangles) {
                triangle.draw3();
            }
        }
        Triangle& t(int index) {
            return triangles[index];
        }
        vector<Triangle>& t() {
            return triangles;
        }
    };
}

class ofApp : public ofBaseApp {
public:
    ofEasyCam cam;
    Geometry::Mesh flat;
    void setup() {
        ofMesh mesh;
//        mesh.load("sphere.ply");
        mesh.load("lofi-bunny.ply");
        flat.setup(mesh);
        ofBackground(0);
        ofNoFill();
        
//        root.t(0).place(flat.t(0));
//        root.t(1).place(flat.t(0));
//        root.t(2).place(flat.t(0));
//        
//        Geometry::Triangle& a = root.t(0);
//        a.t(0).place(a);
//        a.t(1).place(a);
//        a.t(2).place(a);
    }
    void update() {
    }
    void draw() {
        ofTranslate(ofGetWidth() / 2, ofGetHeight() / 2);
        ofScale(2, 2);
        
        flat.unplace();
        int start = ofMap(mouseX, 0, ofGetWidth(), 0, flat.t().size() - 1, true);
        
        flat.placeAll(start);
        
//        Geometry::Triangle& root = flat.t(start);
//        root.place();
//        root.placeRecursive();

//        Geometry::Triangle& root = flat.t(0);
//        root.draw2();
//        root.t(0).draw2();
//        root.t(1).draw2();
//        root.t(2).draw2();
//        Geometry::Triangle& a = root.t(0);
//        a.t(0).draw2();
//        a.t(1).draw2();
//        a.t(2).draw2();
        
        flat.draw2();
    }
};
int main() {
    ofSetupOpenGL(1280, 720, OF_WINDOW);
    ofRunApp(new ofApp());
}