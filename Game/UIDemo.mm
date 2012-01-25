#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderFirst.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    TEGameObject* go = new TEGameObject();
    TEPoint position;
    TESize size;
    RenderFirst* rf = new RenderFirst(nil, position, size);
    go->addComponent(rf);
    addGameObject(go);

}
