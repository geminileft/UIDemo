#include "TERendererProgram.h"
#include "TEUtilMatrix.h"
#include "TERenderTarget.h"

TERendererProgram::TERendererProgram() {
}

TERendererProgram::TERendererProgram(String vertexSource, String fragmentSource) {
    mProgramId = glCreateProgram();
    //NSAssert(program != 0, @"Failed to create program");
    checkGlError("created program");
    uint vertexShader = loadShader(GL_VERTEX_SHADER, vertexSource);
    glAttachShader(mProgramId, vertexShader);
    checkGlError("attached shader");
    uint fragmentShader = loadShader(GL_FRAGMENT_SHADER, fragmentSource);
    glAttachShader(mProgramId, fragmentShader);
    checkGlError("attached shader");
    glLinkProgram(mProgramId);
    checkGlError("linked program");
    int linkStatus[1];
    glGetProgramiv(mProgramId, GL_LINK_STATUS, linkStatus);
    if (linkStatus[0] != GL_TRUE) {
        NSLog(@"Error");
        glDeleteProgram(mProgramId);
        mProgramId = 0;
    }
}

uint TERendererProgram::loadShader(uint shaderType, String source) {
    uint shader = glCreateShader(shaderType);
    if (shader == 0) {
        NSLog(@"Big problem!");
    }
    const char* str = source.c_str();
    glShaderSource(shader, 1, &str, NULL);
    checkGlError("shader source");
    glCompileShader(shader);
    checkGlError("compile source");
    return shader;
}

void TERendererProgram::checkGlError(String op) {
    uint error;
    while ((error = glGetError()) != GL_NO_ERROR) {
        if (error == GL_INVALID_ENUM) {
            NSLog(@"Bad");
        }
    }
}

void TERendererProgram::addAttribute(String attribute) {
    mAttributes.push_back(attribute);
}

uint TERendererProgram::activate(TERenderTarget* target) {
    glUseProgram(mProgramId);
    checkGlError("glUseProgram");
    
    if (mAttributes.size() > 0) {
        std::list<String>::iterator iterator;
        for (iterator = mAttributes.begin();iterator != mAttributes.end();++iterator) {
            uint handle = glGetAttribLocation(mProgramId, (*iterator).c_str());
            glEnableVertexAttribArray(handle);
            checkGlError("glEnableVertexAttribArray");        		
        }
    }
    
    const float width = target->getFrameWidth();
    const float height = target->getFrameHeight();
    glViewport(0, 0, width, height);
    glBindFramebuffer(GL_FRAMEBUFFER, target->getFrameBuffer());
    
    float proj[16];
    float trans[16];
    float view[16];
    float rotate[16];
    float angle;
    float zDepth;
    float ratio;
    
    zDepth = (float)height / 2;
    ratio = (float)width/(float)height;
    
    if (false) {
        angle = -90.0f;
        TEUtilMatrix::setFrustum(&proj[0], ColumnMajor, -1, 1, -ratio, ratio, 1.0f, 1000.0f);
    } else {
        angle = 0.0f;
        TEUtilMatrix::setFrustum(&proj[0], ColumnMajor, -ratio, ratio, -1, 1, 1.0f, 1000.0f);
    }
    
    TEUtilMatrix::setTranslate(&trans[0], ColumnMajor, 0.0f, 0.0f, -zDepth);
    TEUtilMatrix::setRotateZ(&rotate[0], ColumnMajor, deg2rad(angle));
    TEUtilMatrix::multiply(&view[0], ColumnMajor, rotate, trans);
    
    uint mProjHandle  = glGetUniformLocation(mProgramId, "uProjectionMatrix");
    uint mViewHandle = glGetUniformLocation(mProgramId, "uViewMatrix");
    glUniformMatrix4fv(mProjHandle, 1, GL_FALSE, &proj[0]);
    glUniformMatrix4fv(mViewHandle, 1, GL_FALSE, &view[0]);
    return mProgramId;
}

void TERendererProgram::deactivate() {
    if (mAttributes.size() > 0) {
        std::list<String>::iterator iterator;
        for (iterator = mAttributes.begin();iterator != mAttributes.end();++iterator) {
            uint handle = glGetAttribLocation(mProgramId, (*iterator).c_str());
            glDisableVertexAttribArray(handle);
            checkGlError("glDisableVertexAttribArray");
        }
    }
}

uint TERendererProgram::getProgramId() const {
    return mProgramId;
}

void TERendererProgram::run(TERenderTarget* target, TERenderPolygonPrimative* primatives, uint primativeCount) {}
void TERendererProgram::run(TERenderTarget* target, TERenderTexturePrimative* primatives, uint primativeCount) {}

