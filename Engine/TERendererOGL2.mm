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
#include "TERendererBasic.h"
#include "TERenderTarget.h"

static std::map<String, uint> mPrograms;

TERendererOGL2::TERendererOGL2(CALayer* eaglLayer, uint width, uint height) {
    TERenderTarget* target;

    mUseRenderToTexture = YES;
    mTextureLength = 1024;
    mWidth = width;
    mHeight = height;

    // Make sure this is the right version!
    mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!mContext || ![EAGLContext setCurrentContext:mContext]) {
    }
    
    glGenFramebuffers(1, &mScreenFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, mScreenFrameBuffer);
    
    /******************************
    NEEDED FOR RENDER TO TEXTURE
    *******************************/
    glGenTextures(1, &mTextureFrameBufferHandle);
    glBindTexture(GL_TEXTURE_2D, mTextureFrameBufferHandle);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, mTextureLength, mTextureLength, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glGenFramebuffers(1, &mTextureFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER_OES, mTextureFrameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, mTextureFrameBufferHandle, 0);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER); 
    if(status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x", status);
    }
    
    target = new TERenderTarget(mTextureFrameBuffer);
    target->setSize(TESizeMake(mTextureLength, mTextureLength));
    setTarget(mTextureFrameBuffer, target);
    /******************************
     NEEDED FOR RENDER TO TEXTURE
     *******************************/

    glBindFramebuffer(GL_FRAMEBUFFER, mScreenFrameBuffer);
    
    glGenRenderbuffers(1, &mRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, mRenderBuffer);
    [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)eaglLayer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mRenderBuffer);    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed!!");
    }
    
    int screenWidth, screenHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &screenWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &screenHeight);
    
    target = new TERenderTarget(mScreenFrameBuffer);
    target->setSize(TESizeMake(screenWidth, screenHeight));
    setTarget(mScreenFrameBuffer, target);
    //setScreenAdjustment(screenWidth, screenHeight);
    
    [EAGLContext setCurrentContext:mContext];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f); 
    createPrograms();
}

void TERendererOGL2::createPrograms() {
    TEShaderProgram program;
    String vertexSource;
    String fragmentSource;
    vertexSource = TEManagerFile::readFileContents("texture.vs");
    fragmentSource = TEManagerFile::readFileContents("texture.fs");
    program = TERendererOGL2::createProgram("texture", vertexSource, fragmentSource);
    addProgramAttribute(program.programId, "aVertices");
    addProgramAttribute(program.programId, "aTextureCoords");
    
    vertexSource = TEManagerFile::readFileContents("texture.vs");
    fragmentSource = TEManagerFile::readFileContents("toon.fs");
    program = TERendererOGL2::createProgram("blur", vertexSource, fragmentSource);
    addProgramAttribute(program.programId, "aVertices");
    addProgramAttribute(program.programId, "aTextureCoords");
    
    vertexSource = TEManagerFile::readFileContents("colorbox.vs");
    fragmentSource = TEManagerFile::readFileContents("colorbox.fs");
    mBasicProgram = new TERendererBasic(vertexSource, fragmentSource);
    //program = TERendererOGL2::createProgram("basic", vertexSource, fragmentSource);
    mBasicProgram->addAttribute("aVertices");
    //addProgramAttribute(program.programId, "aVertices");
}

void TERendererOGL2::render() {
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    TEFBOTarget target;
    TERenderTarget* rt;
    if (mUseRenderToTexture) {
        rt = getTarget(mTextureFrameBuffer);
    } else {
        rt = getTarget(mScreenFrameBuffer);
    }

    uint count = getPolygonCount();
    TERenderPolygonPrimative* primatives = getPolygonPrimatives();
    mBasicProgram->run(rt, primatives, count);

    target.frameBuffer = mScreenFrameBuffer;
    target.width = mWidth;
    target.height = mHeight;
    //mBasicProgram->run(target, primatives, count);
    renderTexture(target);
    //renderBlur(target);
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}

void TERendererOGL2::renderTexture(TEFBOTarget target) {
    String programName = "texture";
    uint simpleProgram = switchProgram(programName, target);
    uint positionHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aVertices");
    uint textureHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aTextureCoords");
    uint coordsHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aPosition");
    uint alphaHandle = TERendererOGL2::getUniformLocation(simpleProgram, "uAlpha");
    

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
    const float leftX = -var;
    const float bottomY = -var - 160;
    const float rightX = var;
    const float topY = var - 160;
    
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

    TERenderTexturePrimative* primatives = getRenderPrimatives();
    uint count = getPrimativeCount();
    TEVec3 vec;
    for (int i = 0;i < count;++i) {
        vec = primatives[i].position;
        glBindTexture(GL_TEXTURE_2D, primatives[i].textureName);
        glVertexAttrib2f(coordsHandle, vec.x, vec.y);
        glVertexAttribPointer(textureHandle, 2, GL_FLOAT, false, 0, primatives[i].textureBuffer);
        glVertexAttribPointer(positionHandle, 2, GL_FLOAT, false, 0, primatives[i].vertexBuffer);
        glUniform1f(alphaHandle, 1.0);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    }

    stopProgram(programName);
}

void TERendererOGL2::renderBlur(TEFBOTarget target) {
    String programName = "blur";
    uint simpleProgram = switchProgram(programName, target);
    uint positionHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aVertices");
    uint textureHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aTextureCoords");
    uint coordsHandle = TERendererOGL2::getAttributeLocation(simpleProgram, "aPosition");
    uint offsetHandle = TERendererOGL2::getUniformLocation(simpleProgram, "uOffsets");
    uint kernelHandle = TERendererOGL2::getUniformLocation(simpleProgram, "uKernel");
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
    /*
     kernel[0] = 1.0/9.0;
     kernel[1] = 1.0/9.0;
     kernel[2] = 1.0/9.0;
     kernel[3] = 1.0/9.0;
     kernel[4] = 1.0/9.0;
     kernel[5] = 1.0/9.0;
     kernel[6] = 1.0/9.0;
     kernel[7] = 1.0/9.0;
     kernel[8] = 1.0/9.0;
     */
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

     kernel[0] = -1.0/9.0;
     kernel[1] = -1.0/9.0;
     kernel[2] = -1.0/9.0;
     kernel[3] = -1.0/9.0;
     kernel[4] = 8.0/9.0;
     kernel[5] = -1.0/9.0;
     kernel[6] = -1.0/9.0;
     kernel[7] = -1.0/9.0;
     kernel[8] = -1.0/9.0;

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
    
    TERenderTexturePrimative* primatives = getRenderPrimatives();
    uint count = getPrimativeCount();
    TEVec3 vec;
    for (int i = 0;i < count;++i) {
        vec = primatives[i].position;
        glBindTexture(GL_TEXTURE_2D, primatives[i].textureName);
        glVertexAttrib2f(coordsHandle, vec.x, vec.y);
        glVertexAttribPointer(textureHandle, 2, GL_FLOAT, false, 0, primatives[i].textureBuffer);
        glVertexAttribPointer(positionHandle, 2, GL_FLOAT, false, 0, primatives[i].vertexBuffer);
        glUniform2fv(offsetHandle, OFFSET_COUNT, &offsets[0]);
        glUniform1fv(kernelHandle, OFFSET_COUNT, &kernel[0]);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    }
    stopProgram(programName);
}

TEShaderProgram TERendererOGL2::createProgram(String programName, String vertexSource, String fragmentSource) {
    uint programId = glCreateProgram();
    //NSAssert(program != 0, @"Failed to create program");
    checkGlError("created program");
    mPrograms[programName] = programId;
    uint vertexShader = loadShader(GL_VERTEX_SHADER, vertexSource);
    glAttachShader(programId, vertexShader);
    checkGlError("attached shader");
    uint fragmentShader = loadShader(GL_FRAGMENT_SHADER, fragmentSource);
    glAttachShader(programId, fragmentShader);
    checkGlError("attached shader");
    glLinkProgram(programId);
    checkGlError("linked program");
    int linkStatus[1];
    glGetProgramiv(programId, GL_LINK_STATUS, linkStatus);
    if (linkStatus[0] != GL_TRUE) {
        NSLog(@"Error");
        glDeleteProgram(programId);
        programId = 0;
    }
    TEShaderProgram program;
    program.programId = programId;
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

uint TERendererOGL2::switchProgram(String programName, TEFBOTarget target) {
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
    
    glViewport(0, 0, target.width, target.height);
    glBindFramebuffer(GL_FRAMEBUFFER, target.frameBuffer);

    float proj[16];
    float trans[16];
    float view[16];
    float rotate[16];
    float angle;
    float zDepth;
    float ratio;
    
    zDepth = (float)target.height / 2;
    ratio = (float)target.width/(float)target.height;
    
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
