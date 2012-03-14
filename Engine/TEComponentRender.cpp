#include "TEComponentRender.h"
#include "TERenderer.h"

static TERenderer* mSharedRenderer = NULL;

TEComponentRender::TEComponentRender() {
    uint screenFrameBuffer = mSharedRenderer->getScreenFrameBuffer();
    mTarget = sharedRenderer()->getTarget(screenFrameBuffer);
}

TERenderer* TEComponentRender::sharedRenderer() {
    return mSharedRenderer;
}

void TEComponentRender::setSharedRenderer(TERenderer* renderer) {
    mSharedRenderer = renderer;
}

void TEComponentRender::setRenderTarget(TERenderTarget* target) {
    mTarget = target;
}

TERenderTarget* TEComponentRender::getRenderTarget() {
    return mTarget;
}
