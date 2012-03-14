#ifndef TERENDERERBASIC
#define TERENDERERBASIC

#include "TERendererProgram.h"

class TERendererBasic : public TERendererProgram {

public:
    TERendererBasic();
    TERendererBasic(String vertexSource, String fragmentSource);
    
    virtual void run(TEFBOTarget target, TERenderPolygonPrimative* primatives, uint primativeCount);
};

#endif
