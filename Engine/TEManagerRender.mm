#include "TEComponentRender.h"
#include "TEManagerRender.h"
#include "TERenderer.h"

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

static TEManagerRender* mSharedInstance = NULL;

void TEManagerRender::update() {
    TEComponentContainer components = getComponents();
    TEComponentContainer::iterator iterator;
    for (iterator = components.begin(); iterator != components.end();iterator++) {
        TEComponentRender* component = (TEComponentRender*)(*iterator);
        component->update();
        component->draw();
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
    
    TEComponentRender::sharedRenderer()->addPolygon(squareVertices, position, color);

}

void TEManagerRender::moveComponentToTop(TEComponent* component) {
	TEComponentContainer components = getComponents();
	components.remove(component);
	addComponent(component, Bottom);			
}

TEManagerRender* TEManagerRender::sharedManager() {
    if (mSharedInstance == NULL) {
        mSharedInstance = new TEManagerRender();
    }
    return mSharedInstance;
}
