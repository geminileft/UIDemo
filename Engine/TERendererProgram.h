#ifndef TERENDERERPROGRAM
#define TERENDERERPROGRAM

#include "TETypes.h"

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
    uint activate(TEFBOTarget target);
    void deactivate();

};
#endif
