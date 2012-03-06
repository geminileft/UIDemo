#ifndef RENDERTOTEXTURE
#define RENDERTOTEXTURE

#include "TEComponentRender.h"
#include "TETypes.h"

class TEUtilTexture;

class RenderToTexture : public TEComponentRender {
private:
    
public:
    virtual void update();
    virtual void draw();
};
#endif
