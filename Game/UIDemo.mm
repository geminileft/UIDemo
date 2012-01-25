#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderBox.h"
#include "RenderImage.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    TEGameObject* go = new TEGameObject();
    TESize size = TESizeMake(160.0f, 160.0f);
    TEColor4 color = TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f);
    RenderBox* rf = new RenderBox(size, color);
    go->position.x = 80.0f;
    go->position.y = 240.0f;
    go->addComponent(rf);
    addGameObject(go);

    TEPoint position;
    position.x = 0.0f;
    position.y = 0.0f;
    go = new TEGameObject();
    RenderImage* ri = new RenderImage(@"spade_ace.png", position, size);
    go->position.x = 240.0f;
    go->position.y = 240.0f;
    go->addComponent(ri);
    addGameObject(go);
}
