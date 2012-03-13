#ifndef RENDERPOLYGONFACTORY
#define RENDERPOLYGONFACTORY

#include "TETypes.h"

class RenderPolygon;

class RenderPolygonFactory {
public:
    static RenderPolygon* roundedRectCorner(TEColor4 color, float radius, uint density);
    static RenderPolygon* roundedRectPolygon(TESize size, TEColor4 color, float radius);
    static RenderPolygon* roundedRect(TESize size, TEColor4 color, float radius, uint density);
};
#endif