#include "RenderImage.h"
#include "TERenderer.h"
#include "TEUtilTexture.h"
#include "TEGameObject.h"
#include "TEEventListener.h"
#include "TEManagerTexture.h"

RenderImage::RenderImage(NSString* resourceName, TEPoint position, TESize size) {
    UIImage* image = [UIImage imageNamed:resourceName];
    mTextureName = TEManagerTexture::GLUtexImage2D([image CGImage]);
    mTexture = new TEUtilTexture(resourceName, position, size);
    
    const float leftX = -(float)size.width / 2;
	const float rightX = leftX + size.width;
	const float bottomY = -(float)size.height / 2;
	const float topY = bottomY + size.height;

    mVertexBuffer[0] = leftX;
	mVertexBuffer[1] = bottomY;
	mVertexBuffer[2] = rightX;
	mVertexBuffer[3] = bottomY;
	mVertexBuffer[4] = rightX;
	mVertexBuffer[5] = topY;
	mVertexBuffer[6] = leftX;
	mVertexBuffer[7] = topY;
    /*
    -|
    -|
     */
    mTextureBuffer[0] = 0.0f;//left
	mTextureBuffer[1] = 1.0f;//top
	mTextureBuffer[2] = 1.0f;//right
	mTextureBuffer[3] = 1.0f;//top
	mTextureBuffer[4] = 1.0f;//right
	mTextureBuffer[5] = 0.0f;//bottom
	mTextureBuffer[6] = 0.0f;//left
	mTextureBuffer[7] = 0.0f;//bottom
    /*
    mTextureBuffer[0] = 0.0f;//left
	mTextureBuffer[1] = 0.5f;//bottom
	mTextureBuffer[2] = 0.5f;//right
	mTextureBuffer[3] = 0.5f;//bottom
	mTextureBuffer[4] = 0.5f;//right
	mTextureBuffer[5] = 0.0f;//top
	mTextureBuffer[6] = 0.0f;//left
	mTextureBuffer[7] = 0.0f;//top
    */
}

void RenderImage::update() {
    TEVec3 vec3;
    vec3.x = mParent->position.x;
    vec3.y = mParent->position.y;
    vec3.z = 0;
        
    sharedRenderer()->addTexture(mTextureName, mVertexBuffer, mTextureBuffer, vec3);
}

void RenderImage::draw() {
}

void RenderImage::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};
