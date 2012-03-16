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
#include "TEManagerTime.h"

TERendererOGL2::TERendererOGL2(CALayer* eaglLayer, uint width, uint height) {
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
    
    mScreenTarget = new TERenderTarget(screenFrameBuffer);
    mScreenTarget->setSize(TESizeMake(screenWidth, screenHeight));
    
    [EAGLContext setCurrentContext:mContext];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    createPrograms();
}

void TERendererOGL2::createPrograms() {
    String vertexSource;
    String fragmentSource;
    TERendererProgram* rp;
    
    vertexSource = TEManagerFile::readFileContents("texture.vs");
    fragmentSource = TEManagerFile::readFileContents("texture.fs");
    rp = new TERendererTexture(vertexSource, fragmentSource);
    mShaderPrograms[ShaderTexture] = rp;
    rp->addAttribute("aVertices");
    rp->addAttribute("aTextureCoords");
    
    fragmentSource = TEManagerFile::readFileContents("blur.fs");
    rp = new TERendererKernel(vertexSource, fragmentSource);
    mShaderPrograms[ShaderKernel] = rp;
    rp->addAttribute("aVertices");
    rp->addAttribute("aTextureCoords");
    
    vertexSource = TEManagerFile::readFileContents("colorbox.vs");
    fragmentSource = TEManagerFile::readFileContents("colorbox.fs");
    rp = new TERendererBasic(vertexSource, fragmentSource);
    mShaderPrograms[ShaderPolygon] = rp;
    rp->addAttribute("aVertices");
}

void TERendererOGL2::render() {
    TERenderTarget* rt;
    
    std::map<uint, TERenderTarget*> targets = getTargets();
    uint targetCount = targets.size();
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    if (targetCount > 0) {
        std::map<uint, TERenderTarget*>::iterator iterator;
        for (iterator = targets.begin(); iterator != targets.end(); iterator++) {
            rt = (*iterator).second;
            runTargetShaders(rt);
        }
    }
    
    rt = mScreenTarget;
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    
    runTargetShaders(rt);
    
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}

void TERendererOGL2::runTargetShaders(TERenderTarget* target) {
    TEShaderData* shaderData;
    TEShaderData shader;
    uint count;
    TERendererProgram* rp;
    
    target->activate();
    glClear(GL_COLOR_BUFFER_BIT);
    shaderData = target->getShaderData(count);
    for (uint i = 0; i < count; ++i) {
        shader = shaderData[i];
        rp = mShaderPrograms[shader.type];
        if (rp != NULL) {
            rp->activate(target);
            rp->run(target, shader.primatives, shader.primativeCount);
        } else {
            NSLog(@"Hrm.");
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
