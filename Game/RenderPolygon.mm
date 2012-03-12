#include "RenderPolygon.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

RenderPolygon::RenderPolygon(TESize size, TEColor4 color) : mWidth(size.width), mHeight(size.height), mR(color.r), mG(color.g), mB(color.b), mA(color.a), mVertexCount(5) {
    const float halfHeight = (float)mHeight / 2;
    const float halfWidth = (float)mWidth / 2;
    mVertices = (float*)malloc(mVertexCount * 2);
    mVertices[0] = -halfWidth;
    mVertices[1] = -halfHeight;
    mVertices[2] = halfWidth;
    mVertices[3] = -halfHeight;
    mVertices[4] = halfWidth;
    mVertices[5] = halfHeight;
    mVertices[6] = -halfWidth;
    mVertices[7] = halfHeight;
    mVertices[8] = -halfWidth;
    mVertices[9] = -halfHeight;
    //draws Bottom Left->Bottom Right->Top Left->Top Right
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

