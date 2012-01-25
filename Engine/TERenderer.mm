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
    pp.vertexBuffer[0] = vertexBuffer[0];
    pp.vertexBuffer[1] = vertexBuffer[1];
    pp.vertexBuffer[2] = vertexBuffer[2];
    pp.vertexBuffer[3] = vertexBuffer[3];
    pp.vertexBuffer[4] = vertexBuffer[4];
    pp.vertexBuffer[5] = vertexBuffer[5];
    pp.vertexBuffer[6] = vertexBuffer[6];
    pp.vertexBuffer[7] = vertexBuffer[7];
    //pp.vertexBuffer = vertexBuffer;
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
