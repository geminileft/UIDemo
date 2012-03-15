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
    setScreenTarget(target);
    
    [EAGLContext setCurrentContext:mContext];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    
    createPrograms();
    createRenderToTexture(screenFrameBuffer);    
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
    TERenderTexturePrimative* rtp;
    uint count;
    TERenderPolygonPrimative* primatives;
    
    //uint count = getPolygonCount();
    //TERenderPolygonPrimative* primatives = getPolygonPrimatives();
    rp = mShaderPrograms["basic"];

    std::map<uint, TERenderTarget*> targets = getTargets();
    uint targetCount = targets.size();

    if (targetCount > 0) {
        std::map<uint, TERenderTarget*>::iterator iterator;
        for (iterator = targets.begin(); iterator != targets.end(); iterator++) {
            rt = (*iterator).second;
            primatives = rt->getPolygonPrimatives(count);
            if (count > 0) {
                rp->run(rt, primatives, count);
                //NSLog(@"We have something!");
            }
        }
    }
    
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
    
    rp = mShaderPrograms["kernel"];
    rt = getScreenTarget();
    rp->activate(rt);
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    

    if (mUseRenderToTexture)
        addTexture(rt, getTextureFrameBufferHandle(), vertexBuffer, textureBuffer, vec);

    uint primativeCount;
    rtp = rt->getTexturePrimatives(primativeCount);
    rp->run(rt, rtp, primativeCount);
    
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

void TERendererOGL2::createRenderToTexture(uint currentFrameBuffer) {
    TERenderTarget* target;
    uint handle;
    target = createRenderTarget(handle, mTextureLength);
    setTextureFrameBufferHandle(handle);
    setTextureTarget(target);
    setTarget(target->getFrameBuffer(), target);
    glBindFramebuffer(GL_FRAMEBUFFER, currentFrameBuffer);
}
