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

}
void RenderToTexture::update() {
}

void RenderToTexture::draw() {
}

TERenderTarget* RenderToTexture::getRenderTarget() {
    return mTarget;
}

uint RenderToTexture::getTextureHandle() {
    return mTextureHandle;
}
