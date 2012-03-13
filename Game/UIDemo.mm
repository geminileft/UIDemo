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
    TEColor4 color;
    RenderPolygon* rp;
    TESize size;
    float radius;
    go = new TEGameObject();
    
    color = TEColor4Make(1.0, 0.0, 0.0, 1.0);
    size = TESizeMake(160, 160);
    radius = 20.0;
    rp = RenderPolygonFactory::roundedRectPolygon(size, color, radius);

    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    go->addComponent(rp);
    addGameObject(go);
    
    go = new TEGameObject();
    
    rp = RenderPolygonFactory::roundedRectCorner(color, radius, (uint)radius);
    
    go->position.x = (size.width / 2.0) - radius;
    go->position.y = (size.height / 2.0) - radius;
    
    go->addComponent(rp);
    addGameObject(go);
    
}
