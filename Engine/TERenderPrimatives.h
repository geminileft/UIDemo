//
//  TERenderPrimatives.h
//  UIDemo
//
//  Created by dev on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef UIDemo_TERenderPrimatives_h
#define UIDemo_TERenderPrimatives_h

class TEUtilTexture;

struct TERenderTexturePrimative {
    TEUtilTexture* texture;
    TEVec3 position;
    float* vertexBuffer;
    float* textureBuffer;
};

typedef TERenderTexturePrimative TERenderTexturePrimative;

#endif
