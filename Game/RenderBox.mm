#include "RenderBox.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

RenderBox::RenderBox(TESize size, TEColor4 color) : mWidth(size.width), mHeight(size.height), mR(color.r), mG(color.g), mB(color.b), mA(color.a) {
    const float halfHeight = (float)mHeight / 2;
    const float halfWidth = (float)mWidth / 2;
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

void RenderBox::update() {
    
    TEColor4 color;
    color.r = mR;
    color.g = mG;
    color.b = mB;
    color.a = mA;
    
    TEVec3 position;
    position.x = mParent->position.x;
    position.y = mParent->position.y;
    position.z = 0.0f;
    
    sharedRenderer()->addPolygon(mVertices, 5, position, color);
}

void RenderBox::draw() {
}

void RenderBox::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};
