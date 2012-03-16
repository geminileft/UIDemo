#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderPolygon.h"
#include "RenderPolygonFactory.h"
#include "RenderImage.h"
#include "RenderToTexture.h"
#include "TEEventListener.h"
#include "TouchSingle.h"
#include "TERenderer.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    TEGameObject* go;
    TEColor4 color;
    RenderPolygon* rp;
    TESize size;
    float radius;
    RenderToTexture* rtt;
    RenderToTexture* rtt2;

    go = new TEGameObject();
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    rtt  = new RenderToTexture(256);
    
    go->addComponent(rtt);
    addGameObject(go);

    go = new TEGameObject();
    color = TEColor4Make(1.0, 0.0, 0.0, 1.0);
    size = TESizeMake(160, 160);
    radius = 5.0;
    
    rp = RenderPolygonFactory::roundedRect(size, color, radius, (uint)radius);
    rp->setRenderTarget(rtt->getRenderTarget());
    go->addComponent(rp);
    
    size.width += 4;
    size.height += 4;
    color.r = 0.0;
    color.g = 0.0;
    color.b = 0.0;
    color.a = 1.0;
    rp = RenderPolygonFactory::roundedRect(size, color, radius, (uint)radius);
    rp->setRenderTarget(rtt->getRenderTarget());
    go->addComponent(rp);
    
    
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    addGameObject(go);

    /*
    go = new TEGameObject();
    go->position.x = 0.0f;
    go->position.y = -160.0f;
    
    rtt2  = new RenderToTexture(256);
    
    go->addComponent(rtt);
    addGameObject(go);
    
    rtt->setRenderTarget(rtt2->getRenderTarget());
    */
    
    
    /*
    go = new TEGameObject();
    size = TESizeMake(160, 160);
    RenderImage* ri = new RenderImage(@"olympic.jpg", TEPointMake(0, 0), size);
    //ri->setRenderTarget(rtt->getRenderTarget());
    
    go->position.x = 80.0f;
    go->position.y = 0.0f;
    
    go->addComponent(ri);
    addGameObject(go);
    */
/*
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
*/
}
