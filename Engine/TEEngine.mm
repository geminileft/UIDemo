#include "TEEngine.h"
#include "TEGameObject.h"
#include "TERunnable.h"
#include "TEManagerRender.h"
#include "TEManagerTouch.h"
#include "TEManagerSound.h"
#include "TEManagerProfiler.h"
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
#include "TEManagerTime.h"
    
TEEngine::TEEngine(int width, int height) {
	mGameWidth = width;
	mGameHeight = height;
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
    mRenderer->render();
    double currentFrameTime = TEManagerTime::currentTime();
    double diff = currentFrameTime - mPreviousFrameTime;
    mPreviousFrameTime = currentFrameTime;
    NSLog(@"Run Rate: %.1f", diff);
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
	size.width = mGameWidth;
	size.height = mGameHeight;
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
    mRenderer = new TERendererOGL2(view.layer, mGameWidth, mGameHeight);
    TEComponentRender::setSharedRenderer(mRenderer);
    this->start();
    mRunnable = [[TERunnable alloc] initWithGame:this];
    [mWindow makeKeyAndVisible];
}

