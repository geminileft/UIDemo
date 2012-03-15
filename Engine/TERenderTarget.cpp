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

void TERenderTarget::addTexturePrimative(TERenderTexturePrimative primative) {
    mTexturePrimatives.push_back(primative);
}

void TERenderTarget::addPolygonPrimative(TERenderPolygonPrimative primative) {
    mPolygonPrimatives.push_back(primative);
}

void TERenderTarget::resetPrimatives() {
    mTexturePrimatives.clear();
    mPolygonPrimatives.clear();
}
