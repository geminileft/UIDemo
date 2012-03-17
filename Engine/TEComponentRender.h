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
    
public:
    TEComponentRender();
	virtual void draw() = 0;
    static TERenderer* sharedRenderer();
    static void setSharedRenderer(TERenderer* renderer);
    void setRenderTarget(TERenderTarget* target);
    TERenderTarget* getRenderTarget();
    void setKernel(float* kernel);
    float* getExtraData() const;
    void setExtraType(TEShaderType extraType);
    TEShaderType getExtraType();
};

#endif