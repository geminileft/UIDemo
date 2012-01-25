#include "TEEngine.h"
#include "TEGameObject.h"
#include "TERunnable.h"
#include "TEManagerRender.h"
#include "TEManagerTouch.h"
#include "TEManagerSound.h"
#include "TEComponentRender.h"
#include "TEComponentTouch.h"
#include "TEComponentSound.h"
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include "EAGLView.h"
#include "TERenderer.h"
#include "TERendererOGL2.h"
    
TEEngine::TEEngine(int width, int height) {
	mWidth = width;
	mHeight = height;
    TEManagerTouch* touchManager = TEManagerTouch::sharedManager();
    TEManagerSound* soundManager = TEManagerSound::sharedManager();
    TEManagerRender* renderManager = TEManagerRender::sharedManager();
    mManagers.push_back(touchManager);
    mManagers.push_back(soundManager);
    mManagers.push_back(renderManager);
}

void TEEngine::run() {
    mRenderer->reset();
    int managerCount = mManagers.size();
    for (int count = 0;count < managerCount; ++count) {
        mManagers[count]->update();
    }

    const float totalSize = 160.0f;
    const float sideSize = totalSize / 2.0f;
    
    float squareVertices[] = {
        -sideSize, -sideSize,//lb
        sideSize,  -sideSize,//rb
        -sideSize,  sideSize,//lt
        sideSize,   sideSize,//rt
    };
    
    TEColor4 color;
    color.r = 0.0f;
    color.g = 1.0f;
    color.b = 0.0f;
    color.a = 1.0f;
    
    TEVec3 position;
    position.x = 80.0f;
    position.y = 240.0f;
    position.z = 0.0f;
    
    mRenderer->addPolygon(squareVertices, position, color);
    mRenderer->render();
}

void TEEngine::addGameObject(TEGameObject* gameObject) {
    TEManagerRender* renderManager = TEManagerRender::sharedManager();
    TEManagerTouch* touchManager = TEManagerTouch::sharedManager();
    TEManagerSound* soundManager = TEManagerSound::sharedManager();
    TEComponentContainer components = gameObject->getComponents();
    TEComponentContainer::iterator iterator;
    TEComponent* component;
    for(iterator = components.begin();iterator != components.end();++iterator) {
        component = *iterator;
        if (dynamic_cast<TEComponentRender*>(component)) {
            renderManager->addComponent(component, Bottom);
        } else if (dynamic_cast<TEComponentTouch*>(component)) {
            touchManager->addComponent(component, Top);
        } else if (dynamic_cast<TEComponentSound*>(component)) {
            soundManager->addComponent(component, Top);
        }
    }
    mGameObjects.push_back(gameObject);
}

TESize TEEngine::getScreenSize() const {
	TESize size;
	size.width = mWidth;
	size.height = mHeight;
	return size;
}

void TEEngine::initialize() {
    CGRect frame = [[UIScreen mainScreen] bounds];    
    EAGLView* view = [[EAGLView alloc] initWithFrame:frame];
    mWindow = [[UIWindow alloc] initWithFrame:frame];
    UIViewController* vc = [[UIViewController alloc] init];
    vc.view = view;
    mWindow.rootViewController = vc;
    //mRenderer = new TERendererOGL1(layer);
    mRenderer = new TERendererOGL2(view.layer);
    TEComponentRender::setSharedRenderer(mRenderer);
    this->start();
    mRunnable = [[TERunnable alloc] initWithGame:this];
    [mWindow makeKeyAndVisible];
}

