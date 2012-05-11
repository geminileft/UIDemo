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
    
    mTextureBuffer[0] = 0.0f;//left
	mTextureBuffer[1] = 1.0f;//top
	mTextureBuffer[2] = 1.0f;//right
	mTextureBuffer[3] = 1.0f;//top
	mTextureBuffer[4] = 1.0f;//right
	mTextureBuffer[5] = 0.0f;//bottom
	mTextureBuffer[6] = 0.0f;//left
	mTextureBuffer[7] = 0.0f;//bottom
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
