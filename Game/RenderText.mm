//
//  RenderText.cpp
//  UIDemo
//
//  Created by dev on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "RenderText.h"
#include "TEGameObject.h"
#include "TEManagerTexture.h"
#include "TERenderTarget.h"

RenderText::RenderText(NSString* resourceName, TESize size, std::map<const char*, TETextMap> charMap)
: TEComponentRender(), mText(NULL), mPrimativeCount(0) {
    
    UIImage* image = [UIImage imageNamed:resourceName];
    float width = image.size.width;
    float height = image.size.height;
    mTextureName = TEManagerTexture::GLUtexImage2D([image CGImage]);
    
    mRenderPrimatives = (TERenderPrimative*)malloc(sizeof(TERenderPrimative));
    
    const float leftX = -(float)size.width / 2;
	const float rightX = leftX + size.width;
	const float bottomY = -(float)size.height / 2;
	const float topY = bottomY + size.height;
    
    mVertexBuffer[0] = leftX;
	mVertexBuffer[1] = bottomY;
	mVertexBuffer[2] = rightX;
	mVertexBuffer[3] = bottomY;
	mVertexBuffer[4] = rightX;
	mVertexBuffer[5] = topY;
	mVertexBuffer[6] = leftX;
	mVertexBuffer[7] = topY;
    
    float left = 22.0f / width;
    float right = 78.0f / width;
    float bottom = 19.0f / height;
    float top = 78.0f / height;
    
    mTextureBuffer[0] = left;//left
	mTextureBuffer[1] = top;//top
	mTextureBuffer[2] = right;//right
	mTextureBuffer[3] = top;//top
	mTextureBuffer[4] = right;//right
	mTextureBuffer[5] = bottom;//bottom
	mTextureBuffer[6] = left;//left
	mTextureBuffer[7] = bottom;//bottom
}

RenderText::~RenderText() {
    delete (mRenderPrimatives);
}

void RenderText::update() {
    TERenderPrimative primative;
    primative.textureName = mTextureName;
    primative.position.x = mParent->position.x;
    primative.position.y = mParent->position.y;
    primative.position.z = 0;
    primative.vertexCount = 4;
    primative.vertexBuffer = mVertexBuffer;
    primative.textureBuffer = mTextureBuffer;
    primative.extraData = getExtraData();
    primative.extraType = getExtraType();
    mRenderPrimatives[0] = primative;
    mPrimativeCount = 1;
    for (int i = 0;i < mPrimativeCount;++i) {
        getRenderTarget()->addPrimative(mRenderPrimatives[i]);        
    }
}

void RenderText::draw() {}

void RenderText::moveToTopListener() {
	getManager()->moveComponentToTop(this);
};

void RenderText::setText(String text) {
    mTextLength = text.length();
    if (mText) {
        delete mText;
    }
    mText = (char*)malloc(mTextLength * sizeof(char));
    memcpy(mText, text.c_str(), mTextLength);
}
