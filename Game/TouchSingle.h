#ifndef TOUCHSINGLE
#define TOUCHSINGLE

#include "TEComponentTouch.h"

class TEInputTouch;

class TouchSingle : public TEComponentTouch {
private:
    bool mTouched;
    
public:
    TouchSingle(TESize size);
    virtual void update();
    virtual bool addTouch(TEInputTouch* touch);
	virtual bool updateTouch(TEInputTouch* touch);
};

#endif