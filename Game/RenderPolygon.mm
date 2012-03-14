#include "RenderPolygon.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

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
    
    sharedRenderer()->addPolygon(getRenderTarget(), mVertices, mVertexCount, position, color);
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
