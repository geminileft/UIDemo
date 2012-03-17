#include "TEComponentRender.h"
#include "TERenderer.h"

static TERenderer* mSharedRenderer = NULL;

TEComponentRender::TEComponentRender() : mKernel(NULL) {
    TERenderTarget* target = sharedRenderer()->mScreenTarget;
    setRenderTarget(target);
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

void TEComponentRender::setKernel(float* kernel) {
    if (mKernel != NULL) {
        free(mKernel);
    }
    mKernel = (float*)malloc(9 * sizeof(float));
    memcpy(mKernel, kernel, 9 * sizeof(float));
}

float* TEComponentRender::getKernel() const {
    return mKernel;
}
