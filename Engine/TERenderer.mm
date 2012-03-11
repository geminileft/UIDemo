#include "TERenderer.h"

TERenderer::TERenderer() : mTextureTop(0), mPolygonTop(0) {}

void TERenderer::addTexture(uint textureName, float* vertexBuffer, float* textureBuffer, TEVec3 position) {
    TERenderTexturePrimative rp;
    rp.textureName = textureName;
    rp.position = position;
    rp.vertexBuffer = vertexBuffer;
    rp.textureBuffer = textureBuffer;
    mTexturePrimatives[mTextureTop] = rp;
    ++mTextureTop;
}

void TERenderer::addPolygon(float* vertexBuffer, int count, TEVec3 position, TEColor4 color) {
    TERenderPolygonPrimative pp;
    pp.vertexBuffer = vertexBuffer;
    pp.vertexCount = count;
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
