#include "TERenderer.h"

TERenderer::TERenderer() : mTop(0) {}

void TERenderer::addTexture(TEUtilTexture* texture, float* vertexBuffer, float* textureBuffer, TEVec3 position) {
    TERenderTexturePrimative rp;
    rp.texture = texture;
    rp.position = position;
    rp.vertexBuffer = vertexBuffer;
    rp.textureBuffer = textureBuffer;
    mTexturePrimatives[mTop] = rp;
    ++mTop;
}

void TERenderer::reset() {
    glClear(GL_COLOR_BUFFER_BIT);
    mTop = 0;
}

TERenderTexturePrimative* TERenderer::getRenderPrimatives() {
    return mTexturePrimatives;
}

uint TERenderer::getPrimativeCount() const {
    return mTop;
}
