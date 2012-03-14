#include "TERenderTarget.h"

TERenderTarget::TERenderTarget(uint frameBuffer) : mFrameBuffer(frameBuffer) {}

void TERenderTarget::setSize(TESize size) {
    mFrameWidth = size.width;
    mFrameHeight = size.height;
}

uint TERenderTarget::getFrameBuffer() const {
    return mFrameBuffer;
}

float TERenderTarget::getFrameWidth() const {
    return mFrameWidth;
}

float TERenderTarget::getFrameHeight() const {
    return mFrameHeight;
}
