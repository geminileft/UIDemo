#ifndef TouchEngine_TERenderer_h
#define TouchEngine_TERenderer_h

#include "TETypes.h"

class TEUtilTexture;

#define MAX_RENDER_PRIMATIVES   1000

struct TERenderTexturePrimative {
    TEUtilTexture* texture;
    TEVec3 position;
    float* vertexBuffer;
    float* textureBuffer;
};

typedef TERenderTexturePrimative TERenderTexturePrimative;

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
