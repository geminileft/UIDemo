#ifndef TouchEngine_TERenderer_h
#define TouchEngine_TERenderer_h

#include "TETypes.h"
#include <map>

class TEUtilTexture;
class TERenderTarget;

#define MAX_RENDER_PRIMATIVES   1000

class TERenderer {
private:
    uint mTextureTop;
    uint mPolygonTop;
    TERenderTexturePrimative mTexturePrimatives[MAX_RENDER_PRIMATIVES];
    TERenderPolygonPrimative mPolygonPrimatives[MAX_RENDER_PRIMATIVES];
    std::map<uint, TERenderTarget*> mTargets;

    
public:
    TERenderer();
    virtual void render() = 0;
    void addTexture(TERenderTarget* target, uint textureName, float* vertexBuffer, float* textureBuffer, TEVec3 position);
    void addPolygon(TERenderTarget* target, float* vertexBuffer, int count, TEVec3 position, TEColor4 color);
    void reset();
    TERenderTexturePrimative* getRenderPrimatives();
    TERenderPolygonPrimative* getPolygonPrimatives();
    uint getPrimativeCount() const;
    uint getPolygonCount() const;
    void setTarget(uint frameBuffer, TERenderTarget* target);
    TERenderTarget* getTarget(uint frameBuffer);
};

#endif
