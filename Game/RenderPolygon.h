#ifndef RENDERPOLYGON
#define RENDERPOLYGON

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;

class RenderPolygon : public TEComponentRender {
private:
    float mR;
    float mG;
    float mB;
    float mA;
    int mVertexCount;
    float *mVertices;
    TERenderPrimative mRenderPrimative;

public:
    RenderPolygon();
    ~RenderPolygon();
    virtual void update();
    virtual void draw();
	void moveToTopListener();
    void setColor(TEColor4 color);
    void setColorData(TEColor4* data, size_t count);
    void setVertices(float* vertices, int vertexCount);
};
#endif