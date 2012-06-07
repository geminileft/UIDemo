#include "UIDemo.h"
#include "TEGameObject.h"
#include "RenderPolygon.h"
#include "RenderPolygonFactory.h"
#include "RenderImage.h"
#include "RenderToTexture.h"
#include "RenderText.h"
#include "TEEventListener.h"
#include "TouchSingle.h"
#include "TERenderer.h"

UIDemo::UIDemo(int width, int height) : TEEngine(width, height){}

void UIDemo::start() {
    exampleGradientBox();
    //exampleRenderToTexture();
    //exampleDrawImage();
    //exampleDrawFilters();
    //exampleText();
}

void UIDemo::exampleRenderToTexture() {
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
    float kernel[9];
    kernel[0] = 1.0/9.0;
    kernel[1] = 1.0/9.0;
    kernel[2] = 1.0/9.0;
    kernel[3] = 1.0/9.0;
    kernel[4] = 1.0/9.0;
    kernel[5] = 1.0/9.0;
    kernel[6] = 1.0/9.0;
    kernel[7] = 1.0/9.0;
    kernel[8] = 1.0/9.0;
    rtt->setKernel(kernel);

    go->addComponent(rtt);
    addGameObject(go);
    
    go = new TEGameObject();
    color = TEColor4Make(1.0, 0.0, 0.0, 1.0);
    size = TESizeMake(160, 160);
    radius = 5.0;
    
    rp = RenderPolygonFactory::roundedRect(size, color, radius, (uint)radius);
    rp->setRenderTarget(rtt->getTargetFrameBuffer());
    go->addComponent(rp);
    
    size.width += 4;
    size.height += 4;
    color.r = 0.0;
    color.g = 0.0;
    color.b = 0.0;
    color.a = 1.0;
    rp = RenderPolygonFactory::roundedRect(size, color, radius, (uint)radius);
    rp->setRenderTarget(rtt->getTargetFrameBuffer());
    go->addComponent(rp);
    
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    addGameObject(go);
    
    go = new TEGameObject();
    go->position.x = 0.0f;
    go->position.y = 0.0f;

    rtt2  = new RenderToTexture(256);
    color.r = 0;
    color.g = 0;
    color.b = 0;
    rtt2->setTransparentColor(&color);

    go->addComponent(rtt2);
    addGameObject(go);

    rtt->setRenderTarget(rtt2->getTargetFrameBuffer());

}

void UIDemo::exampleDrawImage() {
    TEGameObject* go;
    TESize size;
    
    go = new TEGameObject();
    size = TESizeMake(160, 160);
    RenderImage* ri = new RenderImage(@"olympic.jpg", TEPointMake(0, 0), size);

    go->position.x = 0.0f;
    go->position.y = 0.0f;

    go->addComponent(ri);
    addGameObject(go);
}

void UIDemo::exampleDrawFilters() {
    TEGameObject* go;
    TESize size;
    RenderImage* ri;
    RenderToTexture* rtt;
    
    go = new TEGameObject();
    size = TESizeMake(160, 160);
    ri = new RenderImage(@"flower.png", TEPointMake(0, 0), size);
    go->position.x = -80.0f;
    go->position.y = 160.0f;
    go->addComponent(ri);
    addGameObject(go);    

    go = new TEGameObject();
    size = TESizeMake(160, 160);
    ri = new RenderImage(@"flower.png", TEPointMake(0, 0), size);
    ri->setGrayscale();
    go->position.x = -80.0f;
    go->position.y = 0.0f;
    go->addComponent(ri);
    addGameObject(go);    
    
    go = new TEGameObject();
    size = TESizeMake(160, 160);
    ri = new RenderImage(@"flower.png", TEPointMake(0, 0), size);
    ri->setSepia();
    go->position.x = -80.0f;
    go->position.y = -160.0f;
    go->addComponent(ri);
    addGameObject(go);
    
    go = new TEGameObject();
    size = TESizeMake(160, 160);
    ri = new RenderImage(@"flower_pow2.jpg", TEPointMake(0, 0), size);
    go->position.x = 80.0f;
    go->position.y = 160.0f;
    go->addComponent(ri);
    addGameObject(go);    
    
    go = new TEGameObject();
    size = TESizeMake(160, 160);
    ri = new RenderImage(@"flower_pow2.jpg", TEPointMake(0, 0), size);
    ri->setNegative();
    go->position.x = 80.0f;
    go->position.y = 0.0f;
    go->addComponent(ri);
    addGameObject(go);    
    
    go = new TEGameObject();
    go->position.x = 80.0f;
    go->position.y = -160.0f;
    
    rtt  = new RenderToTexture(256);
    float kernel[9];
    kernel[0] = -1.0;
    kernel[1] = -1.0;
    kernel[2] = -1.0;
    kernel[3] = -1.0;
    kernel[4] = 8.0;
    kernel[5] = -1.0;
    kernel[6] = -1.0;
    kernel[7] = -1.0;
    kernel[8] = -1.0;
    rtt->setKernel(kernel);
    
    go->addComponent(rtt);
    addGameObject(go);
    
    go = new TEGameObject();
    size = TESizeMake(160, 160);
    ri = new RenderImage(@"flower_pow2.jpg", TEPointMake(0, 0), size);
    ri->setRenderTarget(rtt->getTargetFrameBuffer());
    ri->setGrayscale();
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    go->addComponent(ri);
    addGameObject(go);    
}

void UIDemo::exampleText() {
    TEGameObject* go;
    TESize size;
    
    go = new TEGameObject();
    size = TESizeMake(66, 67);
    std::map<const char*, TETextMap> charMap;
    TETextMap map;
    map.left = 20;
    map.top = 28;
    map.right = 71;
    map.bottom = 77;
    charMap["A"] = map;
    map.left = 78;
    map.top = 25;
    map.right = 120;
    map.bottom = 73;
    charMap["B"] = map;
    RenderText* rt = new RenderText(@"text_atlas.png", size, charMap);
    rt->setText("B");
    go->position.x = 0.0f;
    go->position.y = 0.0f;
    
    go->addComponent(rt);
    addGameObject(go);

}

void UIDemo::exampleGradientBox() {
    TEGameObject* go;
    RenderPolygon* rp;
    
    go = new TEGameObject();
    go->position.x = 0;
    go->position.y = 0;
    
    rp = new RenderPolygon();
    float vertices[] = {
        -50.0f, 50.0f
        , 50.0f, 50.0f
        , 50.0f, -50.0f
        , -50.0f, -50.0f
    };
    TEColor4 colors[] = {
        TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f)
        ,TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f)
//        ,TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f)
//        ,TEColor4Make(1.0f, 1.0f, 1.0f, 1.0f)
        ,TEColor4Make(0.0f, 0.0f, 0.0f, 1.0f)
        ,TEColor4Make(0.0f, 0.0f, 0.0f, 1.0f)
    };
    
    rp->setColorData(&colors[0], 4);
    rp->setVertices(vertices, 4);
    go->addComponent(rp);
    addGameObject(go);
}
