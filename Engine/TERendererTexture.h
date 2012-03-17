#ifndef TERENDERERTEXTURE
#define TERENDERERTEXTURE

#include "TERendererProgram.h"

class TERenderTarget;

class TERendererTexture : public TERendererProgram {
    
public:
    TERendererTexture();
    TERendererTexture(String vertexSource, String fragmentSource);
    
    virtual void run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount);
};

#endif
