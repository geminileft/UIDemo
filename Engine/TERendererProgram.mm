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
    
    target->activate();    
    uint mProjHandle  = glGetUniformLocation(mProgramId, "uProjectionMatrix");
    uint mViewHandle = glGetUniformLocation(mProgramId, "uViewMatrix");
    glUniformMatrix4fv(mProjHandle, 1, GL_FALSE, target->getProjMatrix());
    glUniformMatrix4fv(mViewHandle, 1, GL_FALSE, target->getViewMatrix());
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
