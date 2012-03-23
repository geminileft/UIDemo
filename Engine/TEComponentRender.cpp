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
    clearExtra();
    mExtra = malloc(9 * sizeof(float));
    memcpy(mExtra, kernel, 9 * sizeof(float));
    mExtraType = ShaderKernel;
}

void TEComponentRender::setTransparentColor(TEColor4* color) {
    clearExtra();
    mExtra = malloc(sizeof(TEColor4));
    memcpy(mExtra, color, sizeof(TEColor4));
    mExtraType = ShaderTransparentColor;
}

void TEComponentRender::setGrayscale() {
    clearExtra();
    mExtra = malloc(sizeof(float));
    mExtraType = ShaderGrayscale;
}

void TEComponentRender::setSepia() {
    clearExtra();
    mExtra = malloc(sizeof(float));
    mExtraType = ShaderSepia;    
}

void TEComponentRender::setNegative() {
    clearExtra();
    mExtra = malloc(sizeof(float));
    mExtraType = ShaderNegative;    
}

void TEComponentRender::setYellow() {
    clearExtra();
    mExtra = malloc(sizeof(float));
    mExtraType = ShaderYellow;    
    
}

float* TEComponentRender::getExtraData() const {
    return (float*)mExtra;
}

TEShaderType TEComponentRender::getExtraType() {
    return mExtraType;
}

void TEComponentRender::clearExtra() {
    if (mExtra != NULL) {
        free(mExtra);
    }
}

