#ifndef TECOMPONENTRENDER
#define TECOMPONENTRENDER

#include "TEComponent.h"

class TERenderer;
class TERenderTarget;

class TEComponentRender : public TEComponent {
private:
    TERenderTarget* mTarget;
    void* mExtra;
    TEShaderType mExtraType;
    
    void clearExtra();

public:
    TEComponentRender();
	virtual void draw() = 0;
    static TERenderer* sharedRenderer();
    static void setSharedRenderer(TERenderer* renderer);
    void setRenderTarget(TERenderTarget* target);
    TERenderTarget* getRenderTarget();
    void setKernel(float* kernel);
    void setTransparentColor(TEColor4* color);
    void setGrayscale();
    void setSepia();
    void setNegative();
    void setYellow();
    float* getExtraData() const;
    TEShaderType getExtraType();
};

#endif