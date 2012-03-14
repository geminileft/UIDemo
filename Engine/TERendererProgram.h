#ifndef TERENDERERPROGRAM
#define TERENDERERPROGRAM

#include "TETypes.h"

class TERenderTarget;

class TERendererProgram {
private:
    uint mProgramId;
    uint loadShader(uint shaderType, String source);
    std::list<String> mAttributes;
    
    void checkGlError(String op);

public:
    TERendererProgram();
    TERendererProgram(String vertexSource, String fragmentSource);
    
    void addAttribute(String attribute);
    uint activate(TERenderTarget* target);
    void deactivate();
    virtual void run(TERenderTarget* target, TERenderPolygonPrimative* primatives, uint primativeCount);
    virtual void run(TERenderTarget* target, TERenderTexturePrimative* primatives, uint primativeCount);
    uint getProgramId() const;

};
#endif
