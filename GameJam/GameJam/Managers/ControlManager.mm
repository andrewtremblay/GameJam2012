//
//  ControlManager.mm
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "ControlManager.h"
static ControlManager* s_controlManager;
@implementation ControlManager

@synthesize charSprite = _charSprite;
@synthesize moveSetting = _moveSetting; //controlMoveSetting
@synthesize shootSetting = _shootSetting; //controlShootSetting

+(ControlManager*)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_controlManager = [[ControlManager alloc] init];
    });
    
    return s_controlManager;
}

-(void)moveCharToPoint:(CGPoint)p
{
    [self.charSprite setPosition:p];
}



@end
