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
    virtual void run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount) = 0;
    uint getProgramId() const;

};
#endif
