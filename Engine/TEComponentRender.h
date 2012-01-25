#ifndef TECOMPONENTRENDER
#define TECOMPONENTRENDER

#include "TEComponent.h"

class TERenderer;

class TEComponentRender : public TEComponent {
public:
	virtual void draw() = 0;
    static TERenderer* sharedRenderer();
    static void setSharedRenderer(TERenderer* renderer);
};

#endif