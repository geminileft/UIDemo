#ifndef TERENDERTARGET
#define TERENDERTARGET


#include "TETypes.h"
#include <vector>
#include <QuartzCore/QuartzCore.h>
/*
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
*/

class TERenderTarget {
private:
    uint mFrameBuffer;
    float mFrameWidth;
    float mFrameHeight;
    std::vector<TERenderTexturePrimative> mTexturePrimatives;
    std::vector<TERenderPolygonPrimative> mPolygonPrimatives;
    TERenderTexturePrimative* mFrameTexturePrimatives;
    TERenderPolygonPrimative* mFramePolygonPrimatives;
    uint mTextureCount;
    uint mPolygonCount;
    float mProjMatrix[16];
    float mViewMatrix[16];

public:
    TERenderTarget(uint frameBuffer);
    
    void setSize(TESize size);
    uint getFrameBuffer() const;
    float getFrameWidth() const;
    float getFrameHeight() const;
    void addTexturePrimative(TERenderTexturePrimative primative);
    void addPolygonPrimative(TERenderPolygonPrimative primative);
    void resetPrimatives();
    TERenderTexturePrimative* getTexturePrimatives(uint &count);
    TERenderPolygonPrimative* getPolygonPrimatives(uint &count);
    void activate();
    float* getProjMatrix();
    float* getViewMatrix();
};

#endif