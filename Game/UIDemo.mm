#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderBox.h"
#include "RenderImage.h"
#include "TEEventListener.h"
#include "TouchSingle.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    TEGameObject* go = new TEGameObject();
    //TESize size = TESizeMake(100, 150);
    TESize size = TESizeMake(160, 160);
    TEColor4 color = TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f);
    RenderBox* rf = new RenderBox(size, color);
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    go->addComponent(rf);
    go->addComponent(new TouchSingle(size));
    addGameObject(go);
    
    go = new TEGameObject();
    TEPoint position;
    size.width = 160;
    size.height = 160;
    position.x = 0.0f;
    position.y = 0.0f;
    RenderImage* ri = new RenderImage(@"bitmap_font_sample_inverted_alpha.png", position, size);
    go->position.x = 80.0f;
    go->position.y = 0.0f;
    go->addComponent(ri);
    addGameObject(go);
}
