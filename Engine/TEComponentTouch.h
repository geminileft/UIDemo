#ifndef TECOMPONENTTOUCH
#define TECOMPONENTTOUCH

#include "TEComponent.h"
#include "TETypes.h"

class TEInputTouch;

class TEComponentTouch : public TEComponent {
private:
    TESize mSize;
    
public:
    TEComponentTouch(TESize size);
    virtual bool addTouch(TEInputTouch* touch) = 0;
	virtual bool updateTouch(TEInputTouch* touch) = 0;
	virtual bool containsPoint(TEPoint point);
    const TESize getSize() const;
};

#endif