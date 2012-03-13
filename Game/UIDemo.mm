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
    
    RenderPolygon* rf = RenderPolygonFactory::roundedRect(80.0, 30.0);
    //RenderPolygon* rf = RenderPolygonFactory::roundedRectPolygon();

    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    go->addComponent(rf);
    addGameObject(go);
}
