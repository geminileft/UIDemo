#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderPolygon.h"
#include "RenderPolygonFactory.h"
#include "RenderImage.h"
#include "RenderToTexture.h"
#include "TEEventListener.h"
#include "TouchSingle.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    TEGameObject* go;    
    go = new TEGameObject();
    
    RenderPolygon* rf = RenderPolygonFactory::roundedRect();
    //RenderPolygon* rf = RenderPolygonFactory::roundedRectPolygon();

    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    go->addComponent(rf);
    addGameObject(go);
    
    go = new TEGameObject();
    TEPoint position;
    TESize size;
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
