#include "TERenderTarget.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "TEUtilMatrix.h"

TERenderTarget::TERenderTarget(uint frameBuffer) : mFrameBuffer(frameBuffer), mTextureCount(0), mPolygonCount(0) {}

void TERenderTarget::setSize(TESize size) {
    mFrameWidth = size.width;
    mFrameHeight = size.height;
    
    float angle;
    float zDepth;
    float ratio;
    
    zDepth = (float)mFrameHeight / 2;
    ratio = (float)mFrameWidth/(float)mFrameHeight;
    
    if (false) {
        angle = -90.0f;
        TEUtilMatrix::setFrustum(&mProjMatrix[0], ColumnMajor, -1, 1, -ratio, ratio, 1.0f, 1000.0f);
    } else {
        angle = 0.0f;
        TEUtilMatrix::setFrustum(&mProjMatrix[0], ColumnMajor, -ratio, ratio, -1, 1, 1.0f, 1000.0f);
    }
    
    TEUtilMatrix::setTranslate(&mViewMatrix[0], ColumnMajor, 0.0f, 0.0f, -zDepth);
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
    count = mPolygonPrimatives.size();
    if (mPolygonCount > 0) {
        free(mFramePolygonPrimatives);
    }
    mPolygonCount = count;
    if (count > 0) {
        mFramePolygonPrimatives = (TERenderPolygonPrimative*)malloc(count * sizeof(TERenderPolygonPrimative));
        std::vector<TERenderPolygonPrimative>::iterator iterator;
        uint c = 0;
        for(iterator = mPolygonPrimatives.begin(); iterator != mPolygonPrimatives.end(); iterator++) {
            mFramePolygonPrimatives[c] = (*iterator);
            ++c;
        }
    }
    return mFramePolygonPrimatives;
}

void TERenderTarget::activate() {
    glViewport(0, 0, mFrameWidth, mFrameHeight);
    glBindFramebuffer(GL_FRAMEBUFFER, mFrameBuffer);
}

float* TERenderTarget::getProjMatrix() {
    return mProjMatrix;
}

float* TERenderTarget::getViewMatrix() {
    return mViewMatrix;
}
