#include "RenderToTexture.h"
#include "TEGameObject.h"
#include "TERenderer.h"

void RenderToTexture::update() {
    //NSLog(@"RenderToTexture::update");
}

void RenderToTexture::draw() {
    //NSLog(@"RenderToTexture::draw");
}

TERenderTarget* RenderToTexture::getRenderTarget() {
    return mTarget;
}

uint RenderToTexture::getTextureHandle() {
    return mTextureHandle;
}
