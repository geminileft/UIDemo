#ifndef RENDERBOX
#define RENDERBOX

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;

class RenderBox : public TEComponentRender {
private:
	float mWidth;
	float mHeight;
    float mX;
    float mY;
    float mR;
    float mG;
    float mB;
    float mA;
    
public:
    RenderBox(TEPoint position, TESize size, TEColor4 color);
    virtual void update();
    virtual void draw();
	void moveToTopListener();
};
#endif