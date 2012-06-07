#include "RenderPolygon.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"
#include "TERenderTarget.h"

RenderPolygon::RenderPolygon() : TEComponentRender() {
    mRenderPrimative.textureBuffer = NULL;
    mRenderPrimative.extraData = NULL;
    mRenderPrimative.colorData = NULL;
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

    getRenderTarget()->addPrimative(mRenderPrimative);
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

void RenderPolygon::setColorData(TEColor4* data, size_t count) {
    if (mRenderPrimative.colorData)
        free(mRenderPrimative.colorData);
    size_t size = count * sizeof(TEColor4);
    mRenderPrimative.colorData = (TEColor4*)malloc(size);
    memcpy(mRenderPrimative.colorData, data, size);
    NSLog(@"Stopping");
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
