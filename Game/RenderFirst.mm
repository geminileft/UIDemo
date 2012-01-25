#include "RenderFirst.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

RenderFirst::RenderFirst(NSString* resourceName, TEPoint position, TESize size) {    
    mTexture = new TEUtilTexture(resourceName, position, size);
}

void RenderFirst::update() {
    TEVec3 vec3;
    vec3.x = mParent->position.x;
    vec3.y = mParent->position.y;
    vec3.z = 0;
    sharedRenderer()->addTexture(mTexture, mTexture->mVertexBuffer, mTexture->mTextureBuffer, vec3);
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
