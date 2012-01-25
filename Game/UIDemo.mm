#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderBox.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    TEGameObject* go = new TEGameObject();
    TEPoint position;
    TESize size;
    RenderBox* rf = new RenderBox(position, size);
    go->addComponent(rf);
    addGameObject(go);

}
