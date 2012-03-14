#include "TEComponentRender.h"

static TERenderer* mSharedRenderer = NULL;

TEComponentRender::TEComponentRender() {
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
