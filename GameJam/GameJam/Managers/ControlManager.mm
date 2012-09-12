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


//control agnostic behavior

-(void)moveCharToPoint:(CGPoint)p
{
    [self.charSprite setPosition:p];
}

-(void)shootAtPoint:(CGPoint)p
{

}

-(void)moveInDirection:(CGPoint)p
{

}

-(void)shootInDirection:(CGPoint)p
{
    
}

-(void)setCharVelocity:(CGPoint)p
{
    float vx = p.x;
    float vy = p.y;
    CCSpeed *action;
    // set ball velocity by the incoming point
    self.charSprite.getPhysicsBody->SetLinearVelocity(b2Vec2(vx,vy)+self.charSprite.getPhysicsBody->GetLinearVelocity());
    float vel;
    vel = self.charSprite.getPhysicsBody->GetLinearVelocity().Normalize();
    [action setSpeed:vel];
    
    action = (CCSpeed *)[CCSpeed actionWithAction:[CCActionInterval actionWithDuration:1.0f] speed:(0.0f)];

    [self.charSprite runAction:action]; //action will run next timestep
}

-(void)setCharDirection:(CGPoint)p //CGPointZero will try to use velocity of char for direction
{
    if(CGPointEqualToPoint(p, CGPointZero)){
        // rotation by velocity, (should be immediate)
        b2Vec2 vec = self.charSprite.getPhysicsBody->GetLinearVelocity();
        [self.charSprite setRotation:(-1*CC_RADIANS_TO_DEGREES(ccpToAngle(CGPointMake(vec.x, vec.y))))];
    }else {
        // rotation by point, (should be immediate)
        [self.charSprite setRotation:(-1*CC_RADIANS_TO_DEGREES(ccpToAngle(p)))];
    }
}

//interaction handlers


//tilt handling


//touch/swipe handling
- (void)pressFoundAtPoint:(CGPoint)p
{
    
}

- (void)swipeFoundInDirection:(CGPoint)p
{
    
}

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
