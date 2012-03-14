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
#include "TERendererTexture.h"
#include "TERendererKernel.h"

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
    uint screenFrameBuffer;
    glGenFramebuffers(1, &screenFrameBuffer);
    setScreenFrameBuffer(screenFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, screenFrameBuffer);
    
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

    glBindFramebuffer(GL_FRAMEBUFFER, screenFrameBuffer);
    
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
    
    target = new TERenderTarget(screenFrameBuffer);
    target->setSize(TESizeMake(screenWidth, screenHeight));
    setTarget(screenFrameBuffer, target);
    //setScreenAdjustment(screenWidth, screenHeight);
    
    [EAGLContext setCurrentContext:mContext];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f); 
    createPrograms();
}

void TERendererOGL2::createPrograms() {
    String vertexSource;
    String fragmentSource;
    TERendererProgram* rp;
    
    vertexSource = TEManagerFile::readFileContents("texture.vs");
    fragmentSource = TEManagerFile::readFileContents("texture.fs");
    rp = new TERendererTexture(vertexSource, fragmentSource);
    mShaderPrograms["texture"] = rp;
    rp->addAttribute("aVertices");
    rp->addAttribute("aTextureCoords");
    
    fragmentSource = TEManagerFile::readFileContents("blur.fs");
    rp = new TERendererKernel(vertexSource, fragmentSource);
    mShaderPrograms["kernel"] = rp;
    rp->addAttribute("aVertices");
    rp->addAttribute("aTextureCoords");
    
    vertexSource = TEManagerFile::readFileContents("colorbox.vs");
    fragmentSource = TEManagerFile::readFileContents("colorbox.fs");
    rp = new TERendererBasic(vertexSource, fragmentSource);
    mShaderPrograms["basic"] = rp;
    rp->addAttribute("aVertices");
}

void TERendererOGL2::render() {
    TERenderTarget* rt;
    TERendererProgram* rp;
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    if (mUseRenderToTexture) {
        rt = getTarget(mTextureFrameBuffer);
    } else {
        rt = getTarget(getScreenFrameBuffer());
    }

    uint count = getPolygonCount();
    TERenderPolygonPrimative* primatives = getPolygonPrimatives();
    rp = mShaderPrograms["basic"];
    rp->run(rt, primatives, count);

    /************************
     RENDER TO TEXTURE
    *************************/
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
    const float bottomY = -var;
    const float rightX = var;
    const float topY = var;
    
    vertexBuffer[0] = leftX;
	vertexBuffer[1] = bottomY;
	vertexBuffer[2] = rightX;
	vertexBuffer[3] = bottomY;
	vertexBuffer[4] = rightX;
	vertexBuffer[5] = topY;
	vertexBuffer[6] = leftX;
	vertexBuffer[7] = topY;
    TEVec3 vec;
    vec.x = 0;
    vec.y = -160;
    uint screenFrameBuffer = getScreenFrameBuffer();
    rt = getTarget(screenFrameBuffer);
    addTexture(rt, mTextureFrameBufferHandle, vertexBuffer, textureBuffer, vec);

    rt = getTarget(screenFrameBuffer);
    rp = mShaderPrograms["kernel"];
    rp->run(rt, getRenderPrimatives(), getPrimativeCount());
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}

void TERendererOGL2::checkGlError(String op) {
    uint error;
    while ((error = glGetError()) != GL_NO_ERROR) {
        if (error == GL_INVALID_ENUM) {
            NSLog(@"Bad");
        }
    }
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
