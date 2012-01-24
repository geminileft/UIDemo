#ifndef TouchEngine_TERenderer_h
#define TouchEngine_TERenderer_h

#include "TETypes.h"
#include "TERenderPrimatives.h"

class TEUtilTexture;

#define MAX_RENDER_PRIMATIVES   1000

class TERenderer {
private:
    uint mTop;
    TERenderTexturePrimative mTexturePrimatives[MAX_RENDER_PRIMATIVES];
    
public:
    TERenderer();
    virtual void render() = 0;
    void addTexture(TEUtilTexture* texture, float* vertexBuffer, float* textureBuffer, TEVec3 position);
    void reset();
    TERenderTexturePrimative* getRenderPrimatives();
    uint getPrimativeCount() const;
};

#endif
