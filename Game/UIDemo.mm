#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderPolygon.h"
#include "RenderImage.h"
#include "RenderToTexture.h"
#include "TEEventListener.h"
#include "TouchSingle.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    TESize size;
    TEGameObject* go;
    
    go = new TEGameObject();
    
    size = TESizeMake(160, 160);
    
    const float halfHeight = (float)size.height / 2;
    const float halfWidth = (float)size.width / 2;
    const int vertexCount = 5;
    float vertices[10];
    vertices[0] = -halfWidth;
    vertices[1] = -halfHeight;
    vertices[2] = halfWidth;
    vertices[3] = -halfHeight;
    vertices[4] = halfWidth;
    vertices[5] = halfHeight;
    vertices[6] = -halfWidth;
    vertices[7] = halfHeight;
    vertices[8] = -halfWidth;
    vertices[9] = -halfHeight;

    TEColor4 color = TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f);
    //RenderPolygon* rf = new RenderPolygon(size, color);
    RenderPolygon* rf = new RenderPolygon;

    rf->setVertices(&vertices[0], vertexCount);
    rf->setColor(color);

    
    RenderToTexture* rtt = new RenderToTexture();
    
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    go->addComponent(rtt);
    go->addComponent(rf);
    go->addComponent(new TouchSingle(size));
    addGameObject(go);
    
    go = new TEGameObject();
    TEPoint position;
    size.width = 256;
    size.height = 256;
    position.x = 0.0f;
    position.y = 0.0f;
    
    RenderImage* ri = new RenderImage(@"olympic.jpg", position, size);
    //RenderImage* ri = new RenderImage(@"manroc.png", position, size);
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    go->addComponent(ri);
    addGameObject(go);
}
