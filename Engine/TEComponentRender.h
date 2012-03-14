#ifndef TECOMPONENTRENDER
#define TECOMPONENTRENDER

#include "TEComponent.h"

class TERenderer;
class TERenderTarget;

class TEComponentRender : public TEComponent {
private:
    TERenderTarget* mTarget;
    
public:
	virtual void draw() = 0;
    static TERenderer* sharedRenderer();
    static void setSharedRenderer(TERenderer* renderer);
    void setRenderTarget(TERenderTarget* target);
    TERenderTarget* getRenderTarget();
};

#endif