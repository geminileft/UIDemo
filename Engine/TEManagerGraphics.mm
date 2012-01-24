#include "TEManagerGraphics.h"
#include "TERenderer.h"
#include "TERendererOGL1.h"
#include "TERendererOGL2.h"

static TERenderer* mRenderer;

void TEManagerGraphics::initialize(CALayer* layer, float width, float height) {
    //mRenderer = new TERendererOGL1(layer);
    mRenderer = new TERendererOGL2(layer);
}

void TEManagerGraphics::render() {
    mRenderer->render();
}

void TEManagerGraphics::resetRenderer() {
    mRenderer->reset();
}
