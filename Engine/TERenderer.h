#ifndef TouchEngine_TERenderer_h
#define TouchEngine_TERenderer_h

#include "TETypes.h"

class TEUtilTexture;

#define MAX_RENDER_PRIMATIVES   1000

class TERenderer {
private:
    uint mTextureTop;
    uint mPolygonTop;
    
    TERenderTexturePrimative mTexturePrimatives[MAX_RENDER_PRIMATIVES];
    TERenderPolygonPrimative mPolygonPrimatives[MAX_RENDER_PRIMATIVES];
    
public:
    TERenderer();
    virtual void render() = 0;
    void addTexture(TEUtilTexture* texture, float* vertexBuffer, float* textureBuffer, TEVec3 position);
    void addPolygon(float* vertexBuffer, TEVec3 position, TEColor4 color);
    void reset();
    TERenderTexturePrimative* getRenderPrimatives();
    TERenderPolygonPrimative* getPolygonPrimatives();
    
    uint getPrimativeCount() const;
    uint getPolygonCount() const;
};

#endif
