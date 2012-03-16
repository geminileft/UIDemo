#ifndef TouchEngine_TERenderer_h
#define TouchEngine_TERenderer_h

#include "TETypes.h"
#include <map>

class TEUtilTexture;
class TERenderTarget;

#define MAX_RENDER_PRIMATIVES   1000

class TERenderer {
private:
    std::map<uint, TERenderTarget*> mTargets;
    uint mScreenFrameBuffer;

public:
    TERenderTarget* mScreenTarget;

    TERenderer();
    virtual void render() = 0;
    void addTexture(TERenderTarget* target, uint textureName, float* vertexBuffer, float* textureBuffer, TEVec3 position);
    void addPolygon(TERenderTarget* target, float* vertexBuffer, int count, TEVec3 position, TEColor4 color);
    void reset();
    void setTarget(uint frameBuffer, TERenderTarget* target);
    TERenderTarget* getTarget(uint frameBuffer);
    uint getScreenFrameBuffer() const;
    void setScreenFrameBuffer(uint screenFrameBuffer);
    std::map<uint, TERenderTarget*> getTargets() const;
    static TERenderTarget* createRenderTarget(uint &textureHandle, uint size);
};

#endif
