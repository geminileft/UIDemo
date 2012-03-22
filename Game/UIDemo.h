#ifndef UIDEMO
#define UIDEMO

#include "../Engine/TEEngine.h"

class UIDemo : public TEEngine {
public:
    UIDemo(int width, int height);	
    virtual void start();
    void exampleRenderToTexture();
    void exampleDrawImage();
    void exampleDrawGrayscale();
};

#endif