#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderBox.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    TEGameObject* go = new TEGameObject();
    TEPoint position = TEPointMake(80.0f, 240.0f);
    TESize size = TESizeMake(160.0f, 160.0f);
    TEColor4 color = TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f);
    RenderBox* rf = new RenderBox(position, size, color);
    go->addComponent(rf);
    addGameObject(go);
}
