#include "RenderToTexture.h"
#include "TEGameObject.h"
#include "TERenderer.h"
#include "TERenderTarget.h"

RenderToTexture::RenderToTexture(uint size) : TEComponentRender() {
    mSize = size;
    uint handle;
    mTarget = sharedRenderer()->createRenderTarget(handle, size);
    //sharedRenderer()->setTextureFrameBufferHandle(handle);
    mTextureHandle = handle;
    //sharedRenderer()->setTextureTarget(target);
    sharedRenderer()->setTarget(mTarget->getFrameBuffer(), mTarget);
    uint currentFrameBuffer = sharedRenderer()->getScreenFrameBuffer();
    glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);

}
void RenderToTexture::update() {
    //NSLog(@"RenderToTexture::update");
}

void RenderToTexture::draw() {
    /************************
     RENDER TO TEXTURE
     *************************/
    float textureBuffer[8]; 
    textureBuffer[0] = 0.0f;//left
    textureBuffer[1] = 1.0f;//top
    textureBuffer[2] = 1.0f;//right
    textureBuffer[3] = 1.0f;//top
    textureBuffer[4] = 1.0f;//right
    textureBuffer[5] = 0.0f;//bottom
    textureBuffer[6] = 0.0f;//left
    textureBuffer[7] = 0.0f;//bottom
    
    float vertexBuffer[8];
    const float var = mSize / 2;
    const float leftX = -var;
    const float bottomY = -var;
    const float rightX = var;
    const float topY = var;
    
    vertexBuffer[0] = leftX;
    vertexBuffer[1] = bottomY;
    vertexBuffer[2] = rightX;
    vertexBuffer[3] = bottomY;
    vertexBuffer[4] = rightX;
    vertexBuffer[5] = topY;
    vertexBuffer[6] = leftX;
    vertexBuffer[7] = topY;
    TEVec3 vec;
    vec.x = 0;
    vec.y = -160;
    //sharedRenderer()->addTexture(sharedRenderer()->getScreenTarget(), mTextureHandle, vertexBuffer, textureBuffer, vec);        
}

TERenderTarget* RenderToTexture::getRenderTarget() {
    return mTarget;
}

uint RenderToTexture::getTextureHandle() {
    return mTextureHandle;
}
