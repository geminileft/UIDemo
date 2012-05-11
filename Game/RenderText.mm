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
: TEComponentRender(), mText(NULL) {
    
    UIImage* image = [UIImage imageNamed:resourceName];
    mTextureName = TEManagerTexture::GLUtexImage2D([image CGImage]);
    
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
    
    float left = 0.0f;
    float right = 0.5f;
    float top = 0.5f;
    float bottom = 0.0f;
    
    mTextureBuffer[0] = left;//left
	mTextureBuffer[1] = top;//top
	mTextureBuffer[2] = right;//right
	mTextureBuffer[3] = top;//top
	mTextureBuffer[4] = right;//right
	mTextureBuffer[5] = bottom;//bottom
	mTextureBuffer[6] = left;//left
	mTextureBuffer[7] = bottom;//bottom
}

void RenderText::update() {}

void RenderText::draw() {
    mRenderPrimative.textureName = mTextureName;
    mRenderPrimative.position.x = mParent->position.x;
    mRenderPrimative.position.y = mParent->position.y;
    mRenderPrimative.position.z = 0;
    mRenderPrimative.vertexCount = 4;
    mRenderPrimative.vertexBuffer = mVertexBuffer;
    mRenderPrimative.textureBuffer = mTextureBuffer;
    mRenderPrimative.extraData = getExtraData();
    mRenderPrimative.extraType = getExtraType();
    getRenderTarget()->addPrimative(mRenderPrimative);
}

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
