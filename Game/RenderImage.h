#ifndef RENDERIMAGE
#define RENDERIMAGE

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;

class RenderImage : public TEComponentRender {
private:
	TEUtilTexture* mTexture;
	int mWidth;
	int mHeight;
    uint mTextureName;
    float mVertexBuffer[8];
    float mTextureBuffer[8];

public:
    RenderImage(NSString* resourceName, TEPoint position, TESize size);
    virtual void update();
    virtual void draw();
	void moveToTopListener();
};
#endif
