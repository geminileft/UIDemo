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
    uint mCoordsHandle;
    uint maPositionHandle;
    uint maTextureHandle;
    int mWidth;
    int mHeight;
    std::map<String, TERendererProgram*> mShaderPrograms;
    
    static void checkGlError(String op);
    void createPrograms();
    void createRenderToTexture(uint currentFrameBuffer);

public:
    TERendererOGL2(CALayer* eaglLayer, uint width, uint height);
    virtual void render();
};

#endif
