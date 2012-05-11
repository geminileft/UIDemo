//
//  RenderText.h
//  UIDemo
//
//  Created by dev on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef UIDemo_RenderText_h
#define UIDemo_RenderText_h

#include "TEComponentRender.h"
#include "TETypes.h"
#include <map>

class RenderText : public TEComponentRender {
private:
	int mWidth;
	int mHeight;
    uint mTextureName;
    float mVertexBuffer[8];
    float mTextureBuffer[8];
    TERenderPrimative* mRenderPrimatives;
    int mPrimativeCount;
    char* mText;
    int mTextLength;
    
public:
    RenderText(NSString* resourceName, TESize size, std::map<const char*, TETextMap> charMap);
    ~RenderText();
    virtual void update();
    virtual void draw();
	void moveToTopListener();
    void setText(String text);
};

#endif
