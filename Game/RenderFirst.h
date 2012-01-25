#ifndef RENDERFIRST
#define RENDERFIRST

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;

class RenderFirst : public TEComponentRender {
private:
	TEUtilTexture* mTexture;
	int mCrop[4];
	int mWidth;
	int mHeight;
    uint mProgram;
    uint mCoordsHandle;
    uint maPositionHandle;
    uint maTextureHandle;
    
    
public:
    RenderFirst(NSString* resourceName, TEPoint position, TESize size);
    virtual void update();
    virtual void draw();
	void moveToTopListener();
	TESize getSize();
};
#endif