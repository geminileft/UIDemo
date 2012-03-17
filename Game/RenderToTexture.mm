#include "RenderToTexture.h"
#include "TEGameObject.h"
#include "TERenderer.h"
#include "TERenderTarget.h"

RenderToTexture::RenderToTexture(uint size) : TEComponentRender() {
    mSize = size;
    uint handle;
    mTarget = sharedRenderer()->createRenderTarget(handle, size);
    mTextureHandle = handle;
    sharedRenderer()->setTarget(mTarget->getFrameBuffer(), mTarget);
    uint currentFrameBuffer = sharedRenderer()->getScreenFrameBuffer();
    glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);

    
    mTextureBuffer[0] = 0.0f;//left
    mTextureBuffer[1] = 0.0f;//top
    mTextureBuffer[2] = 1.0f;//right
    mTextureBuffer[3] = 0.0f;//top
    mTextureBuffer[4] = 1.0f;//right
    mTextureBuffer[5] = 1.0f;//bottom
    mTextureBuffer[6] = 0.0f;//left
    mTextureBuffer[7] = 1.0f;//bottom
    
    const float var = size / 2;
    const float leftX = -var;
    const float bottomY = -var;
    const float rightX = var;
    const float topY = var;
    
    mVertexBuffer[0] = leftX;
    mVertexBuffer[1] = bottomY;
    mVertexBuffer[2] = rightX;
    mVertexBuffer[3] = bottomY;
    mVertexBuffer[4] = rightX;
    mVertexBuffer[5] = topY;
    mVertexBuffer[6] = leftX;
    mVertexBuffer[7] = topY;
}

void RenderToTexture::update() {}

void RenderToTexture::draw() {
    mRenderPrimative.textureName = mTextureHandle;
    mRenderPrimative.position.x = mParent->position.x;
    mRenderPrimative.position.y = mParent->position.y;
    mRenderPrimative.position.z = 0;
    mRenderPrimative.vertexCount = 4;
    mRenderPrimative.vertexBuffer = mVertexBuffer;
    mRenderPrimative.textureBuffer = mTextureBuffer;
    mRenderPrimative.extraData = getKernel();
    getRenderTarget()->addPrimative(mRenderPrimative);
}

TERenderTarget* RenderToTexture::getTargetFrameBuffer() {
    return mTarget;
}

uint RenderToTexture::getTextureHandle() {
    return mTextureHandle;
}
