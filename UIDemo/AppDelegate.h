#ifndef APPDELEGATE
#define APPDELEGATE

#import <UIKit/UIKit.h>

class TEEngine;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
@private
    TEEngine* mGame;
}

@end

#endif