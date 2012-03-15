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
    
    go = new TEGameObject();
    
    color = TEColor4Make(1.0, 0.0, 0.0, 1.0);
    size = TESizeMake(160, 160);
    radius = 5.0;
    RenderToTexture* rtt  = new RenderToTexture(1024);
    rtt->sharedRenderer()->setTextureTarget(rtt->getRenderTarget());
    rtt->sharedRenderer()->setTextureFrameBufferHandle(rtt->getTextureHandle());
    rp = RenderPolygonFactory::roundedRect(size, color, radius, (uint)radius);
    rp->setRenderTarget(rtt->getRenderTarget());
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    go->addComponent(rp);
    go->addComponent(rtt);
    addGameObject(go);


    go = new TEGameObject();
    
    RenderImage* ri = new RenderImage(@"olympic.jpg", TEPointMake(0, 0), size);
    
    go->position.x = 80.0f;
    go->position.y = 0.0f;
    
    go->addComponent(ri);
    addGameObject(go);

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
