#include "TERenderTarget.h"

TERenderTarget::TERenderTarget(uint frameBuffer) : mFrameBuffer(frameBuffer), mTextureCount(0), mPolygonCount(0) {}

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

TERenderTexturePrimative* TERenderTarget::getTexturePrimatives(uint &count) {
    count = mTexturePrimatives.size();
    if (mTextureCount > 0) {
        free(mFrameTexturePrimatives);
    }
    mTextureCount = count;
    if (count > 0) {
        mFrameTexturePrimatives = (TERenderTexturePrimative*)malloc(count * sizeof(TERenderTexturePrimative));
        std::vector<TERenderTexturePrimative>::iterator iterator;
        uint c = 0;
        for(iterator = mTexturePrimatives.begin(); iterator != mTexturePrimatives.end(); iterator++) {
            mFrameTexturePrimatives[c] = (*iterator);
            ++c;
        }
    }
    return mFrameTexturePrimatives;
}

TERenderPolygonPrimative* TERenderTarget::getPolygonPrimatives(uint &count) {
    return NULL;
}
