#include "RenderPolygonFactory.h"
#include "RenderPolygon.h"

RenderPolygon* RenderPolygonFactory::roundedRect() {
    TESize size;
    
    const float halfHeight = (float)size.height / 2;
    const float halfWidth = (float)size.width / 2;
    const int vertexCount = 4;
    float vertices[vertexCount * 2];
    vertices[0] = 0;
    vertices[1] = 0;
    vertices[2] = 0;
    vertices[3] = halfHeight;
    
    vertices[4] = halfWidth;
    vertices[5] = 0;
    
    vertices[(vertexCount - 1) * 2] = vertices[0];
    vertices[((vertexCount - 1) * 2) + 1] = vertices[1];
    
    TEColor4 color = TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    RenderPolygon* rf = new RenderPolygon;
    
    rf->setVertices(&vertices[0], vertexCount);
    rf->setColor(color);
    
    return rf;
}

RenderPolygon* RenderPolygonFactory::roundedRectPolygon() {
    TESize size;
    size = TESizeMake(160, 160);
    
    const float halfHeight = (float)size.height / 2;
    const float halfWidth = (float)size.width / 2;
    const int vertexCount = 9;
    float vertices[vertexCount * 2];
    const float roundRadius = 5;
    vertices[0] = -halfWidth + roundRadius;
    vertices[1] = -halfHeight;
    vertices[2] = halfWidth - roundRadius;
    vertices[3] = -halfHeight;
    
    vertices[4] = halfWidth;
    vertices[5] = -halfHeight + roundRadius;
    vertices[6] = halfWidth;
    vertices[7] = halfHeight - roundRadius;
    
    vertices[8] = halfWidth - roundRadius;
    vertices[9] = halfHeight;
    vertices[10] = -halfWidth + roundRadius;
    vertices[11] = halfHeight;
    
    vertices[12] = -halfWidth;
    vertices[13] = halfHeight - roundRadius;
    vertices[14] = -halfWidth;
    vertices[15] = -halfHeight + roundRadius;
    
    vertices[(vertexCount - 1) * 2] = vertices[0];
    vertices[((vertexCount - 1) * 2) + 1] = vertices[1];
    
    TEColor4 color = TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    RenderPolygon* rf = RenderPolygonFactory::roundedRect();
    
    rf->setVertices(&vertices[0], vertexCount);
    rf->setColor(color);
    return rf;
}
