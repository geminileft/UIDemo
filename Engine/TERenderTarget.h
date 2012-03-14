#ifndef TERENDERTARGET
#define TERENDERTARGET


#include "TETypes.h"

class TERenderTarget {
private:
    uint mFrameBuffer;
    float mFrameWidth;
    float mFrameHeight;
    
public:
    TERenderTarget(uint frameBuffer);
    
    void setSize(TESize size);
    uint getFrameBuffer() const;
    float getFrameWidth() const;
    float getFrameHeight() const;
};

#endif