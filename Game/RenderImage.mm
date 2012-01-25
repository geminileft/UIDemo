#include "RenderImage.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"

RenderImage::RenderImage(NSString* resourceName, TEPoint position, TESize size) {    
    mTexture = new TEUtilTexture(resourceName, position, size);
}

void RenderImage::update() {
    TEVec3 vec3;
    vec3.x = mParent->position.x;
    vec3.y = mParent->position.y;
    vec3.z = 0;
        
    /*
    UIImage* image = [UIImage imageNamed:resourceName];
    CGImage* cImage = [image CGImage];
    float width = CGImageGetWidth(cImage);
    float height = CGImageGetHeight(cImage);
    mTextureName = TEManagerTexture::GLUtexImage2D(cImage);
     */
    
    sharedRenderer()->addTexture(mTexture->mTextureName, mTexture->mVertexBuffer, mTexture->mTextureBuffer, vec3);
}

void RenderImage::draw() {
}

void RenderImage::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};
