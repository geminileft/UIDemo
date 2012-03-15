#ifndef TERENDERTARGET
#define TERENDERTARGET


#include "TETypes.h"
#include <vector>

class TERenderTarget {
private:
    uint mFrameBuffer;
    float mFrameWidth;
    float mFrameHeight;
    std::vector<TERenderTexturePrimative> mTexturePrimatives;
    std::vector<TERenderPolygonPrimative> mPolygonPrimatives;

public:
    TERenderTarget(uint frameBuffer);
    
    void setSize(TESize size);
    uint getFrameBuffer() const;
    float getFrameWidth() const;
    float getFrameHeight() const;
    void addTexturePrimative(TERenderTexturePrimative primative);
    void addPolygonPrimative(TERenderPolygonPrimative primative);
    void resetPrimatives();
};

#endif