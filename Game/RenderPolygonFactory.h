#ifndef RENDERPOLYGONFACTORY
#define RENDERPOLYGONFACTORY

#include "TETypes.h"

class RenderPolygon;

class RenderPolygonFactory {
public:
    static RenderPolygon* roundedRect(float radius, uint density);
    static RenderPolygon* roundedRectPolygon();
};
#endif