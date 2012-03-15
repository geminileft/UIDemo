#include "TERenderer.h"
#include "TERenderTarget.h"
#include <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

TERenderer::TERenderer() {}

void TERenderer::addTexture(TERenderTarget* target, uint textureName, float* vertexBuffer, float* textureBuffer, TEVec3 position) {
    TERenderTexturePrimative rp;
    rp.textureName = textureName;
    rp.position = position;
    rp.vertexBuffer = vertexBuffer;
    rp.textureBuffer = textureBuffer;
    target->addTexturePrimative(rp);
}

void TERenderer::addPolygon(TERenderTarget* target, float* vertexBuffer, int count, TEVec3 position, TEColor4 color) {
    TERenderPolygonPrimative pp;
    pp.vertexBuffer = vertexBuffer;
    pp.vertexCount = count;
    pp.position = position;
    pp.color = color;
    target->addPolygonPrimative(pp);

}

void TERenderer::reset() {
    std::map<uint, TERenderTarget*>::iterator iterator;

    for (iterator = mTargets.begin(); iterator != mTargets.end(); iterator++) {
        (*iterator).second->resetPrimatives();
    }
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

std::map<uint, TERenderTarget*> TERenderer::getTargets() const {
    return mTargets;
}

void TERenderer::setScreenTarget(TERenderTarget* target) {
    mScreenTarget = target;
}

TERenderTarget* TERenderer::getScreenTarget() const {
    return mScreenTarget;
}

TERenderTarget* TERenderer::createRenderTarget(uint &textureHandle, uint size) {
    uint frameBuffer;;
    glGenTextures(1, &textureHandle);
    glBindTexture(GL_TEXTURE_2D, textureHandle);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size, size, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER_OES, frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureHandle, 0);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER); 
    if(status != GL_FRAMEBUFFER_COMPLETE) {
    NSLog(@"failed to make complete framebuffer object %x", status);
    }

    TERenderTarget* target = new TERenderTarget(frameBuffer);
    target->setSize(TESizeMake(size, size));
    return target;

}
