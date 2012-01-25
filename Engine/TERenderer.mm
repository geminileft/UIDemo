#include "TERenderer.h"

TERenderer::TERenderer() : mTextureTop(0), mPolygonTop(0) {}

void TERenderer::addTexture(TEUtilTexture* texture, float* vertexBuffer, float* textureBuffer, TEVec3 position) {
    TERenderTexturePrimative rp;
    rp.texture = texture;
    rp.position = position;
    rp.vertexBuffer = vertexBuffer;
    rp.textureBuffer = textureBuffer;
    mTexturePrimatives[mTextureTop] = rp;
    ++mTextureTop;
}

void TERenderer::addPolygon(float* vertexBuffer, TEVec3 position, TEColor4 color) {
    TERenderPolygonPrimative pp;
    pp.vertexBuffer = vertexBuffer;
    pp.position = position;
    pp.color = color;
    mPolygonPrimatives[mPolygonTop] = pp;
    ++mPolygonTop;
}

void TERenderer::reset() {
    mTextureTop = 0;
    mPolygonTop = 0;
}

TERenderTexturePrimative* TERenderer::getRenderPrimatives() {
    return mTexturePrimatives;
}

TERenderPolygonPrimative* TERenderer::getPolygonPrimatives() {
    return mPolygonPrimatives;
}

uint TERenderer::getPrimativeCount() const {
    return mTextureTop;
}

uint TERenderer::getPolygonCount() const {
    return mPolygonTop;
}
