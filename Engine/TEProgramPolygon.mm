#include "TEProgramPolygon.h"

TEProgramPolygon::TEProgramPolygon() {}

TEProgramPolygon::TEProgramPolygon(String vertexSource, String fragmentSource) :
TERendererProgram(vertexSource, fragmentSource) {}

void TEProgramPolygon::run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount) {
    uint programId = activate(target);
    uint vertexHandle = glGetAttribLocation(programId, "aVertices");
    uint colorHandle = glGetAttribLocation(programId, "aColor");
    uint posHandle = glGetAttribLocation(programId, "aPosition");
    TERenderPrimative p;
    
    for (int i = 0;i < primativeCount;++i) {
        p = primatives[i];
        
        glVertexAttribPointer(vertexHandle, 2, GL_FLOAT, GL_FALSE, 0, &p.vertexBuffer[0]);
        glVertexAttribPointer(colorHandle, 4, GL_FLOAT, GL_FALSE, 0, &p.colorData[0]);
        glVertexAttrib2f(posHandle, p.position.x, p.position.y);
        glDrawArrays(GL_TRIANGLE_FAN, 0, p.vertexCount);
    }
    deactivate();
}
