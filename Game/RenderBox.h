#ifndef RENDERBOX
#define RENDERBOX

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;

class RenderBox : public TEComponentRender {
private:
	int mWidth;
	int mHeight;    
    
public:
    RenderBox(TEPoint position, TESize size);
    virtual void update();
    virtual void draw();
	void moveToTopListener();
};
#endif