#include "TERendererKernel.h"

TERendererKernel::TERendererKernel() {}

TERendererKernel::TERendererKernel(String vertexSource, String fragmentSource) :
TERendererProgram(vertexSource, fragmentSource) {}

void TERendererKernel::run(TERenderTarget* target, TERenderPrimative* primatives, uint primativeCount) {
    uint simpleProgram = activate(target);
    uint positionHandle = glGetAttribLocation(simpleProgram, "aVertices");
    uint textureHandle = glGetAttribLocation(simpleProgram, "aTextureCoords");
    uint coordsHandle = glGetAttribLocation(simpleProgram, "aPosition");
    uint offsetHandle = glGetUniformLocation(simpleProgram, "uOffsets");
    uint kernelHandle = glGetUniformLocation(simpleProgram, "uKernel");
    /*
     float textureBuffer[8]; 
     textureBuffer[0] = 0.0f;//left
     textureBuffer[1] = 1.0f;//top
     textureBuffer[2] = 1.0f;//right
     textureBuffer[3] = 1.0f;//top
     textureBuffer[4] = 1.0f;//right
     textureBuffer[5] = 0.0f;//bottom
     textureBuffer[6] = 0.0f;//left
     textureBuffer[7] = 0.0f;//bottom
     
     float vertexBuffer[8];
     const float var = mTextureLength / 2;
     const float leftX = -var - 80;
     const float bottomY = -var;
     const float rightX = var - 80;
     const float topY = var;
     
     vertexBuffer[0] = leftX;
     vertexBuffer[1] = bottomY;
     vertexBuffer[2] = rightX;
     vertexBuffer[3] = bottomY;
     vertexBuffer[4] = rightX;
     vertexBuffer[5] = topY;
     vertexBuffer[6] = leftX;
     vertexBuffer[7] = topY;
     
     if (mUseRenderToTexture) {
     glBindTexture(GL_TEXTURE_2D, mTextureFrameBufferHandle);
     glVertexAttrib2f(coordsHandle, 0, 0);
     glVertexAttribPointer(textureHandle, 2, GL_FLOAT, false, 0, textureBuffer);
     glVertexAttribPointer(positionHandle, 2, GL_FLOAT, false, 0, vertexBuffer);
     glUniform1f(alphaHandle, 1.0);
     glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
     }
     */
    const float TEXTURE_SIZE = 256.0;
    float step_w = 1.0/TEXTURE_SIZE;
    float step_h = 1.0/TEXTURE_SIZE;
    
    const int OFFSET_COUNT = 9;
    float offsets[OFFSET_COUNT * 2] = {
        -step_w, -step_h
        , 0.0, -step_h
        , step_w, -step_h
        , -step_w, 0.0
        , 0.0, 0.0
        , step_w, 0.0
        , -step_w, step_h
        , 0.0, step_h
        , step_w, step_h
    };
    
    float kernel[OFFSET_COUNT];
    
    // Gaussian kernel
    // 1 2 1
    // 2 4 2
    // 1 2 1
    /*
    kernel[0] = 1.0/16.0;
    kernel[1] = 2.0/16.0;
    kernel[2] = 1.0/16.0;
    kernel[3] = 2.0/16.0;
    kernel[4] = 4.0/16.0;
    kernel[5] = 2.0/16.0;
    kernel[6] = 1.0/16.0;
    kernel[7] = 2.0/16.0;
    kernel[8] = 1.0/16.0;
    */
    // Mean kernel
    // 1 1 1
    // 1 1 1
    // 1 1 1

     kernel[0] = 1.0/9.0;
     kernel[1] = 1.0/9.0;
     kernel[2] = 1.0/9.0;
     kernel[3] = 1.0/9.0;
     kernel[4] = 1.0/9.0;
     kernel[5] = 1.0/9.0;
     kernel[6] = 1.0/9.0;
     kernel[7] = 1.0/9.0;
     kernel[8] = 1.0/9.0;

    // Emboss kernel
    // 2  0  0
    // 0 -1  0
    // 0  0 -1
    /*
     kernel[0] = 2.0/9.0;
     kernel[1] = 0.0/9.0;
     kernel[2] = 0.0/9.0;
     kernel[3] = 0.0/9.0;
     kernel[4] = -1.0/9.0;
     kernel[5] = 0.0/9.0;
     kernel[6] = 0.0/9.0;
     kernel[7] = 0.0/9.0;
     kernel[8] = -1.0/9.0;
     */
    // Laplacian kernel
    // 0  1  0
    // 1 -4  1
    // 0  1  0
    /*
     kernel[0] = -1.0/9.0;
     kernel[1] = -1.0/9.0;
     kernel[2] = -1.0/9.0;
     kernel[3] = -1.0/9.0;
     kernel[4] = 8.0/9.0;
     kernel[5] = -1.0/9.0;
     kernel[6] = -1.0/9.0;
     kernel[7] = -1.0/9.0;
     kernel[8] = -1.0/9.0;
     */
    // Sharpen kernel
    // -1  -1  -1
    // -1   9  -1
    // -1  -1  -1
    /*
     kernel[0] = 0.0/9.0;
     kernel[1] = -1.0/9.0;
     kernel[2] = 0.0/9.0;
     kernel[3] = -1.0/9.0;
     kernel[4] = 5.0/9.0;
     kernel[5] = -1.0/9.0;
     kernel[6] = 0.0/9.0;
     kernel[7] = -1.0/9.0;
     kernel[8] = 0.0/9.0;
     */
    /*
     //unknown
     kernel[0] = -0.5/16.0;
     kernel[1] = 0.0/16.0;
     kernel[2] = 0.0/16.0;
     kernel[3] = 0.0/16.0;
     kernel[4] = 2.0/16.0;
     kernel[5] = 0.0/16.0;
     kernel[6] = 0.0/16.0;
     kernel[7] = 0.0/16.0;
     kernel[8] = 2.0/16.0;
     */

    TEVec3 vec;
    TERenderPrimative primative;
    for (int i = 0;i < primativeCount;++i) {
        primative = primatives[i];
        vec = primative.position;
        glBindTexture(GL_TEXTURE_2D, primative.textureName);
        glVertexAttrib2f(coordsHandle, vec.x, vec.y);
        glVertexAttribPointer(textureHandle, 2, GL_FLOAT, false, 0, primative.textureBuffer);
        glVertexAttribPointer(positionHandle, 2, GL_FLOAT, false, 0, primative.vertexBuffer);
        glUniform2fv(offsetHandle, OFFSET_COUNT, &offsets[0]);
        glUniform1fv(kernelHandle, OFFSET_COUNT, (float*)primative.extraData);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    }
    deactivate();
}
