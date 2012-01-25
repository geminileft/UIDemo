#include "TERenderer.h"

TERenderer::TERenderer() : mTextureTop(0) {}

void TERenderer::addTexture(TEUtilTexture* texture, float* vertexBuffer, float* textureBuffer, TEVec3 position) {
    TERenderTexturePrimative rp;
    rp.texture = texture;
    rp.position = position;
    rp.vertexBuffer = vertexBuffer;
    rp.textureBuffer = textureBuffer;
    mTexturePrimatives[mTextureTop] = rp;
    ++mTextureTop;
}

void TERenderer::reset() {
    glClear(GL_COLOR_BUFFER_BIT);
    mTextureTop = 0;
}

TERenderTexturePrimative* TERenderer::getRenderPrimatives() {
    return mTexturePrimatives;
}

uint TERenderer::getPrimativeCount() const {
    return mTextureTop;
}

void TERenderer::addPolygon(float* vertexBuffer, TEVec3 position, TEColor4 color) {
    TERenderPolygonPrimative pp;
    pp.vertexBuffer = vertexBuffer;
    pp.position = position;
    pp.color = color;
}
