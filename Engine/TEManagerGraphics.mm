#include "TEManagerGraphics.h"
#include "TERenderer.h"
#include "TERendererOGL1.h"
#include "TERendererOGL2.h"

static TERenderer* mRenderer;
static float mWidth;
static float mHeight;

void TEManagerGraphics::initialize(CALayer* layer, float width, float height) {
    mWidth = width;
    mHeight = height;
    //mRenderer = new TERendererOGL1(layer);
    mRenderer = new TERendererOGL2(layer);
}

void TEManagerGraphics::render() {
    mRenderer->render();
}

void TEManagerGraphics::resetRenderer() {
    mRenderer->reset();
}
