#include "TEComponentRender.h"
#include "TERenderer.h"

static TERenderer* mSharedRenderer = NULL;

TEComponentRender::TEComponentRender() : mExtra(NULL) {
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
    if (mExtra != NULL) {
        free(mExtra);
    }
    mExtra = (float*)malloc(9 * sizeof(float));
    memcpy(mExtra, kernel, 9 * sizeof(float));
    mExtraType = ShaderKernel;
}

float* TEComponentRender::getExtraData() const {
    return (float*)mExtra;
}

void TEComponentRender::setExtraType(TEShaderType extraType) {
    mExtraType = extraType;
}

TEShaderType TEComponentRender::getExtraType() {
    return mExtraType;
}
