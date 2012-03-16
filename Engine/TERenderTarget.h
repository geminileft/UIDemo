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
    void resetPrimatives();
    void activate();
    float* getProjMatrix();
    float* getViewMatrix();
    TEShaderData* getShaderData(uint &count);
};

#endif