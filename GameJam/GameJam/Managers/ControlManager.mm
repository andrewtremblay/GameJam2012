//
//  ControlManager.mm
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "ControlManager.h"

@interface ControlManager ()
    @property (nonatomic, assign) CGPoint startPoint;
    @property (nonatomic, assign) CGPoint endPoint;
@end

static ControlManager* s_controlManager;
@implementation ControlManager
@synthesize charSprite = _charSprite;
@synthesize moveSetting = _moveSetting; //controlMoveSetting
@synthesize shootSetting = _shootSetting; //controlShootSetting


@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;


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




//touch handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _startPoint = location;
        _endPoint = location;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _endPoint = location;
    }
    if (ccpLengthSQ(ccpSub(_startPoint, _endPoint)) > 25)
    {
        //have a minimum drag distance, for performance
        _startPoint = _endPoint;
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}


@end
