#include "TERenderer.h"
#include "TERenderTarget.h"

TERenderer::TERenderer() : mTextureTop(0), mPolygonTop(0) {}

void TERenderer::addTexture(TERenderTarget* target, uint textureName, float* vertexBuffer, float* textureBuffer, TEVec3 position) {
    TERenderTexturePrimative rp;
    rp.textureName = textureName;
    rp.position = position;
    rp.vertexBuffer = vertexBuffer;
    rp.textureBuffer = textureBuffer;
    mTexturePrimatives[mTextureTop] = rp;
    ++mTextureTop;
    target->addTexturePrimative(rp);
}

void TERenderer::addPolygon(TERenderTarget* target, float* vertexBuffer, int count, TEVec3 position, TEColor4 color) {
    if (target->getFrameBuffer() == mScreenFrameBuffer) {
        NSLog(@"Render to Screen");
    } else {
        NSLog(@"Render to something else");
    }
    TERenderPolygonPrimative pp;
    pp.vertexBuffer = vertexBuffer;
    pp.vertexCount = count;
    pp.position = position;
    pp.color = color;
    mPolygonPrimatives[mPolygonTop] = pp;
    ++mPolygonTop;
    target->addPolygonPrimative(pp);

}

void TERenderer::reset() {
    mTextureTop = 0;
    mPolygonTop = 0;
    std::map<uint, TERenderTarget*>::iterator iterator;

    for (iterator = mTargets.begin(); iterator != mTargets.end(); iterator++) {
        (*iterator).second->resetPrimatives();
    }
}

TERenderPolygonPrimative* TERenderer::getPolygonPrimatives() {
    return mPolygonPrimatives;
}

uint TERenderer::getPolygonCount() const {
    return mPolygonTop;
}

void TERenderer::setTarget(uint frameBuffer, TERenderTarget* target) {
    mTargets[frameBuffer] = target;
}

TERenderTarget* TERenderer::getTarget(uint frameBuffer) {
    return mTargets[frameBuffer];
}

uint TERenderer::getScreenFrameBuffer() const {
    return mScreenFrameBuffer;
}
void TERenderer::setScreenFrameBuffer(uint screenFrameBuffer) {
    mScreenFrameBuffer = screenFrameBuffer;
}

