#include "RenderPolygonFactory.h"
#include "RenderPolygon.h"
#include <cmath>

RenderPolygon* RenderPolygonFactory::roundedRect(TEColor4 color, float radius, uint density) {
    TESize size;
    size = TESizeMake(radius * 2, radius * 2);
    const float halfHeight = radius;
    const float halfWidth = radius;
    const int vertexCount = 4 + density;
    float vertices[vertexCount * 2];
    vertices[0] = 0;
    vertices[1] = 0;
    vertices[2] = 0;
    vertices[3] = halfHeight;
    float x;
    float y;
    if (density > 0) {
        float theta = 90.0 / (density + 1);
        float angle;
        for (int i = 1; i <= density; ++i) {
            angle = 90 - (theta * i);
            float lCos = cos(deg2rad(angle));
            float lSin = sin(deg2rad(angle));
            x = lCos * radius;
            y = lSin * radius;
            vertices[4 + (i - 1) * 2] = x;
            vertices[4 + (i - 1) * 2 + 1] = y;
        }
    }
    vertices[(vertexCount - 2) * 2] = halfWidth;
    vertices[((vertexCount - 2) * 2) + 1] = 0;
    vertices[(vertexCount - 1) * 2] = vertices[0];
    vertices[((vertexCount - 1) * 2) + 1] = vertices[1];

    RenderPolygon* rf = new RenderPolygon;
    
    rf->setVertices(&vertices[0], vertexCount);
    rf->setColor(color);
    
    return rf;
}

RenderPolygon* RenderPolygonFactory::roundedRectPolygon(TESize size, TEColor4 color, float radius) {    
    const float halfHeight = (float)size.height / 2;
    const float halfWidth = (float)size.width / 2;
    const int vertexCount = 9;
    float vertices[vertexCount * 2];
    vertices[0] = -halfWidth + radius;
    vertices[1] = -halfHeight;
    vertices[2] = halfWidth - radius;
    vertices[3] = -halfHeight;
    
    
    vertices[4] = halfWidth;
    vertices[5] = -halfHeight + radius;
    vertices[6] = halfWidth;
    vertices[7] = halfHeight - radius;
    
    vertices[8] = halfWidth - radius;
    vertices[9] = halfHeight;
    vertices[10] = -halfWidth + radius;
    vertices[11] = halfHeight;
    
    vertices[12] = -halfWidth;
    vertices[13] = halfHeight - radius;
    vertices[14] = -halfWidth;
    vertices[15] = -halfHeight + radius;
    
    vertices[(vertexCount - 1) * 2] = vertices[0];
    vertices[((vertexCount - 1) * 2) + 1] = vertices[1];
        
    RenderPolygon* rf = new RenderPolygon;
    
    rf->setVertices(&vertices[0], vertexCount);
    rf->setColor(color);
    return rf;
}
