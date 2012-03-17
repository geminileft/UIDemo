#ifndef TERENDERERKERNEL
#define TERENDERERKERNEL

#include "TERendererProgram.h"

class TERenderTarget;

class TERendererKernel : public TERendererProgram {
    
public:
    TERendererKernel();
    TERendererKernel(String vertexSource, String fragmentSource);
    
    virtual void run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount);
};

#endif
