#ifndef TERENDERTARGET
#define TERENDERTARGET


#include "TETypes.h"
#include <vector>
#include <map>

struct TEShaderData {
    TEShaderType type;
    TERenderPrimative* primatives;
    uint primativeCount;
};

typedef struct TEShaderData TEShaderData;

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
    std::map<TEShaderType, std::vector<TERenderPrimative> > mShaders;
    TEShaderData* mShaderData;

public:
    TERenderTarget(uint frameBuffer);
    
    void setSize(TESize size);
    uint getFrameBuffer() const;
    float getFrameWidth() const;
    float getFrameHeight() const;
    void addPrimative(TERenderPrimative primative);
    void addTexturePrimative(TERenderTexturePrimative primative);
    void addPolygonPrimative(TERenderPolygonPrimative primative);
    void resetPrimatives();
    TERenderTexturePrimative* getTexturePrimatives(uint &count);
    TERenderPolygonPrimative* getPolygonPrimatives(uint &count);
    void activate();
    float* getProjMatrix();
    float* getViewMatrix();
    TEShaderData* getShaderData(uint &count);
};

#endif