#include "RenderPolygon.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"
#include "TERenderTarget.h"

RenderPolygon::RenderPolygon() : TEComponentRender() {
    mRenderPrimative.textureBuffer = NULL;
    mRenderPrimative.kernel = NULL;
    mRenderPrimative.vertexCount = 0;
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

    mRenderPrimative.position.x = mParent->position.x;
    mRenderPrimative.position.y = mParent->position.y;

    sharedRenderer()->addPolygon(getRenderTarget(), mVertices, mVertexCount, position, color);
}

void RenderPolygon::draw() {
}

void RenderPolygon::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};

void RenderPolygon::setColor(TEColor4 color) {
    mRenderPrimative.color.r = color.r;
    mRenderPrimative.color.g = color.g;
    mRenderPrimative.color.b = color.b;
    mRenderPrimative.color.a = color.a;
    
    mR = color.r;
    mG = color.g;
    mB = color.b;
    mA = color.a;
}

void RenderPolygon::setVertices(float* vertices, int vertexCount) {
    int memSize = vertexCount * 2 * sizeof(float);
    if (mRenderPrimative.vertexCount > 0) {
        free(mRenderPrimative.vertexBuffer);
    }
    mRenderPrimative.vertexCount = vertexCount;
    mRenderPrimative.vertexBuffer = (float*)malloc(memSize);
    mVertices = mRenderPrimative.vertexBuffer;
    memcpy(mRenderPrimative.vertexBuffer, vertices, memSize);
    mVertexCount = vertexCount;
    mRenderPrimative.vertexCount = vertexCount;
}


RenderPolygon::~RenderPolygon() {
    free(mVertices);
}
