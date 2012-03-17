#ifndef TERENDERERBASIC
#define TERENDERERBASIC

#include "TERendererProgram.h"

class TERenderTarget;

class TERendererBasic : public TERendererProgram {

public:
    TERendererBasic();
    TERendererBasic(String vertexSource, String fragmentSource);
    
    virtual void run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount);
};

#endif
