#include "RenderFirst.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

RenderFirst::RenderFirst(NSString* resourceName, TEPoint position, TESize size) {    
    mTexture = new TEUtilTexture(resourceName, position, size);
}

void RenderFirst::update() {
    //sharedRenderer()->addTexture(mTexture, mTexture->mVertexBuffer, mTexture->mTextureBuffer, vec3);
    const float totalSize = 160.0f;
    const float sideSize = totalSize / 2.0f;

    float squareVertices[] = {
        -sideSize, -sideSize,//lb
        sideSize,  -sideSize,//rb
        -sideSize,  sideSize,//lt
        sideSize,   sideSize,//rt
    };
    
    TEColor4 color;
    color.r = 1.0f;
    color.g = 0.0f;
    color.b = 0.0f;
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
