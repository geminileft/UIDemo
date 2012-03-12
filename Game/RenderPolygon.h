#ifndef RENDERPOLYGON
#define RENDERPOLYGON

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;

class RenderPolygon : public TEComponentRender {
private:
	float mWidth;
	float mHeight;
    float mR;
    float mG;
    float mB;
    float mA;
    int mVertexCount;
    float *mVertices;

public:
    RenderPolygon(TESize size, TEColor4 color);
    virtual void update();
    virtual void draw();
	void moveToTopListener();
    void setColor(TEColor4 color);
};
#endif