#include "TERendererTexture.h"

TERendererTexture::TERendererTexture() {}

TERendererTexture::TERendererTexture(String vertexSource, String fragmentSource) :
TERendererProgram(vertexSource, fragmentSource) {}

void TERendererTexture::run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount) {
    activate(target);
    uint simpleProgram = activate(target);
    uint positionHandle = glGetAttribLocation(simpleProgram, "aVertices");
    uint textureHandle = glGetAttribLocation(simpleProgram, "aTextureCoords");
    uint coordsHandle = glGetAttribLocation(simpleProgram, "aPosition");
    uint alphaHandle = glGetUniformLocation(simpleProgram, "uAlpha");
    
    TEVec3 vec;
    for (int i = 0;i < primativeCount;++i) {
        vec = primatives[i].position;
        glBindTexture(GL_TEXTURE_2D, primatives[i].textureName);
        glVertexAttrib2f(coordsHandle, vec.x, vec.y);
        glVertexAttribPointer(textureHandle, 2, GL_FLOAT, false, 0, primatives[i].textureBuffer);
        glVertexAttribPointer(positionHandle, 2, GL_FLOAT, false, 0, primatives[i].vertexBuffer);
        glUniform1f(alphaHandle, 1.0);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    }
    
    deactivate();
}
