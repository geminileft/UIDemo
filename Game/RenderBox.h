#ifndef RENDERBOX
#define RENDERBOX

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;

class RenderBox : public TEComponentRender {
private:
	float mWidth;
	float mHeight;
    float mR;
    float mG;
    float mB;
    float mA;
    float mVertices[10];
    
public:
    RenderBox(TESize size, TEColor4 color);
    virtual void update();
    virtual void draw();
	void moveToTopListener();
};
#endif