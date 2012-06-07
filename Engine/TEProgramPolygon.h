#ifndef TERENDERERPOLYGON
#define TERENDERERPOLYGON

#include "TERendererProgram.h"

class TERenderTarget;

class TEProgramPolygon : public TERendererProgram {
    
public:
    TEProgramPolygon();
    TEProgramPolygon(String vertexSource, String fragmentSource);
    
    virtual void run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount);
};

#endif
