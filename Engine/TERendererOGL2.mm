#include "TERendererOGL2.h"
#include <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "TEManagerFile.h"
#include "TEManagerTexture.h"
#include "TEUtilTexture.h"
#include "TEUtilMatrix.h"


static std::map<String, uint> mPrograms;

TERendererOGL2::TERendererOGL2(CALayer* eaglLayer, uint width, uint height) {
    mWidth = width;
    mHeight = height;

    // Make sure this is the right version!
    mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!mContext || ![EAGLContext setCurrentContext:mContext]) {
    }
    
    glGenFramebuffersOES(1, &mFrameBuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, mFrameBuffer);
    
    /******************************
    NEEDED FOR RENDER TO TEXTURE
    *******************************/
    glGenFramebuffersOES(1, &mTextureFrameBuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, mTextureFrameBuffer);
    glGenTextures(1, &mTextureFrameBufferHandle);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 
                 1024, 1024, 0, GL_RGBA, 
                 GL_UNSIGNED_BYTE, NULL);
    glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, mTextureFrameBufferHandle, 0);
    /******************************
     NEEDED FOR RENDER TO TEXTURE
     *******************************/

    glBindFramebufferOES(GL_FRAMEBUFFER_OES, mFrameBuffer);
    
    glGenRenderbuffersOES(1, &mRenderBuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, mRenderBuffer);
    [mContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)eaglLayer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, mRenderBuffer);    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"Failed!!");
    }
    
    int screenWidth, screenHeight;
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &screenWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &screenHeight);
    setScreenAdjustment(screenWidth, screenHeight);
    
    //glBindFramebufferOES(GL_FRAMEBUFFER_OES, mFrameBuffer);
    [EAGLContext setCurrentContext:mContext];
    
    glViewport(0, 0, screenWidth, screenHeight);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    
    int program;
    String vertexSource;
    String fragmentSource;
    
    vertexSource = TEManagerFile::readFileContents("texture.vs");
    fragmentSource = TEManagerFile::readFileContents("texture.fs");
    program = TERendererOGL2::createProgram("texture", vertexSource, fragmentSource);
    addProgramAttribute(program, "aVertices");
    addProgramAttribute(program, "aTextureCoords");
    
    vertexSource = TEManagerFile::readFileContents("colorbox.vs");
    fragmentSource = TEManagerFile::readFileContents("colorbox.fs");
    program = TERendererOGL2::createProgram("basic", vertexSource, fragmentSource);
    addProgramAttribute(program, "aVertices");
}

void TERendererOGL2::render() {
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
/*
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, mTextureFrameBuffer);
    glClearColor(1, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
*/
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, mFrameBuffer);
    renderBasic();
    renderTexture();
    [mContext presentRenderbuffer:GL_RENDERBUFFER_OES];
}

void TERendererOGL2::renderBasic() {
    String programName = "basic";
    uint program = switchProgram(programName);
    
    uint m_a_positionHandle = TERendererOGL2::getAttributeLocation(program, "aVertices");
    uint colorHandle = TERendererOGL2::getUniformLocation(program, "aColor");
    uint posHandle = TERendererOGL2::getAttributeLocation(program, "aPosition");
        
    uint count = getPolygonCount();
    TERenderPolygonPrimative* primatives = getPolygonPrimatives();
    TERenderPolygonPrimative p;

    for (int i = 0;i < count;++i) {
        p = primatives[i];

        glVertexAttribPointer(m_a_positionHandle, 2, GL_FLOAT, GL_FALSE, 0, &p.vertexBuffer[0]);
        glUniform4f(colorHandle, p.color.r, p.color.g, p.color.b, p.color.a);
        glVertexAttrib2f(posHandle, p.position.x, p.position.y);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);        
    }
    
    stopProgram(programName);
}

void TERendererOGL2::renderTexture() {
    String programName = "texture";
    uint simpleProgram = switchProgram(programName);
    
    uint positionHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aVertices");
    uint textureHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aTextureCoords");
    uint coordsHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aPosition");
    
    TERenderTexturePrimative* primatives = getRenderPrimatives();
    uint count = getPrimativeCount();
    TEVec3 vec;
    for (int i = 0;i < count;++i) {
        vec = primatives[i].position;
        glBindTexture(GL_TEXTURE_2D, primatives[i].textureName);
        glVertexAttrib2f(coordsHandle, vec.x, vec.y);
        glVertexAttribPointer(textureHandle, 2, GL_FLOAT, false, 0, primatives[i].textureBuffer);
        glVertexAttribPointer(positionHandle, 2, GL_FLOAT, false, 0, primatives[i].vertexBuffer);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    }
    /*
    glBindTexture(GL_TEXTURE_2D, mTextureFrameBufferHandle);
    glVertexAttrib2f(coordsHandle, 0, 0);
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
    const float leftX = -240.0;
    const float bottomY = -160.0;
    const float rightX = 0.0;
    const float topY = 240.0;
    
    vertexBuffer[0] = leftX;
	vertexBuffer[1] = bottomY;
	vertexBuffer[2] = rightX;
	vertexBuffer[3] = bottomY;
	vertexBuffer[4] = rightX;
	vertexBuffer[5] = topY;
	vertexBuffer[6] = leftX;
	vertexBuffer[7] = topY;

    glVertexAttribPointer(textureHandle, 2, GL_FLOAT, false, 0, textureBuffer);
    glVertexAttribPointer(positionHandle, 2, GL_FLOAT, false, 0, vertexBuffer);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    */
    stopProgram(programName);
}

int TERendererOGL2::createProgram(String programName, String vertexSource, String fragmentSource) {
    uint program = glCreateProgram();
    //NSAssert(program != 0, @"Failed to create program");
    checkGlError("created program");
    mPrograms[programName] = program;
    uint vertexShader = loadShader(GL_VERTEX_SHADER, vertexSource);
    glAttachShader(program, vertexShader);
    checkGlError("attached shader");
    uint fragmentShader = loadShader(GL_FRAGMENT_SHADER, fragmentSource);
    glAttachShader(program, fragmentShader);
    checkGlError("attached shader");
    glLinkProgram(program);
    checkGlError("linked program");
    int linkStatus[1];
    glGetProgramiv(program, GL_LINK_STATUS, linkStatus);
    if (linkStatus[0] != GL_TRUE) {
        NSLog(@"Error");
        glDeleteProgram(program);
        program = 0;
    }
    return program;
}

void TERendererOGL2::addProgramAttribute(uint program, String attribute) {
    std::list<String> list = mProgramAttributes[program];
    list.push_back(attribute);
    mProgramAttributes[program] = list;
}

uint TERendererOGL2::loadShader(uint shaderType, String source) {
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

uint TERendererOGL2::switchProgram(String programName) {
    uint program = mPrograms[programName];
    glUseProgram(program);
    checkGlError("glUseProgram");
    
    if (mProgramAttributes.count(program) > 0) {
        std::list<String> list = mProgramAttributes[program];
        std::list<String>::iterator iterator;
        for (iterator = list.begin();iterator != list.end();++iterator) {
            uint handle = getAttributeLocation(program, (*iterator));
            glEnableVertexAttribArray(handle);
            checkGlError("glEnableVertexAttribArray");        		
        }
    }
    
    float proj[16];
    float trans[16];
    float view[16];
    float rotate[16];
    float angle;
    float zDepth;
    float ratio;
    
    zDepth = (float)mHeight / 2;
    ratio = (float)mWidth/(float)mHeight;
    if (mRotate) {
        angle = -90.0f;
        TEUtilMatrix::setFrustum(&proj[0], ColumnMajor, -1, 1, -ratio, ratio, 1.0f, 1000.0f);
    } else {
        angle = 0.0f;
        TEUtilMatrix::setFrustum(&proj[0], ColumnMajor, -ratio, ratio, -1, 1, 1.0f, 1000.0f);
    }

    TEUtilMatrix::setTranslate(&trans[0], ColumnMajor, 0.0f, 0.0f, -zDepth);
    TEUtilMatrix::setRotateZ(&rotate[0], ColumnMajor, deg2rad(angle));
    TEUtilMatrix::multiply(&view[0], ColumnMajor, rotate, trans);
    uint mProjHandle  = TERendererOGL2::getUniformLocation(program, "uProjectionMatrix");
    uint mViewHandle = TERendererOGL2::getUniformLocation(program, "uViewMatrix");
    glUniformMatrix4fv(mProjHandle, 1, GL_FALSE, &proj[0]);
    glUniformMatrix4fv(mViewHandle, 1, GL_FALSE, &view[0]);
    return program;
}

void TERendererOGL2::stopProgram(String programName) {
    uint program = mPrograms[programName];
    
    if (mProgramAttributes.count(program) > 0) {
        std::list<String> list = mProgramAttributes[program];
        std::list<String>::iterator iterator;
        for (iterator = list.begin();iterator != list.end();++iterator) {
            uint handle = getAttributeLocation(program, (*iterator));
            glDisableVertexAttribArray(handle);
            checkGlError("glDisableVertexAttribArray");
        }
    }
}

void TERendererOGL2::checkGlError(String op) {
    uint error;
    while ((error = glGetError()) != GL_NO_ERROR) {
        if (error == GL_INVALID_ENUM) {
            NSLog(@"Bad");
        }
    }
}

uint TERendererOGL2::getAttributeLocation(uint program, String attribute) {
    return glGetAttribLocation(program, attribute.c_str());
}

uint TERendererOGL2::getUniformLocation(uint program, String uniform) {
    return glGetUniformLocation(program, uniform.c_str());
}

void TERendererOGL2::setScreenAdjustment(int width, int height) {
    mRotate = false;
    if (mWidth > mHeight) {
        //game in landscape
        if (width > height) {
            //device in landscape
        } else {
            mRotate = true;
        }
    } else {
        //game in portrait
        if (width > height) {
            //device in landscape
            mRotate = true;
        }
    }
    NSLog(@"done");
}
