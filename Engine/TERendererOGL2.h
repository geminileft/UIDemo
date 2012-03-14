#ifndef TouchEngine_TERendererOGL2_h
#define TouchEngine_TERendererOGL2_h

#include "TERenderer.h"
#include "TETypes.h"
#include <map>
#include <list>
#import <QuartzCore/QuartzCore.h>

class TERendererProgram;
class TERenderTarget;

class TERendererOGL2 : public TERenderer {
private:
    bool mUseRenderToTexture;
    
    EAGLContext* mContext;
    uint mRenderBuffer;
    uint mScreenFrameBuffer;
    uint mCoordsHandle;
    uint maPositionHandle;
    uint maTextureHandle;
    uint mTextureFrameBuffer;
    uint mTextureFrameBufferHandle;
    float mTextureLength;
    int mWidth;
    int mHeight;
    uint mTexture;
    std::map<uint, std::list<String> > mProgramAttributes;
    bool mRotate;
    std::map<String, TERendererProgram*> mShaderPrograms;
    
    void addProgramAttribute(uint program, String attribute);
    uint switchProgram(String programName, TERenderTarget* target);
    void stopProgram(String programName);
    static void checkGlError(String op);
    
    void setScreenAdjustment(int width, int height);
    void createPrograms();
    
public:
    TERendererOGL2(CALayer* eaglLayer, uint width, uint height);
    virtual void render();
    static uint loadShader(uint shaderType, String source);
    static uint getAttributeLocation(uint program, String attribute);
    static uint getUniformLocation(uint program, String uniform);
};

#endif
