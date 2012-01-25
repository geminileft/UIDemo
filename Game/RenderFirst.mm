#include "RenderFirst.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

RenderFirst::RenderFirst(NSString* resourceName, TEPoint position, TESize size) {    
    mTexture = new TEUtilTexture(resourceName, position, size);
}

void RenderFirst::update() {
    const float sideSize = 80.0f;
    
    float squareVertices[] = {
        -sideSize, -sideSize,//lb
        sideSize,  -sideSize,//rb
        -sideSize,  sideSize,//lt
        sideSize,   sideSize,//rt
    };
    
    TEColor4 color;
    color.r = 0.0f;
    color.g = 1.0f;
    color.b = 1.0f;
    color.a = 1.0f;
    
    TEVec3 position;
    position.x = 80.0f;
    position.y = 240.0f;
    position.z = 0.0f;
    
    sharedRenderer()->addPolygon(squareVertices, position, color);
}

void RenderFirst::draw() {
}

void RenderFirst::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};

TESize RenderFirst::getSize() {
	TESize size;
	size.width = mWidth;
	size.height = mHeight;
	return size;
}
