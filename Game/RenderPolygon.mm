#include "RenderPolygon.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

RenderPolygon::RenderPolygon(TESize size, TEColor4 color) {
    const float halfHeight = (float)size.height / 2;
    const float halfWidth = (float)size.width / 2;
    const int vertexCount = 5;
    float vertices[10];
    vertices[0] = -halfWidth;
    vertices[1] = -halfHeight;
    vertices[2] = halfWidth;
    vertices[3] = -halfHeight;
    vertices[4] = halfWidth;
    vertices[5] = halfHeight;
    vertices[6] = -halfWidth;
    vertices[7] = halfHeight;
    vertices[8] = -halfWidth;
    vertices[9] = -halfHeight;
    
    setVertices(&vertices[0], vertexCount);
    setColor(color);
}

void RenderPolygon::update() {
    
    TEColor4 color;
    color.r = mR;
    color.g = mG;
    color.b = mB;
    color.a = mA;
    
    TEVec3 position;
    position.x = mParent->position.x;
    position.y = mParent->position.y;
    position.z = 0.0f;
    
    sharedRenderer()->addPolygon(mVertices, mVertexCount, position, color);
}

void RenderPolygon::draw() {
}

void RenderPolygon::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};

void RenderPolygon::setColor(TEColor4 color) {
    mR = color.r;
    mG = color.g;
    mB = color.b;
    mA = color.a;
}

void RenderPolygon::setVertices(float* vertices, int vertexCount) {
    int memSize = vertexCount * 2 * sizeof(float);
    mVertices = (float*)malloc(memSize);
    memcpy(mVertices, vertices, memSize);
    mVertexCount = vertexCount;
}


RenderPolygon::~RenderPolygon() {
    free(mVertices);
}
