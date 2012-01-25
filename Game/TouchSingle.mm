#include "TouchSingle.h"
#include "TEManagerTime.h"
#include "TEGameObject.h"
#include "TEEventListener.h"
#include "TEInputTouch.h"

TouchSingle::TouchSingle(TESize size) : TEComponentTouch(size), mTouched(false) {}

void TouchSingle::update() {
    if (mTouched) {
        mParent->invokeEvent(EVENT_TOUCH_STARTED);
        NSLog(@"EVENT_TOUCH_STARTED");
    }
    mTouched = false;
}

bool TouchSingle::addTouch(TEInputTouch* touch) {
    mTouched = true;
    return true;
}

bool TouchSingle::updateTouch(TEInputTouch* touch) {
    return true;
}
