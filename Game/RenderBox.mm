#include "RenderBox.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

RenderBox::RenderBox(TEPoint position, TESize size, TEColor4 color) : mX(position.x), mY(position.y), 
    mWidth(size.width), mHeight(size.height), mR(color.r), mG(color.g), mB(color.b), mA(color.a) {}

void RenderBox::update() {
    const float halfHeight = (float)mHeight / 2;
    const float halfWidth = (float)mWidth / 2;
    
    float squareVertices[] = {
        -halfWidth, -halfHeight,//lb
        halfWidth,  -halfHeight,//rb
        -halfWidth,  halfHeight,//lt
        halfWidth,   halfHeight,//rt
    };
    
    TEColor4 color;
    color.r = mR;
    color.g = mG;
    color.b = mB;
    color.a = mA;
    
    TEVec3 position;
    position.x = mX;
    position.y = mY;
    position.z = 0.0f;
    
    sharedRenderer()->addPolygon(squareVertices, position, color);
}

void RenderBox::draw() {
}

void RenderBox::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};
