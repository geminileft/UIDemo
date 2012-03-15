#ifndef RENDERTOTEXTURE
#define RENDERTOTEXTURE

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;
class TERenderTarget;

class RenderToTexture : public TEComponentRender {
private:
    TERenderTarget* mTarget;
    uint mTextureHandle;
    uint mSize;
    float mVertexBuffer[8];
    float mTextureBuffer[8];

public:
    RenderToTexture(uint size);
    virtual void update();
    virtual void draw();
    TERenderTarget* getRenderTarget();
    uint getTextureHandle();
};
#endif
