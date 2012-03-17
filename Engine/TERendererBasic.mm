#include "TERendererBasic.h"

TERendererBasic::TERendererBasic() {}

TERendererBasic::TERendererBasic(String vertexSource, String fragmentSource) :
    TERendererProgram(vertexSource, fragmentSource) {}

void TERendererBasic::run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount) {
    uint programId = activate(target);
    uint vertexHandle = glGetAttribLocation(programId, "aVertices");
    uint colorHandle = glGetUniformLocation(programId, "aColor");
    uint posHandle = glGetAttribLocation(programId, "aPosition");
    
    TERenderPrimative p;
    
    for (int i = 0;i < primativeCount;++i) {
        p = primatives[i];
        
        glVertexAttribPointer(vertexHandle, 2, GL_FLOAT, GL_FALSE, 0, &p.vertexBuffer[0]);
        glUniform4f(colorHandle, p.color.r, p.color.g, p.color.b, p.color.a);
        glVertexAttrib2f(posHandle, p.position.x, p.position.y);
        glDrawArrays(GL_TRIANGLE_FAN, 0, p.vertexCount);        
    }
    deactivate();
}
