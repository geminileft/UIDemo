#ifndef RENDERPOLYGONFACTORY
#define RENDERPOLYGONFACTORY

#include "TETypes.h"

class RenderPolygon;

class RenderPolygonFactory {
public:
    static RenderPolygon* roundedRect();
    static RenderPolygon* roundedRectPolygon();
};
#endif